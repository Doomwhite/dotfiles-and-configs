from collections import defaultdict

from anki.hooks import wrap
from anki import stats
from aqt import mw


def get_learning_table_html(data):
	types = sorted({i[0] for i in data})

	headers = '<th>Step</th>'
	if 0 in types:
		headers += '<th colspan="4">Learn</th>'
	if 1 in types:
		headers += '<th colspan="4">Relearn</th>'
	if 2 in types:
		headers += '<th colspan="4">Cram</th>'

	rows = f"<tr>{headers}</tr>"

	steps = sorted(
		{(i[1], i[2]) for i in data},
		key=lambda x: (x[0] is None, -x[0] if x[0] else 0, x[1])
	)
	for ivl, n in steps:
		if ivl is not None:
			step = []
			if n:
				step.append(f"({n + 1})")
			d, m = divmod(abs(ivl), 86400)
			m, s = divmod(m, 60)
			if d:
				step.append(f"{d} d")
			if m:
				step.append(f"{m} min")
			if s or not ivl:
				step.append(f"{s} s")
			columns = f"<td>{' '.join(step)}</td>"
		else:
			columns = "<td>Graduation</td>"

		for thetype in types:
			ivl_data = data.get((thetype, ivl, n))
			if ivl_data:
				correct, total = ivl_data
				percentage = correct / total * 100.0
				columns += f"<td>{percentage:.1f}%</td><td>{correct}</td><td> / </td><td>{total}</td>"
			else:
				columns += "<td></td><td></td><td></td><td></td>"
		rows += f"<tr>{columns}</tr>"

	return (
		"""\
<style>
#learning-retention {
	margin-top: 20px;
}
#learning-retention th:nth-child(n+2) {
	padding-left: 2em;
}
#learning-retention td {
	text-align: right;
}
#learning-retention td:nth-child(4n+2) {
	font-weight: bold;
	padding-left: 2em;
}
#learning-retention td:nth-child(4n+3) {
	padding-left: 1em;
}
</style>"""
		f'<table id="learning-retention">{rows}</table>'
	)


def get_graph_html(self, data, xmax, **kwargs):
	percentage = []
	answers = []
	for ivl, correct, total in data:
		percentage.append((ivl, correct / total * 100.0))
		answers.append((ivl, total))

	return self._graph(
		data=(
			{"data": percentage, "stack": 1, "color": stats.colCum, "label": "% Correct"},
			{"data": answers, "stack": 0, "yaxis": 2, "bars": {"barWidth": 0.2}, "color": stats.colHour,
				"label": "Answers"}
		),
		conf={
			"xaxis": {"min": 0.5, "max": xmax + 0.5},
			"yaxes": (
				{"min": 0, "max": 105},
				{"min": 0, "position": "right"}
			)
		},
		ylabel="% Correct",
		ylabel2="Answers",
		**kwargs
	)


