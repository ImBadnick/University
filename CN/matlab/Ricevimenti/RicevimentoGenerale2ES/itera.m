function [xk,k]=itera(x0,tol)

g=@(x) exp(-x);
nmax=100;
k=0;
err=inf;
while ((err>tol) && (k<nmax))
    x=g(x0);
    err=abs(x-x0);
    k=k+1;
    x0=x;
end
xk=x;
end