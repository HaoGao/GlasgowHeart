# -*- coding: utf-8 -*-
#import os
import pandas as pd
class Datasets(object):
    def __init__(self, file_data):
        self.data = pd.read_excel(file_data, index_col=0)
        self.data.columns = ['q1', 'q2', 'q3', 'q4', r'$\alpha^v$', r'$\beta^v$', r'$\alpha^1$',
                r'$\beta^1$', r'$\alpha^2$', r'$\beta^2$']
        self.label_column = [ r'$\alpha^v$', r'$\beta^v$', r'$\alpha^1$',
                r'$\beta^1$', r'$\alpha^2$', r'$\beta^2$']
    def __len__(self):
        return len(self.data)
    def feature_normlize(self):
        self.norm_mean, self.norm_std = [], []
        for col in self.label_column:
            self.norm_mean.append(self.data[col].mean())
            self.norm_std.append(self.data[col].std())
            self.data[col] = (self.data[col]-self.norm_mean[-1])/self.norm_std[-1] 
    
    def train_test_split(self, train_rate = 0.9):
        q_data, y_data = self.data.iloc[:,:4],self.data.iloc[:,4:]
        train_size = int(train_rate * len(self.data))
        q_data_train, q_data_test = q_data.iloc[:train_size,:], q_data.iloc[train_size:,:]
        y_data_train, y_data_test = y_data.iloc[:train_size,:], y_data.iloc[train_size:,:]
        return q_data_train.values, y_data_train.values, q_data_test.values, y_data_test.values
    
    def getExp(self):
        q_data_exp, y_data_exp=self.data.iloc[-1,:4],self.data.iloc[-1,4:]
        return q_data_exp.values.reshape((1,-1)), y_data_exp.values.reshape((1,-1))
    
    def get_all_data(self):
        q_data, y_data=self.data.iloc[:,:4],self.data.iloc[:,4:]
        return q_data.values, y_data.values

   


    



     



