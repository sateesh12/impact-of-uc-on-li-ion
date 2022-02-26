function path = get_adv_path(varargin)
%GET_ADV_PATH return the root or path relative to ADVISOR install directory 
%   with no arguments, returns the ADVISOR install directory path
%   with variable arguments, returns the path relative to install directory
root_path = fileparts(which('advisor'));
if nargin == 0
    path = root_path;
else
    path = fullfile(root_path, varargin{:});
end 
end