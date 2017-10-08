function [outImg] = colorConstancy(inputImg, method, varargin)
% ColorConstancy function that implements different the most known colour
% constancy algorithms.
%   Methods: white Patch, grey world and modified white patch.
%
%   Input parameters
%
%       -inputImg:                      image to be processed.
%
%       -method:                        color constancy algorithm used,
%                                       options are: 'WhitePatch', 
%                                       'ModifiedWhitePatch' or
%                                       'GreyWorld', 'Y histogram'
%
%       -varargin:                      only used to input new threshold
%                                       'ModifiedWhitePatch'.
%
%   Output parameters
%
%       -outImg:                        output (processed) image.
%

[m,n, ~] = size(inputImg);
switch(method)
    case 'WhitePatch'
        const_R = 255 / max(max(double(inputImg(:,:,1))));
        const_G = 255 / max(max(double(inputImg(:,:,2))));
        const_B = 255 / max(max(double(inputImg(:,:,3))));
        outImg(:,:,1) = const_R * double(inputImg(:,:,1));
        outImg(:,:,2) = const_G * double(inputImg(:,:,2));
        outImg(:,:,3) = const_B * double(inputImg(:,:,3));
        outImg = uint8(outImg);
        
    case 'ModifiedWhitePatch'
        if (~isempty(varargin))
            threshold = varargin{1};
            R=inputImg(:,:,1); const_R = 255 / mean(R(R>threshold));
            G=inputImg(:,:,2); const_G = 255 / mean(G(G>threshold));
            B=inputImg(:,:,3); const_B = 255 / mean(B(B>threshold));
            outImg(:,:,1) = const_R * double(inputImg(:,:,1));
            outImg(:,:,2) = const_G * double(inputImg(:,:,2));
            outImg(:,:,3) = const_B * double(inputImg(:,:,3));
            outImg = uint8(outImg);
            
        else
            outImg=inputImg;
            fprintf('For ''Modified White Patch'' a threshold should be inputted as the last parameter.\n');
            
        end
        
    case 'GreyWorld'
        Rmean = sum(sum(inputImg(:,:,1)))/(m * n);
        Gmean = sum(sum(inputImg(:,:,2)))/(m * n);
        Bmean = sum(sum(inputImg(:,:,3)))/(m * n);
        Avg = mean([Rmean, Gmean, Bmean]);
        const_R = Avg / Rmean;
        const_G = Avg / Gmean;
        const_B = Avg / Bmean;
        outImg(:,:,1) = const_R * double(inputImg(:,:,1));
        outImg(:,:,2) = const_G * double(inputImg(:,:,2));
        outImg(:,:,3) = const_B * double(inputImg(:,:,3));
        outImg = uint8(outImg);
        
    case 'Y histogram'
        
        
    otherwise
        fprintf('Unknown method, valid inputs are: ''WhitePatch'', ''ModifiedWhitePatch'' or ''GreyWorld''\n');
        outImg = inputImg;
end

end