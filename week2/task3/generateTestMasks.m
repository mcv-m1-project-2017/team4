%% Generate test masks
close all;
clear;
addpath('../../evaluation');
addpath('../colorSegmentation');

pixelTP=0; pixelFN=0; pixelFP=0; pixelTN=0;
processingTimes = [];
pecstrum = zeros(1,80);

plotImgs = false;
plotGran = true;

dataset = 'test';
root = fileparts(fileparts(fileparts(pwd)));
path = fullfile(root, 'datasets', 'trafficsigns', dataset);
resultFolder =  fullfile(root,'m1-results','week2','test','method4');


%Get image files
files = dir( strcat(path, '/*.jpg') );

%Analyse images in path
for i = 1:size(files)
    
    %Read RGB iamge
    fprintf('----------------------------------------------------\n');
    fprintf('Analysing image number  %d\n', i);
    image = imread(strcat(path, '/', files(i).name));
    tic;
    %Apply HSV color segmentation to generate image mask
    segmentationMask = colorSegmentation( image );
    
    %Apply morphlogical operators to improve mask
    
    % -----For methods 4 and 5 we are using stats computed on week1
    %Load thresholds computed over the training set:-----
    %   load('AreaFillingFormFactor_trainingOld.mat')
    
    
    % Replace the function name for your own and add parameters if needed
    %   filteredMask = morphFilterMask_method4(segmentationMask, fillFormArea_stats);
    %    filteredMask = segmentationMask;
    filteredMask = morphFilterMask(segmentationMask);
    
    %Compute time per frame
    time = toc;
    
    %Show images in figure
    if (plotImgs)
        
        subplot(2,2,1), imshow(image);
        subplot(2,2,2), imshow(segmentationMask);
        subplot(2,2,4), imshow(filteredMask);
        if (plotGran)
            %Compute image granulometry
            maxSize = 30;
            x =((1-maxSize):maxSize);
            pecstrum = granulometry(segmentationMask,'disk',maxSize);
            derivative = [-diff(pecstrum) 0];
            subplot(2,2,3), plot(x,derivative),grid, title('Derivate Granulometry with a ''disk'' as SE');
        end
        
    end
    processingTimes = [processingTimes; time];
    imwrite(filteredMask,strcat(resultFolder, '/mask.',files(i).name(1:size(files(i).name,2)-3), 'png'));
    
end