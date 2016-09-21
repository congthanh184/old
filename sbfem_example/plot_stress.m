function plot_stress(local, rec_str, choose_strx)
    figure; 
    x = [];
    y = [];
    strx = [];
    recx = [];
    for iEle = 1:size(local, 2)
        x = [x; local(iEle).x];    
        y = [y; local(iEle).y];
        if choose_strx == 1
            strx = [strx; local(iEle).strx];
            recx = [recx; rec_str(iEle).strx];
        else
            strx = [strx; local(iEle).stry];
            recx = [recx; rec_str(iEle).stry];
        end

    end
%     mesh(x, y, recx);
    contour(x, y, recx, 20);
    figure;
    contour(x, y, strx, 20);
%     contour(x, y, strx, 40);
end