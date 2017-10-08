function [ data ] = reconstruct_data ( histogram, bins)
    % Reconstruct data from an histogram (it is an unsorted estimation)
    ntimes = round(histogram * 1e3);
    data = [];
    for j = 1:length(ntimes)
        for k = 1:ntimes(j)
            data = [data bins(j)];
        end
    end
end
