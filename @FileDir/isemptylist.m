function tf=isemptylist(x)
%% Is List Empty?
%  tf=FileDir.isemptylist(x) returns true if x is an empty char or number, OR a
%  cell (or nested cell) containing empty chars and/or numbers.
%
% Tested on:
%  - MATLAB R2013b
%  - MATLAB R2015b
%
% See also: collapselist, expandlist.
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 05/03/2013
% Last modified: 25/03/2018

if isempty(x)
	tf=ischar(x) || isnumeric(x);
elseif iscell(x)
	tf=all(cellfun(@FileDir.isemptylist,x(:)));
else
	tf=false;
end

end