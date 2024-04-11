function r = bandit_d_s(a, b) % a noi, b avversario 
% deterministic stationary case 
%b = randi(5)
switch a
    case 1  %rock
        if (b == 2 || b == 4) %se perdo
            r = -1; 
        elseif (a == b)
            r = 0;
        else 
            r = 1;
        end

    case 2 %paper
        if (b == 3 || b == 5) %se perdo
            r = -1; 
        elseif (a == b)
            r = 0;
        else
            r = 1;
        end

    case 3 %scissor
        if (b == 1 || b == 4) %se perdo
            r = -1;
        elseif (a == b)
            r = 0;
        else
            r = 1;
        end
    
    case 4 %spock
        if (b == 2 || b == 5) %se perdo
            r = -1;
        elseif (a == b)
            r = 0;
        else
            r = 1;
        end

    case 5 %lizard
        if (b == 1 || b == 3) %se perdo
            r = -1;
        elseif (a == b)
            r = 0;
        else
            r = 1;
        end
end

%azioni
% 1 rock
% 2 paper
% 3 scissors
% 4 spock
% 5 lizard