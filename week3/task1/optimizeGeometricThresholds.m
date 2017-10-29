%% Script to optimize the geometrical constraints defined by thresholds
% We test different thresholds in training and choose the top 'top'
% (normally 10) to run on validation. Finally, we choose the parameters
% that yield the higher F-score (without compromissing a lot the precision
% or the recall) in validation.
close all;
clear;

addpath(genpath('../../../'));
dataset = 'validation';%'train';%'validation';%'train';%'validation';%'train';%'validation';%'train';%'validation'       
% Run 'train' over the set of defined parameters.
% Otherwise run 'validation' for top 10 parameters
% of last train. Define the top X run through
% validation.
test_num = 5;
method_num = 1;
top = 10;

% Select whether to optimize for pixel/window-based F-score
fscorePixel = false;

% Define optimum geometric threshold values (found through validation)
load('GeometricalConstraints_params.mat', 'params');
% Load geometrical stats computed from training (tweaked with params above)
load ('GeometricFeatures_train.mat', 'geometricFeatures');

if (strcmp(dataset, 'train'))
    % ------------------------ DEFINE TRAINING VALUES -----------------------
    % IN TRAINING AND THEN TEST IN VALIDATION THE BEST ONE
    %  Compute nº of combinations and define parameters values
    % load('GeometricFeatures_train.mat')
    
    valuesPerParameter = [5,5];
    %tweakedParameters = 3;
    %numCombinations = valuesPerParameter^(tweakedParameters);
    numCombinations = prod(valuesPerParameter);
    results_mtx_train_pixel = zeros(numCombinations, 8); % 8 reported stats (precision, recall, F-sc....)
    results_mtx_train_window = zeros(numCombinations, 7); % All but 'timePerFrame'
    res_params_values = zeros(numCombinations, 6);
    % 6 params: min area, max area, AR, FF_tri, FF_circ and FF_rect
    
    % -------------------Parameter values--------------------
    % Min/max area
    % ------------
    % Test aspect ratio and max min size thresholds.
%     testMinArea_thr = linspace(0.8,2,valuesPerParameter);%1.8;%linspace(1.7, 2, 5);
%     testMaxArea_thr = linspace(0.8,2,valuesPerParameter);%1.175;%linspace(1, 1.3, 5);
    
%     testMinArea_thr = [2, 1.8667];
%     testMaxArea_thr = [0.9333, 1.0667, 1.2000, 1.3333];
    % Values playing with mean + X*std (above is for min/max area only)
    %scaleArea = linspace(1, 4, valuesPerParameter);
    %     [vecMinArea, vecMaxArea, vecStdAR] = ndgrid(testMinArea_thr, testMaxArea_thr, testScaleStd_AR);
%     [vecMinArea, vecMaxArea] = meshgrid(testMinArea_thr, testMaxArea_thr);
%     vecMinArea = vecMinArea(:);
%     vecMaxArea = vecMaxArea(:);
    
    % Optimum values (for now):
%         vecMinArea = ones(numCombinations,1) * 1.5556;
%         vecMaxArea = ones(numCombinations,1) * 0.8889;
% WINDOW
        vecMinArea = ones(numCombinations,1) * 2;
        vecMaxArea = ones(numCombinations,1) * 0.9333;

    
    % Aspect ratio
    % ------------
    %     testScaleStd_AR = linspace(2, 4, valuesPerParameter);
    %     vecScaleStd_AR = testScaleStd_AR;
%     testScaleStd_AR = linspace(2, 4, valuesPerParameter(3));
    
%     [vecMinArea, vecMaxArea] = meshgrid(testMinArea_thr,...
%         testMaxArea_thr);
%     vecMinArea = vecMinArea(:); vecMaxArea = vecMaxArea(:);
%     vecScaleStd_AR = vecScaleStd_AR(:);
    % Optimum values (for now):
    vecScaleStd_AR = ones(numCombinations,1) * 2.2105;
    
    % Filling ratio
    % -------------
%         testFR_tri = linspace(4, 5, valuesPerParameter(3));%[4, 4.25, 5];
        testFR_circ = linspace(4, 5, valuesPerParameter(1));%[4.5, 4.75, 5];
        testFR_rect = linspace(4, 5, valuesPerParameter(2));%[4.5, 4.75, 5];
    
    % Testing values (NDGRID)
    %     [FR_triangle, FR_circ, FR_rect] = meshgrid(testFR_tri, testFR_circ, testFR_rect);
    %
        [FR_circ, FR_rect] = meshgrid(testFR_circ, testFR_rect);
    FR_circ = FR_circ(:); FR_rect = FR_rect(:);
