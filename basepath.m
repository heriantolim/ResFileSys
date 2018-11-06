function Path=basepath
%% Base Path
%  Returns the path to the project folder.
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 08/04/2013
% Last modified: 08/04/2013

if isunix
	Path=fullfile(filesep,'home','hlim');
elseif ismac
	Path=fullfile(filesep,'Users','Herianto');
elseif ispc
	Path=fullfile('C:','Users','Herianto');
else
	error('ResFileSys:basepath:UnsupportedPlatform',...
		'Platform not supported.');
end

Path=fullfile(Path,'Schools','University of Melbourne','Research','Projects');

end