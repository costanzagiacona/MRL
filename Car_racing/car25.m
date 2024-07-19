function [sp,r,s_finale] = car25(s,a, griglia) %la velocità è dentro lo stato
    % a -> modifica velocità: +1,-1,0 per dx, sx, su
    D = 26; %dimensione griglia
    S = 25*25; 
    Vx = 5 + 1; %velocità va da 0 a 5
    Vy = 5 + 1;
    % fprintf("\n\nstato attuale %d\n", s);
    %mappiamo stato in righe e colonne
    [pos, vx,vy] = ind2sub([S,Vx,Vy],s);
    s_finale = 0;
    % sottraggo -1 perche la veloticità è compresa tra 0 e 5
    vx = vx-1;
    vy = vy-1;

    % fprintf("prendiamo azione %d\n velocita attuale vx = %d, vy = %d\n", a, vx, vy)
    % 
    % trovo velocità vx e vy in base ad a
    if a == 1
        vx = vx + 1;
        vy = vy + 1;
    
    elseif a == 2
        vx = vx + 1;
        vy = vy - 1;
    
    elseif a == 3
        vx = vx + 1;
        vy = vy + 0;
    
    elseif a == 4
        vx = vx - 1;
        vy = vy + 1;
    
    elseif a == 5
        vx = vx - 1;
        vy = vy - 1;
    
    elseif a == 6
        vx = vx - 1;
        vy = vy + 0;
    
    
    elseif a == 7
        vx = vx + 0;
        vy = vy + 1;
    
    elseif a == 8
        vx = vx + 0;
        vy = vy - 1;
    
    elseif a == 9
        vx = vx + 0;
        vy = vy + 0;
    
    else
        error('Action not allowed');
    
    end
    
    %controllo velocità max e min vx
    if vx > Vx-1
        vx = Vx-1;
    end
    if vx < 0
        vx = 0;
    end
    %controllo velocità max e min vy
    if vy > Vy-1
        vy = Vy-1-1;
    end
    if vy < 0
        vy = 0;
    end
    
    %r+vx e c+vy e trovo lo stato successivo
    % fprintf("posizione successiva -> %d\n ", pos);
    
    % x colonne
    % y righe
    [y,x]=ind2sub(size(griglia),pos);
    x = x;
    y = y;
    % if (D-x == 0)
    %     x = x-1;
    % end
    % fprintf("posizione attuale -> (%d,%d)\n valore griglia = %d\n", x,y, griglia(y,x));
    x1 = x+vx;
    y1 = y+vy;
    
    if x1 < 1
        x1 = 1;
    elseif x1 > D-1
        x1 = D-1;
    end
    
    if y1 < 1
        y1 = 1;
    elseif y1 > D-1
        y1 = D-1;
    end
    y1 = y1;
    x1 = x1;
    % x1 = D - x1;
    % y1 = D - y1;
    pos1 = sub2ind(size(griglia),y1,x1);
  
    % disp(x1)
    vx = vx+1;
    vy = vy+1;
    % if (D-x1 == 0)
    %     x1 = x1-1;
    % end
    % fprintf("vx successiva -> %d \n", vx-1);
    % fprintf("vy successiva -> %d \n", vy-1);
    % fprintf("posizione successiva ---> (%d,%d)\n valore sulla griglia = %d\n\n",x1,y1,griglia(y1,x1));
    
    sp = sub2ind([S,Vx,Vy], pos1, vx,vy);
    %in base a dove mi trovo ho reward
    if (griglia(y1,x1) == 1) %sono in pista
        % disp('sei in pista');
        r = -1;
    elseif (griglia(y1,x1) == 0) %fuori pista
        [y_s,x_s] = find(griglia ==3);
        s_iniziale = sub2ind(size(griglia),y_s,x_s);
        sp = s_iniziale(randi(length(s_iniziale)));
        r = -5;
        % sp = -2;
        % disp("sei uscito dalla pista")
    elseif (griglia(y1,x1) == 2) %linea di arrivo
        r = +10;
        s_finale = sp;
        sp = -1;
        % disp("congratulazioni hai vinto!")
    else
        r=-1;
        % disp('stato iniziale')
    end
    % fprintf("stato successivo %d",sp)
end

