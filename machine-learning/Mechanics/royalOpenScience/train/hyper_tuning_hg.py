# -*- coding: utf-8 -*-
"""
Created on Mon Nov 16 00:12:01 2020

@author: sharp
"""

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

# for violin plot
import seaborn as sns

import joblib

from data_utils import Datasets
import warnings
warnings.filterwarnings('ignore')

def mse_loss(y_true,y_pred):
    return np.mean(np.square(y_true-y_pred))

fold = KFold(n_splits=5, shuffle=True, random_state=42)
def run_6sub_oof(clf, params):
    models = []
    pred = np.zeros(y_test.shape)
    oof = np.zeros(y.shape)
    for index, (train_idx, val_idx) in enumerate(fold.split(X)):
        x_tr, y_tr = X[train_idx,:], y[train_idx, :]
        x_val, y_val = X[val_idx,:], y[val_idx, :]

        tr_pred = np.zeros(y_tr.shape)
        val_pred = np.zeros(y_val.shape)
        test_pred = np.zeros(y_test.shape)
        for ix, para in enumerate (params):
            sub_model = clf(**para)
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
    print("#"*100)
    print('Test: mse loss={:.6f} r2_score={:.6f}'.format(
            mse_loss(y, oof),metrics.r2_score(y_test, pred)))
    return models,oof,pred


