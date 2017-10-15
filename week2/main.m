% Block 2
% Goal: Understand and apply morphological operators in Image Processing
% See https://es.mathworks.com/help/images/morphological-filtering.html

% Add code to path
addpath(genpath('.'))
% Add some external code to path
addpath('../:../evaluation/')
% Set database path
global dataset_path
root = fileparts(fileparts(pwd));
dataset_path = fullfile(root, 'datasets', 'trafficsigns');

%% Task 1: Implement morphological operators Erosion/Dilation. Compose new 
%   operators from Dilation/Erosion: Opening, Closing, TopHat and TopHat 
%   dual
%   Run test with 'cameraman.tif' and a 5x5 square SE:
morphOperators_test;
% Navigate to task1/ folder for implementation details.

%% Task 2: Measure the computational efficiency of your programed operators
%   Erosion/Dilation
MorphOper_Performance;      % 
% This is not the optimal way of measuring performance by executing all
% algorithms at the same time (the first executed is not dealing with
% already allocated resources,....).
% The results in the presentation are more reliable (executed separately
% with empty workspace).

%% Task 3: Use operators to improve results in sign detection
morphFilterMask_test


%% Task 4: Apply histogram back-projection to perform color segmentation