%     [vecMinArea, vecMaxArea, FR_triangle] = meshgrid(testMinArea_thr,...
%         testMaxArea_thr, testFR_tri);
%     vecMinArea = vecMinArea(:); vecMaxArea = vecMaxArea(:);
%     FR_triangle = FR_triangle(:);
    
    % Optimum values (for now):
    FR_triangle = ones(numCombinations,1) * 5;
    %     FR_triangle = testFR_tri;
%     FR_circ = ones(numCombinations,1) * 4.5;
%     %     FR_circ = testFR_circ;
%     FR_rect = ones(numCombinations,1) * 4.5;
    
    for p = 1:numCombinations
        params = [vecMinArea(p), vecMaxArea(p), vecScaleStd_AR(p),...
            FR_triangle(p), FR_circ(p), FR_rect(p)];
        %         params = [scaleArea(p), scaleArea(p), vecScaleStd_AR(p),...
        %             FR_triangle(p), FR_circ(p), FR_rect(p)];
        [results_mtx_train_pixel(p,:), results_mtx_train_window(p,:)] =...
            generateAndEvaluate_BBMasks('debug', geometricFeatures,...
            params, dataset, method_num);
        % res_params_values(p,:) = [vecMinArea(p), vecMaxArea(p), vecStdAR(p)];
        res_params_values(p,:) = params;
    end
    
    % In both cases (optimizing for pixel or window, save both)
    if (fscorePixel)
        filename = strcat('res_geometricConstraints_train_pixel_v',...
            num2str(test_num),'_m', num2str(method_num), '.mat');
        save(filename, 'results_mtx_train_pixel',...
            'res_params_values', 'results_mtx_train_window');
    else
        filename = strcat('res_geometricConstraints_train_window_v',...
            num2str(test_num),'_m', num2str(method_num), '.mat');
        save(filename, 'results_mtx_train_window',...
            'res_params_values', 'results_mtx_train_pixel');
    end
    
elseif (strcmp(dataset, 'validation')) % validation
    % Load results from last train (both, as we want to compare them when
    % optimizing for one or the other; 'pixel' or 'window')
    if (fscorePixel)
        filename = strcat('res_geometricConstraints_train_pixel_v',...
            num2str(test_num),'_m', num2str(method_num), '.mat');
        load(filename, 'results_mtx_train_pixel', 'res_params_values',...
            'results_mtx_train_window');
    else
        filename = strcat('res_geometricConstraints_train_window_v',...
            num2str(test_num),'_m', num2str(method_num), '.mat');
        load(filename, 'results_mtx_train_window', 'res_params_values',...
            'results_mtx_train_pixel');
    end
    % Get the parameter values for the 10 best training f-scores results
    if (fscorePixel)
        fscore = results_mtx_train_pixel(:, 4);
        [tmp_sortedFscore, idxSort] = sort(fscore, 'descend');
        top10_fscore = tmp_sortedFscore(1:top);
        top10_fscoreIdx = idxSort(1:top);
    else
        fscore = results_mtx_train_window(:, 4);
        [tmp_sortedFscore, idxSort] = sort(fscore, 'descend');
        top10_fscore = tmp_sortedFscore(1:top);
        top10_fscoreIdx = idxSort(1:top);
    end
    
    % Define parameters matrix to be run through validation (same as
    % output)
    res_params_values_val = res_params_values(top10_fscoreIdx,:);
    % Allocate matrix to store validation results
    results_mtx_validation_pixel = zeros(top, 8);
    results_mtx_validation_window = zeros(top, 7);
    
    for p = 1:top
        params = res_params_values_val(p,:);
        [results_mtx_validation_pixel(p,:), results_mtx_validation_window(p,:)] =...
            generateAndEvaluate_BBMasks('debug', geometricFeatures,...
            params, dataset, method_num);
    end
    if (fscorePixel)
        filename = strcat('res_geometricConstraints_validation_pixel_v',...
            num2str(test_num),'_m', num2str(method_num), '.mat');
        save(filename,...
            'results_mtx_validation_pixel', 'res_params_values_val',...
            'results_mtx_validation_window');
    else
        filename = strcat('res_geometricConstraints_validation_window_v',...
            num2str(test_num),'_m', num2str(method_num), '.mat');
        save(filename,...
            'results_mtx_validation_window', 'res_params_values_val',...
            'results_mtx_validation_pixel');
    end
else
    error('This optimization script can only be run with training (actual optimization) and validation (test optimal values)\n');
end