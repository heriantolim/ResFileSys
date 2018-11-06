function closeproject()
%% Close Project
%  Removes any Project library from path.
%
% See also: openproject.
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 08/04/2013
% Last modified: 08/04/2013

Path=regexp(path,[regexptranslate('escape',basepath),'[^;]+;'],'match');
N=numel(Path);
for i=1:N
	rmpath(Path{i});
end

end