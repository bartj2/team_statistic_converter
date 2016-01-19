function erstelleCSV(Zellen)
% Diese Funktion erstellt eine CSV-Datei auf Basis des CellArray 'Zellen'.


Dateiname = 'Anwesenheitsliste.csv';
Datei = fopen(Dateiname, 'w');


[Zeilen Spalten] = size(Zellen);

for z = 1:Zeilen
   for s = 1:Spalten
       if iscell(Zellen{z,s})
           % WENN Element ueberhaupt eine 'Cell' ist:
           if ischar(Zellen{z,s}{1,1})
               % WENN Element ueberhaupt ein Zeichen/Wort ist:
                fprintf(Datei, '%s;', Zellen{z,s}{1,1}); % speichern.                
           else
               fprintf(Datei, ';');
           end           
       else
           fprintf(Datei, ';');
       end
   end
   fprintf(Datei, '\n');
   
end
fclose(Datei);
end


