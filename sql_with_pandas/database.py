# /usr/bin/env python3
# -*- coding: utf-8 -*-

import csv
import os
import sqlite3

import check_foreign as cf
import constants as const
import pandas as pd


def get_table_csv(table, table_loc=const.TABLE_LOC, file_format="%s.csv"):
    df = pd.read_csv(str(os.path.join(table_loc, file_format % table)), sep=",")
    return df.fillna('null')


def get_fk_csv(filename="foreign_keys.csv", table_loc=const.FOREIGN_KEY_LOC):
    return pd.read_csv(os.path.join(table_loc, filename))


def get_tables(cursor):
    tables = [t for (t,) in cursor.execute("select name from sqlite_schema").fetchall()]
    tables.remove("sqlite_sequence")
    return tables


def csv_table(cursor, tablename, filename=None):
    if filename is None:
        filename = f"{tablename}.csv"
    os.makedirs(const.TABLE_LOC, exist_ok=True)
    filepath = os.path.join(const.TABLE_LOC, filename)
    with open(filepath, "w") as file:
        writer = csv.writer(file)
        cursor = cursor.execute(f"select * from {tablename}")
        cols = []
        for col_desc in cursor.description:
            cols.append(col_desc[0])
        writer.writerow(cols)
        for row in cursor:
            writer.writerow(row)


def create_csvs(database_path):
    with sqlite3.connect(database_path) as connection:
        cursor = connection.cursor()
        tables, fks = get_tables(cursor), {}
        for table in tables:
            csv_table(cursor, table)
            fks.update(cf.get_foreign_keys(cursor, table))
        cf.foreign_keys_to_csv(fks)

if __name__ == "__main__":
    df = get_table_csv('products')
    # print(type(tuple(df.columns)), tuple(df.columns))
    print(df.values, type(df.values))
