/* 1. Desplegar para cada elección el país y el partido político que obtuvo mayor
porcentaje de votos en su país. Debe desplegar el nombre de la elección, el
año de la elección, el país, el nombre del partido político y el porcentaje que
obtuvo de votos en su país. */

select eleccion, anio_eleccion, pais, Partido, (total_votos_partido/total_votos_pais)*100 as porcentaje
from(
select vtp.eleccion  as eleccion, vtp.anio_eleccion as anio_eleccion, 
vtp.pais as pais,p3.Nombre  as Partido,(sum(p.Analfabetos)+sum(p.Alfabetos)) as total_votos_partido, vtp.total_votos_pais as total_votos_pais
from poblacion p inner join votacion v on p.Votacion_Id = v.Id
inner join partido p3 on p3.Id = v.Partido_Id
inner join eleccion e on e.Id = v.Eleccion_Id 
inner join municipio m on m.Id = v.Municipio_Id 
inner join departamento d on d.Id = m.Departamento_Id 
inner join region r on d.Region_Id = r.Id 
inner join pais p2 on p2.Id = r.Pais_Id 
inner join votos_totales_pais vtp on vtp.pais = p2.Nombre 
group by partido
order by total_votos_partido desc) as tabla1
group by pais;

/* 2. Desplegar total de votos y porcentaje de votos de mujeres por departamento
y país. El ciento por ciento es el total de votos de mujeres por país. (Tip:
Todos los porcentajes por departamento de un país deben sumar el 100%) */

select d.Nombre as departamento , vtpm.pais as pais,(sum(p.Analfabetos)+sum(p.Alfabetos)) as total_votos,
((sum(p.Analfabetos)+sum(p.Alfabetos))/vtpm.total_votos_pais)*100 as porcentaje
from poblacion p inner join votacion v on p.Votacion_Id = v.Id 
inner join sexo s on s.Id = p.Sexo_Id 
inner join municipio m on m.Id = v.Municipio_Id 
inner join departamento d on d.Id = m.Departamento_Id 
inner join region r on d.Region_Id = r.Id 
inner join pais p2 on p2.Id = r.Pais_Id 
inner join votos_totales_pais_mujeres vtpm on vtpm.pais = p2.Nombre 
where s.Sexo = 'mujeres'
group by departamento, pais ;

/* 3. Desplegar el nombre del país, nombre del partido político y número de
alcaldías de los partidos políticos que ganaron más alcaldías por país. */



/* 4. Desplegar todas las regiones por país en las que predomina la raza indígena.
Es decir, hay más votos que las otras razas. */

select Pais, Region, votos from
(select Pais, Region, Raza, votos from
(select p2.Nombre as Pais, r2.Nombre as Region, r.Raza as Raza, (sum(p.Analfabetos)+sum(p.Alfabetos)) as votos
from poblacion p inner join raza r on p.Raza_Id = r.Id
inner join votacion v on v.Id = p.Votacion_Id 
inner join municipio m on m.Id = v.Municipio_Id 
inner join departamento d on d.Id = m.Departamento_Id 
inner join region r2 on r2.Id = d.Region_Id 
inner join pais p2 on p2.Id = r2.Pais_Id 
group by Pais, Region, Raza 
order by votos desc) as tabla1
group by Pais, Region) as tabla2
where Raza = 'INDIGENAS';


/* 5. Desplegar el nombre del país, el departamento, el municipio y la cantidad de
votos universitarios de todos aquellos municipios en donde la cantidad de
votos de universitarios sea mayor que el 25% de votos de primaria y menor
que el 30% de votos de nivel medio. Ordene sus resultados de mayor a
menor. */

select p2.Nombre as Pais, d.Nombre as Departamento, m.Nombre as Municipio ,
/*sum(p.Primaria)as primaria, sum(p.Medio)as medio,*/ sum(p.Universidad) as votos_universidad
from poblacion p inner join votacion v on v.Id  = p.Votacion_Id 
inner join municipio m on v.Municipio_Id = m.Id 
inner join departamento d on d.Id = m.Departamento_Id 
inner join region r  on r.Id = d.Region_Id 
inner join pais p2 on p2.Id = r.Pais_Id 
group by Pais, Departamento, Municipio
having votos_universidad > sum(p.Primaria) and votos_universidad < sum(p.Medio)
order by votos_universidad desc;

