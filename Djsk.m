%�Ͻ�˹��������Դ��
%     ��̾��� ��·��    ������� ��ʼ�� ������
 function [res,index] = Djsk(mp,stat,ends)
     n=size(mp,1);
     %��ʼ��
     bj=zeros(n,1); %��ǳ�ʼ��
     dis=mp(stat,:); %�������·�����ʼ��   
     path=ones(n,1),path=path.*stat;%�������··����ʼ�� 
     dis(stat)=0;bj(stat)=1;
   for i=1:n 
     min=Inf; k=1;%�ֲ���ʼ��
      for j=1:n %��δ�ҵ����·���㼯������һ��·����̵ĵ�
       if (bj(j)~=1)&&(dis(j)<min),min=dis(j);k=j;end
      end
       bj(k)=1;%������ҵ��ĵ�����·��
       for j=1:n %�õ�ǰ���·�ڵ����δ�ҵ����·�Ľڵ㣨ͬʱ���¸���·����ǰһ���㣬�����ڵ㣩 
           if (bj(j)~=1)&&(dis(j)>(dis(k)+mp(k,j))), dis(j)=dis(k)+mp(k,j);path(j)=k;end
       end
   end
%��Ҫ�����·�����д���   
tem=ends;index(1)=ends;i=2;
while path(tem)~=stat
    index(i)=path(tem);
    tem=path(tem);
    i=i+1;
end
index(i)=stat;index=index(length(index):-1:1);res=dis(ends);
end
