function [] = funcPlot(iter, fitness, solution)
    global data reqs graphC graphU graphM graphB
    solution = round(solution);
    graphC(iter) = fitness;
    if iter > 1 && solution(1) > 0
        graphU(iter) = data(solution(1), 1);
        graphM(iter) = data(solution(1), 2);
        graphB(iter) = data(solution(1), 3);        
    end
    
    