function [ positions ] = extractLocalMinima(image)
% Extract Local Minima: Finds where is the minimal values inside a grayscale image.
%
%{
Jonatan Poveda
Martí Cobos
Juan Francesc Serracant
Ferran Pérez
Master in Computer Vision
Computer Vision Center, Barcelona
---------------------------
Project M1/Week4
---------------------------
input:  - image: nxm matrix of floats in the range of [0,1]
output: - positions: nx2 matrix of integers where the first column is the y-pos
                    and the second is x-pos
%}
  threshold = 1;  % threshold for a unitary range
  se = strel('disk',3);

  im = imbothat(image, se);
  im = im ./ max(im(:));
  [posy, posx] = find(im == threshold);

  positions = [posx, posy];
end % function
