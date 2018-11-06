classdef FileDir
%% File Directory Class
%  A file-naming system to make file management easier. The constructor of this
%  class FileDir(...) takes input arguments in the form of filenames or
%  information about the file parts. When the essential information is supplied,
%  FileDir automatically generates the rest of the information needed for file
%  naming, such as: the full path of the file.
%
%  A FileDir object can also be constructed by passing another FileDir object as
%  the first input argument. The input may be followed by a series of arguments
%  in Name-Value syntax, where the names are those of the object's properties to
%  be modified and the values are the new values for those properties. For
%  example:
%    A=FileDir(...);
%    B=FileDir(A,Property1Name,Property1NewValue,...);
%  In this syntax, object B will be a copy of object A, except that some of the
%  properties have been changed to new values.
%
%  If more than one file names are supplied and they are all the same, FileDir
%  will remove all the duplicates and store only one copy.
%
% Read-only Properties:
%  NumFiles: The number of filenames stored in FileDir.
%
%  FileName: File names.
%
%  DirPath: Path to the folder where the files reside.
%
%  FullPath: Full path to the files.
%
% Public Properties:
%  ProjectID: The ID of the research project.
%
%  PartID: The ID of the research activity, e.g. Analyses, Experiments, ...
%
%  CategoryID: The ID of the file category, e.g. Data, Figures, Logs,...
%
%  DateID: The ID of the date when the activity is performed.
%
%  FileNO: The numbering of the files that belong to the same part and category.
%
%  ComponentID: Other labelling components given to the file names.
%
%  FileExt: The file extensions.
%
% Public Methods:
%  merge: Merge two or more FileDir objects.
%
%  pathinfo: Get the file parts information from the current working directory.
%
%  isprojectid: Check if input is a valid name for ProjectID.
%
%  ispartid: Check if input is a valid name for PartID.
%
%  iscategoryid: Check if input is a valid name for CategoryID.
%
%  isdateid: Check if input is a valid name for DateID.
%
%  isfileno: Check if input is a valid name for FileNO.
%
%  iscomponentid: Check if input is a valid name for ComponentID.
%
%  isfileext: Check if input is a valid name for FileExt.
%
%  isfilename: Check if input is a valid name for FileName.
%
%  isemptylist: Check if input is an empty char, a number, a cell or a nested
%               cell which contains empty chars and/or numbers.
%
%  collapselist: Collapse an array to a scalar value if all elements in the
%                in the array are equal.
%
%  expandlist: Expand a scalar value to a repeated cell array.
%
%  strjoin: Join strings or array of strings together with a delimiter.
%
%  strsplit: Split strings into array of strings.
%
% Requires package:
%  - MatCommon_v1.0.0+
%
% Tested on:
%  - MATLAB R2013b
%  - MATLAB R2015b
%
% See also ADDFILENAME, ADDFILEPART.
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 06/04/2013
% Last modified: 25/03/2018

%% Properties
properties (SetAccess=protected)
	NumFiles=0;
end

properties
	ProjectID='';% optional
	PartID='';% mandatory
	CategoryID='';% mandatory
	DateID='';% mandatory
	FileNO='';% optional
	ComponentID='';% optional
	FileExt='';% optional
end

properties (Dependent=true,SetAccess=protected)
	FileName
	DirPath
	FullPath
end

properties (Dependent=true,Access=protected)
	PartName
	PartNames
	CategoryName
	CategoryNames
end

properties (Constant=true,Access=protected)
	PartTable=table({'A';'E';'I';'S'},...
		{'Analysis';'Experiment';'Illustration';'Simulation'},...
		{'Analyses';'Experiments';'Illustrations';'Simulations'},...
		'VariableNames',{'PartID','PartName','PartNames'});
	CategoryTable=table({'C';'D';'E';'F';'L';'R';'T'},...
		{'Code';'Data';'Equation';'Figure';'Log';'Result';'Table'},...
		{'Codes';'Data';'Equations';'Figures';'Logs';'Results';'Tables'},...
		'VariableNames',{'CategoryID';'CategoryName';'CategoryNames'});
end

