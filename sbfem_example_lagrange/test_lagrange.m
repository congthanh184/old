y = [];
[p1, w1] = sbfeglqd1(64);
x = p1;
% x = -1:0.1:1;

for iNode = 1:numel(x)
    [~, NN] = lagrangian2( x(iNode), 2);
%     [~, NN] = lobatto( x(iNode), 7);
    y = [y; NN];
end

xx = repmat(x(:), 1, size(y, 2));
plot( xx, y);