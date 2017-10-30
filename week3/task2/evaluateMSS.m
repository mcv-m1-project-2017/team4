function [evalParams_pixel, evalParams_window] = evaluateMSS(mode, dataset, method_num)
% GENERATEANDEVALUATE_BBMASKS: process images in 'dataset' to evaluate the
% performance of the method number 'method_num' and store the detection
% windows and pixel masks generated.
%
%   Input parameters
%
%       - mode:                     flag to avoid storing .mat and png
%                                   files while debugging ('debug') so the
%                                   performance is boosted.
%
%       - dataset_name:             datasen chosen ('validation' or 'test').
%
%       - method_num:               reference to method used to process the
%                                   images (and also to the define a proper path).
%
%   Output parameters
%
%       - evalParams_pixel:         pixel-based evaluation measurements:
%                                   precision, accuracy, recall, fmeasure,
%                                   pixelTP, pixelFP pixelTN and TimePerFrame.
%
%       - evalParams_window:        window-based evaluation measurements:
%                                   precision, accuracy, recall, fmeasure,
%                                   windowTP, windowFP and windowFN
%
%   AUTHORS
%   -------
%   Jonatan Poveda
%   Martí Cobos
%   Juan Francesc Serracant
%   Ferran Pérez
%   Master in Computer Vision
%   Computer Vision Center, Barcelona
%
%   Project M1/Block3
%   -----------------

%% Initialization
addpath(genpath('../../../'));

% Configuration (evaluation types and toggle plots on/off)
evaluatePixel = false;
evaluateWindow = true;

plotImgs = false;
plotGran = true;

if (evaluatePixel)
    % Variables to store pixel-based evaluation current TP, FN, FP and TN's.
    pixelTP=0; pixelFN=0; pixelFP=0; pixelTN=0;
    processingTimes = [];
end

if (evaluateWindow)
    % Variables to store region-based evaluation current TP, FN, FP and TN's
    windowTP=0; windowFN=0; windowFP=0;
end

% Define root
root = fileparts(fileparts(fileparts(pwd)));
path = fullfile(root, 'datasets', 'trafficsigns', dataset);

