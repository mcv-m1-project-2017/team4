function [filteredMask] = circularHough(image)
% circularHough: process image using circular hough and generate filtered
% mask and window candidates
%
%   Input parameters
%
%       - image:                     input image
%                                   
%
%   Output parameters
%
%       - filteredMask:         mask with signal detections
%
%       - windowCandidates:        window containing signal detections
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
%   Project M1/Block5
%   -----------------


    img = double(rgb2gray(image));
    filteredMask = zeros(size(img));
    windowCandidates = struct([]);
    [N,M] = size(img);
    
    %Image enhanced for contour detection
    [grdx, grdy] = gradient(img);
    grdmag = sqrt(grdx.^2 + grdy.^2);
    imgEnhanced = img + grdmag;

    [accum, circen, cirrad] = CircularHough_Grd(imgEnhanced,[20 40],50,10,0.7);
    
    for i = 1:length(cirrad)
        %filteredMask();
        
        mask = createCircle(M,N, circen(i,1), circen(i,2),cirrad(i) );
        filteredMask = filteredMask | mask; 
        
    end
  
end