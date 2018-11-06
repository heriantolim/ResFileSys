function Path=defaultworkdir(projectID)
%% Default Working Directory
%  Path=defaultworkdir() returns the path to:
%   ...\Research\Projects\<ProjectID>\MATLAB
%  where ProjectID is determined from the pwd.
%
%  Path=defaultworkdir(projectID) uses the input as the projectID.
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
% First created: 06/03/2013
% Last modified: 06/03/2013

if nargin==0
	projectID=FileDir.pathinfo;
elseif ~isstringscalar(projectID) || ~FileDir.isprojectid(projectID)
	error('ResFileSys:defaultworkdir:InvalidInput',...
		'Input to the projectID failed validation.');
end
Path=fullfile(basepath,projectID,'MATLAB');

end