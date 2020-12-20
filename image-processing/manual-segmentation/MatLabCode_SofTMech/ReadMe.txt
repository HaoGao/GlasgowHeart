
SegmentationResultExport_SubjectLists.m
This needs to be done manually to set up the name and dir for each subject. The matlab code will search the configure file for segmentation in the corresponding dir, and figure out the index for early diastole. 


SegmentationResultExport.m
export the early-diastole image data and corresponding boundaries, saved in export_root_dir. It will only save the early-diastolic images and their boundaries. Thus it requires much less disk space to save. Png images are also saved for inspection.


Changes may be needed when run with different account
(1) update each line in SegmentationResultExport_SubjectLists.m, ensuring original segmentation results are there
(2) (may) update the export_root_dir, where you can write out files 



In each exported folder, the matlab file img_seg_data.m is the exported data

img_seg_data format explanation

--DataSegLA : segmented BC, 1: LVOT, 2: four chamber, 3: one chamber;  

--DataSegSA : short axis segmentation, from basal to apex 

--imdesiredExported: image data 
  ----SXSlice : all short axis images 
     ----imData: image data matrix
	 ----PixelSpacing: pixel resolution
  ----LVOT_imdata
  ----LVOT_PixelSpacing
  ----FourCH_imdata
  ----FourCH_PixelSpacing
  ----OneCH_imdata
  ----OneCH_PixelSpacing
  