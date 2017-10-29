function [ class ] = checkRegion( region, geometricFeatures, params )
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
This function is used to classify an input ROI.
input:  - ROIMask: input mask to analyze if there is a signal
output: - class: Signal classified in one of the 6 signal groups
(A,B,C,D,E,F) or no detection (X)
---------------------------
%}

% %Dummy code to develope multiscalewindowing
%   regionSize = sum(region(:));
%
%   if ((regionSize > 1000) && (regionSize < 50000))
%       class = 'A';
%   else
%       class = 'X';
%   end

[CC, CC_stats] = computeCC_regionProps(region);
[~, ~, isSignal] = applyGeometricalConstraints(region, CC, CC_stats, geometricFeatures, params);
isSignal

if isSignal
  class = 'A';
else
  class = 'X';

end
