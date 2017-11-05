function out = is_octave ()
  % Checks if it is running on Octave (if not is supposed to be Matlab)
  % Returns true when running on Octave, 0 otherwise.
  out = exist('OCTAVE_VERSION', 'builtin') ~= 0;
end