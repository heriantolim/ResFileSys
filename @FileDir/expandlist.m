function varargout=expandlist(varargin)
%% Expand List
%  [B1,B2,...]=FileDir.expandlist(A1,A2,...)
%  [B1,B2,...]=FileDir.expandlist(A1,A2,...,numItems)
%
% Requires package:
%  - MatCommon_v1.0.0+
%
% Tested on:
%  - MATLAB R2013b
%  - MATLAB R2015b
%
% See also: collapselist, isemptylist.
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 20/04/2013
% Last modified: 20/04/2013

N=nargin;
O=max(1,nargout);
varargout=cell(1,O);

if N==0
	return
end

maxNumItems=0;
if N>O && isintegerscalar(varargin{N}) && varargin{N}>0
	maxNumItems=varargin{N};
	N=N-1;
	varargin=varargin(1:N);
end

N=min(N,O);
numItems=zeros(1,N);
for k=1:N
	if ischar(varargin{k})
		varargin{k}=varargin(k);
	end
	numItems(k)=numel(varargin{k});
end

if maxNumItems==0
	maxNumItems=max(numItems);
end

varargout(1:N)=varargin(1:N);

if maxNumItems~=1
	for k=1:N
		if numItems(k)==1
			varargout{k}=repmat(varargout{k},1,maxNumItems);
		elseif numItems(k)~=maxNumItems
			error('ResFileSys:FileDir:InconsistentNumItems',...
				'The number of items in each list is not consistent.');
		end
	end
end 

end