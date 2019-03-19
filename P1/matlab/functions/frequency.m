function f = frequency(x, X)
    f = zeros(size(X));
    for i = 1:numel(X)
        f(i) = numel(find(x == X(i)));
    end
    f = f / numel(x);
end

