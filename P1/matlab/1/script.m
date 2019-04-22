close all;

%% Parameters

set(0, 'defaultLineLineWidth', 1.3, 'defaultAxesLineWidth', 1.3);
set(0, 'defaultAxesFontSize', 16, 'defaultAxesFontName', 'Times New Roman');
set(0, 'defaultTextInterpreter', 'latex', 'DefaultLegendInterpreter', 'latex');

%% 0

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
Q = Q ./ sum(Q, 2);

% pi_0
pi_0 = zeros(1, m);
pi_0(seq1(1)) = 1;

%% 2

t = 51;

% a
pi_a = zeros(t, m);
pi_a(1, :) = ones(1, m) / m;
for i = 2:t
    pi_a(i, :) = pi_a(i - 1, :) * Q;
end
pi_t_a = pi_a(end, :);

figure('Name', 'pi_a', 'Position', [500 100 900 600]);
plot((1:t)' - 1, pi_a);
xlabel('$t$');
ylabel('$\pi_t$');
legend(leg);

% b
pi_b = zeros(t, m);
pi_b(1, 3) = 1;
for i = 2:t
    pi_b(i, :) = pi_b(i - 1, :) * Q;
end
pi_t_b = pi_b(end, :);

figure('Name', 'pi_b', 'Position', [1000 100 900 600]);
plot((1:t)' - 1, pi_b);
xlabel('$t$');
ylabel('$\pi_t$');
legend(leg);

% c
Q_c = Q^t;
pi_t_c = mean(Q_c);

%% 3

pi_inf = mean(Q^1e3);

%% 4

T = 2 .^ (1:16)';
l = length(T);
seq2 = cell(l, 1);
f = zeros(l, m);
for i = 1:length(T)
    seq2{i} = pick(pi_inf, [T(i) 1]);
    f(i, :) = frequency(seq2{i}, 1:m);
end

figure('Name', 'freq', 'Position', [1500 100 900 600]);
bar(categorical(T), f, 'stacked');
xlabel('$T$');
ylabel('$f_x$');
legend(leg, 'Location', 'BestOutside');

%% clearvars

clearvars -except seq1 Q pi_0 pi_a pi_t_a pi_b pi_t_b Q_c pi_inf seq2 f;