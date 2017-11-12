function [l1, l2, l3, l4] = findSquare(points1, points2)
    l1 = []; l2 = []; l3 = []; l4 = [];
    if length(points1)>3 && length(points2)>3
      dth = 40;
      sth = 30;
      for k1 = 1:length(points1)
        vert1 = abs(points1(k1,2)-points2(k1,2)) < sth;
        if vert1
          for k2 = 1:length(points1)
            hor2 = abs(points1(k2,1)-points2(k2,1)) < sth;
            if hor2
              d21 = pdist([points1(k1,:); points1(k2,:)]);
              d22 = pdist([points1(k1,:); points2(k2,:)]);
              d23 = pdist([points2(k1,:); points1(k2,:)]);
              d24 = pdist([points2(k1,:); points2(k2,:)]);
              dist2 = min([d21 d22 d23 d24]);
              if dist2 < dth
                 for k3 = 1:length(points1)

                   vert3 = abs(points1(k3,2)-points2(k3,2)) < sth;
                   if vert3 && ne(k1,k3)
                     d31 = pdist([points1(k2,:); points1(k3,:)]);
                     d32 = pdist([points1(k2,:); points2(k3,:)]);
                     d33 = pdist([points2(k2,:); points1(k3,:)]);
                     d34 = pdist([points2(k2,:); points2(k3,:)]);
                     dist3 = min([d31 d32 d33 d34]);
                     if dist3 < dth
                       for k4 = 1:length(points1)

                        hor4 = abs(points1(k4,1)-points2(k4,1)) < sth;
                        if hor4 && ne(k1,k4)
                          d41 = pdist([points1(k3,:); points1(k4,:)]);
                          d42 = pdist([points1(k3,:); points2(k4,:)]);
                          d43 = pdist([points2(k3,:); points1(k4,:)]);
                          d44 = pdist([points2(k3,:); points2(k4,:)]);
                          dist4 = min([d41 d42 d43 d44]);

                          if dist4 < dth
                            l1 = [points1(k1,:); points2(k1,:)];
                            l2 = [points1(k2,:); points2(k2,:)];
                            l3 = [points1(k3,:); points2(k3,:)];
                            l4 = [points1(k4,:); points2(k4,:)];
                          end
                        end

                       end
                     end

                 end
                 end
              end
            end

          end
        end

      end
    end
%{
    l1 = []; l2 = []; l3 = []; l4 = [];
    if length(points1)>3 && length(points2)>3
      dth = 15;
      for k1 = 1:length(points1)
        for k2 = 1:length(points1)
          dist1 = pdist([points2(k1,:); points1(k2,:)],'euclidean');
          if (k1 ~= k2) && (dist1 < dth)
            for k3 = 1:length(points2)
              dist2 = pdist([points2(k2,:); points2(k3,:)],'euclidean');
              if (k2 ~= k3) && (dist2 < dth)
                for k4 = 1:length(points1)
                  dist3 = pdist([points1(k3,:); points2(k4,:)],'euclidean');
                  if (k3 ~= k4) && (dist3 < dth)
                    dist4 = pdist([points1(k4,:); points1(k1,:)], 'euclidean');
                    if dist4 < dth
                      %if pdist([points2(k2,:); points2(k1,:)]) > 30
                        l1 = [points1(k1,:); points2(k1,:)];
                        l2 = [points2(k1,:); points2(k2,:)];
                        l3 = [points1(k3,:); points2(k2,:)];
                        l4 = [points1(k3,:); points1(k1,:)];
                      %end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  %}
end
