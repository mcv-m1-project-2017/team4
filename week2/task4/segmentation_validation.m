% Load generated aModels and bModels
% load('histogramsModels.mat')
load('models.mat')

global nBins
nBins = 100;

% Load an image
dataset = 'validation';
root = '/home/jon/mcv_repos';
imagesPath = fullfile(root, 'datasets', 'trafficsigns', dataset);
maskPath = fullfile(root, 'datasets', 'trafficsigns', dataset, 'mask');

imageFiles = dir(fullfile(imagesPath, '*.jpg'));
maskFiles = dir(fullfile(maskPath, '*.png'));


nFrames = size(imageFiles,1);
pixelTP = 0; pixelFP = 0; pixelFN = 0; pixelTN = 0;
nFrames = 10  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Remove that!
tic
for i=1:nFrames
  imageFile = imageFiles(i);
  maskFile = maskFiles(i);

  imagePath = fullfile(imageFile.folder, imageFile.name);
  maskPath = fullfile(maskFile.folder, maskFile.name);
  image = imread(imagePath);
  mask_gt = imread(maskPath);

  % Apply segmentation
  [ probabilites ] = segmentation(image, aModels, bModels);
  mask = enmask(probabilites, ones(3,1)*max(probabilites(:)).*0.5, 0);

  [TP, FP, FN, TN] = PerformanceAccumulationPixel(mask, mask_gt);
  pixelTP = pixelTP + TP;
  pixelFP = pixelFP + FP;
  pixelFN = pixelFN + FN;
  pixelTN = pixelTN + TN;
end
time_per_frame = toc / nFrames
total = pixelTP + pixelFP+ pixelFN + pixelTN;
[pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity] = PerformanceEvaluationPixel(pixelTP, pixelFP, pixelFN, pixelTN);

results1 = [pixelTP, pixelFP, pixelFN, pixelTN] ./ total
results2 = [pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity]
