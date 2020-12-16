function x=newton(p,x0)

dp=derivate(p);
px=horner(p,x0);
x=x0;
while abs(px)>10^-12
    dx=horner(dp,x);
    x=x-px/dx;
    px=horner(p,x);
end
end