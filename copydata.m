function copydata(sourceFileNameArgs,targetFileNameArgs,varargin)
%% Copy MATLAB Data
%  copydata('FileName1','FileName2') reads the location of 'FileName1' and
%  'FileName2' based on their syntax and copies source file to the target file.
%  The parsing of the full path of the files is done through the FileDir class.
%
%  copydata('FileName1',{...}) copies the source file to multiple target files.
%
%  copydata({...},{...}) copies each source file to each target file. The number
%  of source files must be equal to that of target files.
%
%  See FileDir class for information on the input requirements to the
%  sourceFileNameArgs and targetFileNameArgs.
%
%  copydata(...,'Rewrite',value)
%  copydata(...,'Overwrite',value)
%  sets how the file overwriting is handled. The options are are:
%    'yes': always overwrite the target files.
%    'no' : do not overwrite the target files.
%    'ask': always ask before overwriting the target files. (default)
%
% Requires package:
%  - MatCommon_v1.0.0+
%
% Tested on:
%  - MATLAB R2013b
%  - MATLAB R2015b
%
% See also FileDir, loaddata, savedata.
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 23/04/2013
% Last modified: 06/04/2018

%% Defaults
REWRITE='ask';

%% Parse Inputs
k=numel(varargin);

% Read the Rewrite option.
if k>1 && any(strcmpi(varargin{k-1},{'Rewrite','Overwrite'}))
	if any(strcmpi(varargin{k},{'yes','no','ask'}))
		REWRITE=varargin{k};
		k=k-2;
	else
		error('ResFileSys:copydata:InvalidInput',...
			'Input to Rewrite must be either ''yes'', ''no'', or ''ask''.');
	end
end

if k>0
	error('ResFileSys:copydata:UnexpectedInput',...
		'One or more inputs are not recognized.');
end

%% Main
warning('off','all');
if ~iscell(sourceFileNameArgs)
	sourceFileNameArgs={sourceFileNameArgs};
end
try
	S=loaddata(sourceFileNameArgs{:});
catch ME1
	if isempty(regexpi(ME1.identifier,...
			':InvalidInput$|:UnexpectedInput$|:WrongNargin$','once'))
		rethrow(ME1);
	else
		ME=MException('ResFileSys:copydata:InvalidInput',...
			'Invalid source file name arguments.');
		N=numel(ME1.cause);
		for i=1:N
			ME.addCause(ME1.cause{i});
		end
		throw(ME);
	end
end

if ~iscell(targetFileNameArgs)
	targetFileNameArgs={targetFileNameArgs};
end
try
	savedata(S,targetFileNameArgs{:},'Rewrite',REWRITE);
catch ME1
	if ~isempty(regexpi(ME1.identifier,...
			':InvalidInput$|:UnexpectedInput$|:WrongNargin$','once'))
		rethrow(ME1);
	else
		ME=MException('ResFileSys:copydata:InvalidInput',...
			'Invalid target file name arguments.');
		N=numel(ME1.cause);
		for i=1:N
			ME.addCause(ME1.cause{i});
		end
		throw(ME);
	end
end
warning('on','all');

end
