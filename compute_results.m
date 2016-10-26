% Script to evaluate students' submissions. Not to be used by the students.*'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*

    addpath(genpath('.'))

    teams             = [1,2,3,4,5,6,7,8];
    week              = 1;
    window_evaluation = 0; 


    % Open files to store evaluation results
    out_results_pix = sprintf ('W%d_pixel_results.txt', week); 
    pixFile = fopen(out_results_pix, 'w');
    if window_evaluation == 1,
        out_results_win = sprintf ('W%d_window_results.txt', week); 
        winFile = fopen(out_results_win, 'w');
    end

    % Directory where the GT masks and text annotations reside
    test_dir   = '/home/ihcv00/DataSetCorrected/test/';
    test_files = ListFiles(test_dir);

    % Loop for all teams
    for jj=1: length(teams),
        results_dir = sprintf('/home/ihcv%02d/m1-results/week%d/test', teams(jj), week );

        pixelTP=0; pixelFN=0; pixelFP=0; pixelTN=0;
	windowTP=0; windowFN=0; windowFP=0; 

        methods = dir (results_dir);


        % For each team, loop over all the submitted methods
        for kk=3: length(methods),

	    result_files = ListFiles([results_dir, '/', methods(kk).name]);
            sprintf ('Method %s : %d files found', size(result_files,1); % This number should be the same as the number of test images			      

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

            fprintf (pixFile, 'Group %02d pixel, method %s : %.2f, %.2f, %.2f\n', teams(jj), methods(kk).name, pixelPrecision, pixelSensitivity, pixelF1);      
            sprintf (         'Group %02d pixel, method %s : %.2f, %.2f, %.2f\n', teams(jj), methods(kk).name, pixelPrecision, pixelSensitivity, pixelF1)      

	    if window_evaluation == 1,
		[windowPrecision, windowSensitivity, windowAccuracy] = PerformanceEvaluationWindow(windowTP, windowFN, windowFP); % (Needed after Week 3)
		windowF1 =0;

                fprintf (winFile, 'Group %02d window, method %s : %.2f, %.2f, %.2f\n', teams(jj), methods(kk).name, windowPrecision, windowSensitivity, windowF1);     
                sprintf (         'Group %02d window, method %s : %.2f, %.2f, %.2f\n', teams(jj), methods(kk).name, windowPrecision, windowSensitivity, windowF1) 
            end
        end
    end
    fclose(pixFile);
    if window_evaluation == 1,
        fclose(winFile);
    end
