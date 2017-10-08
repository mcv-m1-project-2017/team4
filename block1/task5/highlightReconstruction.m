function [correctedImg] = highlightReconstruction(inputImg, clippingThr, recOperation, colorSpace)
% highlightReconstruction: try to restore highlights from clipped image.
%   FirsCheck if any or multiple colour channels are clipped (0.02 margin),
%   if so, apply a scaling to reduce the "strength" of each colour channel
%   proportionally to the amount of clipping in the most clipped channel.
%
%   Input parameters:
%
%       - inputImg:                         image to reconstruct.
%
%       - clippingThr:                      number from 0 to 1 that defines
%                                           the % of colorRange "used"
%                                           (e.g.: non-clipped).
%
%       - recOperation:                     operation (division/product or
%                                           subtraction of luminace). '/'
%                                           or '-'.
%
%       - colorSpace:                       colorSpace where the highlight
%                                           reconstruction will be performed.
%                                           Options are: 'RGB', 'HSV' and
%                                           'HSL'
%
%   Ouput parameters:
%
%       - correctedImg:                     reconstructed image.
%


tmp_img = double(inputImg);

if (strcmp(colorSpace, 'RGB') == 1)
    R_ch = tmp_img(:,:,1);
    G_ch = tmp_img(:,:,2);
    B_ch = tmp_img(:,:,3);
    
    R_clipped = find(R_ch > 255 * clippingThr);
    G_clipped = find(G_ch > 255 * clippingThr);
    B_clipped = find(B_ch > 255 * clippingThr);
    
    if (~isempty(R_clipped) || ~isempty(G_clipped) || ~ isempty(B_clipped))
        % Recover highlights
        [numPixelsClip,mostClipped] = max([length(R_clipped), length(G_clipped),...
            length(B_clipped)]);
        fprintf('Found most clipped channel(R-> 1, G-> 2, B-> 3) num: %d, with %.2f%% of channel pixels clipped\n',...
            mostClipped, 100* (numPixelsClip/(numel(tmp_img(:,:,mostClipped)))));
        
        % We do not need to check if the others channels are clipped because
        % we need to "underexpose" them with the same value to maintain the
        % relative weight of each colour channel.
        %             clipChImg = tmp_img(:,:,mostClipped);
        switch (mostClipped)
            case 1                       % R channel
                mostClipPix_value = max(R_ch(R_clipped));
                clippingValue = mostClipPix_value - round(255 * clippingThr);
            case 2                       % G channel
                mostClipPix_value = max(G_ch(G_clipped));
                clippingValue = mostClipPix_value - round(255 * clippingThr);
            case 3                       % B channel
                mostClipPix_value = max(B_ch(B_clipped));
                clippingValue = mostClipPix_value - round(255 * clippingThr);
            otherwise
                fprintf('Fatal error, unvalid channel number, exiting...\n');
                
        end
        R_corrected = R_ch;
        B_corrected = B_ch;
        G_corrected = G_ch;
        
        % We must combine all the indices from each channel to correct in
        % all 3 channels the burnt pixels (Apply indices from R => RGB, G
        % => RGB, B => RGB)
        
        if (strcmp(recOperation, '/'))
            % Correct all channels for clippings in R channel
            R_corrected(R_clipped) = R_corrected(R_clipped) .* (100-clippingValue)/100;
            G_corrected(R_clipped) = G_corrected(R_clipped) .* (100-clippingValue)/100;
            B_corrected(R_clipped) = B_corrected(R_clipped) .* (100-clippingValue)/100;
            
            % Correct all channels for clippings in G channel
            R_corrected(G_clipped) = R_corrected(G_clipped) .* (100-clippingValue)/100;
            G_corrected(G_clipped) = G_corrected(G_clipped) .* (100-clippingValue)/100;
            B_corrected(G_clipped) = B_corrected(G_clipped) .* (100-clippingValue)/100;
            
            % Correct all channels for clippings in B channel
            R_corrected(B_clipped) = R_corrected(B_clipped) .* (100-clippingValue)/100;
            G_corrected(B_clipped) = G_corrected(B_clipped) .* (100-clippingValue)/100;
            B_corrected(B_clipped) = B_corrected(B_clipped) .* (100-clippingValue)/100;
            
        elseif (strcmp(recOperation, '-'))
            % Correct all channels for clippings in R channel
            R_corrected(R_clipped) = R_corrected(R_clipped) - clippingValue;
            G_corrected(R_clipped) = G_corrected(R_clipped) - clippingValue;
            B_corrected(R_clipped) = B_corrected(R_clipped) - clippingValue;
            
            % Correct all channels for clippings in G channel
            R_corrected(G_clipped) = R_corrected(G_clipped) - clippingValue;
            G_corrected(G_clipped) = G_corrected(G_clipped) - clippingValue;
            B_corrected(G_clipped) = B_corrected(G_clipped) - clippingValue;
            
            % Correct all channels for clippings in B channel
            R_corrected(B_clipped) = R_corrected(B_clipped) - clippingValue;
            G_corrected(B_clipped) = G_corrected(B_clipped) - clippingValue;
            B_corrected(B_clipped) = B_corrected(B_clipped) - clippingValue;
            
        else
            fprintf('Error, operation not supported, type one of the following: ''*'' or ''+''\n');
        end
        
        correctedImg = cat(3, uint8(R_corrected), uint8(G_corrected), uint8(B_corrected));
        
    else
        fprintf('Given the clipping threshold, no clipped pixel has been found\n');
        correctedImg = inputImg;
    end
