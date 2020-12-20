# -*- coding: utf-8 -*-
import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os
from sklearn.model_selection import KFold, GridSearchCV
from sklearn import metrics
from sklearn.neighbors import KNeighborsRegressor
from xgboost import XGBRegressor
from sklearn.neural_network import MLPRegressor
from sklearn.gaussian_process import GaussianProcessRegressor
from sklearn.gaussian_process.kernels import DotProduct, WhiteKernel
from sklearn.gaussian_process.kernels import ConstantKernel, RBF

from data_utils import Datasets
import warnings
warnings.filterwarnings('ignore')

def mse_loss(y_true,y_pred):
    return np.mean(np.square(y_true-y_pred))

if __name__ == "__main__":
        
    ## Load data
    df_file = "../data_processing/datasets.xlsx"
    df_data = Datasets(df_file)
    df_data.feature_normlize() # label normlization
    X, y, X_test, y_test = df_data.train_test_split()

    feat_flag = 0
    sklearn_model = 'gpr'
    if sklearn_model == 'gpr':
        kernel = RBF(length_scale=0.5, length_scale_bounds=(0.0, 10.0))
        # kernel = RBF(**gpr_para[feat_flag])
        sub = GaussianProcessRegressor(kernel=kernel,
                random_state=0)

        sub.fit(X, y[:, feat_flag])
        

        print(sub.kernel_)
    elif sklearn_model == 'knn':
        grid_params ={
            'n_neighbors': [1, 2, 4, 6, 8, 10, 12, 14],
            'p': [1, 2],
            'algorithm': ['ball_tree'],
            'weights': ['distance'],
            'metric': ['minkowski'],
            'n_jobs': [-1]
        }
        sub = GridSearchCV(KNeighborsRegressor(), grid_params, scoring = 'r2', n_jobs = -1, cv = 5)

        sub.fit(X, y[:, feat_flag])
        print(sub.best_params_)
    elif sklearn_model == 'xgboost':
        grid_params = {
            'n_estimators' : [500, 1000, 2000],
            'max_depth' : [1, 2, 4, 6, 8, 16],
            'learning_rate' : [0.05, 0.1, 0.2],
            'objective' : ['reg:squarederror'],
            'booster' : ['gbtree'],
            'n_jobs' : [-1]
        }
        sub = GridSearchCV(XGBRegressor(), grid_params, scoring = 'r2', n_jobs = -1, cv = 5)

        sub.fit(X, y[:, feat_flag])
        print(sub.best_params_)
    elif sklearn_model == 'mlp':
        grid_params = {
            'hidden_layer_sizes' : [(128), (256,),(512,),(1024,)],
            'learning_rate_init' : [5e-3, 1e-2, 5e-2, 1e-3],
            'activation' : ['relu'],
            'early_stopping' : [True],
            'tol' : [1e-4],
            'n_iter_no_change' : [10],
            'max_iter' : [200]
        }
        sub = GridSearchCV(MLPRegressor(), grid_params, scoring = 'r2', n_jobs = -1, cv = 5)

        sub.fit(X, y[:, feat_flag])
        print(sub.best_params_)
    else:
        raise ValueError('Unknown sklearn_model')

    pred = sub.predict(X_test)
    print('Test: mse loss={:.6f} r2_score={:.6f}'.format(
        mse_loss(y_test[:, feat_flag], pred),metrics.r2_score(y_test[:, feat_flag], pred)))

