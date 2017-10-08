%% Test for freqAppearance

% Test case with 6 classes: 1=>'A', 2=>'B', 3=>'C', 4=>'D', 5=>'E' and 6=>'F'
% Add this folder and its parent (where Datasets its also defined) to the
% path:
addpath(genpath('../../../'));
numClasses = 6;
groundTruth_directory = '../../../Datasets/train_2017/train/gt';
f = dir(groundTruth_directory);
numExamples = size(f,1);


[freqAppearanceClass, numCounts] = frequencyAppearances(groundTruth_directory, ...
    numClasses);

fprintf('----------------------------------------------------\n');
for i = 1:numClasses
    fprintf('Class number  %d (%s): %.4f - %.2f %%\n', i, char(i+64), freqAppearanceClass(i),...
        freqAppearanceClass(i)*100);
end

fprintf('----------------------------------------------------\n');
fprintf('Num. examples: %d | %.4f - %.2f %%\n', numCounts, sum(freqAppearanceClass), ...
    sum(freqAppearanceClass)*100);
fprintf('Computed for a dataset of %d images\n', numExamples);