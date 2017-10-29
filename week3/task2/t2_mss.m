% function [ output ] = multiscaleSearch( image )
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
This function is used to do a multi-scale search over a given binary image and
select candidates which corresponds to a probable traffic signs.
input:  - image: nxm binary image
output: - list of regions: 5xm matrix of susceptible regions to contain a
          traffic sign and its type (A,B,C,D,E or F) or no detection (X).
          Each row is a region formatted as [x, y, w, h, type]
---------------------------
%}
% end
