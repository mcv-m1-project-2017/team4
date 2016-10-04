%
% Template example for using on the test set (no annotations).
% 
 
function TrafficSignDetection_validation(input_dir, output_dir, pixel_method, window_method, decision_method)
    % TrafficSignDetection
    % Perform detection of Traffic signs on images. Detection is performed first at the pixel level
    % using a color segmentation. Then, using the color segmentation as a basis, the most likely window 
    % candidates to contain a traffic sign are selected using basic features (form factor, filling factor). 
    % Finally, a decision is taken on these windows using geometric heuristics (Hough) or template matching.
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'input_dir'         Directory where the test images to analize  (.jpg) reside
    %    'output_dir'        Directory where the results are stored
    %    'pixel_method'      Name of the color space: 'opp', 'normrgb', 'lab', 'hsv', etc. (Weeks 2-5)
    %    'window_method'     'SegmentationCCL' or 'SlidingWindow' (Weeks 3-5)
    %    'decision_method'   'GeometricHeuristics' or 'TemplateMatching' (Weeks 4-5)


    global CANONICAL_W;        CANONICAL_W = 64;
    global CANONICAL_H;        CANONICAL_H = 64;
    global SW_STRIDEX;         SW_STRIDEX = 8;
    global SW_STRIDEY;         SW_STRIDEY = 8;
    global SW_CANONICALW;      SW_CANONICALW = 32;
    global SW_ASPECTRATIO;     SW_ASPECTRATIO = 1;
    global SW_MINS;            SW_MINS = 1;
    global SW_MAXS;            SW_MAXS = 2.5;
    global SW_STRIDES;         SW_STRIDES = 1.2;


    % Load models
    %global circleTemplate;
    %global givewayTemplate;   
    %global stopTemplate;      
    %global rectangleTemplate; 
    %global triangleTemplate;  
    %
    %if strcmp(decision_method, 'TemplateMatching')
    %   circleTemplate    = load('TemplateCircles.mat');
    %   givewayTemplate   = load('TemplateGiveways.mat');
    %   stopTemplate      = load('TemplateStops.mat');
    %   rectangleTemplate = load('TemplateRectangles.mat');
    %   triangleTemplate  = load('TemplateTriangles.mat');
    %end

    files = ListFiles(input_dir);
    
    for ii=1:size(files,1),

        ii
        
        % Read file
        im = imread(strcat(input_dir,'/',files(ii).name));
     
        % Candidate Generation (pixel) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        pixelCandidates = CandidateGenerationPixel_Color(im, pixel_method);
        
        
        % Candidate Generation (window)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % windowCandidates = CandidateGenerationWindow_Example(im, pixelCandidates, window_method); %%'SegmentationCCL' or 'SlidingWindow'  (Needed after Week 3)

        out_file1 = sprintf ('%s/test/pixelCandidates_%06d.png',  output_dir, ii);
	    %out_file2 = sprintf ('%s/test/windowCandidates_%06d.mat', output_dir, ii);

	    imwrite (pixelCandidates, out_file1);
	    %save (out_file2, 'windowCandidates');        
    end
end
 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CandidateGeneration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [pixelCandidates] = CandidateGenerationPixel_Color(im, space)

    im=double(im);

    switch space
        case 'normrgb'
            pixelCandidates = im(:,:,1)>100;
            
        otherwise
            error('Incorrect color space defined');
            return
    end
end    
    

function [windowCandidates] = CandidateGenerationWindow_Example(im, pixelCandidates, window_method)
    windowCandidates = [ struct('x',double(12),'y',double(17),'w',double(32),'h',double(32)) ];
end  
