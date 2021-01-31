# LVgeometry-prediction

Codes and data for "Neural Network-Based Left Ventricle Geometry Prediction from CMR Images with Application in Biomechanics"

## Short instructions:
EXPORT_CROPS.py takes raw data and prepares for segmentation.

EXPORT_SEG.py loads data created in EXPORT_CROPS and calls exportSEGsoftware.py which runs the segmentation software.

EXPORT_3DMESH.py uses network to create the reconstruction of the LV geometry.

dataset contains all of the images to be used for segmentation.

## Detailed instructions: 
 
### 1. Export required MATLAB data, and copy .mat data to your server

Matlab code runs on Desktop (for each patient exports a .mat file) 
Exported data is in exportedAI folder.

The file is SegmentationResultExportOrig.m,
it calls the file at the beginning that gives patient names,
you need to edit first and execute either:
- SegmentationResultExport_SubjectLists
- SegmentationResultExport_SubjectLists_HV 
Uncomment patients you want to export, or give folder names to new data.


### 2. Go to the GPU Server

Data is Located at:
- seg/exportedAI (early-diastole) 
- seg/exportedAI2 (second frame, not used) 

Copy the files to your folder.
run ". e.sh" to initialize CUDA/GPU/PYTHON
main files are in this directory, and in /ukbb_cardiac for SEG network.


### 3. Aligning the datasets 

The original MRI scans are orientated in different ways.
These were annotated to perform rotations/flips to align them.

FILE with annotations:
"annot.txt" [3 LongAxis annotations -- flips ] 

Format:
<PATIENT NAME> ???
where '?' in {'.' [ok], 'X' [x-flip], 'Y' [y-flip]}, 
and each symbol described each LA-view, e.g.:
"""
HV10 ..X
HV11 Y..
"""

SA images are in 2 different configurations in total, and are rotated by 
+90 degrees automatically by checking if the image is in the horizontal 
or portrait mode, hence no annotation of SAs is needed.

All images come at different scales, but the scaling factor is saved 
in the metadata, so all images are rescaled automatically.


### 4. Take the crops from the MRI images -- convert .mat to images/Python files.

Convert exportedAI to crops (use "annot.txt").
These files also save the 3D meshes stored in "pca_all/PCAALLFIX.p"
The meshed are stored in the order given in "seg/all_id.txt",
except 5 indices that were removed (198 out of 203)
[[ code "if i in [27, HVN + 60, HVN + 77, HVN + 78, HVN + 13" ]]

Then, additional examples are excluded (that had some issues),
plus examples with less than 6 SA images are excluded.
This leads to 182 examples.

These files produce dataset of crops of 160x160 pixels 
(central crop -- centre based on annotated curves, 
image resized using pixel_spacing value, cropping with reflect option)

OLD FILES: 
1) 2mattest.py [images only -- two frames (!) ], folder: /2dataset

2) Qmattest.py [segmentation-only], folder /Qdataset
!! DO NOT USE THIS FILE -- AQmattest.py is an improved version!! -- 

3) AQmattest.py [images / segmentations] 
ALIGNED AND FIXED DATA -- LA slices are rotated:
[[ This is the most important dataset processing file.     ]]
[[ See the source code to better understand the dataset.   ]]
[[ All the operations involving flipping etc. make use of  ]]
[[ auxiliary variables to keep track of the LV centre,     ]]
[[ and where the annotated points of the top of the LV     ]]
[[ have been transformed. Then LA rotations are calculated.]]   

    This script exports the dataset and also rotates the LA LVs. 
    Ways to run it -- choose whether to export images/segmentations 
        set -- EXP_IMG to True/False, and run two times.
        
        The main outputs are stored in:     
        AQdataset, AQdatasetIMG


### 5. Additional crops from the MRI images for different purposes
        
        I also run AQdataset with the LA rotation commented-off, and stored in: 
        TAQdataset TAQdatasetIMG
        
        Setting variable TEST to "H" produces: 
        HAQdataset, dataset of segmentations for Hao without the top-wall.
        
        HAQdatasetTRANSF.p contains the list of transformations applied
        (crops, flips, rotations, resize, etc)
        so as to transform the predictions in the MRI coordinates.



### 6. The crops are saved also in pickle files, these are used by Python codes

Datasets on server:

0) datasetf.p  + /dataset/ [old 2019 dataset, standard 9 images] 

1) 2dataset.p + /2dataset/  [images only -- not related to segmentation] 
18 images [9 slices x 2 frames], in turns frame 1 and frame 2 
[LA2.1,LA2.2,LA4.1,LA4.2,LA1.1,LA1.2,SA0.1,SA02, etc..]

