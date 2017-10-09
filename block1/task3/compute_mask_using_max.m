function [ mask ] = compute_mask_using_max (image, features, threshold)
  % COMPUTE MASK USING MAX: If all three colour channels are similar than feature of a class, mark 
  %  that pixel belonging to that class.
  mask = zeros(size(image(:,:,1)));
  
  % Iterate over all classes (equal to the number of features)
  for class=1:size(features, 2)
    threshold = 25;
    red_mask = (image(:,:,1) > features(class).r - threshold) & ...
               (image(:,:,1) < features(class).r + threshold);
    green_mask = (image(:,:,2) > features(class).g - threshold) & ...
                 (image(:,:,2) < features(class).g + threshold);
    blue_mask = (image(:,:,3) > features(class).b - threshold) & ...
                (image(:,:,3) < features(class).b + threshold);
    mask = mask | (red_mask & green_mask & blue_mask);
  end
end
