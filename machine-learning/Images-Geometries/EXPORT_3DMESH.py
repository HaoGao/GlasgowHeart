from __future__ import division, print_function, absolute_import
import argparse
ap = argparse.ArgumentParser()
namein = "SOFTWAREdataset"
nameout = "SOFTWAREmesh"

ap.add_argument("mat", 
   help="MRI folder name")
ap.add_argument("-t", "--type", required=True, default="centr", choices=["centr", "rot"],
   help="centred or rotated data alignment")
ap.add_argument("-g", "--gpu", required=False, default=-1, type=int,
   help="gpu number to use (-1 CPU, 0 gpu)")

args = ap.parse_args()
from sklearn.decomposition import PCA
import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'
import utils
os.environ["CUDA_VISIBLE_DEVICES"] = str(args.gpu)
import tensorflow as tf
import numpy as np
np.random.seed(1)
tf.set_random_seed(1)
import sys
import pickle
from datetime import datetime
import h5py
import math
import PIL
import scipy
#import skimage.transform
import PRO
from PIL import Image
from sklearn.utils import shuffle 
ntime = datetime.now().strftime('%m%d_%H%M%S')
print(ntime)
from skimage.transform import resize
DIR = './log/' + ntime
np.random.seed(1)
tf.set_random_seed(1)

dir_in = namein + "/" + args.mat
dir_out = nameout + "/" + args.mat
path = dir_out
try:
    os.mkdir(path)
except OSError:
    print ("Creation of the directory %s failed" % path)
else:
    print ("Successfully created the directory %s " % path) 

_T = True
_F = False
TRAIN = _F
BS = 13
VB = 1
NB = 12
N = 182
CHANN = 9
KOMP = 8
DATATYPE = args.type
print("DATA TYPE = ", DATATYPE)
IMI = []
j = 0
SIZE=64
#SIZE=85
if not TRAIN:
    imis = []
    for ii in range(0,3):
        imi = np.array(Image.open(dir_in+'/seg_la1_'+str(ii)+'.png'))
        imis.append(resize(imi , (SIZE, SIZE), preserve_range= True))
    for ii in range(0,6):
        imi = np.array(Image.open(dir_in + '/seg_sa_'+str(ii)+'.png'))
        imis.append(resize(imi , (SIZE, SIZE), preserve_range= True))
    imis = np.array(imis)
    imis = np.transpose(imis, [1,2,0])
    IMI.append(np.array(imis))
print(np.mean(IMI), np.amax(IMI), "IMI M" )
IMI = np.array(IMI)/ 300  

I = tf.placeholder(tf.float32, [None,  SIZE, SIZE, CHANN ])

comp = tf.placeholder(tf.float32, [None, None ])
MM = tf.placeholder(tf.float32, [None ])
hvm = tf.placeholder(tf.float32)
hvs = tf.placeholder(tf.float32)
    
Y = tf.placeholder(tf.float32, [None, 17376])
#Y = tf.placeholder(tf.float32, [None, 4])
keep_prob = tf.placeholder(tf.float32) # dropout (keep probability)
LR = tf.placeholder(tf.float32) # dropout (keep probability)
print(np.mean(IMI), np.amax(IMI), "IMI M" )
def leaky(xx):
    return tf.maximum(0.01*xx, xx)


def myPCA(hvtrain):
        MM = np.mean(hvtrain, axis=0)
        hvm = np.mean(hvtrain)
        hvtrain -= hvm
        hvs = np.std(hvtrain)
        hvtrain /= hvs
        pca = PCA(n_components=15)
        pca.fit(hvtrain)
        projection=pca.transform(hvtrain)
        reconstruction=pca.inverse_transform(projection) 
        return MM, hvm, hvs, projection, pca.components_[:KOMP]

