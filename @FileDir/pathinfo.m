function [projectID,partID,categoryID,dateID]=pathinfo
%% Get Path Information
%  Locate the MATLAB current working directory and return any file parts
%  information found in the path. The expression is
%  '...\Research\Projects\<projectID>\<partID>\<dateID>\<categoryID>'
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
% First created: 08/04/2013
% Last modified: 31/03/2018

f=regexptranslate('escape',filesep);
token=regexp(pwd,[regexptranslate('escape',basepath),f,...
	'(\.?\w{3,})',f,'?(\w*)',f,'?(\w*)',f,'?(\w*)'],'tokens');

if isempty(token)
	error('ResFileSys:FileDir:pathinfo:PathNotFound',...
		'Unable to locate the project folder.');
else
	projectID=token{1}{1};
	partID=FileDir.PartTable.PartID(...
		strcmp(FileDir.PartTable.PartNames,token{1}{2}));
	categoryID=FileDir.CategoryTable.CategoryID(...
		strcmp(FileDir.CategoryTable.CategoryNames,token{1}{4}));
	dateID=token{1}{3};
	if ~FileDir.ispartid(partID)
		partID='';
	else
		partID=partID{1};
	end
	if ~FileDir.iscategoryid(categoryID)
		categoryID='';
	else
		categoryID=categoryID{1};
	end
	if ~FileDir.isdateid(dateID)
		dateID=[];
	else
		dateID=str2double(dateID);
	end
end

end