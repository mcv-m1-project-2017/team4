function partition(path, frequencies, train_path, validation_path)

  file_list = dir(strcat(path, '/gt/*.txt'));
  sign_list = [];
    
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
  freq_in_validation = round(frequencies * (.3 * total_num_signs) );
  
  category = 'A';
  for i = 1:size(freq_in_validation)
    category_list = sign_list(sign_list(:,1) == hex2dec(category), :);
    category_list(:,1) = [];

    if ~isempty(validation_split)
        [repeated_images, a, b] = intersect(validation_split, category_list, 'rows');
        category_list = setdiff(category_list,repeated_images,'rows');
    else
        repeated_images = [];
    end

    rows = randperm(length(category_list), freq_in_validation(i) - length(repeated_images));
    
    validation_split = [validation_split; category_list(rows,:)];
       
    category = char(category + 1);
  end

  sign_list(:,1) = [];
  train_split = setdiff(unique(sign_list, 'rows'), validation_split,'rows');
    
  if exist(train_path)
    rmdir(train_path);
  end
  if exist(validation_path)
    rmdir(validation_path);
  end
  
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
