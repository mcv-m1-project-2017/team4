function [ mask ] = updateMask (mask, pixel, window)
% Cancelling Mask algorithm (given MASK,PIXEL CANDIDATE,WINDOW)
%  1. Build a matrix of ones with the same size as the current LAYER => MASK
%  2. Insert the (negated) WINDOW centered in the pixel candidate of this MASK => MASK
%  3. Return MASK
  center = ((size(window,1)-1)/2);
  starting = pixel - center;
  ending = pixel + center;
  mask(starting(1):ending(1), starting(2):ending(2)) = ~window;
end
