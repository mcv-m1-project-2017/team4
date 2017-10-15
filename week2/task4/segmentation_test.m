% Load generated aModels and bModels
% load('histogramsModels.mat')
load('models.mat')

global nBins
nBins = 100;

% Load an image
dataset = 'test';
root = '/home/jon/mcv_repos';
imagesPath = fullfile(root, 'datasets', 'trafficsigns', dataset);
mkdir(fullfile(imagesPath, 'mask'));
imageFiles = dir(fullfile(imagesPath, '*.jpg'));

nFrames = size(imageFiles,1);
for i=1:nFrames
  imageFile = imageFiles(i);
  maskFile = maskFiles(i);

  imagePath = fullfile(imageFile.folder, imageFile.name);
  tmp = split(imageFile.name, '.jpg'); tmp = tmp{1};
  maskname = strcat('mask.', tmp, '.png');
  maskPath = fullfile(imageFile.folder, 'mask', maskFile.name);
  image = imread(imagePath);

  % Apply segmentation
  [ probabilites ] = segmentation(image, aModels, bModels);
  mask = enmask(probabilites, ones(3,1)*max(probabilites(:)).*0.5, 0);
  imwrite(mask, maskPath);
end
