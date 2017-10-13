function [outImg] = team4_erode(inImg, str_elem)
% TEAM4_ERODE custom implementation of the morphological operator 'erosion'.
%   Given the input image 'inImg', compute the output image as the erosion
%   of the former with the provided structuring element 'str_elem' by mo-
%   ing it across the image and retrieving the minima under the window.
%   This is the dual operator of TEAM4_DILATE.
%
%   Input parameters
%
%       - inImg:                image to be eroded. Compatible types are:
%                               'logical', 'uint8', 'double'.
%
%       - str_elem:             structuring element(SE) with which the ero-
%                               sion is calculated.
%
%   Output parameters
%
%       - outImg:               eroded image. Same type as the input.
%
%
%   DETAILS
%   --------
%
%       - We have not deleted the previous implementations so you may see
%         the process we went through to achieve the final result (the
%         fastest).
%
%       - 'str_element': it can be defined by a double matrix with 1's where
%         the SE is 'active, ~=1 elsewhere. MATLAB's 'strel' object is also
%         accepted (flat structuring elements). 'offstrel' also supported
%         for grayscale images only.
%
%       - SE_origin: we follow the convention that it can be computed as:
%                   SE_origin = floor(size(str_element+1)/2).
%
%       - 'min_padding', 'max_padding': it can be proven that, given the
%         expression used to compute the SE' origin, the left (columns) and
%         upper (rows) padding will be equal or smaller than the right
%         (columns) and bottom (rows).
%
%         With 'padarray' we can add the minimum amount of padding needed,
%         following the criteria presented before:
%           - 'pre': left and upper bounds.
%           - 'post' right and bottom bounds.
%
%       - Computation with logical (BW) images: we used an logic-operations
%         based code to improve the performance with BW images (see below).
%
%   EXAMPLES
%   --------
%
%       [binImg_eroded] = team4_erode(binImg, strel('diamond', 3));
%
%       [grayImg_eroded] = team4_erode(grayImg, ones(3,4));
%
%       originalI = imread('cameraman.tif');
%       se = strel('disk',5,5);
%       erodedI = imerode(originalI,se);
%       figure, imshow(originalI), figure, imshow(erodedI)
%
%   See also TEAM4_DILATE, TEAM4_OPEN, TEAM4_CLOSE, TEAM4_TOPHAT
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

if (isa(inImg, 'uint8') || isa(inImg, 'double'))
    if (~isa(str_elem, 'strel'))
        str_elem = double(str_elem);              % Convert SE to double.
    else
        str_elem = double(str_elem.Neighborhood); % Get actual SE array.
    end
    
    str_elem(str_elem ~= 1) = Inf;          % SE with value 1 or 'Inf'.
    [height, width] = size(inImg);          % Image size.
    SE_size = size(str_elem);               % SE size.
    SE_origin = floor((SE_size + 1)/2);     % SE origin.
    
    % Add padding (max_padding = min_padding for symmetrical SEs)
    max_padding = SE_size - SE_origin;
    min_padding = SE_origin - 1;
    
    % Allocate a tmp_img used for computations.
    % Value 'inf' so it does not affect the min(*).
    tmp_img = inf(height+min_padding(1)+max_padding(1),...
        width+min_padding(2)+max_padding(2));
    
    % Copy the original image into the tmp variable.
    tmp_img(1+min_padding(1):end-max_padding(1),...
        1+min_padding(2):end-max_padding(2)) = inImg;
    
    % Convert the image into columns containing all the elements of a block
    % of size SE_size
    tmp_imgCols = im2col(tmp_img, SE_size, 'sliding');
    
    SE_cols = str_elem(:);                  % Put the SE in a column.
    
    % Element wise multiplication of SE and tmp_img (both in 'columns')
    targetPixels = bsxfun(@times, tmp_imgCols, SE_cols);
    
    outImg_cols = min(targetPixels);        % Compute the minimum.
    
    % Reshape the image back to its original shape
    outImg = reshape(outImg_cols, height, width);   
    %     outImg = zeros(height, width);           % Output (double) allocation
    
    % Boost up performance by using nl filters and process it by block
    %     outImg = nlfilter(tmp_img, [SE_size(1), SE_size(2)],...
    %         @(x) erodeBlock(x, str_elem));
    %
    %     % Post-processing: nlfilter/my_nlfilter substitutes the Inf for 0's
    %     % after computing the output image, we need to remove this padding.
    %     outImg = outImg(1+min_padding(1):end-max_padding(1),...
    %         1+min_padding(2):end-max_padding(2));
    
    %     for r = 1:height
    %         for c = 1:width
    %             % Pixels to be processed (under the window and SE = 1).
    %
    %             targetPixels = tmp_img(r:r+min_padding(1)+max_padding(1),...
    %                 c:c+min_padding(2)+max_padding(2)).* str_elem;
    %
    %             % Compute minimum.
    %             outImg(r,c) = min(targetPixels(:));
    %         end
    %     end
    
    % Convert output image back to its original type.
    if(isa(inImg,'uint8'))
        outImg = uint8(outImg);
    else                                    % Type double, do nothing.
    end
