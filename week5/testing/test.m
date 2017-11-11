addpath(genpath('.'));

do_plots = true


% image = imread('line.png');
% image = imread('point.png');
image = imread('cross.png');
image = imread('triangle.png');

if size(image,3) == 3
  imageGreyscale = rgb2gray(image);
elseif size(image, 3) == 1
  imageGreyscale = image;
else
  error('The image should have 1 or 3 channels')
end

im = logical(imageGreyscale);
% imageEdges = edge(im,'Canny');
% im = imageEdges;
[H, THETA, RHO] = hough(im);

if do_plots
  figure(1);
  subplot(1,2,1);
  imshow(imageGreyscale,[]);
  title('original')
  axis square

  subplot(1,2,2);
  RI = imref2d(size(H));
  RI.XWorldLimits = [ THETA(1) THETA(end)];
  RI.YWorldLimits = [ RHO(1) RHO(end) ];
  imshow(H,RI, []);
  title('hough space')
  axis square

  % subplot(2,2,3);
  % imshow(imageEdges,[]);
  % title('edges')
  % axis square
end % if do_plots