if __name__ == "__main__":
    
    ## Load data
    df_file = "../data_processing/datasets.xlsx"
    df_data = Datasets(df_file)
    df_data_ori = df_data.data.copy(deep=True) # in pd dataframe
    q_data_unnorm, y_data_unnorm = df_data.get_all_data()
    df_data.feature_normlize() # label normlization
    X, y, X_test, y_test = df_data.train_test_split()
    q_data_norm, y_data_norm = df_data.get_all_data()
    
    # some post_processing for ploting
    feature_columns = df_data.label_column
    df_data.data[feature_columns].boxplot() #the original data frame is wrapped
    plt.gca().set_ylabel("norm value",fontdict={"size":18})
    plt.gca().set_xlabel("feature name",fontdict={'family' : 'Times New Roman', 'size' : 18})
    plt.show()
    
    ## plot the original unnormalized data 
    df_data_ori[feature_columns].boxplot() #the original data frame is wrapped
    plt.gca().set_ylabel("unnorm value",fontdict={"size":18})
    plt.gca().set_xlabel("feature name",fontdict={'family' : 'Times New Roman', 'size' : 18})
    plt.show()
    
    ## violin plot
    fig, axes = plt.subplots()
    axes.violinplot(dataset = [ df_data.data[feature_columns[0]].values,     
                                df_data.data[feature_columns[1]].values,
                                df_data.data[feature_columns[2]].values,
                                df_data.data[feature_columns[3]].values,
                                df_data.data[feature_columns[4]].values,
                                df_data.data[feature_columns[5]].values  ] )
    axes.set_title('output features')
    axes.yaxis.grid(True)
    axes.set_xlabel('features',fontdict={"size":18})
    axes.set_ylabel('norm value',fontdict={'family' : 'Times New Roman', 'size' : 18})
    
    # training the knn model
    knn_params=[]
    grid_params ={
            'n_neighbors': [1, 2, 4, 6, 8, 10, 12, 14],
            'p': [1, 2],
            'algorithm': ['ball_tree'],
            'weights': ['distance'],
            'metric': ['minkowski'],
            'n_jobs': [-1]
        }
    sub = GridSearchCV(KNeighborsRegressor(), grid_params, scoring = 'r2', n_jobs = -1, cv = 5)

    for feat_flag in range(len(feature_columns)):
        print('GridSearch for feature %d' % feat_flag)
        sub.fit(X, y[:, feat_flag])
        print(sub.best_params_)
        knn_params.append(sub.best_params_)
    
    # predicting the output and others using the selected hyperparameters
    for feat_flag in range(len(feature_columns)):
        print('fitting feature %d' % feat_flag)
        sub = KNeighborsRegressor(**knn_params[feat_flag])
        sub.fit(X, y[:, feat_flag])
        pred = sub.predict(X_test)
        print('Test: mse loss={:.6f} r2_score={:.6f}'.format(
            mse_loss(y_test[:, feat_flag], pred),metrics.r2_score(y_test[:, feat_flag], pred)))
    
    ## now we will re-train the knn model using 5-fold cross-validation
    knn_models, knn_oof, knn_pred = run_6sub_oof(KNeighborsRegressor, knn_params)
    joblib.dump(knn_models, "./Results/knn_models.m")

    ## load the model 
    knn_models = joblib.load("./Results/knn_models.m")
    
    ###### training the xgboost model
    xgboost_params = []
    grid_params = {
            'n_estimators' : [500, 1000, 2000],
            'max_depth' : [1, 2, 4, 6, 8, 16],
            'learning_rate' : [0.05, 0.1, 0.2],
            'objective' : ['reg:squarederror'],
            'booster' : ['gbtree'],
            'n_jobs' : [-1]
        }
    sub = GridSearchCV(XGBRegressor(), grid_params, scoring = 'r2', n_jobs = -1, cv = 5)
    
    for feat_flag in range(len(feature_columns)):
        print('GridSearch for feature %d' % feat_flag)
        sub.fit(X, y[:, feat_flag])
        print(sub.best_params_)
        xgboost_params.append(sub.best_params_)
    
    # predicting the output and others using the selected hyperparameters
    for feat_flag in range(len(feature_columns)):
        print('fitting feature %d' % feat_flag)
        sub = XGBRegressor(**xgboost_params[feat_flag])
        sub.fit(X, y[:, feat_flag])
        pred = sub.predict(X_test)
        print('XGBoost Test: mse loss={:.6f} r2_score={:.6f}'.format(
            mse_loss(y_test[:, feat_flag], pred),metrics.r2_score(y_test[:, feat_flag], pred)))
        
    ###training the MLP
    mlp_params=[]
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
    for feat_flag in range(len(feature_columns)):
        print('GridSearch for feature %d' % feat_flag)
        sub.fit(X, y[:, feat_flag])
        print(sub.best_params_)
        mlp_params.append(sub.best_params_)
    
     # predicting the output and others using the selected hyperparameters
    for feat_flag in range(len(feature_columns)):
        print('fitting feature %d' % feat_flag)
        sub = MLPRegressor(**mlp_params[feat_flag])
        sub.fit(X, y[:, feat_flag])
        pred = sub.predict(X_test)
        print('MLP Test: mse loss={:.6f} r2_score={:.6f}'.format(
            mse_loss(y_test[:, feat_flag], pred),metrics.r2_score(y_test[:, feat_flag], pred)))
    
    ###training the Gaussian process
    
    
       

    models = knn_models
    ##optimization
    def loss_func(x):
        # MSE 
        y_pre=np.zeros(y_data_exp.shape)
        for ix, model in enumerate(models):
            y_pre[:, ix % 6] += model.predict(x.reshape(1, -1))/5
        #print(y_pre,y_data_exp)
        loss = mse_loss(y_pre, y_data_exp)
        return loss 
    
    q_data_exp, y_data_exp = df_data.getExp()
    loss=loss_func(q_data_exp)
    print(loss)
    
    # callback to save the function value.
    def callback_save_func_val(xk, convergence):
        # xk is the current value of x0
        global niter
        niter=niter+1
        error=loss_func(xk)
        print('-'*100)
        print('niter={}:current x={},mse loss={}'.format(niter,xk,error))
        x_vec.append(xk)
        y_vec.append(error)
        return
    
    from scipy.optimize import differential_evolution
    import random
    import time
    start_time=time.clock()
    global niter#niter:Number of evaluations of the objective functions and of its Jacobian and Hessian.
    niter=0
    start_time=time.clock()
    
    lb=0.2*q_data_exp[0]
    ub=5*q_data_exp[0]
    x0=(random.random()*(ub-lb)+lb)
    print('initiate point x:',x0)
    x_vec,y_vec=[],[]
    #res=differential_evolution(loss_func,bounds=[(lb[i],ub[i])for i in range(len(lb))],args=(knn_models,)
    res=differential_evolution(loss_func,bounds=[(lb[i],ub[i])for i in range(len(lb))]
                , strategy='best1bin', maxiter=10, popsize=10, tol=1e-6, mutation=(0.5, 1)
                , callback=callback_save_func_val, recombination=0.7)
    end_time=time.clock()
    print ('#'*100)
    print(res)
    print('optimation cost time=%f(s)' %(end_time-start_time))
        
   


