function y=diagnmeno1other(n,b)
y=ones(n,1);
sum=0;
for i=1:n
    sum=sum+b(i);
end
for i=1:n
    y(i)=b(i)*(n+1);
end
b(1:n)=sum;
y=y-b;
end