# -*- coding: utf-8 -*-
import os
import pandas as pd
import numpy as np
from parse_params import parse_args
from sklearn.model_selection import KFold, GridSearchCV
from sklearn import metrics
from sklearn.neighbors import KNeighborsRegressor
from xgboost import XGBRegressor
from sklearn.neural_network import MLPRegressor
from sklearn.gaussian_process import GaussianProcessRegressor
from sklearn.gaussian_process.kernels import DotProduct, WhiteKernel
from sklearn.gaussian_process.kernels import ConstantKernel, RBF
import joblib
import gc

from data_utils import Datasets
import warnings
warnings.filterwarnings('ignore')

def mse_loss(y_true,y_pred):
    return np.mean(np.square(y_true-y_pred))

def run_6sub_oof(clf, params, X, y, X_test, y_test):
    models = []
    pred = np.zeros(y_test.shape)
    oof = np.zeros(y.shape)
    fold = KFold(n_splits=5, shuffle=True, random_state=42)
    for index, (train_idx, val_idx) in enumerate(fold.split(X)):
        x_tr, y_tr = X[train_idx,:], y[train_idx, :]
        x_val, y_val = X[val_idx,:], y[val_idx, :]

        tr_pred = np.zeros(y_tr.shape)
        val_pred = np.zeros(y_val.shape)
        test_pred = np.zeros(y_test.shape)
        for ix, para in enumerate (params):
            if clf == GaussianProcessRegressor:
                kernel = RBF(**para)
                sub_model = GaussianProcessRegressor(kernel=kernel, random_state=0) 
            else: sub_model = clf(**para)

            sub_model.fit(x_tr, y_tr[:, ix])
            tr_pred[:, ix] = sub_model.predict(x_tr)
            val_pred[:, ix] = sub_model.predict(x_val)
            test_pred[:, ix] = sub_model.predict(X_test)
            models.append(sub_model) 
        oof[val_idx, :] = val_pred
        print('_'*100)
        print(index+1, 'Train: mse loss = {:.6f} r2_score = {:.6f}, Validation: mse loss = {:.6f} r2_score = {:.6f}'.format(
            mse_loss(y_tr, tr_pred), metrics.r2_score(y_tr, tr_pred),
            mse_loss(y_val, val_pred), metrics.r2_score(y_val, val_pred)))
        pred = pred+ test_pred/fold.n_splits
        del x_tr, y_tr, x_val, y_val
        gc.collect() 
    print("#"*100)
    print('Test: mse loss={:.6f} r2_score={:.6f}'.format(
            mse_loss(y, oof),metrics.r2_score(y_test, pred)))
    
    return models, oof, pred


if __name__ == "__main__":
    ## Load data
    df_file = "./data_processing/datasets.xlsx"
    df_data = Datasets(df_file)
    df_data.feature_normlize() # label normlization
    X, y, X_test, y_test = df_data.train_test_split()

    # init which machine learning model to train 
    sklearn_model = 'mlp'

    params = parse_args(sklearn_model)

    if sklearn_model == 'gpr':
        models, oof, pred = run_6sub_oof(GaussianProcessRegressor, params.hyper_params, X, y, X_test, y_test)
    elif sklearn_model == 'knn':
        models, oof, pred = run_6sub_oof(KNeighborsRegressor, params.hyper_params, X, y, X_test, y_test)        
    elif sklearn_model == 'xgboost':
        models, oof, pred = run_6sub_oof(XGBRegressor, params.hyper_params, X, y, X_test, y_test)  
    elif sklearn_model == 'mlp':
        models, oof, pred = run_6sub_oof(MLPRegressor, params.hyper_params, X, y, X_test, y_test)        
    else:
        raise ValueError('Unknown sklearn_model')

    joblib.dump(models, os.path.join(params.save_dir, sklearn_model + "_model.m"))



    
