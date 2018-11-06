function tf=isprojectid(x)
%% Validation Method to Set the Property ProjectID
%  tf=FileDir.isprojectid(x) returns true if x is a word string [a-zA-Z_0-9]
%  consisting of at least 3 chars, OR a cell array containing such strings.
%  False otherwise. A ProjectID cannot contain empty strings.
%
% Examples of a valid ProjectID:
%   'as_df'
%   {'as_df','qwe_rty'}
%
% Subtle examples of an invalid ProjectID:
%   ''
%   {''}
%   {'asdf',''}
%
% Requires package:
%  - MatCommon_v1.0.0+
%
% Tested on:
%  - MATLAB R2013b
%  - MATLAB R2015b
%
% See also: ispartid, iscategoryid, isdateid, isfileno, iscomponentid,
% isfileext, isfilename.
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 05/03/2013
% Last modified: 05/03/2013

tf=false;
if isempty(x)
	return
elseif isstringscalar(x)
	tf=isvalid(x);
elseif isstringvector(x)
	tf=all(cellfun(@isvalid,x));
end

	function tf=isvalid(x)
		tf=~isempty(regexp(x,'^\.?\w{3,}$')); %#ok<RGXP1>
	end

end