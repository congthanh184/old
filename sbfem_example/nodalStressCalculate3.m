function [unpackStress] = nodalStressCalculate3(p, local, supel, mainNodes, ngl)
    % mainNodes = [1; 2; 3; 4; 5];

    [matmtrx,G] = sbfematisolq(1,supel.emodule,supel.poisson);
    D = G*matmtrx;

    [point1, ~] = sbfeglqd1(ngl);
    nodalStress = [];
    for iMainNodes = 1:numel(mainNodes)-1
        [~, idInSupelNodes] = ismember(mainNodes(iMainNodes:iMainNodes+1), supel.nodes);
        startIdx = idInSupelNodes(1);
        endIdx = idInSupelNodes(2);

        sampleX = []; 
        sampleY = [];
        sampleTest = [];
        for iel=startIdx:endIdx-1
            for iP = 1:numel(point1)
                [x, y, gaussStr] = calculateModalStress(D, iel, supel, local, p, point1(iP));
                sampleTest = [sampleTest; gaussStr(:)'];
                sampleY = [sampleY; y];
                sampleX = [sampleX; x];
            end
        end

        nodalX = supel.gcoord(startIdx:endIdx, 1);
        nodalY = supel.gcoord(startIdx:endIdx, 2);
        % check which value is the same, then switch with X
        if numel(unique(sampleX))==1
            sampleX = sampleY;
            nodalX = nodalY;
        end

        if endIdx - startIdx == 1
            stressTempPatch = interpolateStress( sampleX, sampleTest, nodalX, 2);            
        else
            stressTempPatch = [];
            for iel = 1:numel(nodalX)-2
                startIdxTemp = (iel-1)*ngl + 1;
                endIdxTemp = startIdxTemp + 2*ngl - 1;
                stressTemp = interpolateStress( sampleX(startIdxTemp:endIdxTemp, :), sampleTest(startIdxTemp:endIdxTemp, :), ... 
                                                        nodalX(iel:iel+2), 2);            
                if isempty(stressTempPatch)
                    stressTempPatch = stressTemp;
                else
                    stressTempPatch = [ stressTempPatch(1:end-1, :); ...
                                        stressTemp(2:end, :)];
                end
            end
        end

        
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