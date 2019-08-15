%LSPB  Linear segment with parabolic blend
%
% [S,SD,SDD] = LSPB(S0, SF, M) is a scalar trajectory (Mx1) that varies
% smoothly from S0 to SF in M steps using a constant velocity segment and
% parabolic blends (a trapezoidal velocity profile).  Velocity and
% acceleration can be optionally returned as SD (Mx1) and SDD (Mx1)
% respectively.
%
% [S,SD,SDD] = LSPB(S0, SF, M, V) as above but specifies the velocity of 
% the linear segment which is normally computed automatically.

function [x,s,sd,sdd,dir] = lspb(x0,y0,q0, q1, t, V, x_vel, c_vel, plan_choice)

    if isscalar(t)
        t = (0:t-1)';
    else
        t = t(:);
    end

    tf = max(t(:));
    fprintf('tf is %d',tf);
    
    if nargin < 4
        % if velocity not specified, compute it
        V = (q1-q0)/tf * 1.5;
    else
        V = abs(V) * sign(q1-q0); % 判断实际速度符号
        if abs(V) < abs(q1-q0)/tf
            error('V too small');
        elseif abs(V) > 2*abs(q1-q0)/tf
            error('V too big');
        end
    end
    
    if q0 == q1      % 目标位置和起始位置相同            
        s = ones(size(t)) * q0;
        sd = zeros(size(t));
        sdd = zeros(size(t));
        return
    end

    tb = (q0 - q1 + V*tf)/V;  % 计算匀加减速段时间
    fprintf('tb is %e',tb);
    a = V/tb;

    s = zeros(length(t), 1);
    sd = s;
    sdd = s;
    
    for i = 1:length(t)
        tt = t(i);

        if tt <= tb           % 匀加速段
            % initial blend
            s(i) = q0 + a/2*tt^2;
            sd(i) = a*tt;
            sdd(i) = a;
        elseif tt <= (tf-tb)  % 匀速段
            % linear motion
            s(i) = (q1+q0-V*tf)/2 + V*tt;
            sd(i) = V;
            sdd(i) = 0;
        else                  % 匀减速段
            % final blend
            s(i) = q1 - a/2*tf^2 + a*tf*tt - a/2*tt^2;
            sd(i) = a*tf - a*tt;
            sdd(i) = -a;
        end
    end
    
    %plot route/time charts
    subplot(331);
    plot(t,s)
    hold on
    plot(t,s,'k*');
    xlabel('t/s'),ylabel('y-distance (m)')
    hold off
    
    %plot speed/time charts
    subplot(332);
    plot(t,sd)
    hold on
    plot(t,sd,'k*');
    xlabel('t/s'),ylabel('y-speed (m/s)')
    hold off
    
    %plot acceleration/time charts
    subplot(333);
    plot(t,sdd)
    hold on
    plot(t,sdd,'k*');
    xlabel('t/s'),ylabel('y-acceleration (m/s2)')
    hold off
    
    %plan1 设x方向的速度不变
    if plan_choice == 0
       x_vel = x_vel*ones(length(t),1);
       d_angle = atan2(sd,x_vel);
       dir = d_angle;
       subplot(334);
       plot(t,d_angle);
       xlabel('t'), ylabel('direction angle/degrees')
       hold on
       plot(t,d_angle,'k*');
       hold off
       x = ones(length(t),1);
       for i=1:(length(t))
           x(i)=t(i)*x_vel(i);
       end
       subplot(335);
       plot(x,s);
       xlabel('x'),ylabel('y');
       hold on
       plot(x,s,'-o');
       hold off
       
       for i=1:length(x)
           x(i)= x0 + x(i);
           s(i)= y0 + s(i);
       end
       subplot(336)
       plot(x,s,'-o');
       
    end
                
    %plan2 设总速度值不变
    if plan_choice == 1
       c_vel = c_vel*ones(length(t),1);
       x_vel = zeros(length(t),1);
       for j=1:length(t)
           x_vel(j)=sqrt(c_vel(j)^2-sd(j)^2);
       end
       d_angle = atan2(sd,x_vel);
       dir = d_angle;
       subplot(337);
%        fprintf('我操！\n');
       plot(t,d_angle);
       xlabel('t'),ylabel('direction angle/degrees')
       hold on
       plot(t,d_angle,'k*')
       hold off
    end
end
    