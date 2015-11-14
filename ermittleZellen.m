function [Zellen] = ermittleZellen(Texte)

N = length(Texte);
Zellen = {};
z = 1;

for i = 1:N
    
if strcmp(Texte(i).Text, '') == 0
    Zellen{z} = Texte(i).Words;
    z = z+1;
end

end