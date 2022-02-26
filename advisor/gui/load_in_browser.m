function load_in_browser(docfile, varargin)
%LOAD_IN_BROWSER Browse the local html file in a browser
%   docfile is the name of the document file to launch
%   anchor is the optional in-file anchor ('#introduction')
path = strrep(which(docfile), '\', '/');
if nargin == 2
    str = ['file:///', path, varargin{1}];
    web(str, '-browser');
else
    str = ['file:///', path];
    web(str, '-browser');
end
end

