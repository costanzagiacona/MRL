%% DISEGNO DEL SERPENTE

% funzione per far muovere il serpente
function disegno_snake(locx, locy)
    % colore del serpente
    color = ["#00F000","#00FF00", "#00FF60", "#00FF90"]; 

    % testa serpente
    rectangle('Position', [locx(1), locy(1),1, 1], 'FaceColor', 'r') % testa rossa

    % corpo serpente
    for i=2:length(locx)
        
        rectangle('Position', [locx(i), locy(i), 1,1], 'FaceColor', color(i-1)) % corpo verde

    end  
end
