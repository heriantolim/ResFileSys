function tf=isfileext(x)
%% Validation Method to Set the Property FileExt
%  tf=FileDir.isfileext(x) returns true if x is a word string [a-zA-Z_0-9]
%  preceded by a full stop, or a cell array containing such strings. Returns
%  false otherwise.
%
% Examples of a valid FileExt:
%   ''
%   {''}
%   '.txt'
%   {'.mp3','','.ffs_db'}
%
% Requires package:
%  - MatCommon_v1.0.0+
%
% Tested on:
%  - MATLAB R2013b
%  - MATLAB R2015b
%
% See also: isprojectid, ispartid, iscategoryid, isdateid, isfileno,
% iscomponentid, isfilename.
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 04/03/2013
% Last modified: 04/03/2013

if isstringscalar(x)
	tf=isvalid(x);
elseif isstringvector(x)
	tf=all(cellfun(@isvalid,x));
else
	tf=false;
end

	function tf=isvalid(x)
		if isempty(x)
			tf=true;
		else
			tf=~isempty(regexp(x,'^\.\w+$')); %#ok<RGXP1>
		end
	end

end