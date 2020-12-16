function f = pow(x,n)
%Calcola x^n
z=x;
for i=2:n
   z=z*x;
end
f=z;
end

