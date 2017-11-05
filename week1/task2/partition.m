% function partition
% 	path to original training set
%	frequencies an array of order frequencies from 0 to 1 for each sign type
%	train_path path to store train split. Directory will be deleted and created again
%	validation_path path to store validation split. Directory will be deleted and created again
function partition(path, frequencies, train_path, validation_path)

  % get all gt files
  file_list = dir(strcat(path, '/gt/*.txt'));

  %list of all signs [category set file_number]
  % Due to the difficulty of dealing with arrays of strings and chars
  % values for category, set and file_number are converted to integer
  %
  % For a file named gt.01.000935.txt with two signs of types A and B
  % we would have rows like (category as hex)
  %
  %   [10 1 935; 11 1 935]
  sign_list = [];
    
  % read and parse every gt file
  for i = 1:size(file_list)
    file_name = strcat(path, '/gt/', file_list(i).name);
	  
    fid = fopen(file_name);
    numset = str2num(file_list(i).name(4:5));
    numfile = str2num(file_list(i).name(7:12));
    line = fgetl(fid);
    while ischar(line)
	    file_category = hex2dec(line(end));
	    sign_list = [sign_list; [file_category numset numfile]];
      line = fgetl(fid);
    end
    fclose(fid);
  end
  
  total_num_signs = length(sign_list);
  
  validation_split = [];

  % calculate the actual number of sign to be take for every category
  % to keep frequency in the 30% validation split
  freq_in_validation = round(frequencies * (.3 * total_num_signs) );
  
  % for each category ...
  category = 'A';
  for i = 1:size(freq_in_validation)

    % get only the signs of the curernt category
    category_list = sign_list(sign_list(:,1) == hex2dec(category), :);

    % remove category column
    category_list(:,1) = [];

    if ~isempty(validation_split)
	% remove those gt file of current category that are already in the validation set
        [repeated_images, a, b] = intersect(validation_split, category_list, 'rows');
        category_list = setdiff(category_list,repeated_images,'rows');
    else
        repeated_images = [];
    end

    % randomly choose signs. Get less signs if we already got signs of this category
    % while processing previous categories (due to multi-sign gt files)
    rows = randperm(length(category_list), freq_in_validation(i) - length(repeated_images));
    
    % append to chosen rows to validation split
    validation_split = [validation_split; category_list(rows,:)];
       
    % next category
    category = char(category + 1);
  end

  % remove category column in sign list
  sign_list(:,1) = [];

  % train_split = sign_list - validation_split
  train_split = setdiff(unique(sign_list, 'rows'), validation_split,'rows');
    
  % remove directories if needed
  if exist(train_path)
    rmdir(train_path);
  end
  if exist(validation_path)
    rmdir(validation_path);
  end
  
  % create train and validation directories and copy files
  mkdir(train_path);
  train_path_gt = strcat(train_path, '/gt');
  mkdir(train_path_gt);
  train_path_mask = strcat(train_path, '/mask');
  mkdir(train_path_mask);
  
  for i = 1:size(train_split)
    name = strcat( sprintf('%02d',train_split(i,1)), '.', sprintf('%06d',train_split(i,2)));
    strcat(path, '/', strcat(name,'.jpg'));
    copyfile( strcat(path, '/', strcat(name,'.jpg')), strcat(train_path, '/', strcat(name, '.jpg') ) );
    copyfile( strcat(path, '/gt/', strcat('gt.',name,'.txt')), strcat(train_path, '/gt/', strcat('gt.', name, '.txt') ) );
    copyfile( strcat(path, '/mask/', strcat('mask.',name,'.png')), strcat(train_path, '/mask/', strcat('mask.', name, '.png') ) );
  end
  
  mkdir(validation_path);
  mkdir(strcat(validation_path, '/gt'));
  mkdir(strcat(validation_path, '/mask'));

  for i = 1:size(validation_split)
    name = strcat( sprintf('%02d',validation_split(i,1)), '.', sprintf('%06d',validation_split(i,2)));
    strcat(path, '/', strcat(name,'.jpg'));
    copyfile( strcat(path, '/', strcat(name,'.jpg')), strcat(validation_path, '/', strcat(name, '.jpg') ) );
    copyfile( strcat(path, '/gt/', strcat('gt.',name,'.txt')), strcat(validation_path, '/gt/', strcat('gt.', name, '.txt') ) );
    copyfile( strcat(path, '/mask/', strcat('mask.',name,'.png')), strcat(validation_path, '/mask/', strcat('mask.', name, '.png') ) );
  end
  
end
