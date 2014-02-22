import java.io.*;

R = csvread('../Rules/retina.csv');
%S = csvread('../Rules/spatial.csv')

f = File('../Rules/saliency.csv');
S = importdata('../Rules/saliency.csv');
%{
figure
surf(R)
%}
figure
surf(S)
colorbar
linkdata on


a = f.lastModified();
b = a;

while 1
    a = f.lastModified();
    pause(.25)
    b = f.lastModified();
    
    if a ~= b
        v = 1;
        while v
            v = 0;
            try
                S = importdata('../Rules/saliency.csv');
                refreshdata
            catch err
                v = 1;
                disp('could not read file')
            end
        end
    end
end

%S = csvread('../Rules/spatial.csv')

%{
1. Gernrate map w/ normal distribution (across fovea & parafovea)
2. Add stimulus submarticies
3. Do convolution with 3x3 gaussian kernel
%}
%{
figure
surf(S)
axis vis3d %lock aspect ratio
colorbar
%}
%{
colormap('jet')
imagesc(S)
colorbar
%}