function x1=gs_step(x0,b,a)
%Implementa un passo di gs

n=length(b);
x1=zeros(n,1);
q(1)=b(1);
q(2:n)=b(2:n)-b(1:n-1);

%y=G*x0
y=zeros(n,1);
y(1)=-a*x0(2);
for i=2:n-1
    y(i)=a*(x0(i)-x0(i+1));
end
y(n)=a*x0(n);

x(1)=y+q;

end