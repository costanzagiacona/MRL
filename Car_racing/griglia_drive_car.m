% % driving race
clc
close all
% creiamo la struttura di base della griglia
lengthGrid = 50;
heightGrid = 50;
griglia = zeros(heightGrid,lengthGrid);
h = 0;
count  =0;
k = 3;
count_incr = 0;
incr = 0;
% creiamo la struttura della strada, come una matrice di 1 e 0
% le posizioni con 1 caratterizzano un punto della strada, dove la macchina
% può passare. Gli 0 sono punti esterni a tale strada

for i = heightGrid:-1:2
    if (i > round(heightGrid/1.2))
        for j = 10:lengthGrid-30
            griglia(i,j) = 1;
        end
    else
        count_incr = count_incr +1;
        count = count +1;
        if count == k
            h = h+incr;
            count = 0;
        end
        if (k >1)
            k = k-1;
        end
        if (count_incr ==5)
            incr = incr +1;
            count_incr = 0;
        end
        
        for j = 10+round(h/5):min(lengthGrid-30+round(0.3*h), lengthGrid)
            % disp('1')
            if j == lengthGrid
                % linea rossa
                griglia(i,j) = 2;
            else
                griglia(i,j) = 1;
            end
           
        end
    end
    
end
 
griglia(heightGrid,10:lengthGrid-30) = 3*ones;
figure
% grid = imagesc([0 widthGrid],[0 lengthGrid],griglia);
background = [0,0,0]; %nero
white = [1,1,1]
red=[1,0,0];
green = [0,1,0];
colormap([background;white; red;green])
grid = imagesc(griglia)

save grid.mat grid griglia
















