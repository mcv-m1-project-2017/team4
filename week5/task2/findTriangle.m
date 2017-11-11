function [l1, l2, l3] = findTriangle(points1, points2)
        l1 = []; l2 = []; l3 = [];
        if length(points1)>2 && length(points2)>2
            dth = 15;
            for k1 = 1:length(points1)
                for k2 = 1:length(points2)
                    dist1 = pdist([points1(k1,:); points2(k2,:)],'euclidean');
                    if dist1 < dth
                        for k3 = 1:length(points1)
                            dist2 = pdist([points1(k2,:); points1(k3,:)],'euclidean');
                            if (dist2 > 0) && (dist2 < dth)
                                dist3 = pdist([points2(k3,:); points2(k1,:)],'euclidean');
                                if dist3 < dth
                                    l1 = [points1(k1,:); points2(k1,:)];
                                    l2 = [points1(k2,:); points1(k1,:)];
                                    l3 = [points1(k2,:); points2(k1,:)];
                                end
                            end
                        end
                    end
                end
            end
        end
end