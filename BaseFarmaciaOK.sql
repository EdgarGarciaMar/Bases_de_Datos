drop database if exists farm;
create database farm;
use farm;

CREATE TABLE Postal
(
  Codigo_Postal varchar(5) NOT NULL,
  Estado varchar(100) NOT NULL,
  Ciudad varchar(100) NOT NULL,
  Colonia varchar(100) NOT NULL,
  PRIMARY KEY (Codigo_Postal)
);

CREATE TABLE Admin1
(
  IDAdm varchar(30) NOT NULL,
  contrasenaAdmin varchar(100) NOT NULL,
  ApellidoPaAdm varchar(100) NOT NULL,
  ApellidoMaAdm varchar(100) NOT NULL,
  NombreAdm varchar(100) NOT NULL,
  PRIMARY KEY (IDAdm)
);

CREATE TABLE Empleado
(
  IDEmpleado varchar(30) NOT NULL,
  ContrasenaEmp varchar(100) NOT NULL,
  NombreEmpleado varchar(100) NOT NULL,
  ApellidoPaEmp varchar(100) NOT NULL,
  ApellidoMaEmp varchar(100) NOT NULL,
  IDAdm varchar(30) NOT NULL,
  PRIMARY KEY (IDEmpleado),
  FOREIGN KEY (IDAdm) REFERENCES Admin1(IDAdm)
);

CREATE TABLE Provedor
(
  IDProveedor varchar(30) NOT NULL,
  NombreProveedor varchar(100) NOT NULL,
  TelefonoProveedor varchar(13) NOT NULL,
  PaisProve varchar(100) NOT NULL,
  IDAdm varchar(30) NOT NULL,
  PRIMARY KEY (IDProveedor),
  FOREIGN KEY (IDAdm) REFERENCES Admin1(IDAdm)
);

CREATE TABLE Farmacia
(
  IDFarmacia varchar(30) NOT NULL,
  TelefonoFarm varchar(13) NOT NULL,
  NombreFarm varchar(100) NOT NULL,
  IDAdm varchar(30) NOT NULL,
  PRIMARY KEY (IDFarmacia),
  FOREIGN KEY (IDAdm) REFERENCES Admin1(IDAdm)
);

CREATE TABLE Cliente
(
  IDCliente varchar(30) NOT NULL,
  NombreCli varchar(100) NOT NULL,
  ApellidoPaCli varchar(100) NOT NULL,
  ApellidoMaCli varchar(100) NOT NULL,
  IDEmpleado varchar(30) NOT NULL,
  PRIMARY KEY (IDCliente),
  FOREIGN KEY (IDEmpleado) REFERENCES Empleado(IDEmpleado)
);

CREATE TABLE Ubicacion
(
  Numero INT NOT NULL,
  Calle varchar(100) NOT NULL,
  IDFarmacia varchar(30) NOT NULL,
  Codigo_Postal varchar(5) NOT NULL,
  FOREIGN KEY (IDFarmacia) REFERENCES Farmacia(IDFarmacia),
  FOREIGN KEY (Codigo_Postal) REFERENCES Postal(Codigo_Postal)
);

CREATE TABLE Abastecer
(
  IDFarmacia varchar(30) NOT NULL,
  IDProveedor varchar(30) NOT NULL,
  PRIMARY KEY (IDFarmacia, IDProveedor),
  FOREIGN KEY (IDFarmacia) REFERENCES Farmacia(IDFarmacia),
  FOREIGN KEY (IDProveedor) REFERENCES Provedor(IDProveedor)
);

CREATE TABLE Trabajar
(
  IDFarmacia varchar(30) NOT NULL,
  IDEmpleado varchar(30) NOT NULL,
  PRIMARY KEY (IDFarmacia, IDEmpleado),
  FOREIGN KEY (IDFarmacia) REFERENCES Farmacia(IDFarmacia),
  FOREIGN KEY (IDEmpleado) REFERENCES Empleado(IDEmpleado)
);

