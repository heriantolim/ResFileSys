function y=strsplit(x,dlm)
%% String Split
%  y=FileDir.strsplit(x,dlm) split string x of dlm-separated values into an
%  array of split strings. If x is a string array then this function returns a
%  bigger array (higher dimension). Note that to use special characters as dlm,
%  a preceding backslash \ is required.
%
% Tested on:
%  - MATLAB R2013b
%  - MATLAB R2015b
%
% See also: strjoin.
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 06/03/2013
% Last modified: 06/03/2013

assert(isstringscalar(dlm),...
	'ResFileSys:FileDir:strsplit:InvalidInput',...
	'The delimiter must be a string scalar.');

if isstringscalar(x)
	y=regexp(x,dlm,'split');
elseif iscell(x)
	y=cellfun(@(z)FileDir.strsplit(z,dlm),x,'UniformOutput',false);
else
	error('ResFileSys:FileDir:strsplit:InvalidInput',...
		'The input string must be a string scalar or a nested array of strings.');
end

end