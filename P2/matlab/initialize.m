%% Load

tsp = readtable(['resources/txt/' name '.txt']);

%% Computations

% Distances
n = size(tsp, 1);
D = zeros(n);

coo = tsp{:, 2:end};

tic
for i = 1:(n - 1)
    D(i, i) = Inf;
    for j = (i + 1):n
        D(i, j) = sum((coo(i, :) - coo(j, :)).^2, 2).^(1 / 2);
        D(j, i) = D(i, j);
    end
end
toc

% Nearest neighbour algorithm
x_nna_min = 1:n;
l_nna_min = f(D, x_nna_min);

tic
for i = 1:n
    x = [1:i - 1, i + 1:n];
    x_nna = zeros(n, 1);
    x_nna(1) = i;

    for j = 2:n
        [~, k] = min(D(x_nna(j - 1), x));
        x_nna(j) = x(k);
        x = [x(1:k - 1), x(k + 1:end)];
    end

    l_nna = f(D, x_nna);
    
    if l_nna < l_nna_min
        x_nna_min = x_nna;
        l_nna_min = l_nna;
    end
end
toc

l_nna = l_nna_min;
x_nna = x_nna_min;

%% Save

if ~exist('products', 'dir')
    mkdir products;
    mkdir products/mat;
elseif ~exist('products/mat', 'dir')
    mkdir products/mat;
end

save(['products/mat/' name '.mat'], 'tsp', 'n', 'D', 'x_nna', 'l_nna');