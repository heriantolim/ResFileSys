function y=num2str(x)
%% Convert Numeric to String
%  y=FileDir.num2str(x) converts all real elements in x into a formatted string.
%  Decimal point is replaced with the letter p, negative sign with the letter n,
%  and positive sign with an empty char.
%
% Tested on:
%  - MATLAB R2017b
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 26/03/2018
% Last modified: 26/03/2018

if isrealarray(x)
	if isscalar(x)
		y=regexprep(sprintf('%g',x),{'\.','-','+'},{'p','n',''});
	else
		y=arrayfun(@FileDir.num2str,x,'UniformOutput',false);
	end
else
	if iscell(x)
		for i=1:numel(x)
			x{i}=FileDir.num2str(x{i});
		end
	end
	y=x;
end

end