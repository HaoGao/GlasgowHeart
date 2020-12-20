# -*- coding: utf-8 -*-

import codecs
import array
import pandas as pd
import numpy as np
import os
from lsq_curve_fit import pres_strain_fit, pres_vol_fit
from Config import parameters as pm

def find_exist_niter(file_data_sample):
    import pandas as pd
    samples = pd.read_excel(file_data_sample,header=None)
    samples.columns = ['q1','q2','q3','q4','fun_objs']
    total_size = pm.total_size
    existIndex = [i for i in range(total_size) if samples['fun_objs'][i]!=0]
    return existIndex

def Load_presvol(file_data_presvol):
    # load file presvol(i).dat
    pres,vol=array.array('d'),array.array('d')
    with codecs.open(file_data_presvol, 'r', encoding='utf-8') as f:
        lines=f.readlines()
        for line in lines:
            presvol=line.strip().split()
            pres.append(float(presvol[0]))
            vol.append(float(presvol[-1]))
        f.close()
    return np.array(pres),np.array(vol)

def mean_strain(strain):
    return np.mean(np.delete(strain,0,axis=1),axis=1)
    
def Load_strain(file_data_strain):
    with codecs.open(file_data_strain, 'r', encoding='utf-8') as f:
        lines=f.readlines()
        _strain=array.array('d')
        for line in lines:
            strain_str=line.strip().split()
            for i in range(len(strain_str)):
                _strain.append(float(strain_str[i]))
        strain=np.reshape(_strain,(len(lines),-1))
        f.close()
    return strain     

def write_datasets_pres_vol_ab(abs_dir='./dataSets/',total_size=2000): 
    vol_ab=np.zeros((total_size,2),dtype=np.float64)
    volErrIdx = []
    print("start write pres_vol_ab...")
    for i in range(total_size):
        file_pres_vol=os.path.join(abs_dir,'raw_data','presVol','presvol'+str(i+1)+'.dat')
        # isfile():
        flag=os.path.isfile(file_pres_vol)
        if flag:
            pres,vol=Load_presvol(file_pres_vol)
            if vol[-1] > 3*vol[0] or vol[-1] < 1.2*vol[0]:
                volErrIdx.append(i)
            popt=pres_vol_fit(pres,vol)
            vol_ab[i,:]=popt
        else:
            print('not have presvol{}.dat file.'.format(i+1))
            continue
    print("write done pres_vol_ab...")
    return volErrIdx,vol_ab

def write_datasets_pres_strain_ab(abs_dir='./dataSets/',total_size=2000):
    strain_ab=np.zeros((total_size,len(pm.strain_tags),2),dtype=np.float64)
    strains_ab={}
    print("start write pres_strain_ab...")   
    # Load pres & strain data
    for i in range(total_size):
        file_pres_vol=os.path.join(abs_dir,'raw_data','presVol','presvol'+str(i+1)+'.dat')
        flag=os.path.isfile(file_pres_vol)
        if flag:
            #Load pres data
            pres,_=Load_presvol(file_pres_vol)
        else:
            print('not have presvol{}.dat file.'.format(i+1))
            continue

        for t,tag in enumerate(pm.strain_tags):
            #Load strain data
            file_strain=os.path.join(abs_dir,'raw_data','strain','strain'+tag,"interchangestrain"+tag+str(i+1)+".dat")
            strain=Load_strain(file_strain)
            strain_mean=mean_strain(strain)
            if tag=='min': strain_mean=-1.*strain_mean
            # curve fitting
            strain_ab[i,t,:]=pres_strain_fit(pres,strain_mean)
    strain_ab=np.transpose(strain_ab,[1,0,2]) # -> shape: 3*total_size*2
    for t,tag in enumerate(pm.strain_tags):
        strains_ab[tag]=strain_ab[t]
    print("write done pres_strain_ab...")
    return strains_ab
  
def write_datasets(abs_dir = './dataSets/', total_size = 2000, use_tags = ['max','min']):
    strains_ab = write_datasets_pres_strain_ab(pm.abs_dir, pm.total_size) # shape-> total_size*2
    volErrIdx, vol_ab = write_datasets_pres_vol_ab(pm.abs_dir, total_size) # shape-> total_size*2
    df = pd.read_excel(pm.file_samples, header = None, names = ['q1','q2','q3','q4','fun_objs'])
    errIdx = [i for i in df.index if df['fun_objs'][i]==0 ]
    errIdx.extend(volErrIdx)
    # delete error index of data
    vol_ab = np.delete(vol_ab, errIdx, axis=0)
    df=df.drop(errIdx,axis=0)
    df=df.drop(['fun_objs'],axis=1)
    # add alpha & beta into df.columns
    df['alpha_vol'] = vol_ab[:,0]
    df['beta_vol'] = vol_ab[:,1]
    for tag in pm.use_tags:
        alpha_tag='alpha_'+tag
        beta_tag='beta_'+tag
        strain_ab = np.delete(strains_ab[tag], errIdx, axis=0)
        df[alpha_tag] = strain_ab[:,0]
        df[beta_tag] = strain_ab[:,1]

    # add experimental data to datasets
    vol_ab_exp,strain_ab_exp = write_datasets_exp_ab(
        pm.file_presvol_exp, pm.file_strains_exp, use_tags = pm.use_tags)
    exp_data=np.array([1.,1.,1.,1.]+vol_ab_exp.tolist()+strain_ab_exp.tolist()).reshape((1,-1))
    df2=pd.DataFrame(exp_data,columns=df.columns)
    datasets=pd.concat([df,df2],ignore_index=True)
    datasets.to_excel(pm.file_datasets)
    return

def write_datasets_exp_ab(file_presvol_exp, file_strains_exp, use_tags=['max','min']):
    print("start write exp_ab...") 
    # Load expermiental data
    # -> volume
    pres_exp,vol_exp=Load_presvol(file_presvol_exp)
    popt_exp=pres_vol_fit(pres_exp,vol_exp)
    vol_ab_exp=np.array(popt_exp)
    # -> strain
    strain_ab_exp=np.zeros((len(use_tags),2))
    file_data_strains_exp=[file for tag,file in file_strains_exp.items() if tag in use_tags]
    for ix,(tag,file_data_strain) in enumerate(zip(use_tags,file_data_strains_exp)):
        strain=Load_strain(file_data_strain)
        strain_mean=mean_strain(strain)
        if tag=='min': strain_mean=-1.*strain_mean
        strain_ab_exp[ix,:]=pres_strain_fit(pres_exp,strain_mean) 
    print("write down exp_ab...") 
    return vol_ab_exp.flatten(),strain_ab_exp.flatten()


def write_out_sample_case(file_presvol, file_strain):
    # add experimental data to datasets
    vol_ab_exp,strain_ab_exp=write_datasets_exp_ab(
        file_presvol, file_strain, use_tags=pm.use_tags)
    sample = np.array(vol_ab_exp.tolist() + strain_ab_exp.tolist()).reshape(1,-1)
    return sample

    
    
    

                         
    
        
        