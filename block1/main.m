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
root = fileparts(fileparts(fileparts(pwd)))
dataset_path = fullfile(root, 'datasets', 'trafficsigns')
% The dataset folder is on the following path:
% home/mcv04/datasets/trafficsigns/train/...

%% Task 1: Determine the characteristics of the signals in the training set: 
%   max and min size, form factor, filling ratio of each type of signal, 
%   frequency of appearance (using text annotations and ground-truth masks). 
%   Group the signals according to their shape and color.
% [ traffic_sign_type, vector_of_features] = extract_features(dataset_path)
%[ freqAppearanceClass,trafficSignType, vectorFeatures, maxMinResults] = extractFeatures(strcat(dataset_path, '/train/'))
addpath(genpath(dataset_path));
[ freqAppearanceClass,trafficSignType, vectorFeatures] = extractFeatures(strcat(dataset_path,'/train/'));

% Task 2: Create balanced train/validation split using provided dataset.
% [ paths_for_training, paths_for_validation ] = split(dataset_path, 
%                                                      traffic_sign_type, 
%                                                      vector_of_features, 
%                                                      validation_percentage)
%[ paths_for_training, paths_for_validation ] = partition(dataset_path, traffic_sign_type, vector_of_features,  validation_percentage)
f = load('/task1/freqAppearances.mat')
partition(fullfile(dataset_path, 'train'), f.freqAppearanceClass, fullfile(dataset_path, 't'), fullfile(dataset_path, 'v'))

% Task 3: Color segmentation to generate a mask
% [ features ] = train(paths_for_training, class_names)
% [ paths_of_computed_masks ] = predict(paths_for_validation, features)
paths_for_training = [
  '/home/mcv04/datasets/trafficsigns/train/00.000948.jpg',
  '/home/mcv04/datasets/trafficsigns/train/00.000949.jpg',
  '/home/mcv04/datasets/trafficsigns/train/01.002810.jpg',
  '/home/mcv04/datasets/trafficsigns/train/00.004782.jpg',
];
paths_for_validation = [
  '/home/mcv04/datasets/trafficsigns/train/00.004815.jpg',
  '/home/mcv04/datasets/trafficsigns/train/00.005893.jpg',
  '/home/mcv04/datasets/trafficsigns/train/01.001340.jpg',
  '/home/mcv04/datasets/trafficsigns/train/01.001788.jpg',
];

% Uncoment next two lines to use 'MAX' algorithm.
%features = train_max(paths_for_training);
%mask_paths = predict_max(features, paths_for_validation);

% Uncoment next two lines to use 'GAUSSIAN' algorithm.
features = train_gaussian(paths_for_training);
mask_paths = predict_gaussian(features, paths_for_validation);

% Task 4: Evaluate the segmentation using ground truth
% [ precision, accuracy, recall, f1_mesure, 
%   tp, fp, fn, time_per_frame ] = evaluate(paths_for_validation, computed_maks) 
[ pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity, pixelTP, pixelFP, pixelFN,pixelTN, time_per_frame ] = evaluateResults(paths_for_validation, masks_paths) ;



% Task 5: Study the influence of luminance normalization (Optional)
% ...
