% clear;
% tempCoord = linspace(1000, 0, 5);
% temp1 = tempCoord(2:end);
% horiElem = [fliplr(tempCoord); 1000*ones(size(tempCoord))];
% vertElem = [1000*ones(size(temp1)); temp1];
% orimesh = [horiElem'; vertElem'];
% orimesh = [[1:1:size(orimesh, 1)]', orimesh];
% centrecoord=[0 0];
% p = ones( size(orimesh, 1)-1, 1);

tempCoord = linspace(1000, 0, 5);
temp1 = tempCoord(2:end);
xElem = [1000*ones(size(tempCoord)), temp1];
yElem = [fliplr(tempCoord), 1000*ones(size(temp1))];
orimesh = [xElem(:), yElem(:)];
orimesh = [[1:1:size(orimesh, 1)]', orimesh];
orimesh = [orimesh(1:8, :); 10 150 1000; 11 75 1000; orimesh(9, :)];
centrecoord=[0 0];
% p = [2;2;2;2;3;3;3;3];
p = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1];

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
[ss_star] = nodalStressCalculate3(p, local, supel, [1;5;9], 3);
[recStress] = recoverFromModalStress(ss_star, supel, local, p);
plot_stress(local, recStress, 0);
% plot_disp(local);
% test_recovery_patch
