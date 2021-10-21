drop table Pais  ;
drop table Region;
drop table departamento ;
drop table municipio ;
drop table eleccion ;
drop table partido ;
drop table votacion ;
drop table sexo ;
drop table raza ;
drop table poblacion ;


create table Pais(
Id int auto_increment not null primary key,
Nombre Varchar(100) not null
);

create table Region(
Id int auto_increment not null primary key,
Nombre varchar(100) not null,
Pais_Id int not null,
foreign key (Pais_Id) references Pais(Id)
);

create table Departamento(
Id int auto_increment not null primary key,
Nombre varchar(100) not null,
Region_Id int not null,
foreign key (Region_Id) references Region(Id)
);

create table Municipio(
Id int auto_increment not null primary key,
Nombre varchar(100) not null,
Departamento_Id int not null,
foreign key (Departamento_Id) references Departamento(Id)
);

create table Eleccion(
Id int auto_increment not null primary key,
Nombre varchar(100) not null,
anio_eleccion int not null
);

create table Partido(
Id int auto_increment not null primary key,
Acronimo varchar(100) not null,
Nombre varchar(100) not null
);

create table Votacion(
Id int auto_increment not null primary key,
Municipio_Id int not null,
Partido_Id int not null,
Eleccion_Id int not null,
foreign key (Municipio_Id) references Municipio(Id),
foreign key (Partido_Id) references Partido(Id),
foreign key (Eleccion_Id) references Eleccion(Id)
);

create table Sexo(
Id int auto_increment not null primary key,
Sexo varchar(100) not null
);

create table Raza(
Id int auto_increment not null primary key,
Raza varchar(100) not null
);

create table Poblacion(
Id int auto_increment not null primary key,
Analfabetos int not null,
Alfabetos int not null,
Sexo_Id int not null,
Raza_Id int not null,
Primaria int not null,
Medio int not null,
Universidad int not null,
Votacion_Id int not null,
foreign key (Sexo_Id) references Sexo(Id),
foreign key (Raza_Id) references Raza(Id),
foreign key (Votacion_Id) references Votacion(Id)
);








