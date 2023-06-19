function x=calcU(alfa,b)

n=length(b);
x=zeros(n,1);
x(n)=b(n)/(1+alfa);

for i=n-1:-1:1
    x(i)=b(i)+x(i+1);
end
end
