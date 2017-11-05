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
models = load('/home/jon/mcv_repos/team4/week4/task1/templateModels.mat');
templates = zeros(40,40,4);
templates(:,:,1) = models.circularModel;
templates(:,:,2) = models.downTriangModel;
templates(:,:,3) = models.rectModel;
templates(:,:,4) = models.upTriangModel;

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

  % For each template
  % for t = 1:size(templates,3)
  for t = 1:1
    template = templates(:,:,i);
    % Add a border to avoid losing contours when filtering
    template = padarray(template, [1,1], 0, 'both');
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

    % Find local minimas
    % --------------------------- CODE in DEV -------------------------------
    c = correlated;
    min(c(:)), max(c(:))
    se = ones(1,3);
    betterC = imbothat(c, se);
    betterC = imtophat(betterC, se');
    betterC = betterC ./ max(betterC);
    min(betterC(:)), max(betterC(:))
    bestC = c;
    betterC = c;
    c(betterC<0.01)=1;

    % for i = 1:size(positions, 1)
    %
    % end % for
    % %c(c==min(c(:)))=256;
    %[min(c(:)),   max(c(:))]
    positions = extractLocalMinima(bestC);

    % Save mask
    % oMaskPath = fullfile(tmpPath, inputMaskObject.name);
    % sprintf('Writing in %s', oMaskPath)
    % oMask = iMask & ~cancellingMask;
    % imwrite(oMask, oMaskPath);

    % Save regions
    % name = strsplit(inputMaskObject.name, '.png');
    % name = name{1};
    % region_path = fullfile(tmpPath, strcat(name, '.mat'));
    % save(region_path, 'regionProposal');
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
    imshow(c*256,hsv(256));
    title('cor mask');

    figure(2), subplot(2,1,1), imshow(c, []);
    subplot(2,1,2), imshow(betterC, []);

  end

end
