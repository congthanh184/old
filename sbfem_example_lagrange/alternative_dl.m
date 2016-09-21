function y = alternative_dl(j,x,z)

j = 2;
x = [-1; 1];
z = -1;

y = 0;
n = length(x);
for l=1:n
    if not(l==j)
        k = 1/(x(j)-x(l));
        for m=1:n
            if not(m==j) && not(m==l)
                k = k*(z-x(m))/(x(j)-x(m));
            end
        end
        y = y + k;
    end
end

end