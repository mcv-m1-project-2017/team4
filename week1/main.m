% Set path to code
addpath(genpath('.'))
% Set path to external code
addpath('../:../evaluation/')

if (is_octave())
  disp('Octave detected. Loading packages..')
  pkg load image 
  pkg load io
  pkg load statistics
end  

global dataset_path
root = fileparts(fileparts(pwd));
dataset_path = fullfile(root, 'datasets', 'trafficsigns');

%% Task 1: Determine the characteristics of the signals in the training set: 
%   max and min size, form factor, filling ratio of each type of signal, 
%   frequency of appearance (using text annotations and ground-truth masks). 
%   Group the signals according to their shape and color.
% [ traffic_sign_type, vector_of_features] = extract_features(dataset_path)
%[ freqAppearanceClass,trafficSignType, vectorFeatures, maxMinResults] = extractFeatures(strcat(dataset_path, '/train/'))
%addpath(genpath(dataset_path));
%[ freqAppearanceClass,trafficSignType, vectorFeatures] = extractFeatures(strcat(dataset_path,'/train/'));

%% Task 2: Create balanced train/validation split using provided dataset.
% [ paths_for_training, paths_for_validation ] = split(dataset_path, 
%                                                      traffic_sign_type, 
%                                                      vector_of_features, 
%                                                      validation_percentage)
%[ paths_for_training, paths_for_validation ] = partition(dataset_path, traffic_sign_type, vector_of_features,  validation_percentage)
%f = load('/task1/freqAppearances.mat')
%partition(fullfile(dataset_path, 'train'), f.freqAppearanceClass, fullfile(dataset_path, 't'), fullfile(dataset_path, 'v'))

%% Task 3: Color segmentation to generate a mask
% [ features ] = train(paths_for_training, class_names)
% [ paths_of_computed_masks ] = predict(paths_for_validation, features)
clear train_paths;  clear validation_paths; clear test_paths;
algorithm = 'gaussian';

files =  ListFiles(fullfile(dataset_path, 'train'));
for i = 1:size(files)
  train_paths(i,:) = fullfile(dataset_path, 'train', files(i).name);
end

files = ListFiles(fullfile(dataset_path, 'validation'));
for i = 1:size(files)
  validation_paths(i,:) = fullfile(dataset_path, 'validation', files(i).name);
end

files = ListFiles(fullfile(dataset_path, 'test'));
for i = 1:size(files)
  test_paths(i,:) = fullfile(dataset_path, 'test', files(i).name);
end

if strcmp(algorithm,'max')
    features = train_max(train_paths);
    mask_paths = predict_max(features, validation_paths);
    mask_paths = predict_max(features, test_paths);
elseif strcmp(algorithm,'gaussian')
    features = train_gaussian(train_paths);
    mask_paths = predict_gaussian(features, validation_paths);
    mask_paths = predict_gaussian(features, test_paths);
else
    error('You should choose an `algorithm` to compute the mask')
end
%% Task 4: Evaluate the segmentation using ground truth
% [ precision, accuracy, recall, f1_mesure, 
%   tp, fp, fn, time_per_frame ] = evaluate(paths_for_validation, computed_maks) 
%[ pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity, pixelTP, pixelFP, pixelFN,pixelTN, time_per_frame ] = evaluateResults(validation_paths, mask_paths) ;

%% Task 5: Study the influence of luminance normalization (Optional)
% ...
