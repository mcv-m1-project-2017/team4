% Load generated aModels and bModels
% load('histogramsModels.mat')
load('models.mat')

global nBins
nBins = 100;

% Load an image
dataset = 'validation';
root = '/home/jon/mcv_repos';
root = '/home/mcv04';
imagesPath = fullfile(root, 'datasets', 'trafficsigns', dataset);
masksPath = fullfile(root, 'datasets', 'trafficsigns', dataset, 'mask');

imageFiles = dir(fullfile(imagesPath, '*.jpg'));
%maskFiles = dir(fullfile(maskPath, '*.png'));

nFrames = size(imageFiles,1);
pixelTP = 0; pixelFP = 0; pixelFN = 0; pixelTN = 0;
%nFrames = 10  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Remove that!
tic
for i=1:nFrames
  imageFile = imageFiles(i);
  tmp = strsplit(imageFile.name, '.jpg'); imageFileName = tmp{1};
  maskFileName = strcat('mask.', imageFileName, '.png');
  imagePath = fullfile(imagesPath, imageFile.name)
  maskPath = fullfile(masksPath, maskFileName)
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
time_per_frame_in_seconds = toc / nFrames
total = pixelTP + pixelFP+ pixelFN + pixelTN;
[pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity] = PerformanceEvaluationPixel(pixelTP, pixelFP, pixelFN, pixelTN);

disp('TP, FP, FN, TN')
result1 = [pixelTP, pixelFP, pixelFN, pixelTN] ./ total
disp('Precision, Accuracy, Specificity, Sensitivity')
results2 = [pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity]

