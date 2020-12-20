# -*- coding: utf-8 -*-
import os
import time
from scipy.optimize import differential_evolution
from func_helper import OptimizationHelper
import random
import numpy as np



if __name__ == "__main__":
    start_time = time.clock()
    sklearn_model = 'xgboost'
    loss_flag = 'mse'
    opr = OptimizationHelper(sklearn_model)
    loss = opr.choose_loss(loss_flag)
    
    start_time = time.clock()

    lb = 0.1*opr.q_data_exp[0]
    ub = 5*opr.q_data_exp[0]
    x0 = (random.random()*(ub-lb)+lb)
    print('initiate point x:', x0)
    
    res = differential_evolution(loss, bounds=[(lb[i],ub[i])for i in range(len(lb))]
                , strategy='best1bin', maxiter=500, popsize=50, tol=1e-6, mutation=(0.5, 1)
                , recombination=0.7,callback=opr.callback_save_func_val)
    end_time = time.clock()
    print ('#'*100)
    print(res)
    print('optimation cost time=%f(s)' %(end_time-start_time))
    opr.visualization()
    np.save(os.path.join("./results", sklearn_model+"_y_vec.npy") , np.array(opr.y_vec))