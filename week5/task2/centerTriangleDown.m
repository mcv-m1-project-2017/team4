function [cy cx] = centerTriangleDown(image)
  do_plots = false;
  
  cy = -1; cx = -1;
  
  BW = edge(rgb2gray(image),'prewitt');
  BW = imdilate(BW,strel('square',3));
  
  [H,T,R] = hough(BW);
  %imshow(H,[],'XData',T,'YData',R,...
  %      'InitialMagnification','fit');
  %xlabel('\theta'), ylabel('\rho');
  %axis on, axis normal, hold on;

  P  = houghpeaks(H,5,'threshold',ceil(0.35*max(H(:))));
  %x = T(P(:,2)); y = R(P(:,1));
  %plot(x,y,'s','color','white');
    
  l = min(size(BW,1), size(BW,2));
  lines = houghlines(BW,T,R,P,'FillGap',.1*l,'MinLength',.5*l);
  if do_plots
    figure, imshow(BW), hold on
  end
  max_len = 0;
  points1 = []; points2 = [];
  for k = 1:length(lines)
    points1 = [points1; lines(k).point1];
    points2 = [points2; lines(k).point2];
  end
     
  for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    if do_plots
        figure, imshow(BW), hold on
    end
    max_len = 0;
    points1 = []; points2 = [];
    for k = 1:length(lines)
        isVert = abs(lines(k).point1(2)-lines(k).point2(2)) < round(l*.03);
        if ~isVert
            points1 = [points1; lines(k).point1];
            points2 = [points2; lines(k).point2];
        end
    end
         
    for k = 1:length(lines)
        xy = [lines(k).point1; lines(k).point2];
        if do_plots
            plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
            % Plot beginnings and ends of lines
            %plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
            %plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
        end
    end
  end

  [l1, l2, l3] = findTriangle(points1, points2);
  if length(l1)>0 && length(l2)>0 && length(l3)>0
    if do_plots
       plot(l1(:,1),l1(:,2),'LineWidth',2,'Color','red');
       plot(l2(:,1),l2(:,2),'LineWidth',2,'Color','red');
       plot(l3(:,1),l3(:,2),'LineWidth',2,'Color','red');
    end
    ys = [l1(1,1) l1(2,1) l2(1,1) l2(2,1) l3(1,1) l3(2,1)];
    xs = [l1(1,2) l1(2,2) l2(1,2) l2(2,2) l3(1,2) l3(2,2)];
    if length(find(xs>mean(xs))) == 2
      %cy = mean(ys);
      %cx = mean(xs);
      miny = min(ys); maxy = max(ys);
      minx = min(xs); maxx = max(xs);
      if abs(maxy-miny)>(0.5*l) && abs(minx-maxx)>(0.5*l)
        cy = miny; cx = minx; 
      end
    end
    
       
     if do_plots
       plot(cy, cx,'x','LineWidth',4,'Color','blue');
     end
  end
end
