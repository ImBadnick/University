function [xk,k,err]=bisection(f,tol, itr, a, b, x_interval,y_interval)

% Plot the function f and the iterations of bisection method starting from interval [a,b] until
% |x_k - x_(k-1)| < tol or k>=nmax or f(c)~=0
    
% f = function
% tol = tolerance
% itr = Max number of iterations
% [a,b] = Initial interval of bisection
% x_interval        width of plot
% y_interval        height of plot


syms x 
format long

nmax=itr; %Number of iterations
err = inf; %Initial error
k=0; %Iteration counter

c = (a+b)/2; %Interval's middle point
%Calculating function in a,b,c
fa = double(subs(f,x,a)); 
fb = double(subs(f,x,b));
fc = double(subs(f,x,c));

if (fa*fb>=0) %There aren't zeroes in the interval
    disp("The function doesn't pass from zero")
    return
end

plot(x_interval, [0,0], 'k') %x-axis
hold on
plot([0,0], y_interval, 'k') %y-axis
fplot(f,x_interval,'b') %plot f
plot([a,a], [0,fa],'r') %Plotting red line from 0 to f(a)
plot([b,b], [0,fb],'r') %Plotting red line from 0 to f(b)

%Results container
VarNames = {'k', 'a', 'b', 'x', 'err'};
datasave=[];
datasave=[datasave; k, a, b, c, err];

while ((tol<err) && k<nmax && fc ~=0)
    %Checking if update a or b
    if (fa*fc <= 0) 
        b=c; 
        fb = fc;
        plot([b,b], [0,fb],'r') %Plotting red line from 0 to f(b)
    else
        a=c; 
        fa = fc;
        plot([a,a], [0,fa],'r') %Plotting red line from 0 to f(a)
    end
    %Result approximation
    c = (a+b)/2;
    fc = double(subs(f,x,c));
    err = abs(b-a);
    k=k+1;
    datasave=[datasave; k, a, b, c, err]; %Saving iteration results
end
axis([x_interval y_interval]) % rescaling 
hold off
T = table(datasave(:,1),datasave(:,2),datasave(:,3),datasave(:,4),datasave(:,5), 'VariableNames',VarNames);
display(T) %Displaying iteration results
end


