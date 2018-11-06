function tf=iscomponentid(x)
%% Validation Method to Set the Property ComponentID
%  tf=FileDir.iscomponentid(x) returns true if x is a cell array containing
%  strings [a-zA-Z0-9], OR a cell array containing such cell arrays. False
%  otherwise. A ComponentID may be empty.
%
% Examples of a valid ComponentID:
%   []
%   ''
%   123
%   'asdf'
%   {[]}
%   {''}
%   {'',[],''}
%   {'asdf','123','zxcv'}
%   {{'asdf'}}
%   {{'asdf','zxcv'},{123},{'jlkl',456,'zxcv'}}
%   {{123,'zxcv'},'',{'jlkl','asdf','zxcv'},[],''}
%
% Subtle examples of an invalid ComponentID:
%   {'','asdf'}
%   {{'asdf','zxcv'},'',{'jlkl','asdf',123},'asdf',''}
%
% Requires package:
%  - MatCommon_v1.0.0+
%
% Tested on:
%  - MATLAB R2013b
%  - MATLAB R2015b
%
% See also: isprojectid, ispartid, iscategoryid, isdateid, isfileno, isfileext,
% isfilename.
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 04/03/2013
% Last modified: 25/03/2018

if FileDir.isemptylist(x)
	tf=true;
elseif iscell(x) && isvector(x)
	if any(cellfun(@iscell,x))
		tf=true;
		i=0;
		N=numel(x);
		while tf && i<N
			i=i+1;
			if isempty(x{i})
				tf=ischar(x{i}) || isnumeric(x{i});
			else
				tf=iscell(x{i}) && isvector(x{i}) && all(cellfun(@isvalid,x{i}));
			end
		end
	else
		tf=all(cellfun(@isvalid,x));
	end
else
	tf=isvalid(x);
end

	function tf=isvalid(x)
		if isstringscalar(x)
			tf=~isempty(regexp(x,'^[a-zA-Z0-9]+$','once'));
		else
			tf=isrealscalar(x);
		end
	end

end