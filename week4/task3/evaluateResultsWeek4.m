function [evaluationParams] = evaluateResultsWeek4(resultsFolder, gtFolder, evaluationType)
% EVALUATERESULTS compute 'evaluationType'-based evaluation measurements
% for the result files stored in the 'resultsFolder' path by comparing it
% to the Ground Truth data in the 'gtFolder' path.
%
%   Depending on the 'evaluationType', different evaluation functions are
%   called (e.g.: pixel or window-based call performancePixel/window,etc.).
%
%   Input parameters
%
%       - resultsFolder:        path to the folder where the computed masks
%                               and mat files are stored.
%
%       - gtFolder:             path to the folder where the ground truth
%                               masks and mat files are stored.
%
%       - evaluationType:       type of evaluation. For now 'pixel' and
%                               'window' are supported (pixel/window based).
%
%   Output parameters
%
%       - evaluationParams:     object containing the evaluation parameters
%                               computed. We return it as an object to
%                               generalize to different amount of output
%                               evaluation parameters.
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
%   Project M1/Block4
%   -----------------

addpath(genpath('../../../'));

switch evaluationType
    %% Pixel-based
    case 'pixel'
        % Local and output variables
        evaluationParams = struct('pixelPrecision', [], 'pixelAccuracy', [],...
            'pixelRecall', [], 'pixelFscore', [], 'pixelTP', [], 'pixelFP', [],...
            'pixelFN', []);
        
        pixelTP=0; pixelFN=0; pixelFP=0; pixelTN=0;
        processingTimes = [];
        
        % Include all png's (masks) to process
        resultFiles = dir(strcat(resultsFolder, '/*.png'));
        
        fprintf('Evaluating mask...\n');
        for i = 1:size(resultFiles,1)
            % Load mask and display progress
            fprintf('%d\t of \t%d (%.1f%%)\n', i, size(resultFiles,1), 100*(i/size(resultFiles,1)));
            mask = imread(strcat(resultsFolder, '/', resultFiles(i).name));
            
            % Load gt mask
            gtMask = imread(strcat(gtFolder, '/mask/', resultFiles(i).name));
            
            % Compute TP, FP, FN and TN
            [localPixelTP, localPixelFP, localPixelFN, localPixelTN] =...
                PerformanceAccumulationPixel(mask, gtMask);
            
            pixelTP = pixelTP + localPixelTP;
            pixelFP = pixelFP + localPixelFP;
            pixelFN = pixelFN + localPixelFN;
            pixelTN = pixelTN + localPixelTN;
            
        end
        
        % Compute global metrics (precision, recall, ...)
        [pixelPrecision, pixelAccuracy, ~, pixelRecall] = ...
            PerformanceEvaluationPixel(pixelTP, pixelFP, pixelFN, pixelTN);
        FMeasure = 2*(pixelPrecision*pixelRecall)/(pixelPrecision+pixelRecall);
        total = pixelTP + pixelFP + pixelFN + pixelTN;
        pixelTP = pixelTP / total;
        pixelFP = pixelFP / total;
        pixelFN = pixelFN / total;
        
        % Copy evaluation results to output struct
        evaluationParams.pixelPrecision = pixelPrecision;
        evaluationParams.pixelAccuracy = pixelAccuracy;
        evaluationParams.pixelRecall = pixelRecall;
        evaluationParams.pixelFscore = FMeasure;
        evaluationParams.pixelTP = pixelTP;
        evaluationParams.pixelFP = pixelFP;
        evaluationParams.pixelFN = pixelFN;
        
        %% Window-based
    case 'window'
        % Local variables
        evaluationParams = struct('windowPrecision', [], 'windowAccuracy', [],...
            'windowRecall', [], 'windowFscore', [], 'windowTP', [], 'windowFP', [],...
            'windowFN', []);
        
        windowTP=0; windowFN=0; windowFP=0;
        
        % For all .mat's in the result directory
        resultFiles = dir(strcat(resultsFolder, '/*.mat'));
        
        fprintf('Evaluating windowCandidates...\n');
        for i = 1:size(resultFiles,1)
            % Load .mat file containing windowCandidates
            fprintf('%d\t of \t%d (%.1f%%)\n', i, size(resultFiles,1), 100*(i/size(resultFiles,1)));
            matFile = strcat(resultsFolder, '/', resultFiles(i).name);
            load(matFile, 'windowCandidates');
            
            % Load gt window annotations
            gtFile = strcat(gtFolder, '/gt/', strrep(resultFiles(i).name(1:end-3),...
                'mask', 'gt'), 'txt');
            [windowAnnotations, ~] = LoadAnnotations(gtFile);
            
            % Comp% Compute TP, FN and FP
            [localWindowTP, localWindowFN, localWindowFP] =...
                PerformanceAccumulationWindow(windowCandidates, windowAnnotations);
            
            windowTP = windowTP + localWindowTP;
            windowFN = windowFN + localWindowFN;
            windowFP = windowFP + localWindowFP;
        end
        
        % Compute global metrics (precision, recall, etc)
        [windowPrecision, windowSensitivity, windowAccuracy] = ...
            PerformanceEvaluationWindow(windowTP, windowFN, windowFP);
        windowRecall = windowSensitivity;
        windowFmeasure = 2*(windowPrecision*windowRecall)/(windowPrecision+windowRecall);
        
        % Copy evaluation results to output struct
        evaluationParams.windowPrecision = windowPrecision;
        evaluationParams.windowAccuracy = windowAccuracy;
        evaluationParams.windowRecall = windowRecall;
        evaluationParams.windowFscore = windowFmeasure;
        evaluationParams.windowTP = windowTP;
        evaluationParams.windowFP = windowFP;
        evaluationParams.windowFN = windowFN;
        
    otherwise
        error('This type of evaluation is not supported\n');
end
end