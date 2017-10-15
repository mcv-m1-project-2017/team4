function [ mask ] = enmask (probabilites, thresholds, n)
%{
Jonatan Poveda
Martí Cobos
Juan Francesc Serracant
Ferran Pérez
Master in Computer Vision
Computer Vision Center, Barcelona
---------------------------
Project M1/Block2
---------------------------
This function is used to find a mask given a matrix of probabilites and thresholds
input:  - probabilites: nxmx3 array representing pixel probabilites of belonging to 3 classes
        - thresholds: 1x3 threshold
        - n: which mask to be computed. If 0 compute them all
output: - mask: nxm array representing image mask
---------------------------
%}

  if n == 0
    mask_1 = probabilites(:,:,1) > thresholds(1);
    mask_2 = probabilites(:,:,2) > thresholds(2);
    mask_3 = probabilites(:,:,3) > thresholds(3);
    mask = mask_1 | mask_2 | mask_3;
  
  elseif n < 4
    mask = probabilites(:,:,n) > thresholds(n);
   
  else
    error('n should be an integer from 0 to 3')
  end
    
end