elseif (strcmp(colorSpace, 'HSV') == 1)
    scaleFactor = 2;
    % Convert RGB image to HSV (using the colormap function given)
    HSV_img = rgb2hsv(tmp_img);
    H_ch = HSV_img(:,:,1);
    S_ch = HSV_img(:,:,2);
    V_ch = HSV_img(:,:,3);
    
    % With both HSV and HSL, we only need to threshold the V/L channel:
    V_clipped = find(V_ch > 255 * clippingThr);
    % Additionally, to reduce the luminance, V is the only channel
    % modified
    mostClippedPixel = max(V_ch(V_clipped));
    clippingValue = mostClippedPixel - round(255 * clippingThr);
    fprintf('Channel V, %.2f%% of values in the clipped range\n',...
        (length(V_clipped)/numel(HSV_img(:,:,3)) * 100));
    V_corrected = V_ch;
    
    if (strcmp(recOperation, '/'))
        V_corrected(V_clipped) = V_corrected(V_clipped) .* (100 - scaleFactor * clippingValue)/100;
    elseif (strcmp(recOperation, '-'))
        V_corrected(V_clipped) = V_corrected(V_clipped) - (scaleFactor * clippingValue);
    else
        fprintf('Error, operation not supported, type one of the following: ''*'' or ''+''\n');
    end
    
    HSV_restored = cat(3, H_ch, S_ch, V_corrected);
    % Once the correction has been applied, convert the image back to RGB
    correctedImg = uint8(hsv2rgb(HSV_restored));
    
elseif (strcmp(colorSpace, 'YCbCr') == 1)
    % if type(input) = uint8, then:
    % Y is in the range [16, 235], and
    % Cb and Cr are in the range [16, 240].
    scaleFactor = 1;          % used to increase the effect.
    % Convert RGB image to HSL
    YCbCr_img = double(rgb2ycbcr(uint8(tmp_img)));
    
    Y_ch = YCbCr_img(:,:,1);
    Cb_ch = YCbCr_img(:,:,2);
    Cr_ch = YCbCr_img(:,:,3);
    
    Y_clipped = find(Y_ch > 235 * clippingThr);
    % Only modify Y (luma) channel
    mostClippedPixel = max(Y_ch(Y_clipped));
    clippingValue = mostClippedPixel - round(235 * clippingThr);
    fprintf('Channel Y, %.2f%% of values in the clipped range\n',...
        (length(Y_clipped)/numel(YCbCr_img(:,:,1)) * 100));
    Y_corrected = Y_ch;
    
    if (strcmp(recOperation, '/'))
        Y_corrected(Y_clipped) = Y_corrected(Y_clipped) .* (100 - scaleFactor *  clippingValue)/100;
    elseif (strcmp(recOperation, '-'))
        Y_corrected(Y_clipped) = Y_corrected(Y_clipped) - (scaleFactor *  clippingValue);
    else
        fprintf('Error, operation not supported, type one of the following: ''*'' or ''+''\n');
    end
    
    YCbCr_restored = cat(3, uint8(Y_corrected), uint8(Cb_ch), uint8(Cr_ch));
    % Once the correction has been applied, convert the image back to RGB
    correctedImg = ycbcr2rgb(YCbCr_restored);
    
else
    fprintf('Unvalid color space, only ''RGB'', ''HSV'' and ''YCbCr'' are currently supported\n');
end
end