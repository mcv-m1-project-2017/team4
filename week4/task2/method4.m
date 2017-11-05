addpath("../../evaluation");

% Task 2: Template matching using Distance Transform and chamfer distance
do_plots = true;

% Add repository functions to path
addpath(genpath('..'));

% Set paths
dataset = 'validation';
root = '../../../';

%inputMasksPath = fullfile(root, 'datasets', 'trafficsigns', 'm1', dataset);
inputMasksPath = fullfile(root, 'm1', dataset);
fullImagePath = fullfile(root, 'datasets', 'trafficsigns', 'split', dataset);
gtMasksPath = fullfile(root, 'datasets', 'trafficsigns', 'split', dataset, 'mask');

% Get all the files
inputMasks = dir(fullfile(inputMasksPath, '*.png'));
frames = dir(fullfile(fullImagePath, '*.jpg'));
gtMasks = dir(fullfile(gtMasksPath, '*.png'));

%Get models
tri_down = uint8( imread('/tmp/test/2_1.png') );
tri_up = uint8( imread('/tmp/test/18_1.png') );
squ = uint8( imread('/tmp/test/7_1.png') );
circ = uint8( imread('/tmp/test/1_1.png') );

pixelTP=0; pixelFN=0; pixelFP=0; pixelTN=0;
processing_times = [];


% for i = 1:size(inputMasks,1)
for i = 2:2 %size(inputMasks,1)
  sprintf('Checking mask %d', i)
  inputMaskObject = inputMasks(i);
  inputMaskPath = fullfile(inputMasksPath, inputMaskObject.name);
  iMask = imread(inputMaskPath);

  frameObject = frames(i);
  framePath = fullfile(fullImagePath, frameObject.name);
  frame = imread(framePath);
  
  gtMaskObject = gtMasks(i);
  gtMaskPath = fullfile(gtMasksPath, gtMaskObject.name);
  gtMask = imread(gtMaskPath);

  %figure, imshow(iMask)
 
  CC = bwconncomp(iMask);
  rp = regionprops(CC, 'BoundingBox');
  
  imwrite(iMask, ['/tmp/test4/' num2str(i) '.png']);
  
  extraMargin = 10;
  for j = 1:1 %size(rp,1)
  
    minr = max(rp(j).BoundingBox(2) - extraMargin, 1);
    minc = max(rp(j).BoundingBox(1) - extraMargin, 1);
    maxr = min(rp(j).BoundingBox(2) + rp(j).BoundingBox(4) + extraMargin, size(frame,1));
    maxc = min(rp(j).BoundingBox(1) + rp(j).BoundingBox(3) + extraMargin, size(frame,2));
    signalMask = frame(minr:maxr, minc:maxc,:);
    figure, imshow(signalMask);
    signalMask = rgb2gray(signalMask);
    imdist = getDistImage(signalMask);
    figure, imshow(normalize(imdist));
    [imDetectionC, cC] = featureDetection2( imdist, circ, .4, extraMargin );
    %[imDetectionTD, cTD] = featureDetection2( imdist, tri_down, .4, extraMargin );
    %[imDetectionTU, cTU] = featureDetection2( imdist, tri_up, .4, extraMargin );
    %[imDetectionS, cS] = featureDetection2( imdist, squ, .4, extraMargin );
    %figure, imshow(imDetection);
    
    %minC = min([cC cTD cTU cS])
    
    imwrite(signalMask, ['/tmp/test3/' num2str(i) '_' num2str(j) '_i.png']);
    if minC == cC
      imwrite(imDetectionC, ['/tmp/test3/' num2str(i) '_' num2str(j) '_m_c.png']);
       iMask(minr:maxr, minc:maxc) = imDetectionC;
    elseif minC == cTD
      imwrite(imDetectionTD, ['/tmp/test3/' num2str(i) '_' num2str(j) '_m_td.png']);
      iMask(minr:maxr, minc:maxc) = imDetectionTD;
    elseif minC == cTU
      imwrite(imDetectionTU, ['/tmp/test3/' num2str(i) '_' num2str(j) '_m_tu.png']);
      iMask(minr:maxr, minc:maxc) = imDetectionTU;
    else
      imwrite(imDetectionS, ['/tmp/test3/' num2str(i) '_' num2str(j) '_m_s.png']);
      iMask(minr:maxr, minc:maxc) = imDetectionS;
    end
  
    %iMask = uint8(iMask);
    %signalMask = iMask(minr:maxr, minc:maxc,:);
    %featureDetection( signalMask, tri_down, tri_up, circ, squ );
  end
  %imwrite(iMask, ['/tmp/test4/' num2str(i) '_m.png']);   
  
  pixelAnnotation = gtMask>0;
  [localPixelTP, localPixelFP, localPixelFN, localPixelTN] = PerformanceAccumulationPixel(iMask, pixelAnnotation);
  pixelTP = pixelTP + localPixelTP;
  pixelFP = pixelFP + localPixelFP;
  pixelFN = pixelFN + localPixelFN;
  pixelTN = pixelTN + localPixelTN; 
  
end

total = pixelTP + pixelFP + pixelFN + pixelTN;
[pixelTP, pixelFP, pixelFN, pixelTN] / total

[pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity] = PerformanceEvaluationPixel(pixelTP, pixelFP, pixelFN, pixelTN);
[pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity]
  
recall = pixelTP / (pixelTP + pixelFN)
