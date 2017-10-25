%% Script to optimize the geometrical constraints defined by thresholds
% We test different thresholds in training and choose the top 'top'
% (normally 10) to run on validation. Finally, we choose the parameters
% that yield the higher F-score (without compromissing a lot the precision
% or the recall) in validation.
close all;
clear;

addpath(genpath('../../../'));
train = false;       % Run 'train' over the set of defined parameters.
% Otherwise run 'validation' for top 10 parameters
% of last train. Define the top X run through
% validation.
top = 1;

% Define optimum geometric threshold values (found through validation)
load('GeometricalConstraints_params.mat', 'params');
% Load geometrical stats computed from training (tweaked with params above)
load ('GeometricFeatures_train.mat', 'geometricFeatures');

if (train)
    % ------------------------ DEFINE TRAINING VALUES -----------------------
    % IN TRAINING AND THEN TEST IN VALIDATION THE BEST ONE
    %  Compute nº of combinations and define parameters values
    % load('GeometricFeatures_train.mat')
    
    valuesPerParameter = 1;
    tweakedParameters = 1;
    numCombinations = valuesPerParameter^(tweakedParameters);
    results_mtx_train =  zeros(numCombinations, 8); % 8 reported stats (precision, recall, F-sc....)
    res_params_values = zeros(numCombinations, 6);
    % 6 params: min area, max area, AR, FF_tri, FF_circ and FF_rect
    
    % -------------------Parameter values--------------------
    % Min/max area
    % ------------
    % Test aspect ratio and max min size thresholds.
    %         testMinArea_thr = linspace(0.8,2,valuesPerParameter);%1.8;%linspace(1.7, 2, 5);
    %         testMaxArea_thr = linspace(0.8,2,valuesPerParameter);%1.175;%linspace(1, 1.3, 5);
    
    % Values playing with mean + X*std (above is for min/max area only)
    %scaleArea = linspace(1, 4, valuesPerParameter);
    % [vecMinArea, vecMaxArea, vecStdAR] = ndgrid(testMinArea_thr, testMaxArea_thr, testScaleStd_AR);
    %         [vecMinArea, vecMaxArea] = meshgrid(testMinArea_thr, testMaxArea_thr);
    %         vecMinArea = vecMinArea(:);
    %         vecMaxArea = vecMaxArea(:);
    
    % Optimum values (for now):
    vecMinArea = ones(numCombinations,1) * 1.5556;
    vecMaxArea = ones(numCombinations,1) * 0.8889;
    
    % Aspect ratio
    % ------------
    %     testScaleStd_AR = linspace(2, 4, valuesPerParameter);
    %     vecScaleStd_AR = testScaleStd_AR;
    
    % Optimum values (for now):
    vecScaleStd_AR = ones(numCombinations,1) * 2.2105;
    
    % Filling ratio
    % -------------
    %     testFR_tri = linspace(4, 5, valuesPerParameter);%[4, 4.25, 5];
    %     testFR_circ = linspace(4, 5, valuesPerParameter);%[4.5, 4.75, 5];
    %     testFR_rect = linspace(4, 5, valuesPerParameter);%[4.5, 4.75, 5];
    
    % Testing values (NDGRID)
    %     [FR_triangle, FR_circ, FR_rect] = meshgrid(testFR_tri, testFR_circ, testFR_rect);
    %
    %     [FR_triangle, FR_circ] = meshgrid(testFR_tri, testFR_circ);
    
    % Optimum values (for now):
    FR_triangle = ones(numCombinations,1) * 4.5;
    %     FR_triangle = testFR_tri;
    FR_circ = ones(numCombinations,1) * 4.5;
    %     FR_circ = testFR_circ;
    FR_rect = ones(numCombinations,1) * 4.5;
    
    for p = 1:numCombinations
        params = [vecMinArea(p), vecMaxArea(p), vecScaleStd_AR(p),...
            FR_triangle(p), FR_circ(p), FR_rect(p)];
        %         params = [scaleArea(p), scaleArea(p), vecScaleStd_AR(p),...
        %             FR_triangle(p), FR_circ(p), FR_rect(p)];
        [results_mtx_train(p,:)] = Test_morphGeometricConstraints(geometricFeatures,...
            params, 'train');
        % res_params_values(p,:) = [vecMinArea(p), vecMaxArea(p), vecStdAR(p)];
        res_params_values(p,:) = params;
    end
    save('res_geometricConstraints_train_v8.mat', 'results_mtx_train',...
        'res_params_values');
    
else % validation
    % Load results from last train
    load('res_geometricConstraints_train_v8.mat', 'results_mtx_train', 'res_params_values');
    
    % Get the parameter values for the 10 best training f-scores results
    fscore = results_mtx_train(:, 4);
    [tmp_sortedFscore, idxSort] = sort(fscore, 'descend');
    top10_fscore = tmp_sortedFscore(1:top);
    top10_fscoreIdx = idxSort(1:top);
    
    % Define parameters matrix to be run through validation (same as
    % output)
    res_params_values_val = res_params_values(top10_fscoreIdx,:);
    % Allocate matrix to store validation results
    results_mtx_validation = zeros(top, 8);
    
    for p = 1:top
        [results_mtx_validation(p, :)] = Test_morphGeometricConstraints(geometricFeatures,...
            res_params_values_val(p,:), 'validation');
    end
    save('res_geometricConstraints_validation_v8.mat',...
        'results_mtx_validation', 'res_params_values_val');
end