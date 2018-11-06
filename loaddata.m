function [S,N]=loaddata(varargin)
%% Load MATLAB Data from .mat Files
%  S=loaddata(filename1,filename2,...)
%  S=loaddata(FileDir args)
%  loads MATLAB data from the files and return them in the output variable S. If
%  there are more than one files, then S will be a cell vector with each element
%  in S containing the data from each file. If no output is assigned during the
%  call, loaddata will create variables filename1, filename2,... that contain
%  the data from each file, in the caller workspace.
%
%  [...,N]=loaddata(...)
%  also returns the number of files that were requested to be loaded.
%
% Requires package:
%  - MatCommon_v1.0.0+
%
% Tested on:
%  - MATLAB R2013b
%  - MATLAB R2015b
%
% See also: FileDir, savedata, copydata.
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 23/04/2013
% Last modified: 23/04/2013

if nargin==0
	if nargout>0
		S=[];
		N=0;
	end
else
	try
		F=FileDir(varargin{:});
	catch ME1
		ME=MException('ResFileSys:loaddata:InvalidInput',...
			'Invalid file name arguments.');
		ME.addCause(ME1);
		throw(ME);
	end
	F.FileExt='';
	N=F.NumFiles;
	[fileName,fullPath]=FileDir.expandlist(...
		F.FileName,strcat(F.FullPath,'.mat'),N);
	S=cell(1,N);
	for i=1:N
		if exist(fullPath{i},'file')==2
			S1=load(fullPath{i});
			if isfield(S1,fileName{i})
				S{i}=S1.(fileName{i});
			else
				S{i}=S1;
			end
		else
			warning('ResFileSys:loaddata:MissingFile',...
			   ['The file %s.mat does not exist. The corresponding ',...
					'return value is left empty.'],fileName{i});
		end
	end
	if nargout==0
		for i=1:N
			assignin('caller',fileName{i},S{i});
		end
	elseif N==1
		S=S{1};
	end
end

end