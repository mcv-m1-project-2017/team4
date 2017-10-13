function [outImg] = team4_close(inImg, str_elem)
% TEAM4_CLOSE custom implementation of the morphological operation 'closing'.
%   Given the input image 'inImg', compute the output image as a dilation
%   followed by an erosion with the provided structuring element 'str_elem'. 
%   This is the dual filter of TEAM4_OPEN.
%
%   Input parameters
%
%       - inImg:                image to be filtered with an opening.
%                               Compatible types are: 'logical', 'uint8',
%                               'double', 'uint32'.
%
%       - str_elem:             structuring element(SE) with which the
%                               closing is computed.
%
%   Output parameters
%
%       - outImg:               image filtered by the closing. Same type as
%                               the input.
%
%
%   DETAILS
%   --------
%
%       - Implementation:       to see more details about the
%                               implementation, please check the morpholo-
%                               gical operators this filter is composed
%                               from: TEAM_DILATION, TEAM_ERODE.
%
%   USAGE & EXAMPLES
%   ----------------
%       
%       [binImg_closing] = team4_close(binImg, strel('diamond', 3));
%
%       [grayImg_closing] = team4_close(grayImg, ones(3,4));
%
%       originalBW = imread('circles.png');
%       figure, imshow(originalBW);
%       se = strel('disk',10);
%       closeBW = team4_close(originalBW,se);
%       figure, imshow(closeBW);
%
%   See also TEAM4_DILATE, TEAM4_ERODE, TEAM4_OPEN, TEAM4_TOPHAT
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

out_tmp = team4_dilate(inImg, str_elem);
outImg = team4_erode(out_tmp, str_elem);
end