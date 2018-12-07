#!/usr/bin/python
import numpy as np
import scipy.sparse
import pickle
import xgboost as xgb

dtrain = xgb.DMatrix('train.txt')
dtest = xgb.DMatrix('test.txt')

param = {'gamma':0.1, 'max_depth':20, 'learning_rate':1.0, 'eta':1, 'silent':0, 'objective':'binary:logistic'}#'objective':'count:poisson'#'objective':'reg:logistic'

watchlist = [(dtest, 'eval'), (dtrain, 'train')]
num_round = 6
bst = xgb.train(param, dtrain, num_round, watchlist)

# this is prediction
preds = bst.predict(dtest)
labels = dtest.get_label()

print(preds)

print('error=%f' % (sum(1 for i in range(len(preds)) if int(preds[i] > 0.5) != labels[i]) / float(len(preds))))
bst.save_model('xgb.model')
# dump model
bst.dump_model('dump.raw.txt')
# dump model with feature map
#bst.dump_model('dump.nice.txt', 'featmap.txt')
