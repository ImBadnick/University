function A=laplace2v2(n)
A=2*eye(n)-diag(ones(n-1,1),-1)-diag(ones(n-1,1),1);
end