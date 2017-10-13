function [outImg] = team4_open(inImg, str_elem)
% TEAM4_OPEN custom implementation of the morphological filter 'opening'. 
%   Given the input image 'inImg', compute the output image as an erosion
%   followed by a dilation with the provided structuring element 'str_elem'. 
%   This is the dual filter of TEAM4_CLOSE.
%
%   Input parameters
%
%       - inImg:                image to be filtered with an opening.
%                               Compatible types are: 'logical', 'uint8',
%                               'double', 'uint32'.
%
%       - str_elem:             structuring element(SE) with which the
%                               opening is computed.
%
%   Output parameters
%
%       - outImg:               image filtered by the opening. Same type as
%                               the input.
%
%
%   DETAILS
%   --------
%
%       - Implementation:       to see more details about the
%                               implementation, please check the morpholo-
%                               gical operators this filter is composed
%                               from: TEAM4_ERODE, TEAM_DILATION.
%
%   USAGE & EXAMPLES
%   ----------------
%       
%       [binImg_opening] = team4_open(binImg, strel('diamond', 3));
%
%       [grayImg_opening] = team4_open(grayImg, ones(3,4));
%
%       original = imread('snowflakes.png');
%       se = strel('disk',5);
%       afterOpening = team4_open(original,se);
%       figure, imshow(original), figure, imshow(afterOpening,[])
%
%   See also TEAM4_DILATE, TEAM4_ERODE, TEAM4_CLOSE, TEAM4_TOPHAT
%            TEAM4_DUALTOPHAT, STREL.
%
%   Examples extracted from Matlab's documentation and applied to custom
%   functions so the results can be compared straightaway.
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
%   Project M1/Block2
%   -----------------

out_tmp = team4_erode(inImg, str_elem);
outImg = team4_dilate(out_tmp, str_elem);
end