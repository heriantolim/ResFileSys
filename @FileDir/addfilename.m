function obj=addfilename(obj,varargin)
%% Add Filenames to the FileDir Object
%  obj=obj.addfilename(filename1,filename2,filename3,...)
%  obj=obj.addfilename({filename1,filename2,filename3,...})
%  extracts fileparts information out of filename1, filename2, filename3, ...
%  and stores them in the FileDir object.
%
% Requires package:
%  - MatCommon_v1.0.0+
%
% Tested on:
%  - MATLAB R2013b
%  - MATLAB R2015b
%
% See also: addfilepart.
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 06/03/2013
% Last modified: 06/03/2013

%% Parse Inputs
if nargin==1
	return
elseif FileDir.isfilename(varargin)
	fileName=varargin;
else
	assert(nargin==2,...
		'ResFileSys:FileDir:addfilename:InvalidInput',...
		'Input to filenames in one cell array must be as a single argument.');
	assert(FileDir.isfilename(varargin{1}),...
		'ResFileSys:FileDir:addfilename:InvalidInput',...
		'Input to filenames failed validation.');
	fileName=varargin{1};
end

%% Initialize Variables
M=numel(fileName);
partID=repmat({''},1,M);
categoryID=repmat({''},1,M);
dateID=repmat({''},1,M);
fileNO=repmat({''},1,M);
componentID=repmat({''},1,M);
fileExt=repmat({''},1,M);

%% Split the Filenames
fileName=strtrim(fileName);
fileName=FileDir.strsplit(fileName,'\.');
for i=1:M
	if length(fileName{i})>1
		fileExt{i}=strcat('.',fileName{i}{2});
	end
	filePart=FileDir.strsplit(fileName{i}{1},'_');
	N=length(filePart);
	partID{i}=filePart{1}(1);
	categoryID{i}=filePart{1}(2);
	dateID{i}=filePart{2};
	if N>2
		if FileDir.isfileno(filePart{3})
			fileNO{i}=filePart{3};
			j=4;
		else
			j=3;
		end
		if N>=j
			componentID{i}=filePart(j:N);
		end
	end
end

%% Set Outputs
obj.ProjectID=FileDir.pathinfo;
obj.PartID=partID;
obj.CategoryID=categoryID;
obj.DateID=dateID;
obj.FileNO=fileNO;
obj.ComponentID=componentID;
obj.FileExt=fileExt;

end
