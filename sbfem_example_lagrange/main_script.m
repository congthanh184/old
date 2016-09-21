clear;
% tempCoord = linspace(1000, 0, 5);
% temp1 = tempCoord(2:end);
% horiElem = [fliplr(tempCoord); 1000*ones(size(tempCoord))];
% vertElem = [1000*ones(size(temp1)); temp1];
% orimesh = [horiElem'; vertElem'];
% orimesh = [[1:1:size(orimesh, 1)]', orimesh];
% centrecoord=[0 0];
% p = ones( size(orimesh, 1)-1, 1);

% tempCoord = linspace(1000, 0, 5);
% temp1 = tempCoord(2:end);
% xElem = [1000*ones(size(tempCoord)), temp1];
% yElem = [fliplr(tempCoord), 1000*ones(size(temp1))];
% orimesh = [xElem(:), yElem(:)];
% orimesh = [[1:1:size(orimesh, 1)]', orimesh];
% centrecoord=[0 0];
orimesh = [ 1 1000 2000; ...    
    2 0 2000; ...
    6 0 1000; ...
    3 0 0; ...
    7 1000 0; ...
    4 2000 0; ...
    5 2000 1000];
centrecoord=[1000 1000];
% orimesh = refinemesh(orimesh, 2)
p = 2*ones( size(orimesh, 1)-1, 1);

% tempCoord = linspace(1000, 0, 5);
% temp1 = tempCoord(1:end);
% xElem = [tempCoord, 0, 1000*ones(size(temp1))];
% yElem = [1000*ones(size(tempCoord)), 0, fliplr(temp1)];
% orimesh = [xElem', yElem'];
% orimesh = [[1:1:size(orimesh, 1)]', orimesh]
% centrecoord=[500 500];
% p = ones( size(orimesh, 1)-1, 1);

% tempCoord = linspace(1000, 0, 5);
% temp1 = tempCoord(2:end);
% xElem = [(tempCoord)'; 0; 1000];
% yElem = [1000*ones(size(tempCoord))'; 0; 0];
% orimesh = [xElem, yElem];
% orimesh = [[1:1:size(orimesh, 1)]', orimesh];
% p = 2*ones( size(orimesh, 1)-1, 1);

% centrecoord=[1000 500];

% distributed force between node 1 & 2
% constrain x on node1, constrain y on node 9
[supel] = initialize_problem(orimesh, centrecoord, p);
[local,supel,globnodesdisp] = today3_modify(p, supel)
% [sigma_star] = nodalStressCalculate3(p, local, supel, 1:5, 2);
% [recStress] = recoverFromModalStress(sigma_star, supel, local, p);
% plot_stress(local, recStress);
% [deltaerror, energyStress, nitaError]= error_calculate3(sigma_star, p, local, supel, globnodesdisp)
% plot_disp(local);
% test_recovery_patch
plot_stress(local, local)