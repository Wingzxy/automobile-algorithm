%三次多项式的轨迹规划
%支持中间路径点
%需要填入的参数为起点和终点的位置   起点和终点的速度 起点和终点的时间，x方向的分速度，整车速度 一共10个参数 第9个参数决定是否需要画图
%1表示画图 0反之，第10个参数表示画哪个方向图像，0表示画x方向速度不变的，1表示画总速度不变的...
%plot_choice 决定是否要画出函数的图像
function [p,sd,sdd,t]=cubic_trajectory(i_pos,f_pos,i_vel,f_vel,x_vel,c_vel,i_t,f_t,plot_choice,plan_choice)
		h=f_pos-i_pos;
		T=f_t-i_t;
		a0=i_pos;
		a1=i_vel;
		a2=(3*h-(2*i_vel+f_vel)*T)/(T^2);
		a3=(-2*h+(i_vel+f_vel)*T)/(T^3);
 
		%开始画图
        t=i_t:0.4:(f_t);
        len=length(t);
        p=zeros(1,len);
        sd=zeros(1,len);
        sdd=zeros(1,len);
        
        for i=1:len
            p(i)=a0+a1*(t(i)-i_t)+a2*(t(i)-i_t)^2+a3*(t(i)-i_t)^3;
            sd(i)=a1 + a2*(2*t(i) - 2*i_t) + 3*a3*(t(i) - i_t)^2;
            sdd(i)=2*a2 + 3*a3*(2*t(i) - 2*i_t);
        end
        
        %plan1 设x方向的速度不变
        if plan_choice == 0
            x_vel = x_vel*ones(1,len);
            d_angle = atan2(sd,x_vel);
            subplot(224);
            plot(t,d_angle);
            xlabel('t'), ylabel('direction angle/degrees')
            hold on
            plot(t,d_angle,'k*');
        end
                
        %plan2 设总速度值不变
        if plan_choice == 1
            c_vel = c_vel*ones(1,len);
            for j=1:len
                x_vel(j)=sqrt(c_vel(j)^2-sd(j)^2);
            end
            d_angle = atan2(sd,x_vel);
            subplot(224);
            plot(t,d_angle);
            xlabel('t'),ylabel('direction angle/degrees')
            hold on
            plot(t,d_angle,'k*');
        end
        
        if  plot_choice > 0
		%位置图像
		subplot(221);
        %axis on;
		plot(t,p);
        hold on 
        plot(t,p,'k*');
        xlabel('t'), ylabel('pos')
        hold off
        
		%速度图像
		subplot(222);
        %axis on;
		plot(t,sd);
        xlabel('t'), ylabel('speed')
 
		%加速度图像
		subplot(223);
        %axis on;
		plot(t,sdd);
        xlabel('t'), ylabel('acceleration')
		end
end