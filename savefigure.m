function savefigure(varargin)
%% Save or Print Figure to Files
%  savefigure(FileDir args) saves or prints the current figure to files whose
%  paths are specified by the filename or filepart arguments as managed by the
%  FileDir class.
%
%  savefigure(...,'Rewrite',value)
%  savefigure(...,'Overwrite',value)
%  sets how the file overwriting is handled. The options are:
%    'yes': always overwrite existing files,
%    'no' : do not overwrite existing files,
%    'ask': always ask before overwriting existing files (default).
%
%  savefigure(...,'Resolution',[R1,R2,..])sets the resolution of the print. If
%  resolution is a vector, then the figure will be printed into multiple files
%  at the different resolutions.
%
%  savefigure(h,...) saves or prints the figure with a handle h instead of the
%  current figure.
%  
%  The file format of the print is specified by the file extensions. If no file
%  extensions are supplied, the figure will be saved as the '.fig' MATLAB file.
%
% Requires package:
%  - MatCommon_v1.0.0+
%
% Tested on:
%  - MATLAB R2017b
%
% See also: FileDir, loaddata, copydata.
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 23/04/2013
% Last modified: 05/04/2018

%% Defaults
REWRITE='ask';
FILE_FORMAT='.fig';
RESOLUTION=300;

%% Input Parsing
k=nargin;
assert(k>0,'ResFileSys:savefigure:WrongNargin',...
	'At least one input argument is required.');

% Read the Rewrite option.
if k>2 && any(strcmpi(varargin{k-1},{'Rewrite','Overwrite'})) ...
		&& any(strcmpi(varargin{k},{'yes','no','ask'}))
	REWRITE=varargin{k};
	k=k-2;
end

% Read the Resolution option.
if k>2 && strcmpi(varargin{k-1},'Resolution') ...
		&& isintegervector(varargin{k}) && all(varargin{k}>0)
	RESOLUTION=varargin{k};
	k=k-2;
end

if k<nargin
	varargin=varargin(1:k);
end

% Read the figure handle.
if k>1 && isa(varargin{1},'matlab.ui.Figure')
	h=varargin{1};
	varargin=varargin(2:k);
else
	h=gcf;
end

% Read the FileDir arguments.
try
	F=FileDir(varargin{:});
catch ME1
	ME=MException('ResFileSys:savefigure:InvalidInput',...
		'Inputs to specify the filenames are invalid.');
	ME.addCause(ME1);
	throw(ME);
end

%% Main
N=F.NumFiles;
[fileName,fileExt,dirPath,fullPath]=FileDir.expandlist(...
	F.FileName,F.FileExt,F.DirPath,F.FullPath,N);
for i=1:N
	% Default extension.
	if isempty(fileExt{i})
		fileExt{i}=FILE_FORMAT;
		fileName{i}=[fileName{i},FILE_FORMAT];
		fullPath{i}=[fullPath{i},FILE_FORMAT];
	end
	
	% If folder does not exist, make it. If target file exists, ask.
	if exist(dirPath{i},'dir')~=7
		mkdir(dirPath{i});
	elseif ~strcmpi(REWRITE,'yes') && exist(fullPath{i},'file')==2
		if strcmpi(REWRITE,'no')
			continue
		else
			reply=input(sprintf(...
				'File %s already exists. Rewrite file? Y/N [N]:',fileName{i}),'s');
			if ~strcmpi(reply,'Y')
				continue
			end
		end
	end
	
	% Saving... Do not turn off the power.
	switch fileExt{i}
		case '.fig'
			flag=1;
		case '.eps'
			flag=2;
			format='-depsc';
		case '.pdf'
			flag=2;
			format='-dpdf';
		case '.ps'
			flag=2;
			format='-dpsc';
		case '.svg'
			flag=2;
			format='-dsvg';
		case '.bmp'
			flag=3;
			format='-dbmp';
		case '.jpg'
			flag=3;
			format='-djpeg';
		case '.png'
			flag=3;
			format='-dpng';
		case '.tif'
			flag=3;
			format='-dtiff';
		otherwise
			warning('ResFileSys:savefigure:NotImplemented',...
				'Printing of %s file is not yet supported.',...
				fileExt{i});
			continue
	end
	switch flag
		case 1
			savefig(h,fullPath{i});
		case 2
			print(h,fullPath{i},format);
		case 3
			for j=1:numel(RESOLUTION)
				print(h,regexprep(fullPath{i},...
						[regexptranslate('escape',fileExt{i}),'$'],...
						sprintf('_%ddpi%s',RESOLUTION(j),fileExt{i})),...
					format,sprintf('-r%d',RESOLUTION(j)));
			end
	end
end

end