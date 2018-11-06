function obj=addfilepart(obj,varargin)
%% Add File Parts to the FileDir Object
% Syntax:
%  There are two kinds of input parsing.
%
%  1. FULL PARSING
%     Full parsing can be executed anywhere (in the research project
%     directory). This syntax requires at least three arguments.
%
%     obj=obj.addfilepart(ProjectID,PartID,CategoryID,DateID,FileNO,
%  	   ComponentID,FileExt)
% 
%     ProjectID may be omitted, for example:
%     
%     obj=obj.addfilepart(PartID,CategoryID,DateID,FileNO,ComponentID,FileExt)
% 
%     FileNO, ComponentID, and/or FileExt may be omitted too, as in:
%
%     obj=obj.addfilepart(PartID,CategoryID,DateID,...)
%
%     where the blanks can be filled optionally with FileNO, ComponentID, or
%     FileExt in the right order, e.g. FileNO, FileExt -- NOT: FileExt, FileNO.
% 
%     ComponentID may be listed all in sequence as string scalars, as shown
%     below. However, this case treats {ComponentID1, ComponentID2,
%     ComponentID3,...} as a single ComponentID for all files.
%     
%     obj=obj.addfilepart(PartID,CategoryID,DateID,ComponentID1,
%  	   ComponentID2,ComponentID3,...,FileExt)
%
%  2. SHORT PARSING
%     Short parsing is executed only if the current working directory is in a
%     directory where information about PartID and DateID can be generated from
%     the path name. This syntax requires at least one argument.
%     
%     obj=obj.addfilepart(CategoryID,FileNO,ComponentID,FileExt)
%
%     FileNO, ComponentID, and/or FileExt may be omitted.
%     
%     obj=obj.addfilepart(CategoryID,...)
%     
%     where the blanks can be filled optionally with FileNO, ComponentID, or
%     FileExt in the right order, e.g. FileNO, FileExt -- NOT: FileExt, FileNO
%     
%     ComponentID may be listed all in sequence as string scalars, as
%     shown below. However, this case treats {ComponentID1, ComponentID2,
%     ComponentID3,...} as a single ComponentID for all files.
%
%     obj=obj.addfilepart(CategoryID,ComponentID1,ComponentID2,...
%  	   ComponentID3,...,FileExt)
%
% Requires package:
%  - MatCommon_v1.0.0+
%
% Tested on:
%  - MATLAB R2013b
%  - MATLAB R2015b
%
% See also: addfilename.
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 06/03/2013
% Last modified: 06/03/2013

%% Preprocessing
K=nargin-1;
if K==0
	return
end

[projectID,partID,~,dateID]=FileDir.pathinfo;

if K>2
	tf=true;
elseif ~isempty(partID) && ~isempty(dateID)
	tf=false;
else
	error('ResFileSys:FileDir:addfilepart:WrongNargin',...
		'More input arguments are required to do a full parsing.');
end

k=0;

%% Set ProjectID (optional for full parsing)
if tf
	% doFullParsing is still conditional
	k=k+1;
	try
		obj.ProjectID=varargin{k};
	catch ME1
		if isempty(regexpi(ME1.identifier,':InvalidInput$','once'))
			rethrow(ME1);
		else
			k=k-1;
			obj.ProjectID=projectID;
		end
	end
	
	% Check again the condition of doFullParsing
	assert(K>k+2,...
		'ResFileSys:FileDir:addfilepart:WrongNargin',...
		'More input arguments are required to do a full parsing.');
end

%% Set DateID (mandatory for full parsing)
if tf
	% doFullParsing is still conditional
	try
		obj.DateID=varargin{k+3};
	catch ME1
		if isempty(regexpi(ME1.identifier,':InvalidInput$','once'))
			rethrow(ME1);
		else
			tf=false;
		end
	end
	% after this line, doFullParsing is no longer conditional.
end

%% Set PartID (mandatory for full parsing)
if tf
	k=k+1;
	obj.PartID=varargin{k};
else
	% Set ProjectID, PartID, and DateID for short parsing
	obj.ProjectID=projectID;
	obj.PartID=partID;
	obj.DateID=dateID;
end

%% Set CategoryID (mandatory for both)
k=k+1;
try
	obj.CategoryID=varargin{k};
catch ME1
	if isempty(regexpi(ME1.identifier,':InvalidInput$','once'))
		rethrow(ME1);
	else
		ME=MException(...
			'ResFileSys:FileDir:addfilepart:UnexpectedInput',...
			'One or more inputs are not recognized.');
		ME=addCause(ME,ME1);
		throw(ME);
	end
end

if tf
	% leap one index, since DateID has been set.
	k=k+1;
end

%% Set FileExt (optional for both)
if k<K
	try
		obj.FileExt=varargin{K};
	catch ME1
		if isempty(regexpi(ME1.identifier,':InvalidInput$','once'))
			rethrow(ME1);
		else
			K=K+1;
		end
	end
	K=K-1;
end

%% Set FileNO (optional for both)
if k<K
	k=k+1;
	try
		obj.FileNO=varargin{k};
	catch ME1
		if isempty(regexpi(ME1.identifier,':InvalidInput$','once'))
			rethrow(ME1);
		else
			k=k-1;
		end
	end
end

%% Set ComponentID (optional for both)
k=k+1;
if k==K
	obj.ComponentID=varargin{k};
elseif k<K
	assert(isrealnstringvector(varargin(k:K)),...
		'ResFileSys:FileDir:addfilepart:UnexpectedInput',...
		'One or more inputs are not recognized.');
	obj.ComponentID=varargin(k:K);
end

end