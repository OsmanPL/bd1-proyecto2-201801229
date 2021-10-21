-- Insertar En Tabla Pais
insert into Pais (Nombre)
select distinct temporal.PAIS  
from temporal 
group by temporal.PAIS ;

select * from pais p ;

-- Insertar En Tabla Region

insert into Region (Nombre, Pais_Id)
select distinct temporal.REGION , pais.Id 
from temporal inner join pais 
on temporal.PAIS = pais.Nombre 
group by temporal.REGION , pais.Id ;

select * from region r ;


