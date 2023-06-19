function f = partialsum2(n)
z=0;
for k=n:-1:1
    z = z+(1/(k^2));
end
f=z;
end

