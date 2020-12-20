# -*- coding: utf-8 -*-
import time
from scipy.optimize import differential_evolution
from func_helper import OptimizationHelper
import random
import numpy as np
from data_utils import Datasets
from collections import deque
from joblib import Parallel, delayed



def gen_sample_by_residual(y_residual):
    q = deque()
    q.append(np.zeros(shape = y_residual.shape))

    for i in range(len(y_residual)):
        size = len(q)
        while size:
            curq = q.popleft()

            for pos in [0., y_residual[i]]:
                curq[i] = pos
                q.append(curq.copy())
            size -= 1

    while q:
        yield q.popleft()

def get_optimize_res(q_data_infer, opr, sample):

    y_pred = opr.get_y_pre(q_data_infer)

    lb = 0.1*opr.q_data_exp[0]
    ub = 5*opr.q_data_exp[0]
    x0 = (random.random()*(ub-lb)+lb)

    opr.replace_y_data_exp(sample + y_pred.reshape((-1)))
    res = differential_evolution(opr.loss, bounds=[(lb[i],ub[i])for i in range(len(lb))]
            , strategy='best1bin', maxiter=500, popsize=50, tol=1e-6, mutation=(0.5, 1)
            , recombination=0.7,callback=opr.callback_save_func_val)
    return res





if __name__ == "__main__":
    sklearn_model = 'mlp'
    loss_flag = 'mse'
    opr = OptimizationHelper(sklearn_model)
    loss = opr.choose_loss(loss_flag)
    q_data_infer = np.array([1.0066, 0.9788, 1.0869, 1.2164], dtype=np.float32)
    y_pred = opr.get_y_pre(q_data_infer)
    y_residual = (opr.y_data_exp - y_pred).reshape((-1))
    
    Res = Parallel(n_jobs=-1)(delayed(get_optimize_res)(q_data_infer, opr, sample) 
                                 for sample in gen_sample_by_residual(y_residual))

    np.save('./results/' + sklearn_model + '_infer_uq', Res)


