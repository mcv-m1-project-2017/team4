function [listBBs] = createListOfWindows(CC_stats)
listBBs = struct([]);
for cc = 1:size(CC_stats,1)
    listBBs(cc).x = uint32(CC_stats(cc).BoundingBox(1));
    listBBs(cc).y = uint32(CC_stats(cc).BoundingBox(2));
    listBBs(cc).w = uint32(CC_stats(cc).BoundingBox(3));
    listBBs(cc).h = uint32(CC_stats(cc).BoundingBox(4));
end
% Transpose struct (size(CC_stats,1) x 1 struct)
listBBs = listBBs';