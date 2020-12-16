function img=newtonfractal(k)

range=linspace(-2,2,k);
p=[1,0,0,1];
img=zeros(k,k);
for s=1:k
    for t=1:k
        z0=range(t)+1i*range(s);
        rad=newton(p,z0);
        img(s,t)=decidi(rad);
    end
end
end