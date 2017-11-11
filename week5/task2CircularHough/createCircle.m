function [mask] = createCircle(imageSizeX,imageSizeY, centerX, centerY,radius )
% createCircle: create mask with circle on a given position
%
%   Input parameters
%
%       - imageSizeX:       image width
%
%       - imageSizeY:       image height
%
%       - centerX:       X coordenate of circle center 
%
%       - centerY:       X coordenate of circle center
%
%       - radius:       circle radius
%
%
%   Output parameters
%
%
%       - mask:        image with circle on defined position
%
%   AUTHORS
%   -------
%   Jonatan Poveda
%   Martí Cobos
%   Juan Francesc Serracant
%   Ferran Pérez
%   Master in Computer Vision
%   Computer Vision Center, Barcelona
%
%   Project M1/Block5
%   -----------------

[columnsInImage rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);

mask = (rowsInImage - centerY).^2 ...
    + (columnsInImage - centerX).^2 <= radius.^2;
end