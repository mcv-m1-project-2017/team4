%% Test for freqAppearance

% Test case with 6 classes: 1=>'A', 2=>'B', 3=>'C', 4=>'D', 5=>'E' and 6=>'F'
% Add this folder and its parent (where Datasets its also defined) to the
% path:
addpath(genpath('..'))
numClasses = 6;
groundTruth_directory = '../Datasets/train_2017/train/gt';

[freqAppearanceClass, numCounts] = frequencyAppearances(groundTruth_directory, ...
    numClasses);

fprintf('----------------------------------------------------\n');
for i = 1:numClasses
    fprintf('Class num. %d: %.4f - %.2f %%\n', i, freqAppearanceClass(i),...
        freqAppearanceClass(i)*100);
end

fprintf('----------------------------------------------------\n');
fprintf('%d examples: %.4f - %.2f %%\n', numCounts, sum(freqAppearanceClass), ...
    sum(freqAppearanceClass)*100);