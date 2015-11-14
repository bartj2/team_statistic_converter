function erstelleCSV(Zellen)



filename = 'Anwesenheitsliste.csv';
file = fopen(filename, 'w');


[Zeilen Spalten] = size(Zellen);

for z = 1:Zeilen
   for s = 1:Spalten
       fprintf(file, '%s;', Zellen{z,s}{1,1});
   end
   fprintf(file, '\n');
   
end
fclose(file);



end


