# /usr/bin/env python3
# -*- coding: utf-8 -*-

from enum import IntEnum


class FkCheck(IntEnum):
    ON_CASCADE, NO_ACTION, RESTRICT, SET_NULL = range(4)


class InstructionType(IntEnum):
    SELECT, UPDATE, INSERT, DELETE = range(4)

CRUD_MAP = dict(
    {str(e)[str(e).find(".") + 1 :]: e for e in InstructionType}
)
REV_CRUD_MAP = dict(
    {e: str(e)[str(e).find(".") + 1 :] for e in InstructionType}
)

Joins = {"INNER_JOIN": "inner", "LEFT_JOIN": "left", "RIGHT_JOIN": 'right'}


SYNTAX_TO_QUERY = {
    "and": "&",
    "or": "|",
    "|": "|",
    "&": "&",
}

TABLE_LOC = "resources/tables"
FOREIGN_KEY_LOC = "resources"

print(str(InstructionType))
print(str(InstructionType.SELECT)[str(InstructionType.SELECT).find(".")+1:])
for e in InstructionType:
    print(e)
    print(str(e)[str(e).find(".")+1:])
