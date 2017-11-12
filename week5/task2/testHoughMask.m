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

if size(inputMasks,1) == 0 | size(frames,1) == 0
  error('No input data found. Check paths')
end % if

% Define a path to save resulting masks
outPath = fullfile(root, 'datasets', 'trafficsigns', 'tmp', 'test5');

% Get models
% models.triangular_down = uint8(imread('/tmp/test/2_1.png'));
% models.triangular_up = uint8(imread('/tmp/test/18_1.png'));
% models.square = uint8(imread('/tmp/test/7_1.png'));
% models.circular = uint8(imread('/tmp/test/1_1.png'));

% Synthetize models
triangle = strel('diamond', 49).Neighborhood;
up_mask = [ones(49,99); zeros(50,99)];
models.square = ones(100);
models.triangular_up = triangle & up_mask;
models.triangular_down = triangle & ~up_mask;
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

  % Get mask
  mask = houghMask(image, rp, models);
  size(mask)

  % Save results
  maskPath = fullfile(outPath, inputMaskObject.name);
  imwrite(mask, maskPath);
end % for each inputMask
