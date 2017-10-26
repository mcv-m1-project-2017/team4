function l = unifyOverlappingRects(rects)
  % gets a list of rects as [x y width height]
  % returns a list of rects as [x y width height] where all overlapping 
  %         rectangles in rects are merged into its common bounding box.
  %         Not that this is not recursive, so there may be overlapping
  %         rectangles on the output.
  result = [];
  
  [rows cols] = size(rects);
  while (rows > 0)
    group = rects(rectint(rects, rects(1,:))>0,:);
    
    rects = setdiff(rects, group,'rows');
    
    x1 = min( group(:,1) );
    y1 = min( group(:,2) );
    x2 = max( group(:,1) + group(:,3) );
    y2 = max( group(:,2) + group(:,4) );
    
    result = [result; x1 y1 x2-x1 y2-y1];
    [rows cols] = size(rects);
  end
  
  l = result;
end