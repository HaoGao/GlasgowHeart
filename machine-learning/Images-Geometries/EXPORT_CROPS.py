import numpy as np
import scipy.misc
from skimage.transform import resize as imresize
import os
import math
import scipy . io as sio
import pickle
from PIL import Image
#import getopt, sys
import argparse
ap = argparse.ArgumentParser()
ap.add_argument("mat", 
   help="MRI folder name")
ap.add_argument("-a", "--annot", required=False, default="...",
   help="annotation, one character per each LA slice, e.g. X.Y")
ap.add_argument("-t", "--type", required=False, default="new", choices=["new", "old"],
   help="old vs new. Old required X.mat file, new X/ folder with 3 files")
ap.add_argument("-f","--frame", default=0,
   help="frame number")

args = ap.parse_args()


name = "SOFTWAREdataset"
DIR = "SOFTWAREdata"
#F = "ER01/imDesired"ann = args.annot
F = args.mat
EXP_IMG = True
TRANSF = []
frame = int(args.frame)
if args.type == "new":
    NEW = True
if args.type == "old":
    NEW = False
OLD = not NEW

def crop_center_fixed(img, sh):
    crop = 160
    y, x = img.shape
    cropx = crop
    cropy = crop
    startx = x//2-(cropx//2)+sh
    starty = y//2-(cropy//2)
    return img[starty:starty+cropy, startx:startx+cropx]

