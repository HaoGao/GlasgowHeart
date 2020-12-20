# -*- coding: utf-8 -*-
import os
import sys
from Config import parameters as pm
from preprocessing import write_datasets, write_out_sample_case

if __name__=="__main__":
    if os.path.isfile(pm.file_datasets):
        pass
    else:
        write_datasets(pm.abs_dir, pm.total_size)

    