CREATE TABLE Almacenar
(
  IDProd varchar(30) NOT NULL,
  CantidadProd varchar(100) NOT NULL,
  IDCliente varchar(30) NOT NULL,
  IDFarmacia varchar(30) NOT NULL,
  PRIMARY KEY (IDProd),
  FOREIGN KEY (IDCliente) REFERENCES Cliente(IDCliente),
  FOREIGN KEY (IDFarmacia) REFERENCES Farmacia(IDFarmacia),
  UNIQUE (IDCliente, IDFarmacia)
);

CREATE TABLE Productos
(
  IDProducto varchar(30) NOT NULL,
  Disponivilidad varchar(100) NOT NULL,
  Caducidad date NOT NULL,
  Tipo varchar(100) NOT NULL,
  Contenido varchar(100) NOT NULL,
  NombreProducto varchar(100) NOT NULL,
  ImagenProduc varchar(100) NOT NULL, -- Investigar como agregar imagenes
  IDFarmacia varchar(100) NOT NULL,
  PRIMARY KEY (IDProducto),
  FOREIGN KEY (IDFarmacia) REFERENCES Farmacia(IDFarmacia)
);

CREATE TABLE Comprar
(
  IDCliente varchar(30) NOT NULL,
  IDProducto varchar(30) NOT NULL,
  PRIMARY KEY (IDCliente, IDProducto),
  FOREIGN KEY (IDCliente) REFERENCES Cliente(IDCliente),
  FOREIGN KEY (IDProducto) REFERENCES Productos(IDProducto)
);

-- show tables;
-- Postal
insert into postal values("55749","Edo. Mex.","Tecamac","Lomas");
-- Admins
insert into admin1 values("edgargarcia@farma.com",'Bon12',"Garcia","Marciano","Edgar");
-- Empleados
insert into empleado values("juan@farma.com",'1234',"Juan","Ruiz","Jimenez","edgargarcia@farma.com");
-- Provedor
insert into provedor values ("Aztrazenec@farm.com","Aztrazeneca","+525509123698","U.K.","edgargarcia@farma.com");
-- Farmacia
insert into farmacia values("Tecamac1234","+525512345678","Farmacia Tecamac","edgargarcia@farma.com");
-- Cliente
insert into cliente values("paty@gmail.com","Patricia","Marciano","Lazaro","juan@farma.com");
-- Ubicacion
insert into ubicacion values(14,"Lomas","Tecamac1234","55749");
-- Abastecer

-- Trabajar

-- Almacenar

-- Productos
insert into productos values("Agua1234","15","2028-04-10","Alimento","Agua Natural 1LT","Agua Epura","https://www.superama.com.mx/Content/images/products/img_large/0750108680063L.jpg","Tecamac1234");
-- Comprar

-- Sp Registrar Admin
drop procedure if exists spCreaAdmin;
delimiter |
create procedure spCreaAdmin(in idadmi nvarchar(30), contra nvarchar(100), in idnewAd nvarchar(30),in newcontra nvarchar(100), in NewApellPAAd nvarchar(100),in NewApellMAAd nvarchar(100),in NewNomAd nvarchar(100))
begin
declare aux1  nvarchar(1);
declare aux2 nvarchar(1);
declare msj nvarchar(100);

set aux1=(select count(*) from Admin1 where idadmi = IDAdm); 
set aux2=(select count(*) from Admin1 where contra=contrasenaAdmin);

if(aux1!= 1)then
set msj="ID incorrecta";
select msj;
end if;

if(aux2!=1)then
set msj="Contraseña incorrecta";
select msj;
end if;

if(aux1+aux2=2)then
insert into Admin1 values(idnewAd,newcontra,NewApellPAAd,NewApellMAAd,NewNomAd);
select * from Admin1;
end if;

if(aux1+aux2=0)then
set msj="Porfavor verifique, si no es Admin no puede agregar a mas Admins.";
select msj;
end if;

end; |
delimiter ;

-- call spCreaAdmin("edgargarcia@farma.com", 'Bon12', "Mario@farma.com","hola","Perez","Ju","Mario");


