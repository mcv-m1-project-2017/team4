clear;
close all;
global corrRes ;
global categories;
corrRes = [];
categories = {};

addpath(genpath('../../../../'));

load('GeometricFeatures_train.mat');
load('GeometricConstraints_params_v2.mat');
circularPrecision = [];
circularRecall = [];
circularAccuracy = [];
upTriangPrecision = [];
upTriangRecall = [];
upTriangAccuracy = [];
downTriangPrecision = [];
downTriangRecall = [];
downTriangAccuracy = [];
rectPrecision = [];
rectRecall = [];
rectAccuracy = [];
values = 0:0.02:1;

%compute ROC for circular template
for i = values
    [evaluationParameters, evalParams_window] = templateMatching_roc('debug',geometricFeatures,...
        params, 'train',1,i,'circular');
    circularPrecision = [circularPrecision evalParams_window(1)];
    circularRecall = [circularRecall evalParams_window(3)];
    circularAccuracy = [circularAccuracy evalParams_window(2)];
end
%compute ROC for upTriangular template
for i = values
    [evaluationParameters, evalParams_window] = templateMatching_roc('debug',geometricFeatures,...
    params, 'train',1,i,'upTriangular');
    upTriangPrecision = [upTriangPrecision evalParams_window(1)];
    upTriangRecall = [upTriangRecall evalParams_window(3)];
    upTriangAccuracy = [upTriangAccuracy evalParams_window(2)];
end
%compute ROC for downTriangular template
for i = values
    [evaluationParameters, evalParams_window] = templateMatching_roc('debug',geometricFeatures,...
    params, 'train',1,i,'downTriangular');
    downTriangPrecision = [downTriangPrecision evalParams_window(1)];
    downTriangRecall = [downTriangRecall evalParams_window(3)];
    downTriangAccuracy = [downTriangAccuracy evalParams_window(2)];
end
%compute ROC for rectangular template
for i = values
    [evaluationParameters, evalParams_window] = templateMatching_roc('debug',geometricFeatures,...
    params, 'train',1,i,'rectangular');
    rectPrecision = [rectPrecision evalParams_window(1)];
    rectRecall = [rectRecall evalParams_window(3)];
    rectAccuracy = [rectAccuracy evalParams_window(2)];
end


figure();
title('Precision-Recall Curves');
subplot(2,2,1); 
plot(circularPrecision,circularRecall);
title('Circular pattern');
axis([0.5 1 0 1]);
subplot(2,2,2); 
plot(upTriangPrecision,upTriangRecall);
title('Up Triangular pattern');
axis([0.5 1 0 1]);
subplot(2,2,3); 
plot(downTriangPrecision,downTriangRecall);
title('Down Triangular pattern');
axis([0.5 1 0 1]);
subplot(2,2,4); 
plot(rectPrecision,rectRecall);
title('Rectangular pattern');
axis([0.5 1 0 1]);