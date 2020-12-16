function i=iterative_method(g_fun, x_0, tol, itr, x_interval, y_interval)
% % % % % % % % % % % % % % % % % % %  
% Plot g_fun in a cartesian plane of x_interval width 
% and show the iterative method starting from x_0 until
% |x_k - x_(k-1)| < tol or i==itr
% 
% % % % % % % % % % % % % % % % % % % 
% Parameters
% 
% g_fun             function to plot
% x_0               starting point
% tol               tollerance
% itr               number of max iterations
% x_interval        width of plot
% y_interval        height of plot
% % % % % % % % % % % % % % % % % % % 

syms x 
format long
    
    plot(x_interval, [0,0], 'k') %x-axis
    hold on
    plot([0,0], y_interval, 'k') %y-axis
    fplot(g_fun, x_interval, 'b') %plot g_func
    fplot(@(x) x, x_interval, 'k') %plot y=x function
    plot(x_0, double(subs(g_fun,x,x_0)), 'or') %plot starting point x_0
    
    i = 0; %Iteration counter
    err = inf; %Initial Error
    
    succ = double(subs(g_fun,x,x_0)); % f(x_0)
    prec = x_0; 
    
    %Saving iteration datas
    VarNames = {'k', 'x', 'fx', 'err'};
    datasave=[];
    datasave=[datasave; i, prec, succ, err];
    
    %iterative method
    while ( err>=tol  &&  i<itr )
    
        plot([prec, succ], [succ, succ], '--r') 
        prec = succ;
        succ = double(subs(g_fun,x,prec)); % f(prec)
        err = abs(succ - prec); 
        plot([prec, prec], [prec, succ], '--r') 
        
        i = i+1;
        datasave=[datasave; i, prec, succ, err]; %Saving iteration datas
    end
    plot([prec, succ], [succ, succ], '--r')
    plot(succ, succ, 'sm') % plot last found point
    axis([x_interval y_interval]) % rescaling 
    hold off
    
    T = table(datasave(:,1),datasave(:,2),datasave(:,3),datasave(:,4), 'VariableNames',VarNames);
    display(T) %Printing results
end