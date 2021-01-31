%%this is for MI258
% abaqusInputDir = 'C:\Users\hg67u\ownCloud\clientsync\Stats-Heart-Modelling\Weiwei-code\LVModelGenerationUsingFitting_New_withMapping\results\MI258\scan1\fibreGeneration';

% abaqusInputDir = 'C:\Users\hg67u\ownCloud\clientsync\Stats-Heart-Modelling\Weiwei-code\LVModelGenerationUsingFitting_New_withMapping\results\MI167\scan1\fibreGeneration';
% abaqusInputDir = 'C:\Users\hg67u\ownCloud\clientsync\Stats-Heart-Modelling\Weiwei-code\LVModelGenerationUsingFitting_New_withMapping\results\MI167_new\scan1\fibreGeneration';
% abaqusInputDir = 'C:\Users\hg67u\ownCloud\clientsync\Stats-Heart-Modelling\Weiwei-code\LVModelGenerationUsingFitting_New_withMapping\results\MI258\scan3\fibreGeneration';

%%MI102
% abaqusInputDir = 'D:\HaoGao\Project\wenguang_result\Results\MI102\scan1\fibreGeneration';

%%MI106
% abaqusInputDir = 'D:\HaoGao\Project\wenguang_result\Results\MI106\scan1\fibreGeneration';

%%MI108
% abaqusInputDir = 'D:\HaoGao\Project\wenguang_result\Results\MI108\scan1\fibreGeneration';

%%MI132
% abaqusInputDir = 'D:\HaoGao\Project\wenguang_result\Results\MI132\scan1\fibreGeneration';

%%MI133
% abaqusInputDir = 'D:\HaoGao\Project\wenguang_result\Results\MI133\scan1\fibreGeneration';

%%MI167
% abaqusInputDir = 'D:\HaoGao\Project\wenguang_result\Results\MI167\scan1\fibreGeneration';

%%MI171
% abaqusInputDir = 'D:\HaoGao\Project\wenguang_result\Results\MI171\scan1\fibreGeneration';

%%MI172
% abaqusInputDir = 'D:\HaoGao\Project\wenguang_result\Results\MI172\scan1\fibreGeneration';

%%MI172
% abaqusInputDir = 'D:\HaoGao\Project\wenguang_result\Results\MI179\scan1\fibreGeneration';

%%MI190
% abaqusInputDir = 'D:\HaoGao\Project\wenguang_result\Results\MI190\scan1\fibreGeneration';

%%MI201
% abaqusInputDir = 'D:\HaoGao\Project\wenguang_result\Results\MI201\scan1\fibreGeneration';

%%MI201
abaqusInputDir = 'D:\HaoGao\Project\wenguang_result\Results\MI258\scan1\fibreGeneration';

dataResult = '.\Results_fiber_60_45'; 

workingDir = pwd();
cd(abaqusInputDir);
if ~exist(dataResult, 'dir')
    mkdir(dataResult);
end
cd(dataResult);
dataResult = pwd();
cd(workingDir);
