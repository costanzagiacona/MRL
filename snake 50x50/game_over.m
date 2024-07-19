%% GAME OVER
% mostra a schermo la scritta GAME OVER
function game_over(e)
%e -> episodio attuale
    if mod(e,1)==0
        % fprintf("game over")
        str = 'GAME OVER!';
        dim = [.1 .4 .7 .7];
        T = annotation('textbox',[.3 .4 .5 .5],'String','GAME OVER!','FitBoxToText','on');
        T.FontSize = 28;
        T.Color = 'r';
        T.BackgroundColor = 'k';
        T.EdgeColor = 'r';
        
    end
end