%% Fonction frequency
%
% Cette fonction prend en entrée une matrice 'x' et une matrice 'D' et retourne
% la fréquence d'apparition dans 'x' de chaque élément de 'D'.

function f = frequency(x, D)
    f = zeros(size(D));
    for i = 1:numel(D)
        f(i) = numel(find(x == D(i)));
    end
    f = f / numel(x);
end