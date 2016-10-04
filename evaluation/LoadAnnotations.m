function [annotations Signs] = LoadAnnotations(file)
    % LoadAnnotations
    % Load text annotations files for the M1 project
    %
    %   [annotations Signs] = LoadAnnotations(file)
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'file'              Annotations file
    %
    %  Each line in the annotation file contains  the coordinates of the top-left corner, the width and height of the window, plus the object type:
    %  248.850000 275.260000 289.720000 315.170000 D7
    %
    % The function returns a vector of windows (annotations) and a vector of object types (Signs)
    
    annotations = [];
    fid = fopen(file, 'r');
    BBs=[]; Signs=[];
    tline = fgetl(fid);
    while ischar(tline)
        [A,c,e,ni]=sscanf(tline,'%f %f %f %f',4);
        annotations = [annotations ; struct('x', A(2), 'y', A(1), 'w', A(4)-A(2), 'h', A(3)-A(1))];
        Signs=[Signs {tline(ni+1:end)}];
        tline = fgetl(fid);
    end
    fclose(fid);
end
