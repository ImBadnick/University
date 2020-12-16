function [xk,k]=tangentmethod(f,x0,tol, itr, x_interval,y_interval)

% Plot the function f and the iterations of tangent iterate method starting from x0 until
% |x_k - x_(k-1)| < tol or k>=nmax
    
% f = function (es: 4*log(1/x) - 2*x + 1/x)
% x_0 = starting point
% tol = tolerance
% x_interval        width of plot
% y_interval        height of plot


syms x 

nmax=itr; %Number of iterations

fderiv = diff(f); %Derivative of f
h = f/fderiv; % f(x)/f'(x)

%tangent = double(subs(fderiv,x,x0))*x+double(subs(f,x,x0))-double(subs(fderiv,x,x0))*x0;

fplot(f,x_interval,'b') %plot f
hold on
plot(x_interval, [0,0], 'k') %x-axis
plot([0,0], y_interval, 'k') %y-axis
plot(x0, double(subs(f,x,x0)),'or') %plot starting point (x0,f(x0))
%fplot(tangent,x_interval,'r'); % f's tangent in x0
 
err = inf;
k=0;
while ((tol<err) && k<nmax)
    color=rand(1,3);
    xk=double(x0-subs(h,x,x0)); %Calculating x(k+1)=x(k)- f(xk)/f'(xk)
    plot([xk,xk], [0, double(subs(f,x,xk))],'--','color',color) 
    plot([x0,xk], [double(subs(f,x,x0)),0],'--','color',color)
    err = abs(xk-x0);
    x0=xk;
    %tangent = double(subs(fderiv,x,x0))*x+double(subs(f,x,x0))-double(subs(fderiv,x,x0))*x0;
    plot(x0, double(subs(f,x,x0)),'or','color',color) %%plot point (x(k+1),f(x(k+1)))
    %fplot(tangent,x_interval,'color',color);
    k=k+1;
end
end


