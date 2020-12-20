# -*- coding: utf-8 -*-
import os
import pandas as pd
class parameters(object):
    numPoint = 195

    abs_dir = "F:\\renlei_study\\paper\\regression-surroages\\data_processing"
    total_size = 10000
    train_size = round(0.9*total_size)
    test_size = total_size - train_size

    strain_tags = ['max','mid','min']
    use_tags = ['max','min']
    file_presvol_exp = os.path.join(abs_dir, 'raw_data','presVol','presvol.dat')
    file_strains_exp = {}
    for tag in strain_tags:
        file_strains_exp[tag] = os.path.join(abs_dir, 'raw_data','strain','strain'+tag,"interchangestrain"+tag+".dat")
    
    file_presvol_out_sample1 = os.path.join(abs_dir, 'raw_data','presVol','presvol10001.dat')
    file_strains_out_sample1 = {}
    for tag in strain_tags:
        file_strains_out_sample1[tag] = os.path.join(abs_dir, 'raw_data','strain','strain'+tag,"interchangestrain"+tag+"10001.dat")

    file_presvol_out_sample2 = os.path.join(abs_dir, 'raw_data','presVol','presvol10002.dat')
    file_strains_out_sample2 = {}
    for tag in strain_tags:
        file_strains_out_sample2[tag] = os.path.join(abs_dir, 'raw_data','strain','strain'+tag,"interchangestrain"+tag+"10002.dat")

    file_samples = os.path.join(abs_dir, 'raw_data', 'ParFun.xls')
    file_datasets = os.path.join(abs_dir, 'raw_data','datasets.xlsx')
    file_mat = os.path.join(abs_dir, 'raw_data',"lsq_fun.mat")