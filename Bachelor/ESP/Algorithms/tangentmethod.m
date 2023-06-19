function [xk,k,err]=tangentmethod(f,x0,tol, itr, x_interval,y_interval)

% Plot the function f and the iterations of tangent iterate method starting from x0 until
% |x_k - x_(k-1)| < tol or k>=nmax
    
% f = function (es: 4*log(1/x) - 2*x + 1/x)
% x_0 = starting point
% tol = tolerance
% x_interval        width of plot
% y_interval        height of plot


syms x 
format long

nmax=itr; %Number of iterations
err = inf; %Initial error
k=0; %Iteration counter

fderiv = diff(f); %Derivative of f

plot(x_interval, [0,0], 'k') %x-axis
hold on
plot([0,0], y_interval, 'k') %y-axis
fplot(f,x_interval,'b') %plot f
y0 = double(subs(f,x,x0));
plot(x0, y0,'or') %plot starting point (x0,f(x0))
plot([x0,x0],[0,y0],'r')

%Saving datas
VarNames = {'k', 'x', 'fx', 'err'};
datasave=[];
datasave=[datasave; k, x0, y0, err];

while ((tol<err) && k<nmax)
    color=rand(1,3); %Random color for grafic visualization
    fx = subs(f,x,x0); %Calculating f(x)
    fdx = subs(fderiv,x,x0); %Calculating f'(x)
    if (abs(fdx)==0)
        break
    end
    xk=double(x0-(fx/fdx)); %Calculating x(k+1)=x(k)- f(xk)/f'(xk)
    %Plotting the grafic visualization of iteration
    plot([xk,xk], [0, double(subs(f,x,xk))],'--','color',color) 
    plot([x0,xk], [double(subs(f,x,x0)),0],'--','color',color)
    err = abs(xk-x0);
    x0=xk;
    y0 = double(subs(f,x,x0));
    plot(x0, y0,'or','color',color) %%plot point (x(k+1),f(x(k+1)))
    %fplot(tangent,x_interval,'color',color);
    k=k+1;
    datasave=[datasave; k, x0, y0, err]; %Saving datas
end
axis([x_interval y_interval]) % rescaling 
hold off
T = table(datasave(:,1),datasave(:,2),datasave(:,3),datasave(:,4), 'VariableNames',VarNames);
display(T) %Displaying datas
end


