% Task 2: Make a mask using Hough Transform over an image

% Add repository functions to path
addpath(genpath('..'));
% Set paths
dataset = 'train';
root = '../../';
inputMasksPath = fullfile(root, 'datasets', 'trafficsigns', 'm1', dataset);
fullImagePath = fullfile(root, 'datasets', 'trafficsigns', 'split', dataset);

% Get list of files
inputMasks = dir(fullfile(inputMasksPath, '*.png'));
frames = dir(fullfile(fullImagePath, '*.jpg'));

% Define a path to save resulting masks
outPath = fullfile(root, 'datasets', 'trafficsigns', 'tmp', 'test5');

% Get models
% models.triangular_down = uint8(imread('/tmp/test/2_1.png'));
% models.triangular_up = uint8(imread('/tmp/test/18_1.png'));
% models.square = uint8(imread('/tmp/test/7_1.png'));
% models.circular = uint8(imread('/tmp/test/1_1.png'));

triangle = strel('diamond', 49).Neighborhood;
up_mask = [ones(49,99); zeros(50,99)];
models.triangular_up = triangle & up_mask;
models.triangular_down = triangle & ~up_mask;
models.square = ones(100);
models.circular = strel('disk', 49, 0).Neighborhood;

for i = 1:size(inputMasks,1)
  % Get an image and its mask
  fprintf('Checking mask %d\n', i)
  inputMaskObject = inputMasks(i);
  inputMaskPath = fullfile(inputMasksPath, inputMaskObject.name);
  iMask = imread(inputMaskPath);

  frameObject = frames(i);
  framePath = fullfile(fullImagePath, frameObject.name);
  image = imread(framePath);

  % Get region proposals
  CC = bwconncomp(iMask);
  rp = regionprops(CC, 'BoundingBox');

  % Get mask and save them to a given path

  houghMask(image, rp, models, outPath);
  %masks = houghMask(image, rp, models, outPath);

  % Save results
%   for m = 1:size(masks, 3)
%     maskPath = fullfile(outPath, [num2str(i) '_' num2str(m) '_t.png']);
%     imwrite(masks(:,:,m), maskPath);
%   end % for each mask
end % for each inputMask
