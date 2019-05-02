%% Load

tsp = readtable(['resources/txt/' name '.txt']);

%% Computations

% Distances
n = size(tsp, 1);
D = zeros(n);

coo = tsp{:, 2:end};

for i = 1:(n - 1)
    D(i, i) = Inf;
    for j = (i + 1):n
        D(i, j) = sum((coo(i, :) - coo(j, :)).^2, 2).^(1 / 2);
        D(j, i) = D(i, j);
    end
end

% Nearest neighbour algorithm
x = 2:n;
x_nna = ones(n, 1);

for i = 2:n
    [~, j] = min(D(x_nna(i - 1), x));
    x_nna(i) = x(j);
    x = [x(1:j - 1), x(j + 1:end)];
end

l_nna = f(D, x_nna);

%% Save

if ~isfolder('products')
    mkdir products;
    mkdir products/mat;
elseif ~isfolder('products/mat')
    mkdir products/mat;
end

save(['products/mat/' name '.mat'], 'tsp', 'n', 'D', 'x_nna', 'l_nna');