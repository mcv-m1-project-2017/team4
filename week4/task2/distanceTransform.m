function [ M ] = distanceTransform( m )
% distance transform: Computes the Distance Transform of a given matrix
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
input:  - m: nxm binary-valued matrix
output: - M: nxm integer-valued matrix
%}
  M = bwdist(m, 'chessboard');
  % M = bwdist(m, 'euclidean');
  % M = bwdist(m, 'cityblock');
  % M = bwdist(m, 'quasi-euclidean');
end
