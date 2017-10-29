function [ pixel_range ] = getAreaFromPixel( start, stop, scale )
%{
Jonatan Poveda
Martí Cobos
Juan Francesc Serracant
Ferran Pérez
Master in Computer Vision
Computer Vision Center, Barcelona
---------------------------
Project M1/Week3
---------------------------
Given an starting and ending point, namely left-upper-most and right-down-most
indices of a matrix, and, an scale factor, it returns a new range that would
fit in a matrix that is scaled using the same factor.
input:  - start: nx2 integers > 1
        - stop:  nx2 integers > 1
        - scale: scale factor
output: - pixel_range: starting and stopping indices of a matrix
---------------------------
%}
  area = (stop - start) * scale;
  start = (start - [1,1]) * scale;
  pixel_range = [start; start+area] + [1,1];
end
