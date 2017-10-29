function y = sliding_window(im)
  win_w = 50;
  win_h = 50;
  step = 5;
  
  [rows, cols] = size(im)
  areas = []
  for row = 1:step:(rows-win_w)
    for col = 1:step:(cols-win_h)
      if sum(sum(im(row:(row+win_w), col:(col+win_h))))>2000
        areas = [areas; [col,row,win_h,win_w]];
      end
    end
  end
  y = areas;
end