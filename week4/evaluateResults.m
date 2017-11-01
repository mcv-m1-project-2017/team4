function [evaluationParams] = evaluateResults(resultsFolder, gtFolder, evaluationType)
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
        % Local variables
        pixelTP=0; pixelFN=0; pixelFP=0; pixelTN=0;
        processingTimes = [];
        
        % Include all png's (masks) to process
        resultFiles = dir(strcat(resultsFolder, '/*.png'));
        
        for i = 1:size(resultFiles,1)
            % Read mask and display progress
            fprintf('--------------------------------------------\n');
            fprintf('Evaluating mask %d of %d\n', i, resultFiles);
            mask = imread(strcat(resultFiles, '/', files(i).name));
            
            % Start counter (processing time)
            tic;
            
            
        end
        
        
        
    %% Window-based
    case 'window'
        % Local variables
        windowTP=0; windowFN=0; windowFP=0;
    otherwise
end




end

