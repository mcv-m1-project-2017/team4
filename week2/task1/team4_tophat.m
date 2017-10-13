function [outImg] = team4_tophat(inImg, str_element)
% TEAM4_TOPHAT custom implementation of the morphological operation 'top hat'
%   Given the input image, a morphological opening filter is used to
%   compute an opening and then substracted from the image: 
%   outImg = inImg - opening(inImg, str_element), where 'str_element' is
%   the structurant element used in the opening.
%   This is the dual operation of TEAM4_DUALTOPHAT.
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
%       [binImg_tophat] = team4_tophat(binImg, strel('diamond', 3));
%
%       [grayImg_tophat] = team4_tophat(grayImg, ones(3,4));
%
%       original = imread('rice.png');
%       figure, imshow(original)
%       se = strel('disk',12);
%       tophatFiltered = team4_tophat(original,se);
%       figure, imshow(tophatFiltered)
%       contrastAdjusted = imadjust(tophatFiltered);
%       figure, imshow(contrastAdjusted)
%
%   See also TEAM4_DILATE, TEAM4_ERODE, TEAM4_CLOSE, TEAM4_OPEN
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

tmp_opening = team4_open(inImg, str_element);
outImg = imsubtract(inImg, tmp_opening);
end