def get_data(self, max_ivl, advanced_mode, max_step_reps, round_steps):
	conds = []

	revlog_limit = self._revlogLimit()
	if revlog_limit:
		conds.append(revlog_limit)

	days = self._periodDays()
	if days:
		try:
			cutoff = self.col.sched.day_cutoff
		except AttributeError:
			cutoff = self.col.sched.dayCutoff
		conds.append(f"id > {(cutoff - days * 86400) * 1000}")

	if isinstance(max_ivl, int) and max_ivl > 0:
		conds.append(f"(lastIvl <= {max_ivl} OR thetype != 3)")

	where = f"WHERE {' AND '.join(conds)}" if conds else ""

	if round_steps:
		rounded_ivl = "(CASE WHEN thetype != 3 AND lastIvl < -86400 THEN CAST(-lastIvl / 86400 AS INT) * -86400 ELSE lastIvl END)"
	else:
		rounded_ivl = "lastIvl"

	if not advanced_mode:
		sql = f"""\
WITH answers AS (
	SELECT
		ease,
		CASE
			WHEN type IN (0, 2) AND lastIvl > 0 THEN -lastIvl * 86400
			ELSE lastIvl
		END AS lastIvl,
		CASE
			WHEN type = 0 THEN 0
			WHEN type = 2 THEN 1
			WHEN lastIvl > 0 THEN 3
			ELSE 2
		END AS thetype
	FROM revlog {where}
)
SELECT
	{rounded_ivl} AS theIvl,
	thetype,
	0,
	SUM(ease > 1),
	COUNT(*)
FROM answers
GROUP BY theIvl, thetype
ORDER BY theIvl"""

	else:
		sql = f"""\
WITH answers AS (
	SELECT
		ease,
		CASE
			WHEN type IN (0, 2) AND lastIvl > 0 THEN -lastIvl * 86400
			ELSE lastIvl
		END AS lastIvl,
		CASE
			WHEN type = 1 THEN COALESCE((
				SELECT
					CASE
						WHEN type = 0 THEN 0
						WHEN type = 2 THEN 1
					END
				FROM revlog AS r2
				WHERE r2.cid = revlog.cid AND r2.id < revlog.id
				ORDER BY id DESC
				LIMIT 1
			), 3)
			WHEN type = 0 THEN 0
			WHEN type = 2 THEN 1
			WHEN lastIvl > 0 THEN 3
			ELSE 2
		END AS thetype,
		CASE
			WHEN type IN (0, 2) OR (type != 1 AND lastIvl < 0) THEN (
				SELECT COUNT(*)
				FROM revlog AS r2
				WHERE r2.cid = revlog.cid AND r2.id < revlog.id AND r2.id > (
					SELECT COALESCE(MAX(id), 0)
					FROM revlog AS r3
					WHERE
						r3.cid = revlog.cid
						AND r3.id < revlog.id
						AND (r3.lastIvl != revlog.lastIvl OR r3.type != revlog.type OR r3.ease = 1)
				)
			)
			ELSE 0
		END AS step_n
	FROM revlog {where}
)
SELECT
	CASE
		WHEN lastIvl > 0 AND thetype != 3 THEN NULL
		ELSE {rounded_ivl}
	END AS theIvl,
	thetype,
	MIN(step_n, {max(0, max_step_reps - 1)}) AS n,
	SUM(ease > 1),
	COUNT(*)
FROM answers
GROUP BY theIvl, thetype, n
ORDER BY theIvl"""

	return self.col.db.all(sql)


def get_data_points(correct, total, min_revs):
	data = []
	for i in sorted(correct.keys()):
		t = total[i]
		if t >= min_revs:
			data.append((i, correct[i], t))
	return data


def retention_graphs(self):
	config = mw.addonManager.getConfig(__name__)
	max_ivl = config.get("max_ivl")
	min_revs = int(config.get("min_revs"))
	advanced_mode = bool(config.get("advanced_mode"))
	max_step_reps = int(config.get("max_step_reps"))
	round_steps = bool(config.get("round_steps"))
	show_day = not config.get("hide_review_day")
	show_week = not config.get("hide_review_week")
	show_month = not config.get("hide_review_month")

	learning_data = {}
	day_data = []
	week_correct = defaultdict(int)
	week_total = defaultdict(int)
	month_correct = defaultdict(int)
	month_total = defaultdict(int)
	data = get_data(self, max_ivl, advanced_mode, max_step_reps, round_steps)
	for ivl, thetype, n, correct, total in data:
		if thetype == 3:
			if ivl <= 31 and total >= min_revs:
				day_data.append((ivl, correct, total))
			if ivl <= 364 or not show_month:
				week = (ivl + 6) // 7
				week_correct[week] += correct
				week_total[week] += total
			month = (ivl + 30) // 31
			month_correct[month] += correct
			month_total[month] += total
		else:
			learning_data[(thetype, ivl, n)] = (correct, total)

	week_data = get_data_points(week_correct, week_total, min_revs)
	month_data = get_data_points(month_correct, month_total, min_revs)

	txt = ""
	if learning_data and not config.get("hide_learn"):
		txt += self._title("Learning Retention", "The percentage of correct answers for each learning step.")
		txt += get_learning_table_html(learning_data)

	review_txt = ""

	if day_data and show_day:
		review_txt += get_graph_html(
			self,
			day_data,
			31,
			id="review-retention-day",
			xunit=1
		)

	if week_data and show_week and (not show_day or data[-1][0] > 31):
		review_txt += get_graph_html(
			self,
			week_data,
			week_data[-1][0],
			id="review-retention-week",
			xunit=7
		)

	if month_data and show_month and (not show_week or data[-1][0] > 364):
		review_txt += get_graph_html(
			self,
			month_data,
			month_data[-1][0],
			id="review-retention-month",
			xunit=31
		)

	if review_txt:
		txt += self._title("Review Retention", "The percentage of correct answers by review interval.")
		txt += review_txt
		if min_revs:
			txt += f"Intervals with less than {min_revs} reviews are not shown."

	return txt


def new_hourGraph(self, _old):
	txt = _old(self)
	txt += retention_graphs(self)
	return txt


stats.CollectionStats.hourGraph = wrap(stats.CollectionStats.hourGraph, new_hourGraph, pos="around")
