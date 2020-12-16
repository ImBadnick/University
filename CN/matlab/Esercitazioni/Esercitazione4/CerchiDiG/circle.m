function circle(center,radius)
t=linspace(0,2*pi);
plot(real(center)+radius*cos(t),imag(center)+radius*sin(t));
axis('equal');
end