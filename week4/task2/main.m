% Task 2: Template matching using Distance Transform and chamfer distance
do_plots = true;

% Add repository functions to path
addpath(genpath('..'));

% Set paths (JON)
dataset = 'train';
root = '../../../';
inputMasksPath = fullfile(root, 'datasets', 'trafficsigns', 'm1', dataset);
groundThruthPath = fullfile(root, 'datasets', 'trafficsigns', 'split', dataset, 'mask');

% Set paths (Ferran)
% inputMasksPath = fullfile(root, 'm1-results', 'week3', 'm1', dataset);
%groundThruthPath = fullfile(root, 'datasets', 'trafficsigns', 'split', dataset, 'mask');
% groundThruthPath = fullfile(root, 'datasets', 'trafficsigns', dataset, 'mask');

tmpPath =  fullfile(root, 'datasets', 'trafficsigns', 'tmp', dataset);
mkdir(tmpPath)

% Get all the files
inputMasks = dir(fullfile(inputMasksPath, '*.png'));
gtMasks = dir(fullfile(groundThruthPath, '*.png'));

% Load templates (circularModel, downTriangModel, rectModel, upTriangModel)
models_task1 = load('/home/jon/mcv_repos/team4/week4/task1/templateModels.mat');
models = zeros(40,40,4);
models(:,:,1) = models_task1.circularModel > 0.5;
models(:,:,2) = models_task1.downTriangModel > 0.5;
models(:,:,3) = models_task1.rectModel > 0.5;
models(:,:,4) = models_task1.upTriangModel > 0.5;

% For each mask
% for i = 1:size(inputMasks,1)
for i = 1:1
  % Load image
  inputMaskObject = inputMasks(i);
  sprintf('Checking mask %d: %s', i, inputMaskObject.name)
  inputMaskPath = fullfile(inputMasksPath, inputMaskObject.name);
  iMask = imread(inputMaskPath);

  % Load ground thruth (comment it out when not validating)
  gtMaskObject = gtMasks(i);
  gtMaskPath = fullfile(groundThruthPath, gtMaskObject.name);
  gtMask = imread(gtMaskPath);
  gtMask = gtMask > 0; % Convert it to logical (faster)

  regionsAll = zeros(0, 4);
  % For each template
  % for t = 1:size(templates,3)
  for t = 1:1
    model = models(:,:,i);
    modelSize = size(model);

    % Add a border to avoid losing contours when filtering
    template = padarray(model, [1,1], 0, 'both');
    featureMask = edge(iMask,'Canny');
    template = edge(template, 'Canny')+0;

    % Add padding to avoid contour effects when doing correlation
    paddedMask = padarray(featureMask, size(template)/2, 0, 'both');

    % Distance Transform the feature mask
    transformedMask = distanceTransform(paddedMask);

    % Do pattern matching with the mask and a template
    correlated = xcorr2(transformedMask, template);
    % correlated = normxcorr2(transformedMask, template);

    % Remove additional padding added before
    border = size(template,1);
    correlated = correlated(border:(end-border), border:(end-border));

    % Normalize result
    correlated = correlated./max(correlated(:));

    % Find local minimas using 8-connected neighbourhood
    minimasMask = imregionalmin(correlated ,8);
    [posy, posx] = find(minimasMask==1);

    % Extract bounding boxes
    regions = zeros(size(posy,1), 4);
    for position = 1:size(posy,1)
      regions(position,:) = [posy(position) - 0.5*modelSize(1), ...
                      posx(position) - 0.5*modelSize(2), ...
                      modelSize(1), ...
                      modelSize(2)];
    end % for

    % Do a plot placing a model wherever the signal is found
    if do_plots
      result = zeros(size(iMask));
      for position = 1:size(posy)
        result(posy(position), posx(position)) = 1;
      end % for
      result = imdilate(result, model);
      figure(3), imshow(result);
    end % do_plots

    % Save mask
    % oMaskPath = fullfile(tmpPath, inputMaskObject.name);
    % sprintf('Writing in %s', oMaskPath)
    % oMask = iMask & ~cancellingMask;
    % imwrite(oMask, oMaskPath);

    % Update regions for this mask
    numOfRegionsSaved = size(regionsAll,1);
    numOfRegionsFound = size(regions,1);
    regionsAll((numOfRegionsSaved+1):(numOfRegionsSaved+numOfRegionsFound), :) = regions;

  % Save regions
  name = strsplit(inputMaskObject.name, '.png');
  name = name{1};
  region_path = fullfile(tmpPath, strcat(name, '.mat'));
  save(region_path, 'regionsAll');

  end % for

  if do_plots
    figure(1)
%     figure('Name',sprintf('Mask %d', i));
    % Show input mask
    subplot(2,3,1);
    imshow(featureMask,[]);
    title('Feature mask');

    % Show transformed
    subplot(2,3,2);
    imshow(transformedMask,[]);
    title('distance transformed');
    %plot = falseXx

    % Show output mask
    subplot(2,3,3);
    imshow(template,[]);
    title('template');
    % axis([1, size(featureMask,1), 1, size(featureMask,2)]);

    % Show ground truth mask
    subplot(2,3,4);
    imshow(gtMask,[]);
    title('GroundTruth mask');

    % Show ground truth mask
    subplot(2,3,5);
    imshow(correlated,[]);
    title('correlated mask');

    % Show ground truth mask
    subplot(2,3,6);
    imshow(correlated*256,hsv(256));
    title('correlated mask with pseudo-colour');

    figure(2), subplot(1,2,1);
    imshow(correlated, []);
    title('correlated mask')

    subplot(1,2,2);
    imshow(result, []);

  end

end
