function [xk,k,err]=SecantMethod(f,x0,x1,tol, itr, x_interval,y_interval)

% Plot the function f and the iterations of secant method starting from x0,x1 until
% |x_k - x_(k-1)| < tol or k>=nmax
    
% f = function
% x_0 = First starting point
% x_1 = Second starting point
% tol = tolerance
% x_interval        width of plot
% y_interval        height of plot


syms x

nmax=itr; %Number of iterations
err = inf; %Initial error
k=0; %Iteration counter

plot(x_interval, [0,0], 'k') %x-axis
hold on
plot([0,0], y_interval, 'k') %y-axis
fplot(f,x_interval,'b') %plot f
y0 = double(subs(f,x,x0)); %Calculating f(x0)
y1 = double(subs(f,x,x1)); %Calculating f(x1)
plot([x0,x0],[0,y0],'r')
plot([x1,x1],[0,y1],'r')

%Saving datas
VarNames = {'k', 'x', 'fx', 'err'};
datasave=[];
datasave=[datasave; k, x1, y1, err];

while ((tol<err) && k<nmax)
    color=rand(1,3); %Random color for grafic visualization
    fx0 = subs(f,x,x0); %Calculating f(x0)
    fx1 = subs(f,x,x1); %Calculating f(x1)
    m = (fx1-fx0)/(x1-x0); %Calculating m
    if (fx1==0)
        break
    end
    x0 = x1;
    x1=eval(x1-(fx1/m)); %Calculating the new x1
    err = abs(x1-x0);
    %Grafic visualization of the iteration 
    plot([x1,x1], [0, double(subs(f,x,x1))],'--','color',color) 
    plot([x0,x1], [double(subs(f,x,x0)),0],'--','color',color)
    y1 = double(subs(f,x,x1));
    k=k+1;
    datasave=[datasave; k, x1, y1, err]; %Saving datas
end

axis([x_interval y_interval]) % rescaling 
hold off
T = table(datasave(:,1),datasave(:,2),datasave(:,3),datasave(:,4), 'VariableNames',VarNames);
display(T) %Displaying results
end


