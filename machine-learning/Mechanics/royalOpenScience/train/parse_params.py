import argparse

def parse_args(sklearn_model):
    parser = argparse.ArgumentParser(description = 'sklearn_model ： %s' %(sklearn_model))
    parser.add_argument('--save_dir'    , default='./results', type=str, help='')

    if sklearn_model == 'gpr':
        parser.add_argument('--hyper_params' , default=[
        {"length_scale" : 1.02, "length_scale_bounds" : "fixed"},
        {"length_scale" : 0.825, "length_scale_bounds" : "fixed"},
        {"length_scale" : 0.658, "length_scale_bounds" : "fixed"},
        {"length_scale" : 0.694, "length_scale_bounds" : "fixed"},
        {"length_scale" : 0.807, "length_scale_bounds" : "fixed"},
        {"length_scale" : 0.79, "length_scale_bounds" : "fixed"},
        ], 
        type=dict, help='hyper parameters for 6 sub-models')
        
    elif sklearn_model == 'knn':
        parser.add_argument('--hyper_params' , default=[
        {'n_neighbors': 10, 'p': 2,
        'algorithm': 'brute', 'weights': 'distance', 'metric': 'minkowski', 'n_jobs': -1},
        {'n_neighbors': 8, 'p': 1,
        'algorithm': 'brute', 'weights': 'distance', 'metric': 'minkowski', 'n_jobs': -1},
        {'n_neighbors': 8, 'p': 1,
        'algorithm': 'brute', 'weights': 'distance', 'metric': 'minkowski', 'n_jobs': -1},
        {'n_neighbors': 6, 'p': 1,
        'algorithm': 'brute', 'weights': 'distance', 'metric': 'minkowski', 'n_jobs': -1},
        {'n_neighbors': 8, 'p': 1,
        'algorithm': 'brute', 'weights': 'distance', 'metric': 'minkowski', 'n_jobs': -1},
        {'n_neighbors': 6, 'p': 1,
        'algorithm': 'brute', 'weights': 'distance', 'metric': 'minkowski', 'n_jobs': -1},
        ], 
        type=dict, help='hyper parameters for 6 sub-models')

    elif sklearn_model == 'xgboost':
        parser.add_argument('--hyper_params' , default=[
        {'n_estimators': 1000, 'max_depth': 6, 'learning_rate':0.05,
        'objective':'reg:squarederror', 'booster':'gbtree', 'n_jobs':-1},
        {'n_estimators': 1000, 'max_depth': 6, 'learning_rate':0.05,
        'objective':'reg:squarederror', 'booster':'gbtree', 'n_jobs':-1},
        {'n_estimators': 1000, 'max_depth': 6, 'learning_rate':0.1,
        'objective':'reg:squarederror', 'booster':'gbtree', 'n_jobs':-1},
        {'n_estimators': 1000, 'max_depth': 6, 'learning_rate':0.05,
        'objective':'reg:squarederror', 'booster':'gbtree', 'n_jobs':-1},
        {'n_estimators': 1000, 'max_depth': 4, 'learning_rate':0.05,
        'objective':'reg:squarederror', 'booster':'gbtree', 'n_jobs':-1},
        {'n_estimators': 1000, 'max_depth': 4, 'learning_rate':0.1,
        'objective':'reg:squarederror', 'booster':'gbtree', 'n_jobs':-1},
        ],
        type=dict, help='hyper parameters for 6 sub-models')

    elif sklearn_model == 'mlp':
        parser.add_argument('--hyper_params' , default=[
            {'hidden_layer_sizes' : (1024,), 'learning_rate_init' : 1e-3, 'activation' : 'relu',
                            'early_stopping' : True, 'tol' : 1e-4, 'n_iter_no_change' : 10, 'max_iter' : 200},
            {'hidden_layer_sizes' : (1024,), 'learning_rate_init' : 1e-3, 'activation' : 'relu',
                            'early_stopping' : True, 'tol' : 1e-4, 'n_iter_no_change' : 10, 'max_iter' : 200},
            {'hidden_layer_sizes' : (1024,), 'learning_rate_init' : 1e-3, 'activation' : 'relu',
                            'early_stopping' : True, 'tol' : 1e-4, 'n_iter_no_change' : 10, 'max_iter' : 200},
            {'hidden_layer_sizes' : (512,), 'learning_rate_init' : 0.001, 'activation' : 'relu',
                            'early_stopping' : True, 'tol' : 1e-4, 'n_iter_no_change' : 10, 'max_iter' : 200,
                            'random_state' : 42},
            {'hidden_layer_sizes' : (1024,), 'learning_rate_init' : 1e-3, 'activation' : 'relu',
                            'early_stopping' : True, 'tol' : 1e-4, 'n_iter_no_change' : 10, 'max_iter' : 200},
            {'hidden_layer_sizes' : (1024,), 'learning_rate_init' : 1e-3, 'activation' : 'relu',
                            'early_stopping' : True, 'tol' : 1e-4, 'n_iter_no_change' : 10, 'max_iter' : 200}
        ],
        type=dict, help='hyper parameters for 6 sub-models')
    else:
        raise ValueError('Unknown sklearn_model')

    return parser.parse_args()