# /usr/bin/env python3
# -*- coding: utf-8 -*-

import sqlite3
import argparse

import pandas as pd
import numpy as np

import database as db
import constants as const
import check_foreign as check_fk


class PandasDatabase:
    def __init__(
        self,
        tables: list[str],
        foreign_keys: set = set(),
        table_loc: str = const.TABLE_LOC,
        file_format: str = "%s.csv",
    ):
        self._tables = {t: db.get_table_csv(t, table_loc, file_format) for t in tables}
        self._foreign_keys = foreign_keys
        self._instruction_to_function = {
            const.InstructionType.SELECT: self._select_request,
            const.InstructionType.UPDATE: self._update_request,
            const.InstructionType.INSERT: self._insert_request,
            const.InstructionType.DELETE: self._delete_request,
        }

    def _select_request(self, table: str, args: list[str]):
        query, df, joins_till = "", self._tables[table], 0
        for arg in args:
            print(arg)
            arg = arg.split()
            print(arg)
            if arg[0] not in const.Joins:
                break
            print(arg)
            how, second_table, first_col, second_col = arg
            how = how.upper()
            joins_till += 1
            df = pd.merge(
                df,
                self._tables[second_table],
                left_on=first_col,
                right_on=second_col,
                how=const.Joins[how]
            )
        return self._delete_request(df, args[joins_till:]) if args[joins_till:] else df

    def _update_request(self, table: str, args: list[str]):
        query = ""
        for arg in args:
            col, concat, op, val = arg.split()
            query += f"`{col}` {op} {val} {concat}"
        df = self._tables[table]
        self._tables[table] = df.drop(df.query(query).index)

    def _insert_request(self, table, *args):
        query = ""
        for row in args:
            self._tables[table].append(row, ignore_index=True)

    def _delete_request(self, table: str, args: list[str]):
        query = ""
        for arg in args[:-1]:
            col, concat, op, val = arg.split()
            print(arg)
            query += f"`{col}` {op} {val} {concat}"
        print(args)
        col, op, val = args[-1].split() if len(args) > 1 else args[0].split()
        query += f"`{col}` {op} {val}"
        df = self._tables[table] if isinstance(table, str) else table
        if isinstance(table, str):
            self._tables[table] = df.drop(df.query(query).index)
            return self._tables[table]
        else:
            return df.query(query)

    def process_request(
        self, instruction_type: const.InstructionType, table: str, args
    ):
        if (
            instruction_type not in self._instruction_to_function
            or table not in self._tables
        ):
            return None
        return self._instruction_to_function[instruction_type](
            table, args
        )

    def _get_foreign_keys_for_table(self, table):
        return {k: v for k, v in self._foreign_keys.items() if k[0] == table}


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="CRUD operations on sqlite3 database")
    parser.add_argument(
        "-d",
        dest="database_path",
        action="store",
        default="resources/ElectricShop.db",
        help="Path to the .db file",
    )
    args = parser.parse_args()
    with sqlite3.connect(args.database_path) as connection:
        pdat = PandasDatabase(
            db.get_tables(connection.cursor()),
            foreign_keys=check_fk.foreign_keys_read(),
        )
        #print(pdat._tables['products'])
        # pdat.process_request(
        #     const.InstructionType.DELETE, "products", [["productId", "==", 5, ""]]
        # )
        #print(pdat._tables['products'])
        print(pdat.process_request(
            const.InstructionType.SELECT, "products",
            ["INNER_JOIN producents producentId producentId", "productId > 20"]
        ))