def crop_center(img, mx, my):
    x, y = img.shape
    N = 200
    img = np.pad(img, 200, 'constant')
    cropx = min(y, x) #*63 // 100
    cropy = min(y, x) #*63 // 100
    startx = N+mx-(cropx//2)
    starty = N+my-(cropy//2)
    #print(mx, my, cropy, "from", startx, "till", startx+cropx, starty, starty+cropy)
    ret = img[startx:startx+cropx, starty:starty+cropy]
    if ret.shape[0] != ret.shape[1]:
        print("ret", ret.shape, cropx, cropy)
    return ret

def resize(im, s, sh=0):
    a, _ = im.shape
    newa = int(a * s)
    im = imresize(im, (newa, newa), preserve_range=True)
    im = crop_center_fixed(im, sh)
    return im



def dist(x1, y1, x2, y2):
    return ((x1-x2)**2+(y1-y2)**2)**0.5


def scale(im):
    im = np.clip(im, 0 , 600)
    return (im/np.amax(im) * 255).astype(np.uint8)

for f in [F]:
    if OLD:
        D = sio.loadmat(DIR + "/" + f + ".mat")
        SXLEN = len(D["imdesiredExported"]["SXSlice"][0][0][0])
    if NEW:
        D = sio.loadmat(DIR + "/" + f + "/imDesired.mat")
        DSA = sio.loadmat(DIR + "/" + f + "/BaseSACentre.mat")
        DLA = sio.loadmat(DIR + "/" + f + "/LABaseStartEnd.mat")
        SXLEN = len(D["imDesired"]["SXSlice"][0][0][0])
    if SXLEN < 6:
        print("less than 6 slices")
    ims = []
    imsSA = []
    pssSA = []
    pss = []
    exc = 0
    which = 0
    ann = args.annot
    for v in ["LVOT", "FourCH", "OneCH"]:
        if OLD:
            pss.append(D["imdesiredExported"][v+"_PixelSpacing"][0][0][0])
            im = D["imdesiredExported"][v+"_imdata"][0][0]
        if NEW:
            pss.append(D["imDesired"][v+"Slice"][0][0][0][0][0][frame]["imInfo"][0]["PixelSpacing"][0][0][0])
            im = (D["imDesired"][v+"Slice"][0][0][0][0][0][frame]["imData"][0])
        oriim = np.array(im)
        #print(DLA)
        if OLD:
                SEGx = int(D["DataSegLA"][0][which]["epi_c"][1][0])
                SEGy = int(D["DataSegLA"][0][which]["epi_c"][0][0])
                SEG2x = int(D["DataSegLA"][0][which]["epi_c"][1][-1])
                SEG2y = int(D["DataSegLA"][0][which]["epi_c"][0][-1])
                _SEGx = int(D["DataSegLA"][0][which]["endo_c"][1][0])
                _SEGy = int(D["DataSegLA"][0][which]["endo_c"][0][0])
                _SEG2x = int(D["DataSegLA"][0][which]["endo_c"][1][-1])
                _SEG2y = int(D["DataSegLA"][0][which]["endo_c"][0][-1])
        if NEW:
                SEGx = int(DLA['LABaseStartEnd'][0][which]["epi_c"][1][0])
                SEGy = int(DLA["LABaseStartEnd"][0][which]["epi_c"][0][0])
                SEG2x = int(DLA["LABaseStartEnd"][0][which]["epi_c"][1][-1])
                SEG2y = int(DLA["LABaseStartEnd"][0][which]["epi_c"][0][-1])
                _SEGx = int(DLA["LABaseStartEnd"][0][which]["endo_c"][1][0])
                _SEGy = int(DLA["LABaseStartEnd"][0][which]["endo_c"][0][0])
                _SEG2x = int(DLA["LABaseStartEnd"][0][which]["endo_c"][1][-1])
                _SEG2y = int(DLA["LABaseStartEnd"][0][which]["endo_c"][0][-1])
        dx, dy = (SEG2x - SEGx), (SEG2y - SEGy)
        _dx, _dy = (_SEG2x - _SEGx), (_SEG2y - _SEGy)

        which += 1
        Mx = (SEGx + SEG2x + _SEGx + _SEG2x) // 4
        My = (SEGy + SEG2y + _SEGy + _SEG2y) // 4
        x, y = im.shape

        if v[0] == 'F':
            what = ann[0]
        if v[0] == 'L':
            what = ann[1]
        if v[0] == 'O':
            what = ann[2]
        trans = False
        cdx, cdy = 0, 0
        im = crop_center(im, Mx+cdx, My+cdy)
        #im2 = crop_center(im2, Mx+cdx, My+cdy)
        if v[0] == 'F':
            what = ann[0]
            if x > y:
                print(f, "FT")
                #exc = 1
        if v[0] == 'L':
            what = ann[1]
            if x > y:
                #LT += 1
                im = im.T
                #im2 = im2.T
                #print(f, "LT")
                _tmp = _dy
                _dy = -_dx
                _dx = -_tmp
                tmp = dy
                dy = -dx
                dx = -tmp
                trans = True
        if v[0] == 'O':
            what = ann[2]
            if x < y:
                print(f, "OT")
                #exc = 1
        if what not in ['.', 'Y', 'X']:
            raise Exception
        if what != '.':
            if what == 'Y':
                im = np.flip(im, 1)
                #im2 = np.flip(im2, 1)
                _dx = - _dx
                dx = - dx 
            if what == 'X':
                im = np.flip(im, 0)
                #im2 = np.flip(im2, 0)
                _dy = -_dy
                dy = -dy

        ang = math.degrees(math.atan2(dx, dy))-90
        _ang = math.degrees(math.atan2(_dx, _dy))-90
        if ang > 90 or ang < -90:
            ang += 180
        if _ang > 90 or _ang < -90:
            _ang += 180
        ang2 = (ang + _ang)/2
        if EXP_IMG:
            order = 3
        im = scipy.ndimage.rotate(im, ang2, reshape=True, order=order)
        #im2 = scipy.ndimage.rotate(im2, ang2, reshape=True, order=order)
        im = resize(im, pss[-1], 20) 
        im = scale(im)
        #im2  = resize(im2, pss[-1],20) 
        #im2 = scale(im2)
        imob = Image.fromarray(im, 'L')
        #imob2 = Image.fromarray(im2, 'L')

        TRANSF.append([f, v, oriim, (x, y), (Mx+cdx, My+cdy), ang2, pss[-1], 20, what, trans])
        os.makedirs(name + "/" + f, exist_ok=True)
        imob.save(name + "/"  + f + "/" + v + ".png")
            #imob2.save(name + "/"  + f + "/2" + v + ".png")
        ims.append(im)
        #ims.append(im2)
    for v in range(SXLEN):
        if OLD:
                pssSA.append(D["imdesiredExported"]["SXSlice"][0][0][0][v]["PixelSpacing"][0])
                imSA = D["imdesiredExported"]["SXSlice"][0][0][0][v]["imData"]
        if NEW:
                pssSA.append(D["imDesired"]["SXSlice"][0][0][0][v][0][frame]["imInfo"][0]["PixelSpacing"][0][0][0])
                imSA = (D["imDesired"]["SXSlice"][0][0][0][v][0][frame]["imData"][0])
        oriim = np.array(imSA)
        x, y = imSA.shape
        if v == 0: 
            which = v
            if OLD:
                    for it in range(len(D["DataSegSA"][0][which]["endo_c"][1])):
                        Mx = int(D["DataSegSA"][0][which]["endo_c"][1][it])
                        My = int(D["DataSegSA"][0][which]["endo_c"][0][it])
                    cMx = int(np.mean(D["DataSegSA"][0][which]["endo_c"][1]))
                    cMy = int(np.mean(D["DataSegSA"][0][which]["endo_c"][0]))
            if NEW:
                    #print(DSA)
                    cMx = int(DSA['BaseSACentre'][0][which]["endo_c"][1][0])
                    cMy = int(DSA["BaseSACentre"][0][which]["endo_c"][0][0])

        #if v == 0 and x < y:
            #print (f, "SA ROT")
            #SAROT += 1

        #if v == 0 and SXLEN < 6:
            #print(f, "low number of SA ____",  SXLEN)
        imSA = crop_center(imSA, cMx, cMy)
        rot = False
        if x < y:
            imSA = np.rot90(imSA)
            #imSA2  = np.rot90(imSA2)
            rot = True
        imSA = resize(imSA, pssSA[-1])
        imSA = scale(imSA)
        imSAob = Image.fromarray(imSA, 'L')
        #imSA2 = resize(imSA2, pssSA[-1])
        #imSA2 = scale(imSA2)
        #imSAob2 = Image.fromarray(imSA2, 'L')
        TRANSF.append([f, v, oriim, (x, y), (cMx, cMy), rot, pssSA[-1]])
        imSAob.save(name + "/"  + f + "/SA" + str(v) + ".png")
            #imSAob2.save(name + "/"  + f + "/2SA" + str(v) + ".png")
        #imsSA.append(imSA)
        #imsSA.append(imSA2)
        #print(pssSA[-1])
    #pcafile.write(f +" "+ str(projection[proji]) + "\n")
    #ALLPS.extend(pss)
    #ALLPSSA.extend(pssSA)
    #if ALLPS[-1] < 1.25 or ALLPS[-1] > 1.7:
        #print(ALLPS[-1], f)
    #imarr = np.array(ims + imsSA[:12])
    #print(imarr.shape)
    #DATASET.append((f, imarr, projection[proji], hv[proji] ))
#pickle.dump(DATASET, open(name +".p", "wb"))
pickle.dump(TRANSF, open(name + "/" + f +"/TRANSF.p", "wb"))
#print("SAROT total = ", SAROT, "LT total = ", LT)
#ALLPS =np.array(ALLPS).flatten()
#ALLPSSA =np.array(ALLPSSA).flatten()
#print("TOTAL LONG", ALLPS.shape)
#print("TOTAL SHORT", ALLPSSA.shape)
#print("LONG", np.amax(ALLPS), np.amin(ALLPS))
#print("SHORT", np.amax(ALLPSSA), np.amin(ALLPSSA))
#print("TOTAL EXPORTED:", total)
#for t,v in TIMES.items():
    #if len(v) > 1:
        #print(v)
#pcafile.close()
print("EXPORTED!")
