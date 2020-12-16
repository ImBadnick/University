function [err,x,k]=JacobiIterations(alfa,b)
n=length(b);
x=zeros(n,1);
xold=zeros(n,1);
tollerance=10^(-12);
k=0;
err=inf;
while ((err>tollerance) && (k<100))
    x(1)=(-alfa)*xold(n)+b(1);
    for i=2:n
        x(i)=(-alfa)*xold(i-1)+b(i);
    end
    err=norm(x-xold,inf);
    k=k+1;
    xold=x;
end
end


