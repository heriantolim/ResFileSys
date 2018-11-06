function savedata(varargin)
%% Save MATLAB Data into .mat Files
%  savedata(filename1,filename2,...)
%  savedata(FileDir args)
%  Save each variable with name filename1, filename2,... found in the caller
%  workspace, into their corresponding full paths, as defined in the FileDir
%  class.
%
%  savedata(S,filename1,filename2,...)
%  savedata(S,FileDir args)
%  Save the variable S into the full paths given by the filenames or FileDir
%  args. If S is a cell vector with equal number of elements as the filenames
%  then each element in S will be saved individually for each filename.
%
%  savedata(var1,var2,...)
%  If the names of the variables var1, var2,... are valid filenames as defined
%  in the FileDir class, then each variable is saved individually with each
%  saving location being the corresponding fullpath of each filename.
%
%  savedata(...,'Rewrite',value)
%  savedata(...,'Overwrite',value)
%  Sets how the file overwriting is handled. The options are:
%    'yes': always overwrite existing files,
%    'no' : do not overwrite existing files,
%    'ask': always ask before overwriting existing files (default).
%
% Requires package:
%  - MatCommon_v1.0.0+
%
% Tested on:
%  - MATLAB R2013b
%  - MATLAB R2015b
%
% See also: FileDir, loaddata, copydata.
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 23/04/2013
% Last modified: 23/04/2013

%% Defaults
REWRITE='ask';

%% Parse Inputs
k=nargin;
assert(k>0,...
	'ResFileSys:savedata:WrongNargin',...
	'At least one input argument is required.');

% Read the Rewrite option.
if k>2 && any(strcmpi(varargin{k-1},{'Rewrite','Overwrite'})) ...
		&& any(strcmpi(varargin{k},{'yes','no','ask'}))
	REWRITE=varargin{k};
	k=k-2;
end

% Input case 1: All inputs are filenames or arguments to form filenames.
flag=1;
try
	F=FileDir(varargin{1:k});
catch
	flag=0;
end

% Input case 2: The first input is the variable to be stored. The rest are
%               filenames or arguments to form filenames.
if ~flag
	flag=2;
	try
		F=FileDir(varargin{2:k});
	catch
		flag=0;
	end
end

% Input case 3: The names of all input variables are a valid filename.
if ~flag
	fileName=arrayfun(@inputname,1:k,'UniformOutput',false);
	if FileDir.isfilename(fileName)
		F=FileDir(fileName);
		flag=3;
	end
end

% Reject other input variations.
if ~flag
	error('ResFileSys:savedata:UnexpectedInput',...
		'One or more inputs are not recognized.');
end

%% Main
F.FileExt='';
N=F.NumFiles;
[fileName,dirPath,fullPath]=FileDir.expandlist(...
	F.FileName,F.DirPath,strcat(F.FullPath,'.mat'),N);

% Preparation.
S=struct();
switch flag
	case 1
		varExist=false(1,N);
		for i=1:N
			varExist(i)=evalin('caller',['exist(''',fileName{i},''',''var'')'])==1;
			if varExist(i)
				S.(fileName{i})=evalin('caller',fileName{i});
			else
				warning('ResFileSys:savedata:MissingVar',...
					'The variable %s does not exist in the workspace.',fileName{i});
			end
		end
		fileName=fileName(varExist);
		dirPath=dirPath(varExist);
		fullPath=fullPath(varExist);
		N=sum(varExist);
	case 2
		tf=false;
		if iscell(varargin{1}) && isvector(varargin{1})
			if numel(varargin{1})==N
				tf=true;
			elseif N~=1
				warning('ResFileSys:savedata:CorrespondenceMismatch',...
				   ['The cell vector %s will be saved identically into ',...
						'multiple files, since its number elements is not equal ',...
						'to the number of files.'],inputname(1));
			end
		end
		if tf
			for i=1:N
				S.(fileName{i})=varargin{1}{i};
			end
		else
			for i=1:N
				S.(fileName{i})=varargin{1};
			end
		end
	case 3
		for i=1:N
			S.(fileName{i})=varargin{i};
		end
end 

for i=1:N
	if isempty(S.(fileName{i}))
		% Skip saving empty data.
		warning('ResFileSys:savedata:EmptyData',...
			'Skipped saving the file %s.mat, since it is empty.',fileName{i});
		continue
	elseif exist(dirPath{i},'dir')~=7
		% Create new directory if the requested location does not exist.
		mkdir(dirPath{i});
	elseif ~strcmpi(REWRITE,'yes') && exist(fullPath{i},'file')==2
		if strcmpi(REWRITE,'no')
			continue
		else
			reply=input(sprintf(...
				'File %s.mat already exists. Rewrite file? Y/N [N]:',...
				fileName{i}),'s');
			if ~strcmpi(reply,'Y')
				continue
			end
		end
	end 
	
	% Saving... Do not turn off the power.
	save(fullPath{i},'-struct','S',fileName{i});
end

end