function angle = angleLines(points1, points2, k1, k2)     
  v1 = points2(k1,:)-points1(k1,:);
  v2 = points2(k2,:)-points1(k2,:);
  angle = abs(rad2deg( atan2( det([v1;v2]), dot(v1,v2) ) ));
end
