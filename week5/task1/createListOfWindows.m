function [listBBs] = createListOfWindows(CC_stats)
listBBs = struct([]);
for cc = 1:size(CC_stats,1)
    % DO NOT CONVERT TO UINT32! IT RETURNS FN/FP WHEN THE OVERLAP WOULD BE
    % GREATER THAN > 0.5 DUE TO DIFFERENT TYPES (DOUBLE VS UINT32)
%     listBBs(cc).x = uint32(CC_stats(cc).BoundingBox(1));
%     listBBs(cc).y = uint32(CC_stats(cc).BoundingBox(2));
%     listBBs(cc).w = uint32(CC_stats(cc).BoundingBox(3));
%     listBBs(cc).h = uint32(CC_stats(cc).BoundingBox(4));

    listBBs(cc).x = CC_stats(cc).BoundingBox(1);
    listBBs(cc).y = CC_stats(cc).BoundingBox(2);
    listBBs(cc).w = CC_stats(cc).BoundingBox(3);
    listBBs(cc).h = CC_stats(cc).BoundingBox(4);

end
% Transpose struct (size(CC_stats,1) x 1 struct)
listBBs = listBBs';