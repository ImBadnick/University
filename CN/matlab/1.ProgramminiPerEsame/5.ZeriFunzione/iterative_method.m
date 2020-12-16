function i=iterative_method(g_fun, x_0, tol, itr, x_interval, y_interval)
% % % % % % % % % % % % % % % % % % % 
% Abstract
% 
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


    fplot(g_fun, x_interval, 'b') %plot g_func
    hold on
    fplot(@(x) x, x_interval, 'k') %plot y=x function
    plot(x_interval, [0,0], 'k') %x-axis
    plot([0,0], y_interval, 'k') %y-axis
    plot(x_0, g_fun(x_0), 'or') %plot starting point x_0
    
    i = 0;
    succ = g_fun(x_0);
    prec = x_0;
    
    %iterative method
    while ( abs(succ - prec)>=tol  &&  i<itr )
    
        plot([prec, succ], [succ, succ], '--r')
        
        prec = succ;
        succ = g_fun(prec);
        
        plot([prec, prec], [prec, succ], '--r') 
        
        i = i+1;
        
    end
    plot([prec, succ], [succ, succ], '--r')
    
    plot(succ, succ, 'sm') % plot last found point
    axis([x_interval y_interval]) % rescaling 
    hold off
end