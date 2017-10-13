close all;
clear;

addpath('../../evaluation');
addpath('../colorSegmentation');
pixelTP=0; pixelFN=0; pixelFP=0; pixelTN=0;

%%Compute validation set histogram back-projection model

dataset = 'train';
root = fileparts(fileparts(fileparts(pwd)));
trainPath = fullfile(root, 'datasets', 'trafficsigns', dataset);
model = generateHistogramModel(trainPath);