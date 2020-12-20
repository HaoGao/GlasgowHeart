%%list of all premesh data which is used for reconstruction and later
%%simualtion
MI_dir='E:\HaoGao\owncloud\clientsync\Projects\segmentations_mi_HGShare\MI_Models';
MI_done_Alan = 'E:\HaoGao\owncloud\clientsync\Projects\segmentations_mi_HGShare\MI_Done_Alan';

%%healthy volunteers
hao_dir='E:\HaoGao\owncloud\clientsync\Projects\segmentations_mi_HGShare\HV_Models\Results_done_HG';
alan_dir='E:\HaoGao\owncloud\clientsync\Projects\segmentations_mi_HGShare\HV_Models\Results_done_Alan';
original_dir='E:\HaoGao\owncloud\clientsync\Projects\segmentations_mi_HGShare\HV_Models\Results_original';

i = 0;
i = i+1 ; SubjectList(i,1).name = 'MR-IMR-1-bsl'; SubjectList(i,1).dir = MI_dir;
i = i+1 ; SubjectList(i,1).name = 'MR-IMR-2-bsl'; SubjectList(i,1).dir = MI_dir;
i = i+1 ; SubjectList(i,1).name = 'Patient1'; SubjectList(i,1).dir = MI_done_Alan;
i = i+1 ; SubjectList(i,1).name = 'HV01'; SubjectList(i,1).dir = hao_dir;