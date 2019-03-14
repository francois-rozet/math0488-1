close all;

set(0, 'defaultLineLineWidth', 1.3, 'defaultAxesLineWidth', 1.3);
set(0, 'defaultAxesFontSize', 16, 'defaultAxesFontName', 'Times New Roman');
set(0, 'defaultTextInterpreter', 'latex', 'DefaultLegendInterpreter', 'latex');

%% load

load 'resources/mat/seq1.mat';
seq1 = seq;

m = max(seq1);

leg = {};
for i = 1:m
    leg{end + 1} = ['$' num2str(i) '$'];
end

%% 1

% Q
Q = zeros(m);

for j = 2:length(seq1)
    Q(seq1(j - 1), seq1(j)) = Q(seq1(j - 1), seq1(j)) + 1;
end

Q = Q ./ sum(Q, 2); % Normalization

% pi_0
pi_0 = zeros(1, m);
pi_0(seq1(1)) = 1;

%% 2

t = 50;

% a
pi_0_a = ones(1, m) / m;

P_a = zeros(t, m);
P_a(1, :) = pi_0_a;

for i = 2:t
    P_a(i, :) = P_a(i - 1, :) * Q;
end

pi_inf_a = P_a(end, :);
res_a = pi_inf_a * Q;

figure;
plot(P_a);
xlabel('$t$');
ylabel('$P_x(t)$');
legend(leg);

% b
pi_0_b = zeros(1, m);
pi_0_b(3) = 1;

P_b = zeros(t, m);
P_b(1, :) = pi_0_b;

for i = 2:t
    P_b(i, :) = P_b(i - 1, :) * Q;
end

pi_inf_b = P_b(end, :);
res_b = pi_inf_b * Q;

figure;
plot(P_b);
xlabel('$t$');
ylabel('$P_x(t)$');
legend(leg);

% c
Q_c = Q^t;

pi_inf_c = Q_c(1, :);
res_c = pi_inf_c * Q;

%% 3

pi_inf = pi_inf_a * Q^1e3;

%% 4

T = 2 .^ (1:12)';
l = length(T);

seq2 = cell(l, 1);
freq = zeros(l, m);

for i = 1:length(T)
    seq2{i} = zeros(T(i), 1);

    % Initial state
    x = rand;
    for j = 1:m
        x = x - pi_inf(j);
        if x < 0
            break;
        end
    end
    seq2{i}(1) = i;

    % Simulation
    for j = 2:T(i)
        x = rand;
        for k = 1:m
            x = x - pi_inf(k);
            if x < 0
                break;
            end
        end
        seq2{i}(j) = k;
    end

    for j = 1:m
        freq(i, j) = sum(seq2{i} == j);
    end
end

freq = freq ./ sum(freq, 2);

figure;
bar(categorical(T), freq, 'stacked');
xlabel('$T$');
ylabel('$f_x$');
legend(leg);