elseif (isa(inImg, 'logical'))              % BW/binary (logical) image.
    if (~isa(str_elem, 'strel'))
        str_elem = logical(str_elem);       % Convert SE to logical.
    else
        str_elem = str_elem.Neighborhood;   % Get actual SE array.
    end
    
    str_elem(str_elem ~= 1) = 0;            % SE with value 1 or 0.
    [height, width] = size(inImg);          % Image size.
    SE_size = size(str_elem);               % SE size.
    SE_origin = floor((SE_size + 1)/2);     % SE origin.
    
    % Add padding (max_padding = min_padding for symmetrical SEs)
    max_padding = SE_size - SE_origin;
    min_padding = SE_origin - 1;
    
    % Allocate a tmp_img used for computations.
    %     tmp_img = inImg;
    %     tmp_img = padarray(tmp_img, [min_padding(1), min_padding(2)], 1, 'pre');
    %     tmp_img = padarray(tmp_img, [max_padding(1), max_padding(2)], 1, 'post');
    %
    % %     outImg = true(height, width);        % Output (logical) 1's allocation
    %
    %     % Boost up performance by using nl filters and process it by block
    %     outImg = nlfilter(tmp_img, [SE_size(1), SE_size(2)],...
    %         @(x) logic_erodeBlock(x, str_elem));
    %
    
    % Allocate a logical matrix of ones (true) with padding.
    tmp_img = true(height+min_padding(1)+max_padding(1),...
        width+min_padding(2)+max_padding(2));
    
    % Copy the image into the tmp_img variable
    tmp_img(1+min_padding(1):end-max_padding(1),...
        1+min_padding(2):end-max_padding(2)) = inImg;
    
    % Convert the image into columns containing the processing blocks
    tmp_imgCols = im2col(tmp_img, SE_size, 'sliding');
    
    SE_cols = str_elem(:);                  % Put SE in columns.
    
    % Element-wise matrix multiplication of SE and tmp_img in columns
    targetPixels = bsxfun(@times, tmp_imgCols, SE_cols);
    
    outImg_cols = min(targetPixels);        % Compute the minimum.
    
    % Reshape image back to its original form factor
    outImg = reshape(outImg_cols, height, width);
    
    %     for r= 1:height
    %         for c= 1:width
    %             % Original pixels within the window defined by the SE.
    %             targetPixels = tmp_img(r:r+min_padding(1)+max_padding(1),...
    %                 c:c+min_padding(2)+max_padding(2));
    %
    %             % Mask defined by the SE to select the pixels that affect min()
    %             maskStrEl = or(or(and(targetPixels, str_elem),...
    %                 and(targetPixels, not(str_elem))),...
    %                 and(not(targetPixels), not(str_elem)));
    %
    %             % Compute the minimum.
    %             outImg(r,c) = min(maskStrEl(:));
    %         end
    %     end
else
    fprintf('Not valid format, the image must be of type ''logical''(BW), ''uint8'', ''double''\n');
end
end
% function [erosion_blockVal] = erodeBlock(imgBlock, SE_mod)
% effectiveBlock = imgBlock .* SE_mod;
% erosion_blockVal = min(effectiveBlock(:));
% end
% function [logErosion_blockVal] = logic_erodeBlock(imgBlock, SE_mod)
% mask_SE = or(or(and(imgBlock, SE_mod), and(imgBlock, not(SE_mod))),...
%     and(not(imgBlock), not(SE_mod)));
% logErosion_blockVal = min(mask_SE(:));
% end