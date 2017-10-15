% Load generated aModels and bModels
% load('histogramsModels.mat')
load('models.mat')

global nBins
nBins = 100;

% Load an image
dataset = 'train';
root = '/home/jon/mcv_repos';

trainPath = fullfile(root, 'datasets', 'trafficsigns', dataset);
maskPath = fullfile(root, 'datasets', 'trafficsigns', dataset, 'mask');

imageFiles = dir(fullfile(trainPath, '*.jpg'));
maskFiles = dir(fullfile(maskPath, '*.png'));

% for i=1:size(imageFiles,1)
th1 = 1e-9; th2 = 1e-9; th3 = 1e-9;
last_score = 0;

tic
nFrames = 1;
nFrames = size(imageFiles,1);
for i=1:nFrames
  imageFile = imageFiles(i);
  maskFile = maskFiles(i);

  imagePath = fullfile(imageFile.folder, imageFile.name);
  maskPath =  fullfile(maskFile.folder, maskFile.name);
  image = imread(imagePath);
  mask_gt = imread(maskPath);
  % Apply segmentation
  [ probabilites ] = segmentation(image, aModels, bModels);
  mask = enmask(probabilites, ones(3,1)*probabilites*0.1);
  % save('probabilities', 'probabilites')


  % normalize probabilites
  for c=1:3
    p = probabilites(:,:,c);
    p = p / max(p(:));  % [0-1]
    logprob(:,:,c) = log10(1+p);  % [0, ~0.3010]
  end

  last_score = 0;
  thresholds = zeros(1,3);
  best_thresholds = zeros(1,3);

  for class=1:3
    p = logprob(:,:,class);
    iterations = 0;
    range = [ 1-e3 1 ];
    last_score = 0;ºq
    % Find best j-threshold
    for th=linspace(range(1),range(2), 1000)
      iterations = iterations + 1;
      th
      thresholds(class) = th;
      mask = enmask(logprob, thresholds, class);
      score = compare_masks(mask_gt, mask);
      if score > last_score
        last_score = score;
        best_thresholds = thresholds;
      else
         break
      end
    end
    iterations
  end
  % Best mask found
  best_thresholds
  mask = enmask(logprob, best_thresholds, 0);
  score = compare_masks(mask_gt, mask)

  subplot(1,2,1), imshow(mask_gt,[]);
  subplot(1,2,2), imshow(mask,[]);
end
timePerFrame = toc/nFrames;

% p = probabilites;
% max(max(p(:,:,2)))
%
% subplot(1,3,1), imshow(p(:,:,1),[]),
% subplot(1,3,2), imshow(p(:,:,2),[]),
% subplot(1,3,3), imshow(p(:,:,3),[]),
%
% mask = p>1.3e-9;
% subplot(1,3,1), imshow(mask(:,:,1),[]),
% subplot(1,3,2), imshow(mask(:,:,2),[]),
% subplot(1,3,3), imshow(mask(:,:,3),[]),
%
% mask_signs_and = mask(:,:,1) & mask(:,:,2) & mask(:,:,3);
% mask_signs_or = mask(:,:,1) | mask(:,:,2) | mask(:,:,3);
% figure()
% subplot(1,2,1), imshow(mask_signs_and,[])
% subplot(1,2,2), imshow(mask_signs_or,[])
%
% mask_signs_and = p(:,:,1) .* p(:,:,2) .* p(:,:,3);
% mask_signs_or = p(:,:,1) + p(:,:,2) + p(:,:,3);
% figure()
% subplot(1,2,1), imshow(mask_signs_and,[])
% subplot(1,2,2), imshow(mask_signs_or,[])
