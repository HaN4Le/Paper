clc,clear
global N M D  PopCon name gen

N = 400;                        % ��Ⱥ����
M = 3;                          % Ŀ�����
name = 'DTLZ1';                 % ���Ժ���ѡ��Ŀǰֻ�У�DTLZ1��DTLZ2��DTLZ3
gen = 500;                      %��������
%% Generate the reference points and random population
[Z,N] = UniformPoint(N,M);        % ����һ���Բο���
[res,Population,PF] = funfun(); % ���ɳ�ʼ��Ⱥ��Ŀ��ֵ
Pop_objs = CalObj(Population); % ������Ӧ�Ⱥ���ֵ
Zmin  = min(Pop_objs(all(PopCon<=0,2),:),[],1); %������㣬��ʵPopCon�Ǵ�����Լ������ģ����ﲢû���õ�

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