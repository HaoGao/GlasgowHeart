from sklearn.decomposition import PCA
import scipy.misc
#Implementing autoencoder training with cross validation
import numpy as np
import os
import time
import math
import multiprocessing
import pickle
from sklearn import preprocessing
import matplotlib.pyplot as plt
import sys
from PIL import Image
import glob
import matplotlib.pyplot as plt
from skimage.draw import line, polygon, circle, ellipse
from skimage.transform import resize as imresize
from scipy.ndimage.interpolation import shift

#DIR = ""
#annots = [line.rstrip('\n') for line in open('annot.txt')]
#DIR = "seg/exported_AI/"
#DIR2 = "seg/exported_AI2/"
#lines = [line.rstrip('\n') for line in open('seg/all_id.txt')]

#name = 'AQdataset' 

import argparse
ap = argparse.ArgumentParser()
ap.add_argument("mat", 
   help="MRI folder name")
args = ap.parse_args()

filename = args.mat
data_dir = 'SOFTWAREdataset' 
expdir = data_dir + "/" +  filename

def unresize(im, s):
    a, a2 = im.shape
    #print(s)
    newa = int(round( a / s[0]))
    im = imresize(im , (newa, newa), preserve_range = True, order= 0)
    return im


def scale(im):
    im = im / np.mean(im)
    return (im/np.amax(im) * 250 ).astype(np.uint8)

TRANSF = pickle.load(open(expdir +"/TRANSF.p", "rb"))

ii=0
for trans in TRANSF:  
    if len(trans) == 10:
        f, v, oriim, shape, center, ang, ps, sh, what, transpose = trans
        imi = np.array(Image.open(data_dir+"/"+filename+'/seg_la2_'+str(ii)+'.png'))
        ii += 1
    else:
        ii = 0 
        f, v, oriim, shape, center, ang, ps = trans
        sh = 0
        what = '.'
        transpose = False
        #if v > 5:qq
            #continue
        imi = np.array(Image.open(data_dir + "/" + filename +'/seg_sa_'+str(v)+'.png'))
        v = "SA"+str(v)
    if ii == 1: 
        print(f)


    Npad = 100
    backg = np.zeros((shape), dtype = np.uint8)
    backg = np.pad(backg, Npad)

    

    imi = np.pad(imi, sh)
    imi = shift(imi, (0,sh) , cval=0)
    imi = unresize(imi,ps)



    if ang is not False:
        if ang is True:
            imi  = np.rot90(imi, k=-1)
        else:
            imi = scipy.ndimage.rotate(imi, -ang, reshape=True, order=0)





    if what == 'Y':
        imi = np.flip(imi, 1)            
    if what == 'X':
        imi = np.flip(imi, 0)            
    if transpose:
        imi = imi.T

    a = imi.shape[0]
    a2m = a//2
    a2p = a - a2m
    cx,cy = center
    #print(a,a2m,a2p,cx,cy, np.amax(imi))


    #Image.fromarray(imi.astype(np.uint8), 'L').save(expdir + "/" + "imi_" +  v + ".png")
    backg[Npad + cx - a2m : Npad + cx + a2p , Npad + cy - a2m : Npad + cy + a2p] = imi
    backg = backg[100:-100, 100:-100]


    backg[ backg > 120] = 0
    #backg[bacgk == 160] = 0
    ori = scale(oriim)
    ori [backg > 0] = 255
    #print(shape, backg.shape)
    imob = Image.fromarray(ori, 'L')
    #os.makedirs(expdir + "/" + f, exist_ok=True)
    imob.save(expdir + "/" + "MRI_" +  v + ".png")



































