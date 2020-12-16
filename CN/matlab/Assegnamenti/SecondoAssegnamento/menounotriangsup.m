function x=menounotriangsup(b)

n=length(b);
x=zeros(n,1);
x(n)=b(n);
sum=0;
for i=n-1:-1:1
    x(i)=b(i)+x(i+1)+sum;
    sum=x(i+1)+sum;
end
end