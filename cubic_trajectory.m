%���ζ���ʽ�Ĺ켣�滮
%֧���м�·����
%��Ҫ����Ĳ���Ϊ�����յ��λ��   �����յ���ٶ� �����յ��ʱ�䣬x����ķ��ٶȣ������ٶ� һ��10������ ��9�����������Ƿ���Ҫ��ͼ
%1��ʾ��ͼ 0��֮����10��������ʾ���ĸ�����ͼ��0��ʾ��x�����ٶȲ���ģ�1��ʾ�����ٶȲ����...
%plot_choice �����Ƿ�Ҫ����������ͼ��
function [p,sd,sdd,t]=cubic_trajectory(i_pos,f_pos,i_vel,f_vel,x_vel,c_vel,i_t,f_t,plot_choice,plan_choice)
		h=f_pos-i_pos;
		T=f_t-i_t;
		a0=i_pos;
		a1=i_vel;
		a2=(3*h-(2*i_vel+f_vel)*T)/(T^2);
		a3=(-2*h+(i_vel+f_vel)*T)/(T^3);
 
		%��ʼ��ͼ
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
        
        %plan1 ��x������ٶȲ���
        if plan_choice == 0
            x_vel = x_vel*ones(1,len);
            d_angle = atan2(sd,x_vel);
            subplot(224);
            plot(t,d_angle);
            xlabel('t'), ylabel('direction angle/degrees')
            hold on
            plot(t,d_angle,'k*');
        end
                
        %plan2 �����ٶ�ֵ����
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
		%λ��ͼ��
		subplot(221);
        %axis on;
		plot(t,p);
        hold on 
        plot(t,p,'k*');
        xlabel('t'), ylabel('pos')
        hold off
        
		%�ٶ�ͼ��
		subplot(222);
        %axis on;
		plot(t,sd);
        xlabel('t'), ylabel('speed')
 
		%���ٶ�ͼ��
		subplot(223);
        %axis on;
		plot(t,sdd);
        xlabel('t'), ylabel('acceleration')
		end
end