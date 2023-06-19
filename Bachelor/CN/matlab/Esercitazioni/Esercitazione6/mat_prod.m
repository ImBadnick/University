function y=mat_prod(c,b)

n=length(b);
y=zeros(n,1);
sum=0;
for i=1:n-1
    y(i)=b(i)-b(i+1)/2;
    sum=sum+b(i);
end
y(n)=c*(sum)+b(n);
end

