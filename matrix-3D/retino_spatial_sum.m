R = csvread('../Rules/retina.csv');
L = csvread('../Rules/spatial.csv');
S = importdata('../Rules/saliency.csv');

figure
surf(R)
colorbar

figure
surf(L)
colorbar

figure
surf(S)
colorbar