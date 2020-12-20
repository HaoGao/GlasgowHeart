# -*- coding: utf-8 -*-
"""
this is a script to curve fit pres , vol and strain
v0=5.2232010e+01 unitchange=1/0.13332236842105 
shapes as :
        norm_pres=a*norm_vol^b
        norm_pres=a*strain^b  
norm_vol=(v-v0)/v0
norm_pres=unitchange*pres : kpa->mmHg
"""

from scipy.optimize import curve_fit 
#import numpy as np

# fitting function
def func(x,a,b):
    return a*(x**b)

# fit norm_pres & norm_vol
def pres_vol_fit(pres,vol):
    unitchange=1/0.13332236842105
    norm_pres=unitchange*pres
    norm_vol=(vol-min(vol))/min(vol)
    popt, _ = curve_fit(func,norm_vol,norm_pres,maxfev=5000,gtol=1e-8)
    return popt

# norm_pres & strain
def pres_strain_fit(pres,strain):
    unitchange=1/0.13332236842105
    norm_pres=unitchange*pres
    popt, _ = curve_fit(func,strain,norm_pres,maxfev=5000,gtol=1e-8)
    return popt

# norm_pres-norm_vol/norm_strain
def norm_fit(pres,arg):
    unitchange=1/0.13332236842105
    norm_pres=unitchange*pres
    norm_arg=(arg-min(arg))/(max(arg)-min(arg))
    popt, _=curve_fit(func,norm_arg[1:],norm_pres[1:],maxfev=50000)
    return popt
    

            
            
