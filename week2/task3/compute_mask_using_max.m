function [ mask ] = compute_mask_using_max (image)
  % COMPUTE MASK USING MAX: If all three colour channels are similar than feature of a class, mark 
  %  that pixel belonging to that class.
  mask = zeros(size(image(:,:,1)));
  
  threshold_2 = 30;
  threshold = 100;
  r_center = 120;
  g_center = 120;
  b_center = 120;
  red_mask = (image(:,:,1) > r_center - threshold) & ...
             (image(:,:,1) < r_center + threshold) & ...
             (image(:,:,2) < threshold_2) & ...
             (image(:,:,3) < threshold_2);
  green_mask =  mask; %(image(:,:,2) > g_center - threshold) & ...
               %(image(:,:,2) < g_center + threshold) & ...
               %(image(:,:,1) < threshold_2) & ...
               %(image(:,:,3) < threshold_2);
  blue_mask = (image(:,:,3) > b_center - threshold) & ...
              (image(:,:,3) < b_center + threshold) & ...
              (image(:,:,1) < threshold_2) & ...
             (image(:,:,2) < threshold_2);
  mask |= red_mask | green_mask | blue_mask;
end