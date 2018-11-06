function tf=ispartid(x)
%% Validation Method to Set the Property PartID
%  tf=FileDir.ispartid(x) returns true if x is an uppercase letter or a cell
%  array containing such characters. False otherwise. A PartID cannot contain
%  empty strings. The uppercase letter must correspond to the PartID defined in
%  PartTable.
%
% Examples of a valid PartID:
%   'A'
%   {'A','B'}
%
% Subtle examples of an invalid PartID:
%   ''
%   {''}
%   {'A',''}
%
% Requires package:
%  - MatCommon_v1.0.0+
%
% Tested on:
%  - MATLAB R2013b
%  - MATLAB R2015b
%
% See also: isprojectid, iscategoryid, isdateid, isfileno, iscomponentid,
% isfileext, isfilename.
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 04/03/2013
% Last modified: 04/03/2013

tf=false;
if isempty(x)
	return
elseif isstringscalar(x)
	tf=isvalid(x);
elseif isstringvector(x)
	tf=all(cellfun(@isvalid,x));
end

	function tf=isvalid(x)
		if numel(x)==1
			tf=ismember(x,FileDir.PartTable.PartID);
		else
			tf=false;
		end
	end

end