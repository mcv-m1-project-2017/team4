% ------------------------------------------------------------------------ 
%  Copyright (C)
%  Universitat Politecnica de Catalunya BarcelonaTech (UPC) - Spain
%  Ramon Morros
%
function seg = segment_ucm(ima, tresh)
% Segment an image by thresholding an UCM
% Usage: seg = segment_ucm(ima, thresh)
%
% INPUT:
%    ima     : image to segment
%    threesh : threshold to apply to the UCM
% OUPUT
%    seg : label image

   ucm2_scg = im2ucm(ima,'fast');
   thr_ucm2_scg = ucm2_scg>tresh;
   seg = gridbmap2seg(thr_ucm2_scg);
   
end



