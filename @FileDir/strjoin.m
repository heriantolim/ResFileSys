function y=strjoin(varargin)
%% Join Strings
%  y=FileDir.strjoin(str1,str2,str3,...,dlm) joins the strings str1, str2, str3,
%  ... together with delimiter dlm placed in between any two non-empty strings.
%  str1, str2, str3 may be a mix of string scalars OR string arrays of the same
%  dimension and shape.
%
% Requires package:
%  - MatCommon_v1.0.0+
%
% Tested on:
%  - MATLAB R2013b
%  - MATLAB R2015b
%
% See also: strsplit.
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 03/03/2013
% Last modified: 03/03/2013

%% Input Validation and Parsing
N=nargin;
assert(N>1,...
	'ResFileSys:FileDir:strjoin:WrongNargin',...
	'At least two input arguments are required.');
dlm=varargin{N};
assert(isstringscalar(dlm),...
	'ResFileSys:FileDir:strjoin:InvalidInput',...
	'The last input argument must be a string scalar for a delimiter.');
N=N-1;
x=varargin(1:N);

%% Join Strings
if isstringvector(x)
	y='';
	i=1;
	tf=false;
	while i<=N
		if ~isempty(x{i})
			y=strcat(y,x{i},dlm);
			tf=true;
		end
		i=i+1;
	end
	if tf
		y=y(1:end-numel(dlm));
	end
else
	A=cellfun(@isstringscalar,x);
	B=cellfun(@isstringvector,x);
	if all(A | B)
		% There must be at least one string array. Obtain their size and compare
		% for equality.
		D=cellfun(@size,x(B),'UniformOutput',false);
		if numel(D)>1
			assert(isequal(D{:}),...
				'ResFileSys:FileDir:strjoin:InvalidInput',...
				'The string arrays must have the same dimension and shape.');
		end
		
		% Expand any string scalar to a string array of the same size.
		k=find(A);
		K=numel(k);
		for i=1:K
			x{k(i)}=repmat(x(k(i)),D{1});
		end
		
		% Expand the delimiter too.
		dlm=repmat({dlm},D{1});
		
		% Finally perform recursive call.
		y=cellfun(@FileDir.strjoin,x{:},dlm,'UniformOutput',false);
	else
		error('ResFileSys:FileDir:strjoin:InvalidInput',...
			'The strings to be joined must be a string scalar or array.');
	end
end

end