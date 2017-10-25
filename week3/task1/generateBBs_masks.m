%% Script to generate tests masks and bounding boxes
close all;
clear;
addpath(genpath('../../../'));
dataset = 'validation';%'test'; % 'validation'

root = fileparts(fileparts(fileparts(pwd)));
path = fullfile(root, 'datasets', 'trafficsigns', dataset);

% Method 1 ==> CCL
% Method 2, 3 and 4 (sliding window: 'standard', 'integral', 'convolution'
resultFolder =  fullfile(root, 'm1-results', 'week3', dataset, 'method1');

% Define optimum geometric threshold values (found through validation)
load('GeometricalConstraints_params.mat', 'params');
% Load geometrical stats computed from training (tweaked with params above)
load ('GeometricFeatures_train.mat', 'geometricFeatures');

% Get image files
files = dir(strcat(path, '/*.jpg'));

% Process images in path
for i = 1:size(files)
    
    % Read image
    fprintf('----------------------------------------------------\n');
    fprintf('Analysing image number  %d\n', i);
    image = imread(strcat(path, '/', files(i).name));
    % Apply HSV color segmentation to generate image mask
    segmentationMask = colorSegmentation(image);
    
    % Apply morphlogical operators to improve mask
    % <Change this method for yours>
    filteredMask = imfill(segmentationMask, 'holes');
    filteredMask = imopen(filteredMask, strel('square', 20));
    
    % Apply geometrical constraints to lower the number of FPs
    
    [CC, CC_stats] = computeCC_regionProps(filteredMask);
    [filteredMask, windowCandidates, isSignal] = applyGeometricalConstraints(filteredMask,...
        CC, CC_stats, geometricFeatures, params); 
    
    % Save .mat with 'windowCandidates' and mask separately
    save(strcat(resultFolder, '/',...
        files(i).name(1:size(files(i).name,2)-3), 'mat'), 'windowCandidates');
    imwrite(filteredMask,strcat(resultFolder, '/mask.',...
        files(i).name(1:size(files(i).name,2)-3), 'png'));
    
end