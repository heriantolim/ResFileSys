function tf=isdateid(x)
%% Validation Method to Set the Property DateID
%  tf=FileDir.isdateid(x) returns true if x is an integer of 8 digits or a
%  string that represents the integer, OR an array containing such integers or
%  strings. False otherwise. A DateID cannot contain empty arrays or strings.
%
% Examples of a valid DateID:
%   20130304
%   [20130304,20130305]
%   {'20130304',20130305}
%   {'20130304','20130305'}
%
% Subtle examples of an invalid DateID:
%   []
%   ''
%   {'20130304',[],''}
%
% Requires package:
%  - MatCommon_v1.0.0+
%
% Tested on:
%  - MATLAB R2013b
%  - MATLAB R2015b
%
% See also: isprojectid, ispartid, iscategoryid, isfileno, iscomponentid,
% isfileext, isfilename.
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 04/03/2013
% Last modified: 04/03/2013

tf=false;
if isempty(x)
	return
elseif isintegervector(x) || isstringscalar(x)
	tf=isvalid(x);
elseif isintegernstringvector(x)
	tf=all(cellfun(@isvalid,x));
end
	
	function tf=isvalid(x)
		if isempty(x)
			tf=false;
		elseif isnumeric(x)
			tf=all(x>=10000000 & x<=99999999);
		elseif ischar(x)
			tf=~isempty(regexp(x,'^[1-9][0-9]{7}$')); %#ok<RGXP1>
		else
			tf=true;
		end
	end

end