function [xk,k,err]=tangenti(x0,tol) 

g=@(x) 4.*log(1./x)+(1./x)-(2.*x);
gderiv=@(x) -(4./x)-(1./(x^2))-2;
h = @(x) (g(x)./gderiv(x));
nmax=100;
k=0;
err=inf;
while ((tol<err) && (k<nmax))
    x=x0-h(x0)
    err=abs(x-x0);
    k=k+1;
    x0=x;
end
xk=x;
end


