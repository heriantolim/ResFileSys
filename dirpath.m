function Path=dirpath(varargin)
%% Directory Path
%  Takes inputs of any valid file information or file names, then returns the
%  path to the folder where those files reside.
%
% Requires package:
%  - MatCommon_v1.0.0+
%
% Tested on:
%  - MATLAB R2013b
%  - MATLAB R2015b
%
% See also: filename, fullpath.
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 06/03/2013
% Last modified: 06/03/2013

F=FileDir(varargin{:});
Path=F.DirPath;

end