/* 6. Desplegar el porcentaje de mujeres universitarias y hombres universitarios
que votaron por departamento, donde las mujeres universitarias que votaron
fueron más que los hombres universitarios que votaron. */

select  vtd.Departamento as Departamento, (votos_mujeres/vtd.total_votos_departamento)*100 as Mujeres,
(votos_hombres/vtd.total_votos_departamento)*100 as Hombres
from votos_totales_departamento vtd inner join
(select p2.Nombre as Pais_M, d.Nombre as Departamento_M,sum(p.Universidad) as votos_mujeres
from poblacion p inner join votacion v on v.Id = p.Votacion_Id 
inner join municipio m on m.Id = v.Municipio_Id 
inner join departamento d on d.Id = m.Departamento_Id 
inner join region r on r.Id = d.Region_Id 
inner join pais p2 on p2.Id = r.Pais_Id 
inner join sexo s on s.Id = p.Sexo_Id 
where s.Sexo = 'mujeres'
group by Pais_M, Departamento_M) as Tabla_Mujeres 
on vtd.pais = Pais_M and vtd.Departamento = Departamento_M
inner join 
(select p2.Nombre as Pais_H, d.Nombre as Departamento_H, sum(p.Universidad) as votos_hombres
from poblacion p inner join votacion v on v.Id = p.Votacion_Id 
inner join municipio m on m.Id = v.Municipio_Id 
inner join departamento d on d.Id = m.Departamento_Id 
inner join region r on r.Id = d.Region_Id 
inner join pais p2 on p2.Id = r.Pais_Id 
inner join sexo s on s.Id = p.Sexo_Id 
where s.Sexo = 'hombres'
group by Pais_H, Departamento_H)as Tabla_Hombres
on vtd.pais = Pais_H and vtd.Departamento = Departamento_H
where votos_mujeres>votos_hombres;

/* 7. Desplegar el nombre del país, la región y el promedio de votos por
departamento. Por ejemplo: si la región tiene tres departamentos, se debe
sumar todos los votos de la región y dividirlo dentro de tres (número de
departamentos de la región). */

select Pais_1 as Pais, Region_1 as Region, votos/cantidad as Promedio
from
(select p2.Nombre as Pais_1, r.Nombre as Region_1, (sum(p.Analfabetos)+sum(p.Alfabetos)) as votos
from poblacion p inner join votacion v on v.Id = p.Id 
inner join municipio m on m.Id = v.Municipio_Id 
inner join departamento d on d.Id = m.Departamento_Id 
inner join region r on r.Id = d.Region_Id 
inner join pais p2 on p2.Id = r.Pais_Id 
group by  Pais_1, Region_1) as tabla1
inner join 
(select p.Nombre as Pais_2,r.Nombre  as Region_2, count(*) as cantidad 
from pais p inner join region r on p.Id = r.Pais_Id
inner join departamento d on d.Region_Id = r.Id
group by Pais_2, Region_2) as tabla2
on Pais_1 = Pais_2 and  Region_1=Region_2;

/* 8. Desplegar el total de votos de cada nivel de escolaridad (primario, medio,
universitario) por país, sin importar raza o sexo. */

select * from votos_totales_educacion;

/* 9. Desplegar el nombre del país y el porcentaje de votos por raza. */

select Pais_R as Pais_, Raza, (Votos/vtp.total_votos_pais)*100 as Porcentaje 
from votos_totales_pais vtp inner join
(select p2.Nombre as Pais_R, r.Raza as Raza, (sum(p.Analfabetos)+sum(p.Alfabetos)) as Votos
from poblacion p inner join raza r ON p.Raza_Id = r.Id
inner join votacion v on v.Id = p.Votacion_Id 
inner join municipio m on m.Id = v.Municipio_Id 
inner join departamento d on d.Id = m.Departamento_Id 
inner join region r2 on r2.Id = d.Region_Id 
inner join pais p2 on p2.Id = r2.Pais_Id 
group by Pais_R, Raza) as Tabla_Raza
on vtp.pais = Pais_R
group by Pais_, Raza;


