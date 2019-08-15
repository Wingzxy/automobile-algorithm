%迪杰斯特拉（单源）
%     最短距离 ，路径    距离矩阵 起始点 结束点
 function [res,index] = Djsk(mp,stat,ends)
     n=size(mp,1);
     %初始化
     bj=zeros(n,1); %标记初始化
     dis=mp(stat,:); %各点最短路距离初始化   
     path=ones(n,1),path=path.*stat;%各点最短路路径初始化 
     dis(stat)=0;bj(stat)=1;
   for i=1:n 
     min=Inf; k=1;%局部初始化
      for j=1:n %从未找到最短路径点集合中找一个路径最短的点
       if (bj(j)~=1)&&(dis(j)<min),min=dis(j);k=j;end
      end
       bj(k)=1;%标记已找到的点的最短路径
       for j=1:n %用但前最短路节点更新未找到最短路的节点（同时更新各点路径的前一个点，即父节点） 
           if (bj(j)~=1)&&(dis(j)>(dis(k)+mp(k,j))), dis(j)=dis(k)+mp(k,j);path(j)=k;end
       end
   end
%对要求最短路径进行处理   
tem=ends;index(1)=ends;i=2;
while path(tem)~=stat
    index(i)=path(tem);
    tem=path(tem);
    i=i+1;
end
index(i)=stat;index=index(length(index):-1:1);res=dis(ends);
end
