# Passive Constitutive  parameter inference using the HO2009 model

There are 5 steps for running the optimization procedure, currently it is managed by hand to ensure each step is running properly. A simplified GUI interface will be added in the future for easy managing the configure file. 

## Steps

* step 1:  set up Sim_DirConfigForwardComputation_HVex.m, you will need the image_processing/manual-segmentation and LV-MechanicsModel for generating necessary data, including mesh, strain, and myofibres, and the Abaqus solver command, which further requires intel Fortran compiler to use the user subroutine for the HO2009 law.

* step 2: Sim_forwardSimulationLV_Ca_Cb.m. You will need to specify the right configure file and the CPUs you wants to use for the Abaqus simulation.

* step 3: Sim_forwardSimulationLV_Ca_Cb_refineKlotz.m. Following the same procedure as step 2. 

* step 4: Sim_forwardSimulationLV_afbf.m. Following the same procedure as step 2. 

* step 5: Sim_forwardSimulationLV_ab.m, an update for the objective function, now using the average strain and normalized volume with equal weights, but not as in step 4, in which strain has higher weights. Following the same procedure as step 2.

The intermediate results are saved in forward_LV_FE_running.dat in the simulation folder for later inspection.

## Reference 
* Gao, H., Li, W.G., Cai, L., Berry, C., Luo, X.Y., 2015. Parameter estimation in a Holzapfel–Ogden law for healthy myocardium. J Eng Math 95, 231–248. https://doi.org/10.1007/s10665-014-9740-3

* Gao, H., Aderhold, A., Mangion, K., Luo, X., Husmeier, D., Berry, C., 2017. Changes and classification in myocardial contractile function in the left ventricle following acute myocardial infarction. J. R. Soc. Interface 14, 20170203. https://doi.org/10.1098/rsif.2017.0203

* Gao, H., Mangion, K., Carrick, D., Husmeier, D., Luo, X., Berry, C., 2017. Estimating prognosis in patients with acute myocardial infarction using personalized computational heart models. Sci Rep 7, 13527. https://doi.org/10.1038/s41598-017-13635-2





