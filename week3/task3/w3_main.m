% Add repository functions to path
addpath(genpath('..')); 
rmpath(genpath('../.git')); 

% Set paths
dataset = 'validation';
root = '../../../';
inputMasksPath = fullfile(root, 'datasets', 'trafficsigns', 'm1', dataset);
groundTruthPath = fullfile(root, 'datasets', 'trafficsigns', 'split', dataset, 'mask');
tmpPath =  fullfile(root, 'datasets', 'trafficsigns', 'tmp', dataset);
mkdir(tmpPath);

% Get all the files
inputMasks = dir(fullfile(inputMasksPath, '*.png'));
gtMasks = dir(fullfile(groundTruthPath, '*.png'));
plot = false;

ts = [];

%% Example code
for i = 1:size(inputMasks)
  i
  inputMaskObject = inputMasks(i);
  inputMaskPath = fullfile(inputMasksPath, inputMaskObject.name);
  iMask = imread(inputMaskPath);

  gtMaskObject = gtMasks(i);
  gtMaskPath = fullfile(groundTruthPath, gtMaskObject.name);
  gtMask = imread(gtMaskPath);
  % Convert it to logical (faster)
  gtMask = gtMask > 0;

  % DO ALL THE MAGIC HERE
  %oMask = zeros(size(iMask));

  tic;
  finalMask = mss( iMask );
  t = toc;
  ts = [ts; t];
end

ts
aux = mean(ts)

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
