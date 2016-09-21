[matmtrx,G] = sbfematisolq(1,supel.emodule,supel.poisson);
D = G*matmtrx;

sampleMidStrX = [];
sampleMidStrY = [];
sampleMidStrXY = [];
sampleX = []; 
sampleY = [];

for iel=1:4
    [x, y, gaussStr] = calculateModalStress(D, iel, supel, local, p, 0);
    sampleMidStrX = [sampleMidStrX; gaussStr(1,:)];
    sampleMidStrY = [sampleMidStrY; gaussStr(2,:)];
    sampleMidStrXY = [sampleMidStrXY; gaussStr(3,:)];
    sampleY = [sampleY; y];    

    [x, y, gaussStr] = calculateModalStress(D, iel, supel, local, p, -0.774596669241483);
    sampleMidStrX = [sampleMidStrX; gaussStr(1,:)];
    sampleMidStrY = [sampleMidStrY; gaussStr(2,:)];
    sampleMidStrXY = [sampleMidStrXY; gaussStr(3,:)];
    sampleY = [sampleY; y];    
    [x, y, gaussStr] = calculateModalStress(D, iel, supel, local, p, 0.774596669241483);
    sampleMidStrX = [sampleMidStrX; gaussStr(1,:)];
    sampleMidStrY = [sampleMidStrY; gaussStr(2,:)];
    sampleMidStrXY = [sampleMidStrXY; gaussStr(3,:)];
    sampleY = [sampleY; y];
end
[locMainNodes, ~] = ismember(supel.nodes, 1:5);
nodalY = supel.gcoord(locMainNodes, 2);
stressPatch1 = interpolateStress( sampleY, sampleMidStrY, nodalY, 2);

stressPatch1 = [];
for iel = 1:3
    idxTemp = iel*3-2;
    stressTemp = interpolateStress( sampleY(idxTemp:idxTemp+5, :), sampleMidStrY(idxTemp:idxTemp+5, :), nodalY(iel:iel+2), 2);
    if iel == 1
        stressTemp(end, :) = [];
    elseif iel == 3
        stressTemp(1, :) = [];
    else
        stressTemp(end, :) = [];
        stressTemp(1, :) = [];
    end
    stressPatch1 = [stressPatch1; stressTemp];
end

%%
sampleMidStrX = [];
sampleMidStrY = [];
sampleMidStrXY = [];
sampleX = [];
for iel=5:10
    [x, y, gaussStr] = calculateModalStress(D, iel, supel, local, p, 0);
    sampleMidStrX = [sampleMidStrX; gaussStr(1,:)];
    sampleMidStrY = [sampleMidStrY; gaussStr(2,:)];
    sampleMidStrXY = [sampleMidStrXY; gaussStr(3,:)];
    sampleX = [sampleX; x];
    
    [x, y, gaussStr] = calculateModalStress(D, iel, supel, local, p, -0.774596669241483);
    sampleMidStrX = [sampleMidStrX; gaussStr(1,:)];
    sampleMidStrY = [sampleMidStrY; gaussStr(2,:)];
    sampleMidStrXY = [sampleMidStrXY; gaussStr(3,:)];
    sampleX = [sampleX; x];
    [x, y, gaussStr] = calculateModalStress(D, iel, supel, local, p, 0.774596669241483);
    sampleMidStrX = [sampleMidStrX; gaussStr(1,:)];
    sampleMidStrY = [sampleMidStrY; gaussStr(2,:)];
    sampleMidStrXY = [sampleMidStrXY; gaussStr(3,:)];
    sampleX = [sampleX; x];
end
[locMainNodes, ~] = ismember(supel.nodes, 5:11);
nodalX = supel.gcoord(locMainNodes, 1);
stressPatch2 = interpolateStress( sampleX, sampleMidStrY, nodalX, 2);

stressPatch2 = [];
for iel = 1:5
    idxTemp = iel*3-2;
    % idxTT = iel-4;
    % stressPatch1 = interpolateStress( sampleX(idxTT:idxTT+3, :), sampleMidStrY(idxTemp:idxTemp+3, :), nodalX(idxTT:idxTT+2), 2);
    stressTemp = interpolateStress( sampleX(idxTemp:idxTemp+5, :), sampleMidStrY(idxTemp:idxTemp+5, :), nodalX(iel:iel+2), 2);
    if iel == 1
        stressTemp(end, :) = [];
    elseif iel == 3
        stressTemp(1, :) = [];
    else
        stressTemp(end, :) = [];
        stressTemp(1, :) = [];
    end
    stressPatch2 = [stressPatch2; stressTemp];
end

%%

% [x, y, strNode1] = calculateModalStress(D, 1, supel, local, p, -1);
% [x, y, strNode9] = calculateModalStress(D, 8, supel, local, p, 1);
%%
% ssY = [	(strNode1(2, :) + stressPatch1(1, :))./2; ...
% 		stressPatch1(2:end-1, :); ...
% 		(stressPatch1(end, :) + stressPatch2(1, :))./2; ...
% 		stressPatch2(2:end-1, :); ...
% 		(strNode9(2, :) +stressPatch2(end, :))./2 ];
% [x, y, gaussStr] = calculateModalStress(D, 1, supel, local, p, -1);
% gaussTemp1st = gaussStr(2, :);
% 
% [x, y, gaussStr] = calculateModalStress(D, 8, supel, local, p, 1);
% gaussTemplast = gaussStr(2, :);

ssY = [	%gaussTemp1st(1, :); ...
		stressPatch1(1:end-1, :); ...
		(stressPatch1(end, :) + stressPatch2(1, :))./2; ...
		stressPatch2(2:end, :); ...
        %gaussTemplast(1, :);...
		];
% ssY = [	stressPatch1(1:end, :); ...
% 		
% 		stressPatch2(2:end, :) ];
    
sdoff = supel.nnode*2 + 2*(sum(p)-supel.nel);
sigma_star = zeros(supel.nnode*3, sdoff);
sigma_star(2:3:supel.nnode*3, :) = ssY;

[stress_field] = recoverFromModalStress(sigma_star, supel, local, p);
plot_stress(local, stress_field, 0)