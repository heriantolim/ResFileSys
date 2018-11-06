function tf=isfileno(x)
%% Validation Method to Set the Property FileNO
%  tf=FileDir.isfileno(x) returns true if x is an integer (0<FileNO<10000000) or
%  a string that represents the integer, OR an array containing such integers or
%  strings. False otherwise. A FileNO may be empty.
%
% Examples of a valid FileNO:
%   []
%   ''
%   [1,2,3]
%   {1,'2',[],'',3}
%
% Subtle examples of an invalid FileNO:
%   {1,2,{}}
%
% Requires package:
%  - MatCommon_v1.0.0+
%
% Tested on:
%  - MATLAB R2013b
%  - MATLAB R2015b
%
% See also: isprojectid, ispartid, iscategoryid, isdateid, iscomponentid,
% isfileext, isfilename.
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 04/03/2013
% Last modified: 04/03/2013

if isemptynumber(x)
	tf=true;
elseif isintegervector(x) || isstringscalar(x)
	tf=isvalid(x);
elseif isintegernstringvector(x)
	tf=all(cellfun(@isvalid,x));
else
	tf=false;
end

	function tf=isvalid(x)
		if isempty(x)
			tf=true;
		elseif isnumeric(x)
			tf=all(x>=0 & x<10000000);
		elseif ischar(x)
			tf=~isempty(regexp(x,'^[1-9][0-9]{0,6}$')); %#ok<RGXP1>
		else
			tf=false;
		end
	end

end