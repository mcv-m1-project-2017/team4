function [ region ] = getRegion( mask, pixel, win )
  center = ((size(win,1)-1)/2);
  range = [pixel(1)-center, pixel(1)+center, pixel(2)-center, pixel(2)+center];
  try
    region = mask(range(1):range(2), range(3):range(4)).*win;
  catch
    region = false;
  end
end
