clc,clear
global N M D  PopCon name gen

N = 400;                        % 种群个数
M = 3;                          % 目标个数
name = 'DTLZ1';                 % 测试函数选择，目前只有：DTLZ1、DTLZ2、DTLZ3
gen = 500;                      %迭代次数
%% Generate the reference points and random population
[Z,N] = UniformPoint(N,M);        % 生成一致性参考解
[res,Population,PF] = funfun(); % 生成初始种群与目标值
Pop_objs = CalObj(Population); % 计算适应度函数值
Zmin  = min(Pop_objs(all(PopCon<=0,2),:),[],1); %求理想点，其实PopCon是处理有约束问题的，这里并没有用到

%% Optimization
for i = 1:gen
    MatingPool = TournamentSelection(2,N,sum(max(0,PopCon),2));
    Offspring  = GA(Population(MatingPool,:));
    Offspring_objs = CalObj(Offspring);
    Zmin       = min([Zmin;Offspring_objs],[],1);
    Population = EnvironmentalSelection([Population;Offspring],N,Z,Zmin);
    Popobj = CalObj(Population);
    if(M<=3)
        plot3(Popobj(:,1),Popobj(:,2),Popobj(:,3),'ro')
        title(num2str(i));
        drawnow
    end
end
if(M<=3)
    hold on
    plot3(PF(:,1),PF(:,2),PF(:,3),'g*')
else
    for i=1:size(Popobj,1)
        plot(Popobj(i,:))
        hold on
    end
end
%%IGD
score = IGD(Popobj,PF)