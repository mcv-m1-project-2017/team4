function [outputMask] = computeResultingMask(positions, inputMask)
[CC, CC_props] = computeCC_regionProps(inputMask);
idx_out = [];
for i = 1:size(CC_props,1)
    if(ismember(positions, CC_props(i).PixelList, 'rows'))
        idx_out = [idx_out;i];     
    end  
end
outputMask = ismember(labelmatrix(CC), idx_out);
end