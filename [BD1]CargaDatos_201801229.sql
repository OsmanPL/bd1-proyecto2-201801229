-- Insertar En Tabla Pais
insert into Pais (Nombre)
select distinct temporal.PAIS  
from temporal 
group by temporal.PAIS ;

-- Insertar En Tabla Region

insert into Region (Nombre, Pais_Id)
select distinct temporal.REGION , pais.Id 
from temporal inner join pais 
on temporal.PAIS = pais.Nombre 
group by temporal.REGION , pais.Id ;

-- Insertar En Tabla Departamento

insert into Departamento (Nombre, Region_Id)
select distinct temporal.DEPTO , region.Id 
from temporal inner join region on temporal.REGION = region.Nombre 
inner join pais on pais.Nombre = temporal.PAIS 
where pais.Id = region.Pais_Id ;

-- Insertar en Tabla Municipio

insert into Municipio (Nombre, Departamento_Id)
select distinct temporal.MUNICIPIO , departamento.Id 
from temporal inner join departamento on departamento.Nombre = temporal.DEPTO 
group by temporal.MUNICIPIO , departamento.Id ;

-- Insertar en Tabla Eleccion

insert into Eleccion (Nombre, anio_eleccion)
select distinct temporal.NOMBRE_ELECCION , temporal.ANIO_ELECCION 
from temporal 
group by temporal.NOMBRE_ELECCION , temporal.ANIO_ELECCION ;

-- Insertar en Tabla Partido

insert into Partido (Partido, Nombre)
select distinct temporal.PARTIDO , temporal.NOMBRE_PARTIDO 
from temporal 
group by temporal.PARTIDO , temporal.NOMBRE_PARTIDO ;

-- Insertar en Tabla Votacion

insert into Votacion (Municipio_Id, Eleccion_Id, Partido_Id)
select distinct municipio.Id , eleccion.Id , partido.id 
from temporal inner join pais on pais.Nombre = temporal.PAIS 
inner join region on region.Nombre = temporal.REGION and pais.Id = region.Pais_Id 
inner join departamento on departamento.Nombre = temporal.DEPTO and region.Id = departamento.Region_Id 
inner join municipio on temporal.MUNICIPIO = municipio.Nombre and municipio.Departamento_Id = departamento.Id 
inner join eleccion on eleccion.Nombre = temporal.NOMBRE_ELECCION and eleccion.anio_eleccion = temporal.ANIO_ELECCION 
inner join partido on temporal.PARTIDO = partido.Partido and temporal.NOMBRE_PARTIDO = partido.Nombre 
group by municipio.Id , eleccion.Id , partido.id ;

-- Insertar en Tabla Sexo

insert into Sexo (Sexo)
select distinct temporal.SEXO 
from temporal 
group by temporal.SEXO ;

-- Insertar en Tabla Raza

insert into Raza (Raza)
select distinct temporal.RAZA 
from temporal 
group by temporal.RAZA ;

-- Insertar en Tabla  Poblacion

insert into Poblacion (Analfabetos, Alfabetos, Sexo_Id, Raza_Id, Primaria, Medio, Universidad, Votacion_Id)
select distinct temporal.ANALFABETOS , temporal.ALFABETOS , sexo.Id , raza.Id , temporal.PRIMARIA , temporal.NIVEL_MEDIO , 
temporal.UNIVERSITARIOS , votacion.Id 
from temporal inner join sexo on sexo.Sexo = temporal.SEXO 
inner join raza on raza.Raza = temporal.RAZA 
inner join eleccion on eleccion.Nombre = temporal.NOMBRE_ELECCION and eleccion.anio_eleccion = temporal.ANIO_ELECCION 
inner join partido on partido.Partido = temporal.PARTIDO  and temporal.NOMBRE_PARTIDO = partido.Nombre 
inner join pais on pais.Nombre = temporal.PAIS 
inner join region on region.Nombre = temporal.REGION and pais.Id = region.Pais_Id 
inner join departamento on departamento.Nombre = temporal.DEPTO and region.Id = departamento.Region_Id 
inner join municipio on municipio.Nombre = temporal.MUNICIPIO and departamento.Id = municipio.Departamento_Id 
inner join votacion on votacion.Municipio_Id = municipio.Id and votacion.Partido_Id = partido.Id 
and votacion.Eleccion_Id = eleccion.Id 
group by temporal.ANALFABETOS , temporal.ALFABETOS , sexo.Id , raza.Id , temporal.PRIMARIA , temporal.NIVEL_MEDIO , 
temporal.UNIVERSITARIOS , votacion.Id ;






