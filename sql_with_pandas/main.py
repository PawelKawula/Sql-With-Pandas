# /usr/bin/env python3
# -*- coding: utf-8 -*-

import argparse

import pandas as pd

import database as db
import check_foreign as cf

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="CRUD operations on sqlite3 database")
    parser.add_argument(
        "-d",
        dest="database_path",
        action="store",
        default="resources/ElectricShop.db",
        help="Path to the .db file",
    )
    parser.add_argument(
        "--create-csv",
        dest="create_csv",
        action=argparse.BooleanOptionalAction,
        default=False,
    )
    args = parser.parse_args()

    if args.create_csv:
        db.create_csvs(args.database_path)
