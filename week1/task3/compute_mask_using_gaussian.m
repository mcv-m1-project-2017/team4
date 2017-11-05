function [ mask ] = compute_mask_using_gaussian (image, features, threshold)
  % COMPUTE MASK USING GAUSSIAN: Compute a mask of a given image using features
  %   which contains a value and a sigma. If a pixel in inside the area of the
  %   given value and 'threshold'-number of sigmas, mark that pixel belonging 
  %   to that class.
  mask = zeros(size(image(:,:,1)));
  
  % Iterate over all classes (equal to the number of features)
  for class=1:size(features, 2)
    feature = features(class).r;
    mu = feature(1);  sigma = sqrt(feature(2));
    red_mask = (image(:,:,1) > (mu - threshold*sigma)) & ...
               (image(:,:,1) < (mu + threshold*sigma));
           
    feature = features(class).g;
    mu = feature(1); sigma = sqrt(feature(2));
    green_mask = (image(:,:,2) > (mu - threshold*sigma)) & ...
                 (image(:,:,2) < (mu + threshold*sigma));
    
    feature = features(class).b;
    mu = feature(1); sigma = sqrt(feature(2));
    blue_mask = (image(:,:,3) > (mu - threshold*sigma)) & ...
                (image(:,:,3) < (mu + threshold*sigma));
    mask = mask | (red_mask & green_mask & blue_mask);
  end
end
