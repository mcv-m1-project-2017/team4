%% Script to test different segmentation algorithms on training data
% The main goal is to select the one which yields the best results with
% respect to the current HSV colour-based segmentation
%
% Algorithms tested:
%
%   - UCM (included in the root folder of the repository)
%   - Mean shift
%   - Watershed (MATLAB's has its own implementation)
%   - (more?)
% The results of the HSV-based segmentation is also shown for comparisonal
% purposes.

% Analyze a subset of manually selected images of the training data (mainly
% difficult ones for the current algorithm) to analyze the improvement
% yield by the tested segmentation algorithms (if any).
% Then, with a relative optimized params for each methods, compute the
% results with the training data (pixel and window-based) to determine
% which algorithm is best.

addpath(genpath('../../../'));
algorithm = 1; % 1 for UCM, 2 for k-means (colour+spatial), 3 for mean shift
% 4 for watershed
plotImage = false;
trainSet = '/home/fperez/Documents/Master in Computer Vision/Module 1 Introduction to Human Visual System and CV/Project/datasets/trafficsigns/train/SegmentationSet';
resultFolder = '/home/fperez/Documents/Master in Computer Vision/Module 1 Introduction to Human Visual System and CV/Project/m1-results/week5/train';

load('GeometricConstraints_params_v2.mat')
load('GeometricFeatures_train.mat')


imageList = dir(strcat(trainSet,'/*.jpg'));

for i = 1:size(imageList)
    % Read image
    I = imread(imageList(i).name);
    %     HSVimage = colorSegmentation(inImage);
    % %     switch (algorithm)
    % %         case 1 % UCM
    % %             % Define algorithm-specific variables
    % %
    %     UCM_image = [];
    % %         case 2 % k-means (colour+spatial)
    % %             K = 10;                 % number of clusters
    % %             [clus_idx] = kmeans(inImage, K);
    % %
    % K = 10; maxIter = 1000; numReplicates = 10;
    % [Ikm2, classKm2] = Kmeans_segmentation(inImage, K, maxIter, numReplicates);
    % %             Ikm2 = Km2(inImage,K);
    % %         case 3 % mean-shift (colour+spatial)
    %             bw = 0.2;
    %             [Ims2, Nms2] = Ms2(inImage,bw);
    %             fprint('Mean-shift algorithms found %d clusters\n', Nms2);
    % %         case 4 % watershed
    % %         otherwise
    % %     end
    %
    %     if (plotImag)
    %        % Input image plotted against other methods (not masks yet)
    %        figure, subplot(2,3,1); imshow(inimage,[]); title('Original image');
    %        subplot(2,3,2); imshow(UCM_image,[]); title('UCM image');
    %        subplot(2,3,4); imshow(Ikm2,[]); title('K-means image');
    %        subplot(2,3,5); imshow(Ims2,[]); title('Mean-shift image');
    %        subplot(2,3,6); imshow(watershed_image,[]); title('Watershed image');
    %
    %        % Input image vs input masks
    %        figure, subplot(2,3,1); imshow(inimage,[]); title('Original image');
    %        subplot(2,3,2); imshow(UCM_mask,[]); title('UCM mask');
    %        subplot(2,3,4); imshow(Ikm2_mask,[]); title('K-means mask');
    %        subplot(2,3,5); imshow(Ims2_mask,[]); title('Mean-shift mask');
    %        subplot(2,3,6); imshow(watershed_mask,[]); title('Watershed mask');
    %
    %     end
    
    %   MEDIAN + COLOUR SEGMENTATION + MORPHOLOGY +  GEOMETRICAL CONSTR. +
    %   WATERSHED
    % MEDIAN
    med_I = medfilt3(I);
    
    % HSV-BASED COLOUR SEGMENTATION
    col_med = colorSegmentation(med_I);
    
    % MORPHOLOGY
    filt_colMed = imfill(col_med,'holes');
    filt_colMed_open = imopen(filt_colMed, strel('square', 20));
    
    % GEOMETRICAL CONSTRAINTS
    [CC, CC_stats] = computeCC_regionProps(filt_colMed_open);
    [filt_2, windowCandidates, ~] = applyGeometricalConstraints(filt_colMed_open,...
        CC, CC_stats, geometricFeatures, params);
    
    % INVERSE OF DISTANCE TRANSFORM AND WATERSHED (conn = 4)
    % Separates overlapped CC
    DT = bwdist(~filt_2);
    DT = -DT;
    DT(~filt_2) = Inf;
    L = watershed (DT);
    L(~filt_2) = 0;
    
    % Final mask as all regions returned by watershed
    final_mask = L > 0;
    if (plotImage)
        rgb = label2rgb(L,'jet',[.5,.5,.5]);
        figure
        imshow(rgb,'InitialMagnification','fit')
        title('Watershed transform of D')
        figure, imshow(L,[])
        
        figure, imshow(final_mask,[]);
    end
    
    
end