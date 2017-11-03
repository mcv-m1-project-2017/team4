function [corrValue] = applyTemplateMask(mask, model)
% APPLYTEMPLATEMAsk: apply template mask on the
% ROI candidate
%
%   Input parameters
%
%       - Mask:      ROI image.
%
%       - model:     template matching model image.
%
%
%   Output parameters
%
%       - corrValue:    result of correlation
%
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
%   Project M1/Block4
%   -----------------



    % Modify mask inorder to avoid errors when masks are not well defined
    mask(mask>0)=1;

    %ROImask = imresize (ROImask,[40,40],'bilinear');
    model = imresize(model, size(mask),'bilinear');
    
    corrValue = corr2(mask, model);
    
    
    
end
