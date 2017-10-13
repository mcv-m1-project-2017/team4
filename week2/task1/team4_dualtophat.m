function [outImg] = team4_dualtophat(inImg, str_elem)
% TEAM4_DUALTOPHAT custom implementation of the morphological operation
% 'dual tophat'.
%   Given the input image, the output is computed by substracting this
%   image from its closing, performed with a structuring element
%   'str_elem': outImg = closing(inImg) - inImg. 
%   This is the dual operation of TEAM4_TOPHAT.
%
%   Input parameters
%
%       - inImg:                image to be filtered with dual top hat.
%                               Compatible types are: 'logical', 'uint8',
%                               'double', 'uint32'.
%
%       - str_elem:             structuring element(SE) with which the
%                               closing in the dual tophat is computed.
%
%   Output parameters
%
%       - outImg:               image filtered by dual tophat. Same type
%                               as the input.
%
%
%   DETAILS
%   --------
%
%       - Implementation:       to see more details about the
%                               implementation, please check the morpholo-
%                               gical filter of TEAM4_CLOSE.
%
%   USAGE & EXAMPLES
%   ----------------
%       
%       [binImg_dualtophat] = team4_dualtophat(binImg, strel('diamond', 3));
%
%       [grayImg_dualtophat] = team4_dualtophat(grayImg, ones(3,4));
%
%      original = imread('pout.tif');
%        se = strel('disk',3);
%        contrastFiltered = ...
%        imsubtract(imadd(original,team4_tophat(original,se)),...
%                         team4_dualtopthat(original,se));
%        figure, imshow(original)
%        figure, imshow(contrastFiltered)
%
%   See also TEAM4_DILATE, TEAM4_ERODE, TEAM4_CLOSE, TEAM4_OPEN
%            TEAM4_TOPHAT, STREL.
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

tmp_closing = team4_close(inImg, str_elem);
outImg = imsubtract(tmp_closing, inImg);
end