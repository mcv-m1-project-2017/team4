function [ mask ] = compute_mask_using_gaussian (image, features, threshold)
  % COMPUTE MASK USING GAUSSIAN: Compute a mask of a given image using features
  %   which contains a value and a sigma. If a pixel in inside the area of the
  %   given value and 'threshold'-number of sigmas, mark that pixel belonging 
  %   to that class.
  mask = zeros(size(image(:,:,1)));
  
  % Iterate over all classes (equal to the number of features)
  for class=1:size(features, 2)
%    threshold = 25;
%    red_mask = (image(:,:,1) > features(class).r - threshold) & ...
%               (image(:,:,1) < features(class).r + threshold);
%    green_mask = (image(:,:,2) > features(class).g - threshold) & ...
%                 (image(:,:,2) < features(class).g + threshold);
%    blue_mask = (image(:,:,3) > features(class).b - threshold) & ...
%                (image(:,:,3) < features(class).b + threshold);
%    mask |= red_mask & green_mask & blue_mask;
  end
end