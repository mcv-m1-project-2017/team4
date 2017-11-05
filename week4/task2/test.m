[nrows, ncols] = size(c);
c_tmp = reshape(c, nrows*ncols,1);
ncluster = 10; maxIter = 1000; numReplicates = 10;
[clus_idx, clus_center] = kmeans(c_tmp, ncluster, 'MaxIter', maxIter,...
    'distance', 'sqEuclidean', 'Replicates', numReplicates);
pixelLabs = reshape(clus_idx, nrows, ncols);
figure, imshow(pixelLabs, []); title('Coor by cluster');
colorbar;
clustPixels_mean = zeros(ncluster,1);
recMeanImg = zeros(size(c_tmp));
for i = 1:ncluster
  clustPixels_mean(i) = mean(c_tmp(clus_idx == i));
  fprintf('Mean of pixels in cluster %d: %.4f\n', i, clustPixels_mean(i));
 
  % Rec image
  recMeanImg = c_tmp;
  recMeanImg(clus_idx == i) = clustPixels_mean(i);
end
recImg = reshape(recMeanImg, nrows, ncols);
figure, imshow(recImg, []);

% Thresholding
maxCorrMean = 0.10;
thrImg = recImg;
thrImg(thrImg < maxCorrMean) = 1;
thrImg(thrImg~=1) = 0;
thrImg = logical(thrImg);
str = sprintf('Thresholded with thr.: %.2f', maxCorrMean);
figure, imshow(thrImg,[]); title(str);

% Plot centroids
CC_out = bwconncomp(thrImg);
props_out = regionprops(CC_out, 'Centroid');
allCentroids = [props_out.Centroid];
xCentroids = allCentroids(1:2:end);
yCentroids = allCentroids(2:2:end);
hold on;
plot(xCentroids,yCentroids,'r+','MarkerSize', 12, 'LineWidth', 5);
title('centroids');

%% TO BE REFINED (only keep CC that are included in the BB)

% Only keep those CC that include the centroids computed above.
CC_mask = bwconncomp(iMask);
CC_props = regionprops(CC_mask, 'Area', 'BoundingBox', 'Centroid');
outIdx = [];
for i = 1:size(CC_props,1)
    topLeftX = CC_props(i).BoundingBox(1);
    topLeftY = CC_props(i).BoundingBox(2);
    width = CC_props(i).BoundingBox(3);
    height = CC_props(i).BoundingBox(4);
    for j = 1:length(xCentroids)
       % See if region 'i' includes centroid 'j'. If so, consider it as signal
       % To do so, list of kept indices .
       if ((xCentroids(j) >= topLeftX && xCentroids(j) <= topLeftX + width) &&...
               (yCentroids(j) >= topLeftY && yCentroids(j) <= topLeftY + height))
           % Keep it
           outIdx = [outIdx; i];
           
       end
       
       % REMEMBER TO DO A UNIQUE() TO AVOID REPETITIONS OF INDICES IN
       % OUTIDX
    end
end
outIdx = unique(outIdx);