function [ se ] = jon_se( type, size )
  switch type
    case 'vertical_vector'
      se = ones(size(1),1);
    case 'horizontal_vector'
      se = ones(1,size(1));
    case 'rect'
      se = ones(size(1), size(2));
    case 'cross'
      if mod(size(1),2) == 0 || mod(size(2),2)==0
        error('Size should be odd')
      end
      se = zeros(size(1), size(2));
      sv = ceil(size(1)/2);
      sh = ceil(size(2)/2);
      se(:,sh) = ones(size(1), 1);
      se(sv,:) = ones(size(2), 1);
    case 'circular'
      se = strel('disk', size(1), 0).getnhood();
    otherwise
      se = 0;
  end