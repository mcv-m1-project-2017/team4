do_plots = true;

% Add repository functions to path
addpath(genpath('..'));

% Set paths
dataset = 'train';
root = '../../../';
inputMasksPath = fullfile(root, 'datasets', 'trafficsigns', 'm1', dataset);
groundTruthPath = fullfile(root, 'datasets', 'trafficsigns', 'split', dataset, 'mask');
tmpPath =  fullfile(root, 'datasets', 'trafficsigns', 'tmp', dataset);
mkdir(tmpPath);

% Get all the files
inputMasks = dir(fullfile(inputMasksPath, '*.png'));
gtMasks = dir(fullfile(groundTruthPath, '*.png'));

% for i = 1:size(inputMasks,1)
for i = 1:size(gtMasks,1)
  %sprintf('Checking mask %d', i)
  gtMaskObject = gtMasks(i);
  gtMaskPath = fullfile(groundTruthPath, gtMaskObject.name);
  gtMask = imread(gtMaskPath);
  % Convert it to logical (faster)
  gtMask = gtMask > 0;
  
  %imshow(gtMask);
  CC = bwconncomp(gtMask);
  rp = regionprops(CC, 'BoundingBox');
  
  for j = 1:size(rp,1)
    minr = max(rp(j).BoundingBox(2) - 1, 1);
    minc = max(rp(j).BoundingBox(1) - 1, 1);
    maxr = rp(j).BoundingBox(2) + rp(j).BoundingBox(4);
    maxc = rp(j).BoundingBox(1) + rp(j).BoundingBox(3);
    signalMask = gtMask(minr:maxr, minc:maxc);
    %canny = edge(uint8(signalMask), 'Canny');
    imwrite(signalMask, ['/tmp/test/' num2str(i) '_' num2str(j) '.png']);
  end
 
 
    
  %regionProps = regionprops(CC, 'Area', 'BoundingBox');
  %regionProps.BoundingBox
end

