function tf=isfilename(x)
%% Determine if Input is a Valid File Name
%  tf=FileDir.isfilename(x) returns true if x is a string scalar or vector with
%  some formats, for example: PC_20130313
%
%  P can be any uppercase letter corresponding to the PartID.
%
%  C can be any uppercase letter corresponding to the CategoryID.
%
%  20130313 can be any 8 digits number or string corresponding to DateID.
%
%  The three components mentioned above are mandatory. They specify the location
%  of the folder where the file is located. A filename may have an extended form
%  such as: PC_20130313_1_comp1_comp2.txt
%
%  The number 1 represents a FileNO for enumeration of the file in the same
%  folder.
%
%  comp1 represents the first element of the ComponentID
%  comp2 represents the second element of the ComponentID
%  ComponentID is used to indicate the different files that correspond to
%  the same entity.
%
%  .txt is the FileExt
%
% Requires package:
%  - MatCommon_v1.0.0+
%
% Tested on:
%  - MATLAB R2013b
%  - MATLAB R2015b
%
% See also: isprojectid, ispartid, iscategoryid, isdateid, isfileno,
% iscomponentid, isfileext.
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 03/03/2013
% Last modified: 03/03/2013

tf=false;
if ~isstringscalar(x) && ~isstringvector(x),...
	return
elseif isstringscalar(x)
	x={x};
end

x=strtrim(x);
x=FileDir.strsplit(x,'\.');
M=length(x);
for i=1:M
	% if there is more than one dot in the filename, return.
	N=length(x{i});
	if N>2
		return
	elseif N==2 && ~FileDir.isfileext(strcat('.',x{i}{2}))
		% if file extension is invalid, return.
		return
	end

	filePart=FileDir.strsplit(x{i}{1},'_');
	N=length(filePart);

	% if there is no dash in the filename, return.
	if N<2
		return
	end

	% if the first split string contains not two letters, return.
	if length(filePart{1})~=2
		return
	end

	% if the first split string is not a PartID CategoryID, return.
	if ~FileDir.ispartid(filePart{1}(1)) || ~FileDir.iscategoryid(x{i}{1}(2))
		return
	end

	% if the second split string is not a DateID, return.
	if ~FileDir.isdateid(filePart{2})
		return
	end

	if N>2
		% check if the third split string is a FileNO, and set a counter.
		if FileDir.isfileno(filePart{3})
			j=4;
		else
			j=3;
		end
		if N>=j && ~FileDir.iscomponentid(filePart(j:N))
			% if the rest of the split string is not a ComponentID, return.
			return
		end
	end
end

tf=true;

end