2) Qdataset.p + /Qdataset/  [segmentations] 
images in turns as above, [LA2.cavity, LA2.cavity+wall, LA4.cavity, ......]
18 images [9 slices x 2 segmentations].
The segmentation used for training is a pixelwise-sum of these, i.e.:
classes: {CAVITY=2, WALL=1, BACKGROUND=0}

3) AQdataset.p + /AQdataset/  [segmentations -- analogous to the above] 


 
### 7. Images + GT Segmentations were used to train CNNs to predict LV segmentation.
 

Code of segmentation network is located at /ukbb_cardiac/
Points 9. and 10. give details of running of the segmentation network.

Predicted Segmentations (trained without test splits) were saved in:
SA:
* ukbb_cardiac/SEGdataset  [transfer -- Bai network as initialization] 
* ukbb_cardiac/SEGdatasetV2 [random weights]
LA:
* ukbb_cardiac/SEGdatasetLA2 [random weights]
* ukbb_cardiac/SEGdatasetLA3  [transfer -- Bai network] -- rotated LAs (main)
* ukbb_cardiac/SEGdatasetLA4  [transfer -- Bai network] -- not rotated LAs
* ukbb_cardiac/SEGdatasetLA3  [transfer -- Bai network] -- predictions for Hao


 
### 8. Predicted segmentations are used to predict the 3D Mesh
 
CNNs for mesh prediction:
train + evaluation -- 14 splits of 13 examples, 182 examples total
* ornn.py [input: images] / ICSTA19 --                  score = 0.049
* qnn.py  [input: GT seg]                               score = 0.030
* SEGnn.py X [input: predicted seg [not used anymore]]  score = 0.032 

X -- optional argument -- number of PCA components to use.
In each CNN you can change 'KOMP' variable to choose 
the number of PCA components used (1..10).
The files use PCAALLFIX.p file, generated by pca_all.py code,
this exports PCA matrix and other variables needed.

* splitsSEGnn_old.py X 
-- version of SEGnn with proper train/test splits.
PCA is fitted at each testing iteration using training dataset, obtains 0.033

* splitsSEGnn.py X 
-- centred data -- obtains 0.026

* PROsplitsSEGnn.py X 
-- centred + PROcrustes-rotated data -- obtains 0.025

The predictions are stored in Ktest.pkl file

These are 182-element list L of 
[patient_name, PCAcomponents, PRED_MESH, GT mesh]
to open in Python:
L = pickle.load(open("Ktest.pkl", "rb"))
One can store any other outputs by extending the list of variables stored.

The outputs were stored here:
/xlwork4/2026068l/Lukasz/Ktest_centred.pkl
/xlwork4/2026068l/Lukasz/Ktest_rot.pkl

forKOMP.sh runs the chosen network in a loop with different numbers of the components.



 
### 9. Segmentation Network -- TRAINING
 
ukbb: /ukbb_cardiac/common/

*** training ***
python train_network.py <splitID>, splitID in 0..13
(run ukbb_cardiac/common/for.sh for loop)

Networks are named as "v*" for SA and "la*" for LA, * is the version of network.
These trained networks are saved in folders:
common/models/v*_<splitID>/, splitID in 0..13
- v2 / la2 are trained with random weights init
- v3 / la3 are trained with Bai init 

- la4 is without LA rotation
- la5 is with no wall at the top of LV for Hao

In train_network.py, you need to set the name of the model to export,
e.g. la5_' for la5:
model_name='la5_'+str(FLAGS.net)

Paths to dataset are specified in the train_network.py, lines 130..210.

 
### 10. Segmentation Network -- PREDICTION / EVALUATION
 
File: deploy_network.py <splitID>
called from /ukbb_cardiac/ folder via:
python demo_pipeline.py (model name "v*/la*" is specified in this file)

deploy_network.py:
lines 159..170 -- read the image,
(uses file /F.pkl that contains names for splits),
212..220 -- save the segmentation.

need to set output dir eg:  
data_dir = 'SEGdatasetLA5' 

One can replace code to read images with own ones,
but these need to be generated by a modified AQmattest.py file,
i.e. the crops need to be taken in the same way.

Evaluation:
There is dice.py file that calculates the Dice scores for test set SAs,
and LAdice for LAs. You can change there the paths to the predictions and GT.

Exporting the predictions in the original MRI coordinates:
    exportSEG.py exports the predicted segmentations, using the *TRANSF.p file,
    by undoing all image transformations in the reversed order.
    This currently saves wall only, but one can easily enable back the cavity.

    These were exported to:
    * AQdatasetEXPORTED (see point 4.) 
    * HAQdatasetEXPORTED (see point 5.)

SOFTWARE:

These are EXPORT_* files as per the instruction of SOFTWARE.

1PCA.py has been used to train the 3D mesh network [centr/rot] and export it and PCA files.
These are saved in /nets/ folder under a few 1PCA_* names.


