function [ class ] = map_number_to_class( number )
  class = char(number-1+uint8('A'));
end