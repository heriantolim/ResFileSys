function openproject(projectID)
%% Open Project
%  openproject() closes the current project if any, then attempts to find the
%  projectID from the pwd, then changes the working directory to the default
%  working directory, then adds the project MATLAB folder to path.
%
%  openproject(projectID) uses the input as the projectID. The project directory
%  will be created if it does not exist.
%
% Requires package:
%  - MatCommon_v1.0.0+
%
% See also: closeproject, defaultworkdir.
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 08/04/2013
% Last modified: 29/03/2018

if nargin==0
	projectID=FileDir.pathinfo;
elseif ~isstringscalar(projectID) || ~FileDir.isprojectid(projectID)
	error('ResFileSys:openproject:InvalidInput',...
		'Input to the projectID failed validation.');
end

closeproject();
Path=defaultworkdir(projectID);
if nargin==0 || exist(Path,'dir')==7 || mkdir(Path)
	cd(Path);
else
	error('ResFileSys:openproject:DirError',...
		'Unable to create the %s project directory.',projectID);
end
addpath(genpath(Path));

end