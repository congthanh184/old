function [unpackStress] = nodalStressCalculate_p(p, local, supel, mainNodes)
    % mainNodes = [1; 2; 3; 4; 5];

    [matmtrx,G] = sbfematisolq(1,supel.emodule,supel.poisson);
    D = G*matmtrx;

    nodalStress = [];
    for iMainNodes = 1:numel(mainNodes)-1
        [~, idInSupelNodes] = ismember(mainNodes(iMainNodes:iMainNodes+1), supel.nodes);
        startIdx = idInSupelNodes(1);
        endIdx = idInSupelNodes(2);

        sNodeIdx = mainNodes(iMainNodes);
        eNodeIdx = mainNodes(iMainNodes+1);

        sampleX = []; 
        sampleY = [];
        sampleTest = [];
        for iel=sNodeIdx:eNodeIdx-1
            % if abs(startIdx - endIdx) > 1
            %     [x, y, gaussStr] = calculateModalStress(D, iel, supel, local, p, 0);
            % else
                % [x, y, gaussStr] = calculateModalStress(D, iel, supel, local, p, 0);
                % sampleTest = [sampleTest; gaussStr(:)'];
                % sampleY = [sampleY; y];
                % sampleX = [sampleX; x];
                [x, y, gaussStr] = calculateModalStress(D, iel, supel, local, p, -0.5774);
                sampleTest = [sampleTest; gaussStr(:)'];
                sampleY = [sampleY; y];
                sampleX = [sampleX; x];
                [x, y, gaussStr] = calculateModalStress(D, iel, supel, local, p, 0.5774);            
            % end
            sampleTest = [sampleTest; gaussStr(:)'];
            sampleY = [sampleY; y];
            sampleX = [sampleX; x];
        end
        [~, gcoordIdx] = ismember( sNodeIdx:eNodeIdx, supel.nodes);
        nodalX = supel.gcoord(gcoordIdx, 1);
        nodalY = supel.gcoord(gcoordIdx, 2);
        % check which value is the same, then switch with X
        if numel(unique(sampleX))==1
            sampleX = sampleY;
            nodalX = nodalY;
        end

        orderInterp = 1;
        if numel(sampleX) > 2
            orderInterp = 2;
        end

        newNodalX = [];
        for iNodal = 1:numel(nodalX)-1
            mu = 0.5*(nodalX(iNodal) + nodalX(iNodal+1));
            newNodalX = [newNodalX; nodalX(iNodal); mu];
        end
        newNodalX = [newNodalX; nodalX(end)];
        stressTempPatch = interpolateStress( sampleX, sampleTest, newNodalX, orderInterp);
        % stressTempPatch = interpolateStress( sampleX, sampleTest, nodalX, orderInterp);
        
        if isempty(nodalStress)
            nodalStress = stressTempPatch;
        else
            nodalStress = [ nodalStress(1:end-1, :); ... 
                            (nodalStress(end, :) + stressTempPatch(1, :))./2; ...
                            stressTempPatch(2:end, :)];
        end

    end

    unpackStress = [];
    numRow = 3;
    numCol = size(nodalStress, 2) / numRow;
    for iSRow = 1:size(nodalStress, 1)
        unTemp = reshape(nodalStress(iSRow, :)', 3, numCol);
        unpackStress = [unpackStress; unTemp];
    end

% [stress_field] = recoverFromModalStress(unpackStress, supel, local, p);
end