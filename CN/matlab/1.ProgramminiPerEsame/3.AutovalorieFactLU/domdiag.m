function flag = domdiag( A, strOpt )
%
% DOMDIAG Check if a matrix is (strictly) diagonally dominant.
%   The input matrix is tested in order to know if its diagonal is
%   dominant.
%   A matrix has a dominant diagonal if for each row the magnitude of the
%   diagonal is greater or equal to the sum of the magnitudes of all the
%   other values in that row.
%   A matrix has a strcitly dominant diagonal if it has a dominant diagonal
%   and at least the magnitude of one diagonal element is greater than the 
%	sum of the magnitudes of the other elements of that row
%
% Input:
%	A - input matrix
%   strOpt - 'strict' to check if matrix is strictly diagonally dominant
%            otherwise only diagonal dominance is tested
%
% Output:
%   flag - indicates if matrix has a dominant diagonal (1) or not (0)
%
% Examples:
%   domdiag( [ .5 .125; .125 .25] )
%       returns 1
%   domdiag( [ .5 1; .125 .25] )
%       returns 0
%   domdiag([ 3 -2 1; 1 -3 2; -1 2 3 ])
%       returns 1
%   domdiag([ 3 -2 1; 1 -3 2; -1 2 3 ], 'strict')
%       returns 0
%
% Author:   Tashi Ravach
% Version:  1.1
%           * H1 is now in the correct position.
%           * More efficient (vectorized) implementation.
%           * Output is now returned as LOGICAL.
%           * Input can now be tested for diagonal dominance or strict 
%             diagonal dominance.
% Date:     20/07/2010
%
% Note: Improvements where suggested by Jan Simon:
%       http://www.mathworks.com/matlabcentral/fileexchange/authors/15233
%

    if nargin == 1
        strOpt = ''; % by default check only for diagonal dominance
    elseif nargin ~= 2
        error('domdiag: invalid input parameters');
    end
    
    [ m , n ] = size(A);
    if m ~= n
        error('domdiag: input matrix must have dimension rows==cols');
    end

    % magnitude of the diagonal
    absDiag  = abs(diag(A));
    
    % sum of the magnitude of the elements of each row exept the diagonal
    % element
    absElem = sum(abs(A), 2) - absDiag;
    
    % check if each row has diagonal magnitude greater or equal to the sum 
    % of magnitudes of its other values
    flag = all(absElem <= absDiag);
    
    % check if each row has diagonal magnitude greater or equal to the sum 
    % of magnitudes of its other values, and at least the magnitude of one
    % diagonal element is greater than the sum of the magnitudes of the
    % other elements of that row
    if strcmpi(strOpt, 'strict') && flag == true
        flag = any(absElem  < absDiag);
    end
    
end
