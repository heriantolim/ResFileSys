function varargout=collapselist(varargin)
%% Collapse List
%  [B1,B2,...]=FileDir.colapselist(A1,A2,...) collapses the vector Ai into a
%  scalar value if all elements of Ai are equal.
%
% Tested on:
%  - MATLAB R2013b
%  - MATLAB R2015b
%
% See also: expandlist, isemptylist.
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 20/04/2013
% Last modified: 20/04/2013

O=max(1,nargout);
varargout=cell(1,O);

if nargin==0
	return
end

k=0;
while k<nargin && k<O
	k=k+1;
	varargout{k}=varargin{k};
	if ~ischar(varargin{k})
		N=numel(varargin{k});
		if isvector(varargin{k}) && N>1 ...
				&& all(arrayfun(@(x) isequal(x,varargin{k}(1)),varargin{k}(2:N)))
			varargout{k}=varargin{k}(1);
		end
		if iscell(varargout{k}) && numel(varargout{k})==1
			varargout(k)=varargout{k};
		end
	end
end  

end