#!/usr/bin/env python3

import glob
from pathlib import Path

import tkinter as tk
import customtkinter as ctk
from tkinter import ttk

import database as db
import constants as const
import model
import check_foreign as check_fk


class View(ctk.CTkFrame):
    def __init__(self, master):
        super().__init__(master)
        self.master = master
        self.update()
        self._configure_option_pane()
        self._configure_tables()
        self.pack(expand=True, side=tk.TOP, fill=tk.BOTH)
        tables = tuple(Path(p).stem for p in glob.glob("resources/tables/*.csv"))
        self.pdatabase = model.PandasDatabase(tables,
                       foreign_keys=check_fk.foreign_keys_read())

    def _configure_option_pane(self):
        self.option_pane = tk.PanedWindow(self)
        self.option_pane.pack(side=tk.TOP)
        var = tk.StringVar()
        self.label_pane = ctk.CTkLabel(self.option_pane, textvariable=var)
        var.set("Choose CRUD option")
        self.label_pane.pack(side=tk.TOP)
        self.crud_box = ctk.CTkComboBox(self.option_pane, values=tuple(const.CRUD_MAP))
        self.crud_box.pack(side=tk.TOP, expand=True, fill=tk.BOTH)
        self.attr = []
        self.execute_button = ctk.CTkButton(self.option_pane, text="Execute", command=self._execute)
        self.execute_button.pack(side=tk.BOTTOM, fill=tk.BOTH, expand=True)
        self.add_att_button = ctk.CTkButton(self.option_pane, text="Add attrib", command=self._add_attrib)
        self.add_att_button.pack(side=tk.BOTTOM, fill=tk.BOTH, expand=True)
        # self.add_attrib_button = ctk.CTkButton(
        #     self.option_pane,
        #     text="Add attrib",
        #     command=self._add_attrib_button_callback,
        # )
        # self.add_attrib_button.pack(side=tk.BOTTOM, fill=tk.BOTH, expand=True)
        #
    def destroy_attrib(self, att):
        self.attr.remove(att)

    def _add_attrib(self):
        att = CrudInstructionArgument(self.option_pane)
        att.pack(side=tk.TOP)
        self.attr.append(att)

    def _execute(self):
        print(self.attr[0])
        args = [att.entry_box.get() for att in self.attr]
        df = self.pdatabase.process_request(const.CRUD_MAP[self.crud_box.get()],
                                            self.input_panes[0].combo_box.get(),
                                            args)
        refresh_table(self.result_pane.table, tuple(df.columns), df.values)


    def _choose_crud(self, event_object):
        self.argument_pane.delete()
        self.argument_pane = ArgumentPane(self.option_pane,
                                          const.REV_CRUD_MAP[self.crud_box.get()])
        self.argument_pane.pack(side=tk.BOTTOM, expand=True, fill=tk.BOTH)

    def _add_attrib_button_callback(self):
        self.attr.append(CrudInstructionArgument(self.option_pane))

    def _configure_tables(self):
        self.tables_pane = tk.Canvas(self)
        self.tables_pane.pack(side=tk.TOP, expand=True)
        cols = tuple(Path(p).stem for p in glob.glob("resources/tables/*.csv"))
        self.input_panes = [TablePane(self.tables_pane, cols) for i in range(2)]
        self.input_panes[0].pack(side=tk.LEFT, ipadx=50, ipady=50, expand=True)
        self.input_panes[1].pack(side=tk.RIGHT, ipadx=50, ipady=50, expand=True)
        self.result_pane = TablePane(self.tables_pane, cols, output=True)
        self.result_pane.pack(side=tk.LEFT, ipadx=50, ipady=100, anchor=tk.S)


class TablePane(tk.Canvas):
    def __init__(self, master, columns, width=200, height=400, output=False):
        super().__init__(master, width=width, height=height)

        if not output:
            self.combo_box = ctk.CTkComboBox(
                self, values=columns, command=self._combo_callback
            )
            self.combo_box.pack(side=tk.TOP, fill="x")

        self.table = ttk.Treeview(self)
        self.table.pack(expand=True, fill=tk.BOTH, ipady=200, side=tk.BOTTOM)

        self.vscrollbar = ctk.CTkScrollbar(
            self.table, orientation=tk.VERTICAL, command=self.table.yview
        )
        self.vscrollbar.pack(fill=tk.Y, side=tk.RIGHT)

        self.hscrollbar = ctk.CTkScrollbar(
            self.table, orientation=tk.HORIZONTAL, command=self.table.xview
        )
        self.hscrollbar.pack(fill=tk.X, side=tk.BOTTOM)

        self.table.configure(
            yscrollcommand=self.vscrollbar.set, xscrollcommand=self.hscrollbar.set
        )
        self.pack(fill=tk.BOTH)

    def _combo_callback(self, event_object):
        df = db.get_table_csv(self.combo_box.get())
        columns, data = tuple(df.columns), df.values
        refresh_table(self.table, columns, data)


class CrudInstructionArgument(ctk.CTkCanvas):
    def __init__(self, master, crud_type=const.InstructionType.SELECT, deleteable=True):
        super().__init__(master)
        self.master = master
        self.entry_box = ctk.CTkEntry(self)
        self.entry_box.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        if deleteable:
            self.delete_button = ctk.CTkButton(
                self, text="X", command=self._destroy_widget, width=10
            )
            self.delete_button.pack(side=tk.LEFT, expand=False, fill=None)
        self.pack(side=tk.TOP, fill=tk.BOTH, expand=True)

    def _destroy_widget(self):
        self.entry_box.destroy()
        self.delete_button.destroy()
        self.destroy()
        self.master.master.destroy_attrib(self)


# class CrudInstructionArgument(ctk.CTkCanvas):
#     def __init__(self, master, crud_type=const.InstructionType.SELECT, deleteable=True):
#         super().__init__(master)
#         self.master = master
#         self.combo_box = ctk.CTkComboBox(self)
#         self.combo_box.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
#         if deleteable:
#             self.delete_button = ctk.CTkButton(
#                 self, text="X", command=self._destroy_widget, width=10
#             )
#             self.delete_button.pack(side=tk.LEFT, expand=False, fill=None)
#         self.pack(side=tk.TOP, fill=tk.BOTH, expand=True)

#     def _destroy_widget(self):
#         self.combo_box.destroy()
#         self.delete_button.destroy()
#         self.destroy()

def refresh_table(table, columns, data):
    table["columns"] = columns
    table.column("#0", width=0, stretch=tk.NO)
    for column in columns:
        table.column(column, anchor=tk.CENTER, width=60, stretch=tk.NO)
        table.heading(column, text=column, anchor=tk.CENTER)
    table.delete(*table.get_children())
    for i, d in enumerate(data):
        table.insert(parent="", index="end", iid=i, text="", values=tuple(d))
    table.pack(expand=True, fill=tk.BOTH)

root = ctk.CTk()
root.geometry("1200x800")
View(root).mainloop()
