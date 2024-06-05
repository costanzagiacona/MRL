function [sp ,r,Ax,Ay] = car_race(~,s,a,Ax,Ay)
% dobbiamo definire un singolo step
Sx=50; % numero di stati asse x
Sy=50; % numero di stati asse y
[ax,ay]=ind2sub([3,3],a);   % -> sfrutto gli indici di una matrice 3x3  ( l'indice 2,1 -> ax=0 ay=-1 , ecc )
% definisco l'azioni prese
Ax=max(Ax+(ax-2),0); % mantengo il valore delle velocità che ho precedentemente ottenuto
Ax=min(Ax,5);

Ay=max(Ay+(ay-2),0); % mantengo il valore delle velocità che ho precedentemente ottenuto
Ay=min(Ay,5);

if( Ax == 0 && Ay == 0) % le velocità non possono essere entrambe zero (vedi libro)
    if rand() < 0.5
        Ax=1;
    else
        Ay=1;
    end
end
[x,y]=ind2sub([Sx,Sy],s); % determino la posizione in cui mi trovo
while true
    % def nuove posizioni
    xn=x+Ax;
    yn=y+Ay;
    % check limiti del percorso
    if (xn < 1 || yn < 1 || yn > 40 || (xn > 15 && yn < 20) ) % -> definisco questi limiti perchè so il percorso com'è fatto (vedi Map o parte finale di Assig)
        sp= randi([1,15]); % ritorno random in uno stato iniziale del percorso
        r=-1;
        break;
    elseif (xn >= 50 && (yn <= 40 && yn >=20))
        sp=-1;
        r=-1;
        break;
    elseif((y <= 40 && y >=20) && xn >= 50)
        j=0;
        for i= 1:Ay
            j=j+1;
            j=min(j,Ax);
            if( y+i <= 40 && y+i >= 20) && (x+j >= 50)
                sp=-1;
                r=-1;
                break;
            end
        end
    elseif ((xn <= 15 && yn  <= 20) || ((yn <= 40 && yn >= 20 )))
        sp=sub2ind([Sx,Sy],xn,yn);
        r=-1;
        break;
    else
        disp([xn,yn])
        error("Something went wrong")
    end
end
end