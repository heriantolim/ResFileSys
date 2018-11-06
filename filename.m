function Path=filename(varargin)
%% Full Path
%  Takes inputs of any valid file information or file names, then returns the
%  names of those files.
%
% Requires package:
%  - MatCommon_v1.0.0+
%
% Tested on:
%  - MATLAB R2013b
%  - MATLAB R2015b
%
% See also: dirpath, fullpath.
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 12/04/2013
% Last modified: 12/04/2013

F=FileDir(varargin{:});
Path=F.FileName;

end
