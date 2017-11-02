close all;
clear;

% addpath('../../evaluation');
% addpath('../colorSegmentation');
% addpath('../../colorspace');

%%Compute validation set histogram back-projection model

dataset = 'train';
root = fileparts(fileparts(fileparts(pwd)));
trainPath = fullfile(root, 'datasets', 'trafficsigns', dataset);
[circularCorr, upTriangCorr,downTriangCorr,rectCorr,corrValues,categories] = computeThreshold(trainPath);
boxplot(corrValues,categories);