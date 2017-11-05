clear;
close all;
global corrRes ;
global categories;
corrRes = [];
categories = {};

addpath(genpath('../../../'));

load('GeometricFeatures_train.mat');
load('GeometricConstraints_params_v2.mat');

[evaluationParameters, windowCandidates] = templateMatching('debug',geometricFeatures,...
    params, 'validation',1)

boxplot(corrRes, categories)
