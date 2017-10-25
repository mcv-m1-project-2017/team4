function [CC, regionProps] = computeCC_regionProps(mask)
% COMPUTEREGIONPROPS Computes the properties of the Connected Components in
% 'mask' (by default only 'area' and 'BoundingBox'). 
% This structure of properties can be then inputted to 
% 'applyGeometricalConstraints.m' to obtain a 'constrained' mask.

CC = bwconncomp(mask);
regionProps = regionprops(CC, 'Area', 'BoundingBox');
end