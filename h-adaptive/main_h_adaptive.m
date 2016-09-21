function [local, orimesh, nitaErrorMean] = main_h_adaptive()
clear;

orimesh = [ 1 1000 2000;...
    2 0 2000;...
    3 0 0;...
    4 2000 0;...
    5 2000 1000];
centrecoord=[1000 1000];
nitaErrorMean = [];

tic();
for iRepeat = 1:5
    
    p = ones( size(orimesh, 1)-1, 1);
    [supel] = initialize_problem(orimesh, centrecoord, p);
%     [supel1] = initialize_problem(orimesh, centrecoord, p);
%     [supel2] = initialize_problem(orimesh, centrecoord, p+ones(size(p)));

    [local,supel,globnodesdisp] = today3_modify(p, supel);
    [ deltaError, energyStress, nitaError] = error_calculate2(p, local, supel, globnodesdisp);
%     [localcoarse,refineIdx,deltaerror,rhs65,error1,rhs66,errest]= main21_modify(p, supel1, supel2)

    orimesh
    nitaError
    nitaErrorMean = [nitaErrorMean, sum(nitaError)*100]
    refineIdx = 100*nitaError > 10;
    if max(refineIdx) == 0
        break;
    end
    newNodeIdx = size(orimesh, 1);
    for iRefineIdx = numel(refineIdx):-1:1
        if refineIdx(iRefineIdx) == 1
            newNodeIdx = newNodeIdx + 1;
            newNode = [ newNodeIdx, mean(orimesh(iRefineIdx:iRefineIdx+1, 2:3)) ];
            orimesh = [ orimesh(1:iRefineIdx, :); newNode; orimesh(iRefineIdx+1:end, :)];
        end
    end
    
end
toc();
end