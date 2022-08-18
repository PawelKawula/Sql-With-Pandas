# /usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import csv

import database as db
import constants as const


def get_foreign_keys(cursor, tablename):
    fks = {}
    (table_schema,) = cursor.execute(
        "select sql from sqlite_master "
        "where type='table' and name='%s'" % (tablename,)
    ).fetchone()
    aps = "`" if table_schema.find("`") != -1 else '"'
    if not table_schema or table_schema.find("FOREIGN") == -1:
        return fks

    def ignore_col(inp, i, j=1):
        for _ in range(j):
            i = inp.find(aps, i)
            i = inp.find(aps, i + 1) + 1
        return i

    def get_col_name(inp, i):
        start = inp.find(aps, i) + 1
        end = inp.find(aps, start + 1)
        return inp[start:end], end + 1

    table_name, _ = get_col_name(table_schema, 0)
    schema = table_schema[table_schema.find("CONSTRAINT") :].split(",")
    for constraint in schema:
        if "REFERENCES" in constraint:
            i = ignore_col(constraint, 0)
            foreign_key, i = get_col_name(constraint, i)
            primary_key = ["", ""]
            primary_key[0], i = get_col_name(constraint, i)
            primary_key[1], i = get_col_name(constraint, i)
            fks[(table_name, foreign_key)] = tuple(primary_key)
    return fks


def foreign_keys_to_csv(fks, filename="foreign_keys.csv"):
    if not fks:
        return
    os.makedirs(const.FOREIGN_KEY_LOC, exist_ok=True)
    filepath = os.path.join(const.FOREIGN_KEY_LOC, filename)
    with open(filepath, "w", encoding="UTF-8") as file:
        writer = csv.writer(file)
        for key, value in fks.items():
            writer.writerow(key + value)


def foreign_keys_read(filename="foreign_keys.csv"):
    fks = {}
    filepath = os.path.join(const.FOREIGN_KEY_LOC, filename)
    with open(filepath, encoding="UTF-8") as file:
        reader = csv.reader(file)
        for line in reader:
            fks[tuple(line[:2])] = tuple(line[2:])
    return fks


if __name__ == "__main__":
    print(foreign_keys_read())
