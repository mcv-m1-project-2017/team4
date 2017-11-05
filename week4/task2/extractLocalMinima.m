function [ positions ] = extractLocalMinima(image)
  se = strel('disk',3);
  threshold = 0.9;  % threshold for a unitary range.
  im = imbothat(image, se);
  im = im ./ max(im(:));
  [posy, posx] = find(im >= threshold); % extract maxima (should that threshold be more relaxed?)
  positions = [posx, posy]; % two-columns (y-pos, x-pos)
end % function
