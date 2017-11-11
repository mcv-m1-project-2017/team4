clear;
close all;


addpath(genpath('../../../'));
load('GeometricFeatures_train.mat');
load('GeometricConstraints_params_v2.mat');

[evaluationParameters, windowCandidates] = trafficSignDetection('debug',geometricFeatures,...
    params, 'train',1)

