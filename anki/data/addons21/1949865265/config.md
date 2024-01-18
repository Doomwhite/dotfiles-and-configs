**advanced_mode**: If true, first review after the last learning or relearning step is shown as a "Graduation" step,
and successive same-length learning steps are separated. Can be slow.

**max_step_reps**: Maximum number of repeats to show for a learning step. Repeats after this are combined.
If advanced_mode is not true, this has no effect.

**max_ivl**: Reviews with an interval longer than this are not shown. Those are likely too spread out to provide useful
information and make the graph less legible. Set to 0 to show all.

**min_revs**: Review intervals with less than this many reviews are not shown.

**round_steps**: If true, long learning steps are rounded down to whole days. This makes a practical difference only if
you have used the v1 or v2 schedulers in the past. The v3 scheduler never stores learning steps with fractional days.

**hide_learn**: If true, statistics for learning steps are never shown.

**hide_review_day**: If true, the graph for learning intervals up to a month is never shown.

**hide_review_week**: If true, the graph for long learning intervals is never shown.

**hide_review_month**: If true, a separate graph for learning intervals over a year is never shown. If you enable it,
remember to set max_ivl to 0 or a sufficiently large value. True by default (i.e. the graph is not enabled).