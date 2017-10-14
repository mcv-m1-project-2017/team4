% Load generated aModels and bModels
load('histogramsModels.mat')

global nBins
nBins = 100

% Load an image
dataset = 'train';
root = '/home/jon/mcv_repos';
trainPath = fullfile(root, 'datasets', 'trafficsigns', dataset);

files = dir(fullfile(trainPath, '*.jpg'));
file = files(1);
filepath = fullfile(file.folder, file.name);
image = imread(filepath);

% Apply segmentation
segmentation(image, aModels, bModels);
