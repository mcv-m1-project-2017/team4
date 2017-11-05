function number = map_class_to_number( class )
  number = uint8(class)-uint8('A')+1;
end