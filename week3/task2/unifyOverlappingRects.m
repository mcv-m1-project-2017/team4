function l = unifyOverlappingRects(rects)
  % gets a list of rects as [x y width height]
  % returns a list of rects as [x y width height] where all overlapping 
  %         rectangles in rects are merged into its common bounding box.
  %         Not that this is not recursive, so there may be overlapping
  %         rectangles on the output.
  
  result = [];
  
  [rows cols] = size(rects);
  % while there are still rects ...
  while (rows > 0)
    % get rects that overlap with the first one on the list
    group = rects(rectint(rects, rects(1,:))>0,:);
    
    % remove those rects from the list
    rects = setdiff(rects, group,'rows');
    
    % get the outer bounding box for the overlapping rects
    x1 = min( group(:,1) );
    y1 = min( group(:,2) );
    x2 = max( group(:,1) + group(:,3) );
    y2 = max( group(:,2) + group(:,4) );
    
    % add outer bounding box to the result
    result = [result; x1 y1 x2-x1 y2-y1];
    
    [rows cols] = size(rects);
  end
  
  l = result;
end