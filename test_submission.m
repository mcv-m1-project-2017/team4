% Use this script to test your submission. Do not look at the results, as they are computed with fake annotations and masks.
% This is just to see if there's any problem with files, paths, permissions, etc. *'


    addpath(genpath('.'))

    % Configure this
    team              = 0;  % Your team number
    week              = 1;  % Week number
    window_evaluation = 1;  % Whether to perform or not window evaluation: 0 for weeks 1&2, 1 for weeks 3,4&5 


    % Do not make changes below this point ---------------------------------
    % If you find a bug, please report it to ramon.morros@upc.edu ----------
    test_dir   = '/home/ihcv00/DataSetCorrected/fake_test/';  % This folder contains fake masks and text annotations. Do not change this.
    test_files = ListFiles(test_dir);

    test_files_num = size(test_files,1);


    results_dir = sprintf('/home/ihcv%02d/m1-results/week%d/test', team, week );

    pixelTP=0; pixelFN=0; pixelFP=0; pixelTN=0;
    windowTP=0; windowFN=0; windowFP=0; 

    methods = dir (results_dir);
    for kk=3: length(methods),

	result_files = ListFiles([results_dir, '/', methods(kk).name]);
        result_files_num = size(result_files,1);

        if result_files_num ~= test_files_num,
	  sprintf ('Method %s : %d result files found but there are %d test files', methods(kk).name, result_files_num, test_files_num) 
        end

	for ii=1:size(result_files,1),

	    % Read mask file
	    candidate_masks_name = fullfile(results_dir, methods(kk).name, result_files(ii).name);
	    pixelCandidates = imread(candidate_masks_name)>0;

	    % Accumulate pixel performance of the current image %%%%%%%%%%%%%%%%%
	    [pathstr,name,ext] = fileparts(test_files(ii).name);
	    gt_mask_name = fullfile(test_dir, 'mask', ['mask.' name '.png']);

	    pixelAnnotation = imread(gt_mask_name)>0;
	    [localPixelTP, localPixelFP, localPixelFN, localPixelTN] = PerformanceAccumulationPixel(pixelCandidates, pixelAnnotation);
	    pixelTP = pixelTP + localPixelTP;
	    pixelFP = pixelFP + localPixelFP;
	    pixelFN = pixelFN + localPixelFN;
	    pixelTN = pixelTN + localPixelTN;

	    if window_evaluation == 1,
		% Read .mat file
		[pathstr_r,name_r, ext_r] = fileparts(result_files(ii).name);
		mat_name = fullfile(results_dir, methods(kk).name, [name_r '.mat']);
		clear windowCandidates
		load(mat_name);

		gt_annotations_name = fullfile(test_dir, 'gt', ['gt.' name '.txt']);
		windowAnnotations = LoadAnnotations(gt_annotations_name);

		[localWindowTP, localWindowFN, localWindowFP] = PerformanceAccumulationWindow(windowCandidates, windowAnnotations);
		windowTP = windowTP + localWindowTP;
		windowFN = windowFN + localWindowFN;
		windowFP = windowFP + localWindowFP;
	    end
	end

	% Plot performance evaluation
	[pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity] = PerformanceEvaluationPixel(pixelTP, pixelFP, pixelFN, pixelTN);
	pixelF1 = 2*((pixelPrecision*pixelSensitivity)/(pixelPrecision + pixelSensitivity));

	sprintf (         'Team %02d pixel, method %s : %.2f, %.2f, %.2f\n', team, methods(kk).name, pixelPrecision, pixelSensitivity, pixelF1)      

	if window_evaluation == 1,
	    [windowPrecision, windowSensitivity, windowAccuracy] = PerformanceEvaluationWindow(windowTP, windowFN, windowFP); % (Needed after Week 3)
	    windowF1 =0;

	    sprintf (         'Team %02d window, method %s : %.2f, %.2f, %.2f\n', team, methods(kk).name, windowPrecision, windowSensitivity, windowF1) 
	end
    end
