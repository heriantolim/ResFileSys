function obj=merge(obj,varargin)
%% Merge FileDir Objects
%  obj=obj.merge(obj2,obj3,...)
%  obj=merge(obj,obj2,obj3,...)
%  merges FileDir objects obj, obj2, obj3,... into a single object.
%
% Requires package:
%  - MatCommon_v1.0.0+
%
% Tested on:
%  - MATLAB R2013b
%  - MATLAB R2015b
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 06/03/2013
% Last modified: 06/03/2013

N=nargin;

% if there is no other objects to merge, return
if N==1
	return
end

assert(all(cellfun(@(x)isa(x,'FileDir'),varargin)),...
	'ResFileSys:FileDir:merge:InvalidInput',...
	'All arguments must be of class ''FileDir''.');

varargin=[{obj},varargin];

numFiles=zeros(1,N);
for i=1:N
	numFiles(i)=varargin{i}.NumFiles;
end

K=sum(numFiles);
if K==numFiles(1)
	return
end

combinedProjectID=cell(1,K);
combinedPartID=cell(1,K);
combinedCategoryID=cell(1,K);
combinedDateID=cell(1,K);
combinedFileNO=cell(1,K);
combinedComponentID=cell(1,K);
combinedFileExt=cell(1,K);

k=1;
for i=1:N
	if numFiles(i)>0
		projectID=varargin{i}.ProjectID;
		partID=varargin{i}.PartID;
		categoryID=varargin{i}.CategoryID;
		dateID=varargin{i}.DateID;
		fileNO=varargin{i}.FileNO;
		componentID=varargin{i}.ComponentID;
		fileExt=varargin{i}.FileExt;
		if numFiles(i)==1
			combinedProjectID{k}=projectID;
			combinedPartID{k}=partID;
			combinedCategoryID{k}=categoryID;
			combinedDateID{k}=dateID;
			combinedFileNO{k}=fileNO;
			combinedComponentID{k}=componentID;
			combinedFileExt{k}=fileExt;
			k=k+1;
		else
			if ischar(projectID)
				projectID=repmat({projectID},1,numFiles(i));
			end
			if ischar(partID)
				partID=repmat({partID},1,numFiles(i));
			end
			if ischar(categoryID)
				categoryID=repmat({categoryID},1,numFiles(i));
			end
			if ischar(dateID)
				dateID=repmat({dateID},1,numFiles(i));
			end
			if ischar(fileNO)
				fileNO=repmat({fileNO},1,numFiles(i));
			end
			if isstringvector(componentID)
				componentID=repmat({componentID},1,numFiles(i));
			end
			if ischar(fileExt)
				fileExt=repmat({fileExt},1,numFiles(i));
			end
			combinedProjectID(k:k+numFiles(i)-1)=projectID;
			combinedPartID(k:k+numFiles(i)-1)=partID;
			combinedCategoryID(k:k+numFiles(i)-1)=categoryID;
			combinedDateID(k:k+numFiles(i)-1)=dateID;
			combinedFileNO(k:k+numFiles(i)-1)=fileNO;
			combinedComponentID(k:k+numFiles(i)-1)=componentID;
			combinedFileExt(k:k+numFiles(i)-1)=fileExt;
			k=k+numFiles(i);
		end
	end
end

obj=FileDir;
obj.ProjectID=combinedProjectID;
obj.PartID=combinedPartID;
obj.CategoryID=combinedCategoryID;
obj.DateID=combinedDateID;
obj.FileNO=combinedFileNO;
obj.ComponentID=combinedComponentID;
obj.FileExt=combinedFileExt;

end