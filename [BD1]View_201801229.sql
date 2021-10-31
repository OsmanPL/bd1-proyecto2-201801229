-- Votos Totales por Pais
create or replace view 
votos_totales_pais as
select p2.Nombre as pais, e.Nombre as eleccion, e.anio_eleccion as anio_eleccion,
(sum(p.Analfabetos)+sum(p.Alfabetos)) as total_votos_pais
from poblacion p inner join votacion v on p.Votacion_Id = v.Id 
inner join eleccion e on e.Id = v.Eleccion_Id 
inner join municipio m on m.Id = v.Municipio_Id 
inner join departamento d on d.Id = m.Departamento_Id 
inner join region r on d.Region_Id = r.Id 
inner join pais p2 on p2.Id = r.Pais_Id 
group by p2.Nombre, e.Nombre , e.anio_eleccion ;

select * from votos_totales_pais;

-- Votos Totales Mujeres por Pais

create or replace view 
votos_totales_pais_mujeres as
select p2.Nombre as pais,(sum(p.Analfabetos)+sum(p.Alfabetos)) as total_votos_pais
from poblacion p inner join votacion v on p.Votacion_Id = v.Id 
inner join sexo s on s.Id = p.Sexo_Id 
inner join municipio m on m.Id = v.Municipio_Id 
inner join departamento d on d.Id = m.Departamento_Id 
inner join region r on d.Region_Id = r.Id 
inner join pais p2 on p2.Id = r.Pais_Id 
where s.Sexo = 'mujeres'
group by p2.Nombre ;

select * from votos_totales_pais_mujeres;

-- Votos Educacion por Pais

create or replace view 
votos_totales_educacion as
select p2.Nombre as pais, sum(p.Primaria) as Votos_Primaria, sum(p.Medio)  as Votos_Medio, 
sum(p.Universidad) as Votos_Universidad
from poblacion p inner join votacion v on p.Votacion_Id = v.Id 
inner join municipio m on m.Id = v.Municipio_Id 
inner join departamento d on d.Id = m.Departamento_Id 
inner join region r on d.Region_Id = r.Id 
inner join pais p2 on p2.Id = r.Pais_Id 
group by pais ;

select * from votos_totales_educacion;


-- Votos Total por Departamento Universidad

create or replace view 
votos_totales_departamento as
select p2.Nombre as pais, d.Nombre as Departamento, 
sum(p.Universidad)as total_votos_departamento
from poblacion p inner join votacion v on p.Votacion_Id = v.Id 
inner join municipio m on m.Id = v.Municipio_Id 
inner join departamento d on d.Id = m.Departamento_Id 
inner join region r on d.Region_Id = r.Id 
inner join pais p2 on p2.Id = r.Pais_Id 
group by p2.Nombre, d.Nombre ;

select * from votos_totales_departamento;

-- Votos partido
create or replace view 
max_totales_pais_partido as
select pais, Partido, max(total_votos_partido) as Maximo
from 
(select p2.Nombre as pais, p3.Nombre as Partido,
(sum(p.Analfabetos)+sum(p.Alfabetos)) as total_votos_partido
from poblacion p inner join votacion v on p.Votacion_Id = v.Id 
inner join partido p3 on p3.Id = v.Partido_Id 
inner join municipio m on m.Id = v.Municipio_Id 
inner join departamento d on d.Id = m.Departamento_Id 
inner join region r on d.Region_Id = r.Id 
inner join pais p2 on p2.Id = r.Pais_Id 
group by p2.Nombre, p3.Nombre
order by total_votos_partido desc)as tabla_p
group by pais;

create or replace view 
min_totales_pais_partido as
select pais, Partido, min(total_votos_partido) as Minimo
from 
(select p2.Nombre as pais, p3.Nombre as Partido,
(sum(p.Analfabetos)+sum(p.Alfabetos)) as total_votos_partido
from poblacion p inner join votacion v on p.Votacion_Id = v.Id 
inner join partido p3 on p3.Id = v.Partido_Id 
inner join municipio m on m.Id = v.Municipio_Id 
inner join departamento d on d.Id = m.Departamento_Id 
inner join region r on d.Region_Id = r.Id 
inner join pais p2 on p2.Id = r.Pais_Id 
group by p2.Nombre, p3.Nombre
order by total_votos_partido asc)as tabla_p
group by pais;

select * from max_totales_pais_partido;
select * from min_totales_pais_partido;