def conv_net(i,  reuse, is_training):
    with tf.variable_scope('ConvNet', reuse=reuse):

        A1 = tf.nn.leaky_relu
        A2 = tf.nn.leaky_relu
        #i = tf.image.resize_images(i, (56,56))
        if is_training:
            i = tf.image.random_crop(i, [13,60,60,CHANN])
        else: 
            i = i[:, 2: 62, 2 : 62, :]
        print(i.shape)
        qconv1 = tf.layers.conv2d(i[:,:,:,:3]    , 32, 3, strides=(2,2), activation=A1)
        qconv1 = tf.layers.dropout(qconv1, rate=0.01, training=is_training)
        qconv2 = tf.layers.conv2d(qconv1, 32, 3, strides=(2,2), activation=A2)
        qconv2 = tf.layers.dropout(qconv2, rate=0.01, training=is_training)
        qconv3 = tf.layers.conv2d(qconv2, 32, 3, strides=(2,2), activation=A2)
        qconv3 = tf.layers.dropout(qconv3, rate=0.01, training=is_training)
        qconv4 = tf.layers.conv2d(qconv3, 32, 3, strides=(1,1), activation=A1)
        qconv4 = tf.layers.conv2d(qconv4, 32, 3, strides=(1,1), activation=A1)
        qconv5 = tf.layers.conv2d(qconv4, 32, 1, strides=(1,1), activation=A1)
        qfull00 = tf.layers.dense(tf.contrib.layers.flatten(qconv5), KOMP)

        conv1 = tf.layers.conv2d(i[:,:,:,3:]    , 32, 3, strides=(2,2), activation=A2)
        conv1 = tf.layers.dropout(conv1, rate=0.01, training=is_training)
        conv2 = tf.layers.conv2d(conv1, 32, 3, strides=(2,2), activation=A2)
        conv2 = tf.layers.dropout(conv2, rate=0.01, training=is_training)
        conv3 = tf.layers.conv2d(conv2, 32, 3, strides=(2,2), activation=A2)
        conv3 = tf.layers.dropout(conv3, rate=0.01, training=is_training)
        conv4 = tf.layers.conv2d(conv3, 32, 3, strides=(1,1), activation=A1)
        conv5 = tf.layers.conv2d(conv4, 32, 1, strides=(1,1), activation=A1)
        full00 = tf.layers.dense(tf.contrib.layers.flatten(conv5), KOMP)
        c2 = tf.math.add(full00,qfull00)*0.1
        c3 =  tf.layers.dense(c2,KOMP)
        full1 =  tf.multiply(100.0, c3)
        out = tf.math.add((tf.tensordot( full1 , comp, 1) + ((MM -hvm) / hvs)) * hvs ,  hvm)
        #print(out.shape)
    return out, full1

# Construct model
logitstrain, kk = conv_net(I, False, True)
logits, kk = conv_net(I,  True, False)
train = logitstrain # tf.nn.softmax(logitstrain)
prediction = logits
loss_op = tf.reduce_mean( 1 * tf.abs(logitstrain-Y)**2)
#loss_op2 = tf.reduce_mean( 1 * tf.abs(logitstrain-Y))
varss   = [v for v in tf.trainable_variables()]
#print(varss)
lossL2 = tf.add_n([ tf.nn.l2_loss(v) for v in varss ]) * 0.001
loss_op_all = loss_op  + lossL2 #+ loss_op2
optimizer = tf.train.AdamOptimizer(learning_rate=LR)
train_op = optimizer.minimize(  loss_op_all)

accuracy = tf.reduce_mean((prediction - Y)**2)

tf.summary.scalar('err', tf.reduce_mean(accuracy))
merged = tf.summary.merge_all()
 
init = tf.global_variables_initializer()
# Start training
np.set_printoptions(precision=5)

tf.set_random_seed(1)
saver = tf.train.Saver()
RES = []   
print("NETWORK CREATED")
EP =  301
Ktest = []
if TRAIN:
    _MM, _hvm, _hvs, _, _comp  = myPCA(TDFL)
    pickle.dump( [_MM, _hvm, _hvs, _comp] , open('nets/1PCA_PCA_' + DATATYPE + '.pkl','wb'), protocol=4)
else:
    _MM, _hvm, _hvs,  _comp  = pickle.load(open('nets/1PCA_PCA_' + DATATYPE + '.pkl','rb'))
meanY = _MM
for net in range(1): 
  with tf.Session() as sess:
    sess.run(init)
    tf.global_variables_initializer().run()
    saver.restore(sess, "./nets/1PCA_" + DATATYPE +".ckpt")
    print("CNN restored")
    print("INF START")
    if not TRAIN:
        batch_i = IMI
        preds = []
        pred,  k = sess.run([prediction, kk], feed_dict={I: batch_i, 
                                                                       MM:_MM, hvm:_hvm, hvs:_hvs, comp:_comp
                                                                        }) 
        for ii in range(len(k)):
            Ktest.append([args.mat, k[ii], pred[ii]] )
if not TRAIN:
        pickle.dump( (Ktest, [_MM, _hvm, _hvs, _comp]) , open(dir_out + "/pred_" + DATATYPE + '.pkl','wb'), protocol=4)
        np.savetxt(dir_out + "/PCAcomp_" + DATATYPE + ".txt", Ktest[0][1])
        np.savetxt(dir_out + "/mesh_" + DATATYPE + ".txt" , Ktest[0][2])
print("<FINISHED>")
