step 1: 
    setp up Sim_DirConfigForwardComputation_HV02.m, make sure everything is there

step 2: Sim_forwardSimulationLV_Ca_Cb.m

step 3: Sim_forwardSimulationLV_Ca_Cb_refineKlotz.m

step 4: Sim_forwardSimulationLV_afbf.m

step 5: Sim_forwardSimulationLV_ab.m, an update for the objective function, now using the average strain and normalized volume with equal weights, but not as in step 4, in which strain has higher weights. Seems better matching

The results from step 2 need to be manually added to step 3, similarly for step 4 and step 5, which can be updated automatically, but not yet done.



