function [ pixel_range ] = getAreaFromPixel( startingPixel, originalAreaSize, scale )
  area = originalAreaSize * scale;
  start = (startingPixel - [1,1]) * scale;
  pixel_range = start:area;
end
