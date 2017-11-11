function [watershedRefined, regProps_refined] = watershedSegmentation(RGB_image, gradient, geometricFeatures)
%WATERSHEDSEGMENTATION Summary of this function goes here
%   Detailed explanation goes here

%% Parameters
se_size = 10;                       % Size of first structuring element
se2_size = 5;                       % Size of second structuring element
CC_minArea = geometricFeatures(1);	% Minimum CC area allowed (computed from train)
CC_maxArea = geometricFeatures(2);	% Maximum  "  "    "
conn = 8;                           % Watershed region connectivity (8 default)

%% Step  1: read in image and compute gradient magnitude
medianRGB = medfilt3(RGB_image);
HSV = rgb2hsv(medianRGB);
V_channel = HSV(:,:,3);
if (strcmpi(gradient, 'sobel'))
    hy = fspecial('sobel');
    hx = hy';
    Iy = imfilter(double(V_channel), hy, 'replicate');
    Ix = imfilter(double(V_channel), hx, 'replicate');
    gradmag = sqrt(Ix.^2 + Iy.^2);
elseif (strcmpi(gradient,'canny'))
    gradmag = edge(V_channel, 'Canny');
else
    error('Unsupported gradient type!\n');
end

%% Step 2: mark the foreground objects
se = strel('disk', se_size);
% Opening by reconstruction of erosion
Ve = imerode(V_channel, se);
Vobr = imreconstruct(Ve, V_channel);

% Opening-closing by reconstruction of dilation
Vobrd = imdilate(Vobr, se);
Vobrcbr = imreconstruct(imcomplement(Vobrd), imcomplement(Vobr));
Vobrcbr = imcomplement(Vobrcbr);

% Obtain foreground markers
fgm = imregionalmax(Vobrcbr);

% Clean edges of the marker blobs and shrink them to avoid overlap
se2 = strel(ones(se2_size, se2_size));
fgm2 = imclose(fgm, se2);
fgm3 = imerode(fgm2, se2);

% Erase too small blobs (isolated pixels)
fgm4 = bwareaopen(fgm3, CC_minArea); % Min. training signal size

%% Step 3: compute background markers
% Compute background markers with the help of distance transform and
% watershed (yes, inception!)
%bw = imbinarize(Vobrcbr);
bw = graythresh(Vobrcbr);
D = bwdist(bw);
DL = watershed(D);
bgm = DL == 0; % watershed 'ridge' lines

%% Step 4: compute the watershed transform of the segmentation function
% Restrict local minima to background and foreground markers position
gradmag2 = imimposemin(gradmag, bgm | fgm4);

% Finally, compute the watershed-based segmentation
L = watershed(gradmag2, conn);

%% Step 5: refinement; only return those regions whose size is feasible
regProps = regionprops(L, 'Area', 'BoundingBox', 'Centroid');
removeIdx = find([regProps.Area] > CC_maxArea);
watershedRefined = L;
regProps_refined = regProps;
for r = length(removeIdx):1
    watershedRefined(watershedRefined == removeIdx(r)) = 0;
    regProps_refined(removeIdx(r)) = [];
end
