#  The Left Ventricle Software  for 2D Segmentation and 3D Mesh prediction
This package has only been tested in our own local linux workstation with python 3.6. Before running the actual code, you will need to run e.sh to set up the python environment, which is managed by anaconda. 

* EXPORT_CROPS.py takes raw data and prepares for segmentation.

* EXPORT_SEG.py loads data created in EXPORT_CROPS and calls exportSEGsoftware.py which runs the segmentation software.

* EXPORT_3DMESH.py uses network to create the reconstruction of the LV geometry.

* dataset contains all of the images to be used for segmentation.