function erstelleCSV(Zellen)



filename = 'Anwesenheitsliste.csv';
file = fopen(filename, 'w');


[Zeilen Spalten] = size(Zellen);

for z = 1:Zeilen
   for s = 1:Spalten
       if iscell(Zellen{z,s})
           
           if ischar(Zellen{z,s}{1,1})
                fprintf(file, '%s;', Zellen{z,s}{1,1});
                
           else
               fprintf(file, ';');
           end
           
       else
           fprintf(file, ';');
       end
   end
   fprintf(file, '\n');
   
end
fclose(file);



end


