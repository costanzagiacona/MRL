% funzione per far muovere il serpente
function disegno_snake(locx, locy)
    color = ["#00F000","#00FF00", "#00FF60", "#00FF90"];
    % colore del serpente
    % testa rossa
    for i=2:length(locx)
        % corpo verde
        rectangle('Position', [locx(i), locy(i), 1,1], 'FaceColor', color(i-1))
    end
    rectangle('Position', [locx(1), locy(1),1, 1], 'FaceColor', 'r')   % testa serpente

    % rectangle('Position', [locx(2), locy(2), 1, 1], 'FaceColor', 'g')
end