/* 10.Desplegar el nombre del país en el cual las elecciones han sido más
peleadas. Para determinar esto se debe calcular la diferencia de porcentajes
de votos entre el partido que obtuvo más votos y el partido que obtuvo menos
votos. */

select Pais_, Min(Diferencia) as Diferencia_ from
(select  mtpp.pais as Pais_, (mtpp.Maximo-mtpp2.Minimo) as Diferencia
from max_totales_pais_partido mtpp inner join min_totales_pais_partido mtpp2
on mtpp.pais = mtpp2.pais 
group by pais_
order by Diferencia asc) as Tabla1;

/* 11. Desplegar el total de votos y el porcentaje de votos emitidos por mujeres
indígenas alfabetas. */

select vtp.pais as Pais_ , votos_MI as Votos, (votos_MI/vtp.total_votos_pais)*100 as Porcentaje
from votos_totales_pais vtp inner join
(select p2.Nombre as Pais_MI, sum(p.Alfabetos) as votos_MI
from poblacion p inner join raza r on r.Id = p.Raza_Id 
inner join votacion v on v.Id = p.Votacion_Id 
inner join sexo s on s.Id = p.Sexo_Id 
inner join municipio m on m.Id = v.Municipio_Id 
inner join departamento d on d.Id = m.Departamento_Id 
inner join region r2 on r2.Id = d.Region_Id 
inner join pais p2 on p2.Id = r2.Pais_Id 
where s.Sexo = 'mujeres' and r.Raza = 'INDIGENAS'
group by Pais_MI) as Tabla_MI
on vtp.pais = Pais_MI;

/* 12.Desplegar el nombre del país, el porcentaje de votos de ese país en el que
han votado mayor porcentaje de analfabetas. (tip: solo desplegar un nombre
de país, el de mayor porcentaje). */

select vtp.pais as Pais_, (votos_A/vtp.total_votos_pais)*100 as Porcentaje
from votos_totales_pais vtp inner join
(select p2.Nombre as Pais_A, sum(p.Analfabetos) as votos_A
from poblacion p inner join votacion v on p.Votacion_Id = v.Id 
inner join municipio m on m.Id = v.Municipio_Id 
inner join departamento d on d.Id = m.Departamento_Id 
inner join region r on r.Id = d.Region_Id 
inner join pais p2 on p2.Id = r.Pais_Id 
group by Pais_A) as Tabla_A
on vtp.pais = Pais_A
group by Pais_
order by Porcentaje desc limit 1;

/* 13.Desplegar la lista de departamentos de Guatemala y número de votos
obtenidos, para los departamentos que obtuvieron más votos que el
departamento de Guatemala.*/

select Pais_G as Pais_, Departamento_G as Departamento_, Votos_G as Votos
from
(select p2.Nombre as Pais_G, d.Nombre as Departamento_G, (sum(p.Analfabetos)+sum(p.Alfabetos)) as Votos_G
from poblacion p inner join votacion v on p.Votacion_Id = v.Id 
inner join municipio m on m.Id = v.Municipio_Id 
inner join departamento d on d.Id = m.Departamento_Id 
inner join region r on r.Id = d.Region_Id 
inner join pais p2 on p2.Id = r.Pais_Id 
where p2.Nombre = 'GUATEMALA'
group by Pais_G, Departamento_G) as Tabla_G
inner join 
(select p2.Nombre as Pais_GG, d.Nombre as Departamento_GG, (sum(p.Analfabetos)+sum(p.Alfabetos)) as Votos_GG
from poblacion p inner join votacion v on p.Votacion_Id = v.Id 
inner join municipio m on m.Id = v.Municipio_Id 
inner join departamento d on d.Id = m.Departamento_Id 
inner join region r on r.Id = d.Region_Id 
inner join pais p2 on p2.Id = r.Pais_Id 
where p2.Nombre = 'GUATEMALA' and d.Nombre = 'Guatemala'
group by Pais_GG, Departamento_GG) as Tabla_GG
on Pais_G = Pais_GG
where Votos_G > Votos_GG;













