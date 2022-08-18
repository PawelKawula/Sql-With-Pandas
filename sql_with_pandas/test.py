#!/usr/bin/env python3

import glob
from pathlib import Path


cols = tuple(Path(p).stem for p in glob.glob("resources/tables/*.csv"))
print(cols)