%% Methods
methods
	% Constructor
	function obj=FileDir(varargin)
		if nargin==0
			return
		elseif isa(varargin{1},'FileDir')
			obj=varargin{1};
			if nargin>1
				propNames={'ProjectID','PartID','CategoryID','DateID',...
					'FileNO','ComponentID','FileExt'};
				n=2;
				while n<nargin
					ME=MException('ResFileSys:FileDir:InvalidInput',...
						['If the first input argument is a FileDir object, the ',...
							'arguments supplied after must follow a Name-Value ',...
							'syntax, where the names are those of the object''s ',...
							'properties to be modified and the values are the new ',...
							'new values for those properties.']);
					if isstringscalar(varargin{n})
						tf=strcmpi(varargin{n},propNames);
						if any(tf)
							obj.(propNames{tf})=varargin{n+1};
						else
							throw(ME);
						end
					else
						throw(ME);
					end
					n=n+2;
				end
				if n<=nargin
					warning('ResFileSys:FileDir:IgnoredInput',...
						'An extra input argument was provided, but is ignored.');
				end
			end
		else
			try
				obj=obj.addfilename(varargin{:});
			catch ME1
				if isempty(regexpi(ME1.identifier,':InvalidInput$','once'))
					rethrow(ME1);
				else
					obj=obj.addfilepart(varargin{:});
				end
			end
		end
	end

	% Get Access Methods
	function x=get.PartName(obj)
		partID=obj.PartID;
		if isempty(partID)
			x='';
		elseif ischar(partID)
			x=FileDir.PartTable.PartName(strcmp(...
				FileDir.PartTable.PartID,partID));
			x=x{1};
		else
			N=numel(partID);
			x=cell(1,N);
			for i=1:N
				x(i)=FileDir.PartTable.PartName(strcmp(...
					FileDir.PartTable.PartID,partID{i}));
			end
		end
	end

	function x=get.PartNames(obj)
		partID=obj.PartID;
		if isempty(partID)
			x='';
		elseif ischar(partID)
			x=FileDir.PartTable.PartNames(strcmp(...
				FileDir.PartTable.PartID,partID));
			x=x{1};
		else
			N=numel(partID);
			x=cell(1,N);
			for i=1:N
				x(i)=FileDir.PartTable.PartNames(strcmp(...
					FileDir.PartTable.PartID,partID{i}));
			end
		end
	end

	function x=get.CategoryName(obj)
		categoryID=obj.CategoryID;
		if isempty(categoryID)
			x='';
		elseif ischar(categoryID)
			x=FileDir.CategoryTable.CategoryName(strcmp(...
				FileDir.CategoryTable.CategoryID,categoryID));
			x=x{1};
		else
			N=numel(categoryID);
			x=cell(1,N);
			for i=1:N
				x(i)=FileDir.CategoryTable.CategoryName(strcmp(...
					FileDir.CategoryTable.CategoryID,categoryID{i}));
			end
		end
	end

	function x=get.CategoryNames(obj)
		categoryID=obj.CategoryID;
		if isempty(categoryID)
			x='';
		elseif ischar(categoryID)
			x=FileDir.CategoryTable.CategoryNames(strcmp(...
				FileDir.CategoryTable.CategoryID,categoryID));
			x=x{1};
		else
			N=numel(categoryID);
			x=cell(1,N);
			for i=1:N
				x(i)=FileDir.CategoryTable.CategoryNames(strcmp(...
					FileDir.CategoryTable.CategoryID,categoryID{i}));
			end
		end
	end

	function x=get.FileName(obj)
		if isempty(obj.PartID) || isempty(obj.CategoryID) || isempty(obj.DateID)
			error('ResFileSys:FileDir:MissingData',...
				['Some of the mandatory properties such as: PartID, ',...
					'CategoryID, and DateID have not been set.']);
		end
		% Join the ComponentID first if any
		componentID=obj.ComponentID;
		if isstringvector(componentID)
			componentID=strjoin(componentID,'_');
		elseif ~ischar(componentID)
			% componentID is a cell of string vectors
			N=numel(componentID);
			for i=1:N
				if isstringvector(componentID{i})
					componentID{i}=strjoin(componentID{i},'_');
				end
			end
		end
		x=strcat(obj.PartID,obj.CategoryID);
		x=FileDir.strjoin(x,obj.DateID,obj.FileNO,componentID,'_');
		x=strcat(x,obj.FileExt);
	end

	function x=get.DirPath(obj)
		if isempty(obj.PartID) || isempty(obj.CategoryID) || isempty(obj.DateID)
			error('ResFileSys:FileDir:MissingData',...
				['Some of the mandatory properties such as: PartID, ',...
					'CategoryID, and DateID have not been set.']);
		end
		if isempty(obj.ProjectID)
			obj.ProjectID=FileDir.pathinfo();
		end
		x=fullfile(basepath,obj.ProjectID,obj.PartNames,obj.DateID,...
			obj.CategoryNames);
		if iscell(x) && numel(x)==1
			x=x{1};
		end
	end

	function x=get.FullPath(obj)
		x=fullfile(obj.DirPath,obj.FileName);
		if iscell(x) && numel(x)==1
			x=x{1};
		end
	end

	% Set Access Methods
	function obj=set.ProjectID(obj,x)
		% Allow to erase ProjectID
		if FileDir.isemptylist(x)
			obj.ProjectID='';
			return
		end

		assert(FileDir.isprojectid(x),...
			'ResFileSys:FileDir:setProjectID:InvalidInput',...
			'Input to set the ProjectID failed validation.');

		% Ensure consistency of the number of files
		if ischar(x)
			numItems=1;
		else
			numItems=numel(x);
		end
		numFiles=obj.NumFiles; %#ok<MCSUP>
		if numFiles==0
			obj.NumFiles=numItems; %#ok<MCSUP>
		elseif numItems>1
			if numFiles==1
				obj.NumFiles=numItems; %#ok<MCSUP>
			elseif numItems~=numFiles
				error(['ResFileSys:FileDir:setProjectID:',...
						'InconsistentNumFiles'],...
					['The number of elements does not agree with the number of ',...
						'files.']);
			end
		end

		% Simplify the data to save memory
		x=FileDir.collapselist(x);
		if iscolumn(x)
			x=x';
		end
		obj.ProjectID=x;
	end

	function obj=set.PartID(obj,x)
		assert(FileDir.ispartid(x),...
			'ResFileSys:FileDir:setPartID:InvalidInput',...
			'Input to set the PartID failed validation.');

		% Ensure consistency of the number of files
		if ischar(x)
			numItems=1;
		else
			numItems=numel(x);
		end
		numFiles=obj.NumFiles; %#ok<MCSUP>
		if numFiles==0
			obj.NumFiles=numItems; %#ok<MCSUP>
		elseif numItems>1
			if numFiles==1
				obj.NumFiles=numItems; %#ok<MCSUP>
			elseif numItems~=numFiles
				error(['ResFileSys:FileDir:setPartID:',...
						'InconsistentNumFiles'],...
					['The number of elements does not agree with ',...
						'the number of files.']);
			end
		end

		% Simplify the data to save memory
		x=FileDir.collapselist(x);
		if iscolumn(x)
			x=x';
		end
		obj.PartID=x;
	end

	function obj=set.CategoryID(obj,x)
		assert(FileDir.iscategoryid(x),...
			'ResFileSys:FileDir:setCategoryID:InvalidInput',...
			'Input to set the CategoryID failed validation.');

		% Ensure consistency of the number of files
		if ischar(x)
			numItems=1;
		else
			numItems=numel(x);
		end
		numFiles=obj.NumFiles; %#ok<MCSUP>
		if numFiles==0
			obj.NumFiles=numItems; %#ok<MCSUP>
		elseif numItems>1
			if numFiles==1
				obj.NumFiles=numItems; %#ok<MCSUP>
			elseif numItems~=numFiles
				error(['ResFileSys:FileDir:setCategoryID:',...
						'InconsistentNumFiles'],...
					['The number of elements does not agree with ',...
						'the number of files.']);
			end
		end

		% Simplify the data to save memory
		x=FileDir.collapselist(x);
		if iscolumn(x)
			x=x';
		end
		obj.CategoryID=x;
	end

	function obj=set.DateID(obj,x)
		assert(FileDir.isdateid(x),...
			'ResFileSys:FileDir:setDateID:InvalidInput',...
			'Input to set the DateID failed validation.');

		% Ensure consistency of the number of files
		if ischar(x)
			numItems=1;
		else
			numItems=numel(x);
		end
		numFiles=obj.NumFiles; %#ok<MCSUP>
		if numFiles==0
			obj.NumFiles=numItems; %#ok<MCSUP>
		elseif numItems>1
			if numFiles==1
				obj.NumFiles=numItems; %#ok<MCSUP>
			elseif numItems~=numFiles
				error(['ResFileSys:FileDir:setDateID:',...
						'InconsistentNumFiles'],...
					['The number of elements does not agree with ',...
						'the number of files.']);
			end
		end

		% Simplify the data to save memory
		if isnumeric(x)
			% convert integer vector to string vector
			x=cellfun(@num2str,num2cell(x),'UniformOutput',false);
		elseif iscell(x)
			% x is a cell vector of integers and/or strings
			for i=1:numItems
				if isnumeric(x{i})
					x{i}=num2str(x{i});
				end
			end
		end
		x=FileDir.collapselist(x);
		if iscolumn(x)
			x=x';
		end
		obj.DateID=x;
	end

	function obj=set.FileNO(obj,x)
		% Allow to erase FileNO
		if FileDir.isemptylist(x)
			obj.FileNO='';
			return
		end

		assert(FileDir.isfileno(x),...
			'ResFileSys:FileDir:setFileNO:InvalidInput',...
			'Input to set the FileNO failed validation.');

		% Ensure consistency of the number of files
		if ischar(x)
			numItems=1;
		else
			numItems=numel(x);
		end
		numFiles=obj.NumFiles; %#ok<MCSUP>
		if numFiles==0
			obj.NumFiles=numItems; %#ok<MCSUP>
		elseif numItems>1
			if numFiles==1
				obj.NumFiles=numItems; %#ok<MCSUP>
			elseif numItems~=numFiles
				error(['ResFileSys:FileDir:setFileNO:',...
						'InconsistentNumFiles'],...
					['The number of elements does not agree with ',...
						'the number of files.']);
			end
		end

		% Simplify the data to save memory
		if isnumeric(x)
			% convert integer vector to string vector
			x=cellfun(@num2str,num2cell(x),'UniformOutput',false);
		elseif iscell(x)
			% x is a cell vector of integers and/or strings
			for i=1:numItems
				if isnumeric(x{i})
					x{i}=num2str(x{i});
				end
			end
		end
		x=FileDir.collapselist(x);
		if iscolumn(x)
			x=x';
		end
		obj.FileNO=x;
	end

	function obj=set.ComponentID(obj,x)
		% Allow to erase ComponentID
		if FileDir.isemptylist(x)
			obj.ComponentID='';
			return
		end

		assert(FileDir.iscomponentid(x),...
			'ResFileSys:FileDir:setComponentID:InvalidInput',...
			'Input to set the ComponentID failed validation.');

		% Ensure consistency of the number of files
		if ischar(x) || isnumeric(x) || isrealnstringvector(x)
			numItems=1;
		else
			numItems=numel(x);
		end
		numFiles=obj.NumFiles; %#ok<MCSUP>
		if numFiles==0
			obj.NumFiles=numItems; %#ok<MCSUP>
		elseif numItems>1
			if numFiles==1
				obj.NumFiles=numItems; %#ok<MCSUP>
			elseif numItems~=numFiles
				error(['ResFileSys:FileDir:setComponentID:',...
						'InconsistentNumFiles'],...
					['The number of elements does not agree with ',...
						'the number of files.']);
			end
		end

		% Simplify the data to save memory
		if ischar(x)
			x={x};
		elseif ~isrealnstringvector(x)
			for i=1:numItems
				if iscolumn(x{i})
					x{i}=x{i}';
				end
			end
			x=FileDir.collapselist(x);
		end
		if iscolumn(x)
			x=x';
		end
		obj.ComponentID=FileDir.num2str(x);
	end

	function obj=set.FileExt(obj,x)
		% Allow to erase FileExt
		if FileDir.isemptylist(x)
			obj.FileExt='';
			return
		end

		assert(FileDir.isfileext(x),...
			'ResFileSys:FileDir:setFileExt:InvalidInput',...
			'Input to set the FileExt failed validation.');

		% Ensure consistency of the number of files
		if ischar(x)
			numItems=1;
		else
			numItems=numel(x);
		end
		numFiles=obj.NumFiles; %#ok<MCSUP>
		if numFiles==0
			obj.NumFiles=numItems; %#ok<MCSUP>
		elseif numItems>1
			if numFiles==1
				obj.NumFiles=numItems; %#ok<MCSUP>
			elseif numItems~=numFiles
				error(['ResFileSys:FileDir:setFileExt:',...
						'InconsistentNumFiles'],...
					['The number of elements does not agree with ',...
						'the number of files.']);
			end
		end

		% Simplify the data to save memory
		x=FileDir.collapselist(x);
		if iscolumn(x)
			x=x';
		end
		obj.FileExt=x;
	end

	% Merge objects
	obj=merge(obj,varargin)
end

methods (Static=true)
	[projectID,partID,categoryID,dateID]=pathinfo
	tf=isprojectid(x)
	tf=ispartid(x)
	tf=iscategoryid(x)
	tf=isdateid(x)
	tf=isfileno(x)
	tf=iscomponentid(x)
	tf=isfileext(x)
	tf=isfilename(x)
	tf=isemptylist(x)
	varargout=collapselist(varargin)
	varargout=expandlist(varargin)
	y=num2str(x)
	y=strjoin(varargin)
	y=strsplit(x,dlm)
end

methods (Access=protected)
	obj=addfilename(obj,varargin)
	obj=addfilepart(obj,varargin)
end

end
