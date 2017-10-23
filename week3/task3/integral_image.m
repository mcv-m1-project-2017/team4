function ii = integral_image(image)
  ii = cumsum(cumsum(double(image)),2);
end