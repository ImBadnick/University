function [xk,k,err]=Corda(f,x0,tol, itr, x_interval,y_interval)
    
% f = function
% x_0 = starting point
% tol = tolerance
% x_interval        width of plot
% y_interval        height of plot

syms x

nmax=itr; %Number of iterations
err = inf; %Initial error
k=0; %Iteration counter

fderiv = diff(f); %Derivative of f
m = subs(fderiv,x,x0);

if(abs(m)==0)
    return
end

plot(x_interval, [0,0], 'k') %x-axis
hold on
plot([0,0], y_interval, 'k') %y-axis
fplot(f,x_interval,'b') %plot f
y0 = double(subs(f,x,x0)); %Calculating f(x0)
plot(x0, y0,'or') %plot starting point (x0,f(x0))
plot([x0,x0],[0,y0],'r')

%Saving datas
VarNames = {'k', 'x', 'fx', 'err'};
datasave=[];
datasave=[datasave; k, x0, y0, err];

while ((tol<err) && k<nmax)
    color=rand(1,3); %Random color for grafic visualization
    fx = subs(f,x,x0); %Calculating f(x)
    xk=double(x0-(fx/m)); %Calculating x(k+1)=x(k)- f(xk)/f'(xk)
    plot([xk,xk], [0, double(subs(f,x,xk))],'--','color',color) 
    plot([x0,xk], [double(subs(f,x,x0)),0],'--','color',color)
    err = abs(xk-x0);
    x0=xk;
    y0 = double(subs(f,x,x0));
    plot(x0, y0,'or','color',color) %%plot point (x(k+1),f(x(k+1)))
    k=k+1;
    datasave=[datasave; k, x0, y0, err]; %Saving datas
end
axis([x_interval y_interval]) % rescaling 
hold off
T = table(datasave(:,1),datasave(:,2),datasave(:,3),datasave(:,4), 'VariableNames',VarNames);
display(T) %Displaying datas
end


