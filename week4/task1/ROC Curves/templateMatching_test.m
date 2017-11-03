clear;
close all;
global corrRes ;
global categories;
corrRes = [];
categories = {};

addpath(genpath('../../../../'));

load('GeometricFeatures_train.mat');
load('GeometricalConstraints_params.mat');
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
values = 0:0.05:1;

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
subplot(2,2,1); title('Circular pattern Precision-Recall Curve');
plot(circularPrecision,circularRecall);
subplot(2,2,2); title('Up Triangular pattern Precision-Recall Curve');
plot(upTriangPrecision,upTriangRecall);
subplot(2,2,3); title('Down Triangular pattern Precision-Recall Curve');
plot(downTriangPrecision,downTriangRecall);
subplot(2,2,4); title('Rectangular pattern Precision-Recall Curve');
plot(rectPrecision,rectRecall);

