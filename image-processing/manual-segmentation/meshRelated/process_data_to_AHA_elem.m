function lge = process_data_to_AHA_elem(AHALVMeshDivision,LGEEachLVNode)
%%using element centroid data for process
basa_InfSept = AHALVMeshDivision.elem_basa_InfSept;
basa_AntSept = AHALVMeshDivision.elem_basa_AntSept;
basa_Ant = AHALVMeshDivision.elem_basa_Ant;
base_AntLat = AHALVMeshDivision.elem_base_AntLat;
base_InfLat = AHALVMeshDivision.elem_base_InfLat;
base_Inf = AHALVMeshDivision.elem_base_Inf;

midd_InfSept = AHALVMeshDivision.elem_midd_InfSept;
midd_AntSept = AHALVMeshDivision.elem_midd_AntSept ;
midd_Ant =AHALVMeshDivision.elem_midd_Ant     ;
midd_AntLat = AHALVMeshDivision.elem_midd_AntLat ;
midd_InfLat = AHALVMeshDivision.elem_midd_InfLat ;
midd_Inf = AHALVMeshDivision.elem_midd_Inf    ;

apex_Sept =AHALVMeshDivision.elem_apex_Sept ;
apex_Ant = AHALVMeshDivision.elem_apex_Ant  ;
apex_Lat = AHALVMeshDivision.elem_apex_Lat  ;
apex_Inf = AHALVMeshDivision.elem_apex_Inf  ;

apicalRegion = AHALVMeshDivision.elem_apicalRegion ;



%%
lge_basa_InfSept = LGEEachLVNode(basa_InfSept); lge(1,1) = mean(lge_basa_InfSept);
lge_basa_AntSept = LGEEachLVNode(basa_AntSept); lge(2,1) = mean(lge_basa_AntSept);
lge_basa_Ant =     LGEEachLVNode(basa_Ant);     lge(3,1) = mean(lge_basa_Ant);
lge_basa_AntLat =  LGEEachLVNode(base_AntLat);  lge(4,1) = mean(lge_basa_AntLat);
lge_basa_InfLat =  LGEEachLVNode(base_InfLat);  lge(5,1) = mean(lge_basa_InfLat);
lge_basa_Inf =     LGEEachLVNode(base_Inf);     lge(6,1) = mean(lge_basa_Inf);

lge_midd_InfSept = LGEEachLVNode(midd_InfSept); lge(7,1) = mean(lge_midd_InfSept);
lge_midd_AntSept = LGEEachLVNode(midd_AntSept); lge(8,1) = mean(lge_midd_AntSept);
lge_midd_Ant =     LGEEachLVNode(midd_Ant);     lge(9,1) = mean(lge_midd_Ant);
lge_midd_AntLat =  LGEEachLVNode(midd_AntLat);  lge(10,1) = mean(lge_midd_AntLat);
lge_midd_InfLat =  LGEEachLVNode(midd_InfLat);  lge(11,1) = mean(lge_midd_InfLat);
lge_midd_Inf =     LGEEachLVNode(midd_Inf);     lge(12,1) = mean(lge_midd_Inf);

lge_apex_Sept = LGEEachLVNode(apex_Sept);       lge(13,1) = mean(lge_apex_Sept);
lge_apex_Ant = LGEEachLVNode(apex_Ant);         lge(14,1) = mean(lge_apex_Ant);
lge_apex_Lat = LGEEachLVNode(apex_Lat);         lge(15,1) = mean(lge_apex_Lat);
lge_apex_Inf = LGEEachLVNode(apex_Inf);         lge(16,1) = mean(lge_apex_Inf);

lge_apicalRegion = LGEEachLVNode(apicalRegion); lge(17,1) = mean(lge_apicalRegion);
