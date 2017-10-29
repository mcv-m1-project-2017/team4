% Add repository functions to path
addpath(genpath('..'));

% Set paths
dataset = 'validation';
root = '../../../';
inputMasksPath = fullfile(root, 'datasets', 'trafficsigns', 'm1', dataset);
groundThruthPath = fullfile(root, 'datasets', 'trafficsigns', 'split', dataset, 'mask');
tmpPath =  fullfile(root, 'datasets', 'trafficsigns', 'tmp', dataset);
mkdir(tmpPath)

% Get all the files
inputMasks = dir(fullfile(inputMasksPath, '*.png'));
gtMasks = dir(fullfile(groundThruthPath, '*.png'));

plot = true;

% Load some parameters from task1
paramsFile = fullfile('..', 'task1', 'GeometricalConstraints_params.mat');
GeometricFeaturesFile = fullfile('..', 'task1', 'GeometricFeatures_train.mat');
load(paramsFile, 'params');
load(GeometricFeaturesFile, 'geometricFeatures');


% FIXME change the next line for this one:
for i = 11:size(inputMasks,1)
  sprintf('Checking mask %d', i)
  inputMaskObject = inputMasks(i);
  inputMaskPath = fullfile(inputMaskObject.folder, inputMaskObject.name);
  iMask = imread(inputMaskPath);

  gtMaskObject = gtMasks(i);
  gtMaskPath = fullfile(gtMaskObject.folder, gtMaskObject.name);
  gtMask = imread(gtMaskPath);
  % Convert it to logical (faster)
  gtMask = gtMask > 0;

  % DO ALL THE MAGIC HERE
  [cancellingMask, regionProposal] = multiscaleSearch(iMask, geometricFeatures, params);
  oMask = iMask & ~cancellingMask;

  if plot % && mod(i,3) == 0
    pause(1)
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
    subplot(2,2,3);
    imshow(oMask,[]);
    title('Output mask');
    %plot = false;

    % Show output mask
    subplot(2,2,4);
    imshow(cancellingMask,[]);
    title('cancelling mask');
    %plot = false;
  end

end
