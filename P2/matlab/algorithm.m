%% Load

name = 'belgium';
file = ['products/mat/' name '.mat'];

if isfile(file)
    load(file);
else
    initialize;
end

%% Metropolis-Hastings

% Initialization

[x, x_min, x_i] = deal(x_nna);
[l, l_min, l_i] = deal(l_nna);

% Parameters

m = 1e6;
beta = log2(n) * n / l;
c = 1e2;

% Algorithm

s = l;
k = 1;

I = randi([1 n], [m 2]);

tic
while k <= m
    i = I(k, 1);
    j = I(k, 2);
        
    delta = delta_f(n, D, x, i, j);
    
    alpha = P(beta * (1 + c * log2(k * l / s)^2), delta);
    
    if alpha >= 1 || rand() < alpha
        l = l + delta;
        temp = x(i);
        x(i) = x(j);
        x(j) = temp;
        
        if l < l_min
            l_min = l;
            x_min = x;
        end
    end
    
    s = s + l;
    k = k + 1;
end
toc

%% Display

disp(['Initial length : ' num2str(l_i)]);
disp(['Nearest neighbour algorithm length : ' num2str(l_nna)]);
disp(['Best length in ' num2str(m) ' iterations : ' num2str(l_min)]);

% plot(tsp{x_min,2}, -tsp{x_min,3}, '-');

%% Functions

function p = P(beta, x)
    if x < 0
        p = 1;
    else
        p = exp(-beta * x);
    end
end

function delta = delta_f(n, D, x, i, j)
    if i == j
        delta = 0; 
        return;
    elseif i > j
        temp = i;
        i = j;
        j = temp;
    end
    
    if i == 1 && j == n
        i_m = i + 1;
        j_p = j - 1;
    elseif i == 1
        i_m = n;
        j_p = j + 1;
    elseif j == n
        i_m = i - 1;
        j_p = 1;
    else
        i_m = i - 1;
        j_p = j + 1;
    end
    
    delta = -D(x(i_m), x(i));
    delta = delta - D(x(j), x(j_p));
    
    delta = delta + D(x(i_m), x(j));
    delta = delta + D(x(i), x(j_p));
    
    if i ~= j - 1 && (i ~= 1 || j ~= n)
        delta = delta - D(x(i), x(i + 1));
        delta = delta - D(x(j - 1), x(j));

        delta = delta + D(x(j), x(i + 1));
        delta = delta + D(x(j - 1), x(i));
    end
end
