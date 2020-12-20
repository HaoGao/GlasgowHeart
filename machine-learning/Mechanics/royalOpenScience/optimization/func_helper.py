# -*- coding: utf-8 -*-
import joblib
import numpy as np
from data_utils import Datasets
import matplotlib.pyplot as plt


class OptimizationHelper():
    def __init__(self, sklearn_model):
        self.sklearn_model = sklearn_model
        self.models = joblib.load("./results/" + sklearn_model + "_model.m")
        self.y_vec = []
        # niter:Number of evaluations of the objective functions 
        # and of its Jacobian and Hessian.
        self.niter = 0
    def choose_loss(self, loss_flag):
        df_file = "./data_processing/datasets.xlsx"
        df_data = Datasets(df_file)
        df_data.feature_normlize()
        self.q_data_exp, self.y_data_exp = df_data.getExp()
        self.norm_mean, self.norm_std = df_data.norm_mean, df_data.norm_std
        del df_data

        if loss_flag == 'prime_mse':
            self.loss = lambda x : self.vol_strain_loss_func(x)
        elif loss_flag == 'mse':
            self.loss = lambda x : self.loss_func(x)
        else:
            raise ValueError("Error loss function choice.")
        return self.loss

    def replace_y_data_exp(self, y_replace):
        self.y_data_exp = np.reshape(y_replace, self.y_data_exp.shape)
        self.niter = 0

    def mse_loss(self, y_true, y_pred):
        return np.mean(np.square(y_true-y_pred))

    def square_loss(self, y_true, y_pred):
        return np.sum(np.square(y_true-y_pred))

    def norm_mse(self, y_pred, y_true):
        return np.mean(np.square(1 - np.floor_divide(y_pred[1:], y_true[1:])))
    
    def prime_loss(self, y):
        # change into strain volume term.
        step = 25
        p = np.linspace(0, 8, step)
        yPrime = np.zeros((int(y.shape[1]/2), step))
        for ix in range(int(y.shape[1]/2)):
            alp = y[:, ix*2]*self.norm_std[ix*2]+self.norm_mean[ix*2]
            beta = y[:, ix*2+1]*self.norm_std[ix*2+1]+self.norm_mean[ix*2+1]
            yPrime[ix, :] = (p/alp)**(1/beta)
        return yPrime
    def get_y_pre(self, x):
        y_pre = np.zeros(self.y_data_exp.shape)
        for ix, model in enumerate(self.models):
            y_pre[:, ix % 6] += model.predict(x.reshape(1, -1))/5
        return y_pre

    def vol_strain_loss_func(self, x):
        # mse loss by volume and strain term.
        y_pre = self.get_y_pre(x)
        pred = self.prime_loss(y_pre)
        true = self.prime_loss(self.y_data_exp)
        vol_pred, strain_pred = pred[0, :], pred[1:, :]
        vol_true, strain_true = true[0, :], true[1:, :]
        loss = self.square_loss(strain_pred, strain_true) + self.square_loss(vol_pred, vol_true)
        return loss

    def loss_func(self, x):
        # MSE loss
        y_pre = self.get_y_pre(x)
        y_data_exp = np.zeros(y_pre.shape)
        for ix in range(int(y_pre.shape[1])):
            y_pre[:, ix] = y_pre[:, ix]*self.norm_std[ix]+self.norm_mean[ix]
            y_data_exp[:, ix] = self.y_data_exp[:, ix]*self.norm_std[ix]+self.norm_mean[ix]
        loss = self.mse_loss(y_pre, y_data_exp)
        return loss

    # callback to save the function value.
    def callback_save_func_val(self, xk, convergence):
        # xk is the current value of x0
        self.niter = self.niter+1
        error = self.loss(xk)
        print('-'*100)
        print('niter={}:current x={},mse loss={}'.format(self.niter, xk, error))
        self.y_vec.append(error)
        return 

    # Visual
    def visualization(self):
        plt.figure()
        plt.plot(self.y_vec, 'r--', label=self.sklearn_model)
        plt.xlabel('itearation')
        plt.ylabel('objective function')
        #plt.title('loss curve')
        plt.legend(loc='upper right')
        plt.show()