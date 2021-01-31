function imgDeformedBsplineRe = BSplineDeformCall(patient_slice_data, cropConfig, resultDir, bsplineDeformBool, NumberOfCpus)

 workingDir = pwd();

 options.type='sd';
 options.centralgrad=false;
 options.penaltypercentage=0.01;
 options.interpolation='cubic';
 Spacing=[8 8];
 
 %%%nubmer of CPUs available
 NofCpus =feature('Numcores');
 if exist('NumberOfCpus','var')
     if NumberOfCpus < NofCpus  && NumberOfCpus >0
         NoOfCpusAvailable = NumberOfCpus;
     else
         NoOfCpusAvailable = NofCpus -1;
     end
 else
     NoOfCpusAvailable = NofCpus -1; 
 end
         
 
 totalInstanceNum = size(patient_slice_data.SXSlice,1); 
% %%now deform
if bsplineDeformBool == 1
    parpool(NoOfCpusAvailable);
    parfor imNo = 1 : totalInstanceNum-1
        I1 = patient_slice_data.SXSlice(imNo,1).imData;
        I2 = patient_slice_data.SXSlice(imNo+1,1).imData;

        I1Crop = imcrop(I1,cropConfig.rect);
        I2Crop = imcrop(I2,cropConfig.rect);
        

        [I1, I2] = NormalizeImageLinear(I1Crop, I2Crop);
        [Tx, Ty] = BsplineDeformHG(I1, I2, options, Spacing);

        imgDeformedBsplineRe(imNo,1).Tx = Tx;
        imgDeformedBsplineRe(imNo,1).Ty = Ty;
        imgDeformedBsplineRe(imNo,1).rect = cropConfig.rect;

    end
%    parpool close;
%     poolobj = gcp('nocreate'); % If no pool, do not create new one.
%     if ~isempty(poolobj)
%         delete(poolobj);
%     end
	delete(gcp('nocreate'));

    cd(resultDir);
    save imgDeformedBsplineRe imgDeformedBsplineRe;
    cd(workingDir);
else
    cd(resultDir);
    load imgDeformedBsplineRe;
    cd(workingDir) 
end

 %%v%now tracking the bcs
 