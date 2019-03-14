close all;

set(0, 'defaultLineLineWidth', 1.3, 'defaultAxesLineWidth', 1.3);
set(0, 'defaultAxesFontSize', 16, 'defaultAxesFontName', 'Times New Roman');
set(0, 'defaultTextInterpreter', 'latex', 'DefaultLegendInterpreter', 'latex');

%% Parameters

K = 10;
lambda = 2;

%% 1

% pX
X = 0:K;
pX = exp(-lambda) * lambda .^ X ./ factorial(X);
C = 1 / sum(pX);
pX = C * pX ;

% Q
Q = zeros(K + 1);
for i = 1:K + 1
    x = i - 1;
    for j = 1:K + 1
        y = j - 1;
        if x == 0 && (y == 0 || y == 1)
            Q(i, j) = 1 / 2;
        elseif x == K && (y == K || y == K - 1)
            Q(i, j) = 1 / 2;
        elseif 0 < x && x < K && (y == x - 1 || y == x + 1)
            Q(i, j) = 1 / 2;
        end
    end
end

%% 2

N = 1e4;
x = zeros(N, 1);

% Initial state
r = rand;
for j = 1:K + 1
    r = r - pX(j);
    if r < 0
        break;
    end
end
x(1) = X(j);
i = j;

% Metropolis-Hastings
for t = 2:N
    r = rand;
    for j = 1:K + 1
        r = r - Q(i, j);
        if r < 0
            break;
        end
    end

    alpha = pX(j) / pX(i) * Q(i, j) / Q(j, i);

    u = rand;
    if u < alpha
        x(t) = X(j);
        i = j;
    else
        x(t) = x(t - 1);
    end
end

freq = zeros(1, K + 1);
for j = 1:K + 1
    freq(j) = sum(x == X(j));
end
freq = freq / N;

%% 3

bar(X, [pX' freq'], 'grouped');
xlabel('$x$');
ylabel('$p(x)$');
legend('$p_X$', 'f');
