function [ fitness ] = fitnessFunc( solution )
    global data reqs
    
    solution = round(solution);
    
    nodeid = solution(1);
    u = data(nodeid, 1);
    m = data(nodeid, 2);
    b = data(nodeid, 3);
    
    reqid = 1;
    mr = reqs(reqid, 1);
    br = reqs(reqid, 2);
    
    if mr > m
        m = -inf;
    else
        m = abs(mr - m);
    end
    
    if br > b
        b = -inf;
    else
        b = abs(br - b);
    end
    
    fitness = u + (-m) + (-b);
