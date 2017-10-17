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

% Show input mask
figure(1);
subplot(2,2,1);
file = inputMasks(1);
inputMaskPath = fullfile(file.folder, file.name);
iMask = imread(inputMaskPath);
imshow(iMask,[]);
title('Input mask');

% Show ground truth mask
figure(1);
subplot(2,2,2);
file = gtMasks(1);
gtMaskPath = fullfile(file.folder, file.name);
gtMask = imread(gtMaskPath);
% Convert it to logical (faster computations)
gtMask = gtMask>0;
imshow(gtMask,[]);
title('GroundTruth mask');

% DO ALL THE MAGIC HERE
oMask = zeros(size(iMask));

% Show output mask
figure(1);
subplot(2,1,2);
imshow(oMask,[]);
title('Output mask');

