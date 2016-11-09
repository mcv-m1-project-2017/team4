
function out = label2color(P1,lut)


if nargin == 1
   lut=round(rand (256,3)*255);
end;


out = zeros([size(P1) 3]);

num_labels=max(max(P1));

for i=0:num_labels

    [x y] = find(P1 == i); 
    for j=1:length(x)
        out(x(j),y(j),:)=lut(P1(x(j),y(j)),:);
    end
end

out = uint8(out);