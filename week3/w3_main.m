% Add repository functions to path
addpath(genpath('..'));
rmpath(genpath('../.git'));

% Set paths
dataset = 'train';
root = '../../';
inputMasksPath = fullfile(root, 'datasets', 'trafficsigns', 'm1', dataset);
groundThruthPath = fullfile(root, 'datasets', 'trafficsigns', 'split', dataset, 'mask');
tmpPath =  fullfile(root, 'datasets', 'trafficsigns', 'tmp', dataset);
mkdir(tmpPath)

% Get all the files
inputMasks = dir(fullfile(inputMasksPath, '*.png'));
gtMasks = dir(fullfile(groundThruthPath, '*.png'));

plot = false;

% FIXME change the next line for this one:
% for i = 1:size(inputMasks,1)
for i = 1:1
  inputMaskObject = inputMasks(i);
  inputMaskPath = fullfile(inputMaskObject.folder, inputMaskObject.name);
  iMask = imread(inputMaskPath);

  gtMaskObject = gtMasks(1);
  gtMaskPath = fullfile(gtMaskObject.folder, gtMaskObject.name);
  gtMask = imread(gtMaskPath);
  % Convert it to logical (faster)
  gtMask = gtMask > 0;

  % DO ALL THE MAGIC HERE
  figure(1), subplot(2,2,1), imshow(iMask), title('Input mask')
  cancellingMask = multiscaleSearch(iMask);
  % FIXME check the next operation
  oMask = iMask & cancellingMask;
end

if plot
  figure(1);
  % Show input mask
  subplot(2,2,1);
  imshow(iMask,[]);
  title('Input mask');

  % Show ground truth mask
  subplot(2,2,2);
  imshow(gtMask,[]);
  title('GroundTruth mask');

  % Show output mask
  subplot(2,1,2);
  imshow(oMask,[]);
  title('Output mask');
end
