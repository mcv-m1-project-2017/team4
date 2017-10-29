function [filteredMask] = morphologyMethodX(mask, geometricFeatures, params)

% Step 1
SE1 = strel('rectangle', [10,15]);
filteredMask = imclose(mask,SE1);
if (isempty(find(filteredMask(filteredMask > 0), 1)))
    filteredMask = mask;
end

% Step 2
filteredMask2 = imfill(filteredMask,'holes');
if (isempty(find(filteredMask2(filteredMask2 > 0), 1)))
    filteredMask2 = filteredMask;
end

% Step 3
SE2 = strel('disk', 1);
filteredMask3 = imopen(filteredMask2, SE2);
if (isempty(find(filteredMask3(filteredMask3 > 0), 1)))
    filteredMask3 = filteredMask2;
end

% Step 4

% APPLY GEOMETRICAL CONSTRAINTS HERE
[CC, CC_stats] = computeCC_regionProps(filteredMask3);
[filteredMask4, ~, ~] = applyGeometricalConstraints(filteredMask, CC,...
    CC_stats, geometricFeatures, params);
if (isempty(find(filteredMask4(filteredMask4 > 0), 1)))
    filteredMask4 = filteredMask3;
end

% Step 5
SE3 = strel('square', 20);
filteredMask5 = imclose(filteredMask4, SE3);
if (isempty(find(filteredMask5(filteredMask5 > 0), 1)))
    filteredMask5 = filteredMask4;
end

% Step 6
filteredMask6 = imfill(filteredMask5, 'holes');
if (isempty(find(filteredMask6(filteredMask6 > 0), 1)))
    filteredMask6 = filteredMask5;
end

filteredMask = filteredMask6;