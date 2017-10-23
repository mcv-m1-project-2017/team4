function s = rectangle_sum(integral_image, x1, y1, x2, y2)

  a = integral_image(x2, y2);
  
  if (y1 - 1) > 0
    b = integral_image(x2, y1 - 1);
  else
    b = 0;
  end
  
  if (x1 - 1) > 0
    c = integral_image(x1 - 1, y2);
  else
    c = 0;
  end
  
  if ( (x1 - 1) > 0 ) and ( (y1 - 1) > 0 ) 
    d = integral_image(x1 - 1, y1 - 1);
  else  
    d = 0;
  end
  
  s = a - b - c + d;
end