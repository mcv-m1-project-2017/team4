% Task 2: Template matching using Distance Transform and chamfer distance
do_plots = true;

% Add repository functions to path
addpath(genpath('..'));

% Set paths
dataset = 'train';
root = '../../../';
inputMasksPath = fullfile(root, 'datasets', 'trafficsigns', 'm1', dataset);
groundThruthPath = fullfile(root, 'datasets', 'trafficsigns', 'split', dataset, 'mask');
tmpPath =  fullfile(root, 'datasets', 'trafficsigns', 'tmp', dataset);
mkdir(tmpPath)

% Get all the files
inputMasks = dir(fullfile(inputMasksPath, '*.png'));
gtMasks = dir(fullfile(groundThruthPath, '*.png'));

% for i = 1:size(inputMasks,1)
for i = 1:1
  sprintf('Checking mask %d', i)
  inputMaskObject = inputMasks(i);
  inputMaskPath = fullfile(inputMasksPath, inputMaskObject.name);
  iMask = imread(inputMaskPath);

  gtMaskObject = gtMasks(i);
  gtMaskPath = fullfile(groundThruthPath, gtMaskObject.name);
  gtMask = imread(gtMaskPath);
  % Convert it to logical (faster)
  gtMask = gtMask > 0;

  % DO ALL THE MAGIC HERE
  iMask = zeros(400,400); iMask(50:149, 100:199)=1; iMask(200:299, 200:299)=1;
  featureMask = edge(iMask,'Canny');
  template = ones(100,100);
  template([1,end],:)=0; template(:,[1,end])=0;

  paddedMask = padarray(featureMask, size(template)/2, 0, 'both');
  transformedMask = distanceTransform(paddedMask);

  template = edge(template, 'Canny')+0;
  correlated = xcorr2(template, transformedMask);
  %correlated = normxcorr2(template, transformedMask);
  border = size(template,1);
  correlated = correlated(border:(end-border), border:(end-border));
  correlated = correlated./max(correlated(:));
  c = correlated;
  %c = ind2rgb(c, jet(256));
  %1-correlated;
  %c = c > 0.9;
  %cor(cor<0.01)=255;
  %cor = int16(cor);
  %c = c*255;
  min(c(:)), max(c(:))
  %se = ones(3);
  se = strel('disk',3);
  %se = ones(3,1);
  % se = [0 1 0;
  %       1 1 1;
  %       0 1 0];
  se = ones(1,3);
  betterC = imbothat(c, se);
  betterC = imtophat(betterC, se');
  betterC = betterC ./ max(betterC);
  min(betterC(:)), max(betterC(:))

  bestC = c;
  positions = extractLocalMinima(bestC);
  % for i = 1:size(positions, 1)
  %
  % end % for
  % %c(c==min(c(:)))=256;
  %[min(c(:)),   max(c(:))]

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
    title('distance mask');
    %plot = falseXx

    % Show output mask
    subplot(2,3,3);
    imshow(template,[]);
    title('template');
    axis([1, size(featureMask,1), 1, size(featureMask,2)]);

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
