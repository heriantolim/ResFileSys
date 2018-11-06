function runscript(varargin)
%% Run Script
%  runscript(FileDir args) executes scripts whose names are specified by the
%  FileDir arguments. The execution is performed for each filename the FileDir
%  arguments form. Before each execution, the working directory is changed to
%  the directory where the script is located. Upon the completion of all
%  executions or if an error is encountered, the working directory is reverted
%  back to its initial state.
%
% Examples:
%  runscript('EC_20130407_main.m','EC_20121005_test_gg',...)
%  Changes the working directory to '.../Experiments/20130406/Codes', then run
%  the script EC_20130407_main.m. If no errors are encountered, change the
%  working directory to '.../Experiments/20121005/Codes', then run the script
%  EC_20121005_test_gg.m. Repeat for the next filename. Change the working
%  directory back to its initial state after all scripts have been executed. 
%
%  runscript('main',{'test','gg'},...)
%  Executes the script .._......._main.m, followed by .._......._test_gg.m in
%  the current working directory. The PartID, CategoryID, and DateID are
%  automatically determined from the path information. This parsing only works
%  in the directories where such information is available.
%
% Requires package:
%  - MatCommon_v1.0.0+
%
% Tested on:
%  - MATLAB R2013b
%  - MATLAB R2015b
%  - MATLAB R2017b
%
% See also: runfunction.
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 07/04/2013
% Last modified: 31/03/2018

N=nargin;

if N==0
	error('ResFileSys:runscript:WrongNargin',...
		'Please specify the script name.');
else
	% Read the script name(s).
	ME=MException(...
		'ResFileSys:runscript:UnexpectedInput',...
		'Unable to determine the script name(s) from the input arguments.');
	try
		F=FileDir(varargin{:});
	catch ME1
		if isempty(regexpi(ME1.identifier,':addfilepart:','once'))
			ME=ME.addCause(ME1);
			throw(ME);
		else
			try
				F=FileDir('C',varargin{:});
			catch ME1
				ME=ME.addCause(ME1);
				throw(ME);
			end
		end
	end
	F.FileExt='';
	
	% Remember the current working directory.
	INITIAL_WORKING_DIR=pwd;
	
	% Execute the scripts one by one.
	N=F.NumFiles;
	[dirPath,fileName]=FileDir.expandlist(F.DirPath,F.FileName);
	try
		for i=1:N
			cd(dirPath{i});
			run(fileName{i});
		end
	catch RUN_SCRIPT_ERROR
		% nothing is true
	end
	
	% Revert the working directory.
	if exist('INITIAL_WORKING_DIR','var')==1
		cd(INITIAL_WORKING_DIR);
	else
		warning('ResFileSys:runscript:MemoryCleared',...
			['Unable to recall the previous directory. ',...
				'Perhaps the memory was cleared.']);
		cd(defaultworkdir);
	end
	
	% Throw errors if any.
	if exist('RUN_SCRIPT_ERROR','var')==1
		rethrow(RUN_SCRIPT_ERROR);
	end
end

end