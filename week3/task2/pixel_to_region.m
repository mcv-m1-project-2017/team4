function [ region ] = pixel_to_region (pixel, window)
  w = size(window,1)-1;
  h = size(window,2)-1;
  x = pixel(1)-0.5*w;
  y = pixel(2)-0.5*h;
  region = [x,y,w,h];
end
