% function [ output ] = multiscaleSearch( mask )
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
This function is used to do a multi-scale search over a given mask and 
select candidates which corresponds to a probable traffic signs.
input:  - image: nxmx3 image
        - mask: nxmx1 mask with the same size as the image
output: - list of regions susceptible to contain a traffic sign and its 
type (A,B,C,D,E,F) or no detection (X).
---------------------------
%}
% Implementation of a Multi-Scale Search
% Run w3_main.m before this one

mask = iMask;
% plot = false;
plot = true;

%   tic
box = ones(10, 10);

% Do as many reductions as the image is 4 times the box (we expect the 
% traffic sign to be as large as 0.25 the image.
pyr{1} = mask;
i = 1;
while min(size(pyr{i})) > 4*size(box,1)
%   for i = 2:6
  i = i+1;
  pyr{i} = impyramid(pyr{i-1}, 'reduce');
end

if plot
  for i = 1:size(pyr,2)
    figure(i), imshow(pyr{i});
  end
end

%% Look at all the pyr{k} images to find a traffic sign

%   output = toc;
% end

