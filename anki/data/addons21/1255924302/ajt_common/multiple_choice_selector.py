# Copyright: Ren Tatsumoto <tatsu at autistici.org>
# License: GNU AGPL, version 3 or later; http://www.gnu.org/licenses/agpl.html

from typing import Optional
from collections.abc import Iterable

from aqt.qt import *

from .checkable_combobox import CheckableComboBox


class MultipleChoiceSelector(QGroupBox):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)  # type: ignore
        self._combo = CheckableComboBox()
        self.setTitle("Limit to fields")
        self.setCheckable(True)
        self.setChecked(False)
        self.setLayout(QVBoxLayout())
        self.layout().addWidget(self._combo)
        qconnect(self.toggled, self._react_to_toggle)

    def _react_to_toggle(self, on: bool):
        self._combo.setHidden(not on)

    def setChecked(self, on: bool) -> None:
        self._react_to_toggle(on)
        return super().setChecked(on)

    def set_texts(self, fields: Iterable[str]):
        return self._combo.setCheckableTexts(fields)

    def checked_texts(self) -> list[str]:
        return list(self._combo.checkedTexts()) if self.isChecked() else []

    def set_checked_texts(self, fields: Optional[list[str]]):
        if fields:
            self.setChecked(True)
            self._combo.setCheckedTexts(fields)
        else:
            self.setChecked(False)
