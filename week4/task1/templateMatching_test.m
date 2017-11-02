clear;
close all;
global corrRes ;
global categories;
corrRes = [];
categories = {};

addpath(genpath('../../../'));

load('GeometricFeatures_train.mat');
load('GeometricalConstraints_params.mat');

[evaluationParameters, windowCandidates] = templateMatching('debug',geometricFeatures,...
    params, 'train',1)

%boxplot(corrRes, categories)