-- Sp Registrar farmacia
drop procedure if exists spCreafarm;
delimiter |
create procedure spCreafarm(in idadmi nvarchar(30), contra nvarchar(100), in idfarm nvarchar(30),in phone nvarchar(13), in nomfarm nvarchar(100), in cp nvarchar(5),in edo nvarchar(100),in ciudad nvarchar(100),in colonia nvarchar(100), in num int)
begin

declare aux1  nvarchar(1);
declare aux2 nvarchar(1);
declare msj nvarchar(100);

set aux1=(select count(*) from Admin1 where idadmi = IDAdm); 
set aux2=(select count(*) from Admin1 where contra=contrasenaAdmin);

if(aux1 !=1 )then
set msj="ID incorrecta";
select msj;
end if;

if(aux2!=1)then
set msj="Contraseña incorrecta";
select msj;
end if;

if(aux1+aux2=2)then
insert into farmacia values(idfarm,phone,nomfarm,idadmi);
insert into postal values(cp,edo,ciudad,colonia);
insert into ubicacion values(num,colonia,idfarm,cp);
select * from farmacia;
select * from postal;
select * from ubicacion;
end if;

if(aux1+aux2=0)then
set msj="Porfavor verifique, si no es Admin no puede Agregar Farmacias.";
select msj;
end if;
end; |
delimiter ;

-- call spCreafarm("edgargarcia@farma.com", 'Bon12', "CDMX1234","+525555555555", "Farmacia CDMX","06920","CDMX","GAM","5 mayo",11);

-- SP contratar empleados
drop procedure if exists spcontratar;
delimiter |
create procedure spcontratar(in idadmi nvarchar(30), contra nvarchar(100), in newidemp nvarchar(30),in newcontra nvarchar(100), in nomemp nvarchar(100), in apellpaem nvarchar(100),in apellmaem nvarchar(100), in idfarm nvarchar(30))
begin

declare aux1  nvarchar(1);
declare aux2 nvarchar(1);
declare msj nvarchar(100);

set aux1=(select count(*) from Admin1 where idadmi = IDAdm); 
set aux2=(select count(*) from Admin1 where contra=contrasenaAdmin);

if(aux1 !=1 )then
set msj="ID incorrecta";
select msj;
end if;

if(aux2!=1)then
set msj="Contraseña incorrecta";
select msj;
end if;

if(aux1+aux2=2)then
insert into empleado values(newidemp,newcontra,nomemp,apellpaem,apellmaem,idadmi);
insert into trabajar values(idfarm,newidemp);
select * from empleado;
select * from trabajar;
end if;

if(aux1+aux2=0)then
set msj="Porfavor verifique, si no es Admin no puede Agregar Farmacias.";
select msj;
end if;
end; |
delimiter ;

-- call spcontratar("edgargarcia@farma.com", 'Bon12', "jose@farma.com","qwer", "jose", "Morales","Luna","Tecamac1234");

-- SP Agregar provedor

drop procedure if exists spagregarpro;
delimiter |
create procedure spagregarpro(in idadmi nvarchar(30), contra nvarchar(100), in newidemp nvarchar(30),in newcontra nvarchar(100), in nomemp nvarchar(100), in apellpaem nvarchar(100),in apellmaem nvarchar(100), in idfarm nvarchar(30))
begin

declare aux1  nvarchar(1);
declare aux2 nvarchar(1);
declare msj nvarchar(100);

set aux1=(select count(*) from Admin1 where idadmi = IDAdm); 
set aux2=(select count(*) from Admin1 where contra=contrasenaAdmin);

if(aux1 !=1 )then
set msj="ID incorrecta";
select msj;
end if;

if(aux2!=1)then
set msj="Contraseña incorrecta";
select msj;
end if;

if(aux1+aux2=2)then
insert into empleado values(newidemp,newcontra,nomemp,apellpaem,apellmaem,idadmi);
insert into trabajar values(idfarm,newidemp);
select * from empleado;
select * from trabajar;
end if;

if(aux1+aux2=0)then
set msj="Porfavor verifique, si no es Admin no puede Agregar Farmacias.";
select msj;
end if;
end; |
delimiter ;
-- select * from farmacia,trabajar where IDEmpleado="jose@farma.com";
-- select * from admin1;