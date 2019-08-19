clear all 
clc

%% import data
global data reqs graphC graphU graphM graphB
data = csvread('data.csv');
reqs = csvread('reqs.csv');

%% algorithm
NumberOfSolutions=30; % Number of search agents
Max_iteration=20; % Maximum numbef of iterations
lb = 1;
ub = size(data, 1);
dim = 1;
fobj=@fitnessFunc;
[Best_score,Best_pos,WOA_cg_curve,Positions]=WOA(NumberOfSolutions,Max_iteration,lb,ub,dim,fobj);

%% result
selected_node = round(Best_pos);
display(['The best solution obtained by WOA is : ', num2str(round(Best_pos))]);
display(['The best optimal value of the objective funciton found by WOA is : ', num2str(Best_score)]);
disp(['U:' num2str(data(selected_node,1)) ', M:' num2str(data(selected_node,2)) ', B:' num2str(data(selected_node,3))]);

fitnesses = zeros(1, NumberOfSolutions);
for i = 1:NumberOfSolutions
    fitnesses(i) = fobj(Positions(i,:));
end
[sv, si] = sort(fitnesses);
BestNodes = zeros(1,NumberOfSolutions);
FinalNodes = [];
for i = 1:NumberOfSolutions
    BestNodes(i) = round(Positions(si(i),:));
    flag = 0;
    for j = 1 : length(FinalNodes)
        if BestNodes(i) == FinalNodes(j)
            flag = 1;
            break;
        end
    end
    if flag == 0
        FinalNodes(end+1) = BestNodes(i);
    end
end
csvwrite('BestNodes.csv', FinalNodes');

