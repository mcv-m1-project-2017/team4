function n = normalize(image)
  %n = (image-min(image(:)))/(max(image(:))-min(image(:)));
  n = imdivide(image, max(image(:)));
end