% Method 1 ==> CCL
% Method 2, 3 and 4 (sliding window: 'standard', 'integral', 'convolution'
resultFolder =  fullfile(root, 'm1-results', 'week3', 'results', dataset,...
    ['method', num2str(method_num)]);

% Get image files
files = dir(strcat(path, '/*.jpg'));

fprintf('Generating and evaluating results for method %d and dataset ''%s''\n',...
    method_num, dataset);

%% Process images in dataset path
for i = 1:size(files,1)

    % Read image
    fprintf('----------------------------------------------------\n');
    fprintf('Processing image number  %d of %d\n', i, size(files,1));
    image = imread(strcat(path, '/', files(i).name));

    tic;
    % Apply HSV color segmentation to generate image mask
    segmentationMask = colorSegmentation(image);
    if (isempty(find(segmentationMask(segmentationMask > 0), 1)))
        warning(['The colour segmentation found 0 candidates!\n'
            'This will add a considerable amount of TN pixels and at least one TN (region) detection\n']);
    end
    % Apply morphlogical operators to improve mask
    % <Insert your method as a new 'elseif' condition>
    if (method_num == 1)
        filteredMask = imfill(segmentationMask, 'holes');
        %         if (isempty(find(filteredMask(filteredMask > 0), 1)))   % (**)
        %             % Revert back to the colour segmentation (better to have a possible
        %             % signal (although it may be a FP) than a FN rightoutaway
        %             filteredMask = segmentationMask;
        %         end
        filteredMask2 = imopen(filteredMask, strel('square', 20));
        %         if (isempty(find(filteredMask2(filteredMask2 > 0), 1))) % (**)
        %             % Same logic as above
        %             filteredMask2 = filteredMask;
        %         end
        % Apply geometrical constraints to lower the number of FPs
        [CC, CC_stats] = computeCC_regionProps(filteredMask2);
        % This function internally checks the conditions put above (**)
        [filteredMask3, windowCandidates, ~] = applyGeometricalConstraints(filteredMask2,...
            CC, CC_stats, geometricFeatures, params);
        filteredMask = filteredMask3;

    elseif (method_num == 2)
        [filteredMask2]= method5(segmentationMask);
        if (isempty(find(filteredMask2(filteredMask2 > 0), 1)))
            filteredMask2 = segmentationMask;
        end
        % Apply geometrical constraints to lower the number of FPs
        [CC, CC_stats] = computeCC_regionProps(filteredMask2);
        % This function internally checks the conditions put above (**)
        [filteredMask3, windowCandidates, ~] = applyGeometricalConstraints(filteredMask2,...
            CC, CC_stats, geometricFeatures, params);
        filteredMask = filteredMask3;

    elseif (method_num == 3)
        filteredMask = morphologyMethodX(segmentationMask, geometricFeatures,...
            params);
        [CC, CC_stats] = computeCC_regionProps(filteredMask);
        [filteredMask, windowCandidates, ~] = applyGeometricalConstraints(filteredMask,...
            CC, CC_stats, geometricFeatures, params);
    elseif (method_num == 99)
	% Multiscale searcho

        [isSignal] = checkRegion(filteredMask)
    end

    % Evaluation
    if(evaluatePixel)
        if (strcmp(dataset, 'test'))
            fprintf('evaluatePixel: the ''test'' set cannot be evaluated (no GT labels)\n');
        else
            time = toc;
            %Show images in figure
            if (plotImgs)

                subplot(2,2,1), imshow(image);
                subplot(2,2,2), imshow(segmentationMask);
                subplot(2,2,4), imshow(filteredMask_3);
                if (plotGran)
                    %Compute image granulometry
                    maxSize = 30;
                    x =((1-maxSize):maxSize);
                    pecstrum = granulometry(filteredMask_3,'diamond',maxSize);
                    derivative = [-diff(pecstrum) 0];
                    subplot(2,2,3), plot(x,derivative),grid, title('Derivate Granulometry with a ''diamond'' as SE');
                end

            end
            processingTimes = [processingTimes; time];
            % Load mask GT
            pixelAnnotation = imread(strcat(path, '/mask/mask.',...
                files(i).name(1:size(files(i).name,2)-3), 'png'))>0;

            % Compute TP, FP, FN and TN
            [localPixelTP, localPixelFP, localPixelFN, localPixelTN] =...
                PerformanceAccumulationPixel(filteredMask, pixelAnnotation);

            pixelTP = pixelTP + localPixelTP;
            pixelFP = pixelFP + localPixelFP;
            pixelFN = pixelFN + localPixelFN;
            pixelTN = pixelTN + localPixelTN;
        end
    end

    if (evaluateWindow)
        if (strcmp(dataset, 'test'))
            fprintf('evaluateWindow: the ''test'' set cannot be evaluated (no GT labels)\n');
        else
            % Load annotations (from txt file defining GT' bounding boxes)
            gtFile = strcat(path, '/gt/gt.', strrep(files(i).name, 'jpg', 'txt'));
            [annotations, ~] = LoadAnnotations(gtFile);
            if(size(annotations,1) > 1 || size(annotations,2) > 1)
                fprintf('check this\n');
            end

            % Compute TP, FN and FP
            [localWindowTP, localWindowFN, localWindowFP] =...
                PerformanceAccumulationWindow(windowCandidates, annotations);

            windowTP = windowTP + localWindowTP;
            windowFN = windowFN + localWindowFN;
            windowFP = windowFP + localWindowFP;
        end
    end


    % Save .mat with 'windowCandidates' and mask in their respective paths
    if (exist(resultFolder, 'dir') == 0)
        % Create folder
        status = mkdir(resultFolder);
        if (status == 0)
            error('Could not create directory ''%s''\n', resultFolder);
        end
    end

    if (strcmp(mode, 'debug'))
        fprintf('Debug mode: not saving mat or png files to boost performance\n');
    else

        save(strcat(resultFolder, '/mask.',...
            files(i).name(1:size(files(i).name,2)-3), 'mat'), 'windowCandidates');
        imwrite(filteredMask,strcat(resultFolder, '/mask.',...
            files(i).name(1:size(files(i).name,2)-3), 'png'));
    end

end

%% Generate (store) mask and bounding boxes as .png and .mat files, respectively

if (evaluatePixel)
    if (strcmp(dataset, 'test'))
        fprintf('The ''test'' set cannot be evaluated (no GT labels\n');
    else
        % Compute algorithm precision, accuracy, specificity, recall and fmeasure
        [pixelPrecision, pixelAccuracy, ~, pixelRecall] = PerformanceEvaluationPixel(pixelTP, pixelFP, pixelFN, pixelTN);
        FMeasure = 2*(pixelPrecision*pixelRecall)/(pixelPrecision+pixelRecall);
        total = pixelTP + pixelFP + pixelFN + pixelTN;
        pixelTP = pixelTP / total;
        pixelFP = pixelFP / total;
        pixelFN = pixelFN / total;

        %Get time per frame mean
        timePerFrame = mean(processingTimes);

        if(strcmp(mode, 'debug'))
            fprintf('Results for area/AR: minArea ==> %.4f maxArea ==> %.4f scaleStdAR ==> %.4f FR_tri ==> %.4f FR_circ ==> %.4f FR_rect ==> %.4f\n',...
                params(1), params(2), params(3), params(4), params(5), params(6));
        end

        % Print results to command window
        fprintf('----------------------PIXEL-BASED RESULTS----------------------\n');
        fprintf('Note: TP, TN and FN are in percentage(%%) (counts/total)\n');
        fprintf('Prm. ==> Precision; \t Accuracy; \t Recall; \t Fmeasure; \t pixelTP; \t pixelFP; \t pixelFN; \t timexFrame\n');
        fprintf('Res. ==> %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n',...
            pixelPrecision, pixelAccuracy, pixelRecall,FMeasure, pixelTP, pixelFP,...
            pixelFN, timePerFrame);
        evalParams_pixel = [pixelPrecision, pixelAccuracy, pixelRecall,FMeasure, pixelTP, pixelFP,...
            pixelFN, timePerFrame];

        if (strcmp(mode, 'debug'))
            fprintf('Debug mode: not saving mat or png files to boost performance\n');
        else
            % Save results to .mat (at the dataset path)
            datasetPath = strrep(resultFolder,['method', num2str(method_num)], '');
            matName = strcat(datasetPath, '/Pixel-based_results_method', num2str(method_num), '.mat');
            save(matName, 'evalParams_pixel');
        end
    end
end

% Final evaluation (region-based)
if (evaluateWindow)
    if (strcmp(dataset, 'test'))
        fprintf('The ''test'' set cannot be evaluated (no GT labels\n');
    else
        [regionPrecision, regionSensitivity, regionAccuracy] = ...
            PerformanceEvaluationWindow(windowTP, windowFN, windowFP);
        regionRecall = regionSensitivity;
        regionFmeasure = 2 * (regionPrecision * regionRecall)/(regionPrecision + regionRecall);

        if (strcmp(mode, 'debug'))
            fprintf('Results for area/AR: minArea ==> %.4f maxArea ==> %.4f scaleStdAR ==> %.4f FR_tri ==> %.4f FR_circ ==> %.4f FR_rect ==> %.4f\n',...
                params(1), params(2), params(3), params(4), params(5), params(6));
        end
        % We do not have TN, so the results are absolute not in percentage!
        % Print results to command window
        fprintf('----------------------WINDOW-BASED RESULTS----------------------\n');
        fprintf('Note: TP, TN and FN are in absolute numbers (counts)\n');
        fprintf('Prm. ==> Precision; \t Accuracy; \t Recall; \t Fmeasure; \t regionTP; \t regionFP; \t regionFN;\n');
        fprintf('Res. ==> %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n',...
            regionPrecision, regionAccuracy, regionRecall, regionFmeasure,...
            windowTP, windowFP, windowFN);
        evalParams_window = [regionPrecision, regionAccuracy, regionRecall,...
            regionFmeasure, windowTP, windowFP, windowFN];

        if (strcmp(mode, 'debug'))
            fprintf('Debug mode: not saving mat or png files to boost performance\n');
        else
            % Save results to .mat (dataset path)
            datasetPath = strrep(resultFolder,['method', num2str(method_num)], '');
            matName = strcat(datasetPath, '/Window-based_results_method', num2str(method_num), '.mat');
            save(matName, 'evalParams_window');
        end
      end
    end
