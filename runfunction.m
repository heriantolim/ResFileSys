function varargout=runfunction(varargin)
%% Evaluate Function
%  Evaluate a function whose name follows the convention set in FileDir class.
%  Before the evaluation, the working directory is changed to the directory of
%  the function. After the evaluation or if an error is encountered, the working
%  directory is reverted back to its previous state.
%
% Examples:
%  [Output1,Output2,...]=runfunction({FileDir args},Input1,Input2,...)
%  Evaluates the function with name specified by the FileDir arguments. The
%  FileDir args are enclosed within a cell. Input1,Input2,... are passed to the
%  function as its input arguments. Outputs from the function are passed to the
%  return variables Output1,Output2,... 
%
%  [Output1,Output2,...]=runfunction('process',Input1,Input2,...)
%  [Output1,Output2,...]=runfunction({'plot','PL','spectra'},Input1,Input2,...)
%  Evaluates function .._......._process or .._......._plot_PL_spectra. The
%  PartID, CategoryID, and DateID are automatically determined from the path
%  information. This parsing only works in the directories where such
%  information is available.
%
% Requires package:
%  - MatCommon_v1.0.0+
%
% Tested on:
%  - MATLAB R2013b
%  - MATLAB R2015b
%  - MATLAB R2017b
%
% See also: runscript.
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 07/04/2013
% Last modified: 31/03/2018

varargout=cell(1,nargout);

if nargin==0
	error('ResFileSys:runfunction:WrongNargin',...
		'Please specify the function name.');
else
	% Read the function name.
	ME=MException(...
		'ResFileSys:runfunction:UnexpectedInput',...
		'Unable to determine the function name from the first input.');
	try
		if iscell(varargin{1})
			F=FileDir(varargin{1}{:});
		else
			F=FileDir(varargin{1});
		end
	catch ME1
		if isempty(regexpi(ME1.identifier,':addfilepart:','once'))
			ME=ME.addCause(ME1);
			throw(ME);
		else
			try
				if iscell(varargin{1})
					F=FileDir('C',varargin{1}{:});
				else
					F=FileDir('C',varargin{1});
				end
			catch ME1
				ME=ME.addCause(ME1);
				throw(ME);
			end
		end
	end
	assert(F.NumFiles==1,...
		'ResFileSys:runfunction:TooManyFiles',...
		'Only inputs pointing to one function is allowed.');
	F.FileExt='';
	
	if strcmp(F.DirPath,pwd)
		% Evaluate the function.
		[varargout{:}]=feval(F.FileName,varargin{2:end});
	else
		% Remember the current working directory.
		INITIAL_WORKING_DIR=pwd;
		
		% Change the working directory and evaluate the function.
		try
			cd(F.DirPath);
			[varargout{:}]=feval(F.FileName,varargin{2:end});
		catch RUN_FUNCTION_ERROR
			% nothing is true
		end
		
		% Revert the working directory.
		if exist('INITIAL_WORKING_DIR','var')==1
			cd(INITIAL_WORKING_DIR);
		else
			warning('ResFileSys:runfunction:MemoryCleared',...
				['Unable to recall the previous directory. ',...
					'Perhaps the memory was cleared.']);
			cd(defaultworkdir);
		end
		
		% Throw errors if any.
		if exist('RUN_FUNCTION_ERROR','var')==1
			rethrow(RUN_FUNCTION_ERROR);
		end
	end
end

end