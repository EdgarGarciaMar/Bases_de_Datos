
-- SET sql_mode=(SELECT REPLACE(@@sql_mode,"ONLY_FULL_GROUP_BY",""));
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
  Disponivilidad int NOT NULL,
  Caducidad date NOT NULL,
  Tipo varchar(100) NOT NULL,
  Contenido varchar(100) NOT NULL,
  NombreProducto varchar(100) NOT NULL,
  ImagenProduc varchar(100) NOT NULL, -- Investigar como agregar imagenes
  Presio int NOT NULL,
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
-- Abastecer listo

-- Trabajar listo
insert into Trabajar values("Tecamac1234","juan@farma.com");
-- Almacenar listo

-- Productos
insert into productos values("Agua1234",15,"2028-04-10","Alimento","Agua Natural 1LT","Agua Epura","https://www.superama.com.mx/Content/images/products/img_large/0750108680063L.jpg",12,"Tecamac1234");
-- Comprar listo

-- SP Inicio Secion
drop procedure if exists spInicio;
delimiter |
create procedure spInicio(in id nvarchar(30), contra nvarchar(100))
begin
declare msj nvarchar(100);
declare adm nvarchar(1);
declare emple nvarchar(1);

set adm =(select count(*) from Admin1 where id = IDAdm and contra=contrasenaAdmin);

if(adm=1)then
set msj ="admin";
 select msj;
 select * from Admin1 where id = IDAdm and contra=contrasenaAdmin;
else 
set emple=(select count(*) from empleado where id = IDEmpleado and contra=ContrasenaEmp);
if(emple=1)then
set msj="empleado";
 select msj;
 select * from empleado where id = IDEmpleado and contra=ContrasenaEmp;
else
set msj="ID o contraseña incorecta";
select msj;
end if;
end if;

end; |
delimiter ;

-- call spInicio("juan@farma.com",'1234'); -- empleado
-- call spInicio("edgargarcia@farma.com",'Bon12'); -- admin


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
set msj="Porfavor verifique, si no es Admin no puede Agregar Empleados.";
select msj;
end if;
end; |
delimiter ;

-- call spcontratar("edgargarcia@farma.com", 'Bon12', "jose@farma.com","qwer", "jose", "Morales","Luna","Tecamac1234");

-- SP Agregar provedor

drop procedure if exists spagregarpro;
delimiter |
create procedure spagregarpro(in idadmi nvarchar(30), contra nvarchar(100), in idprove nvarchar(30),in nombreprove nvarchar(100), in phone nvarchar(13), in pais nvarchar(100))
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
insert into provedor values (idprove,nombreprove,phone,pais,idadmi);
select * from provedor;
end if;

if(aux1+aux2=0)then
set msj="Porfavor verifique, si no es Admin no puede Agregar Provedores.";
select msj;
end if;
end; |
delimiter ;
-- call spagregarpro("edgargarcia@farma.com",'Bon12', "Moderna@farm.com","Moderna","+525578234090", "U.S.A.")

-- SP abastecer
drop procedure if exists spabastecer;
delimiter |
create procedure spabastecer(in idadmi nvarchar(30), contra nvarchar(100), in idprove nvarchar(30),in idfarm nvarchar(30), in producto nvarchar(30),in precio int, in cant int, in fechac date,Tipo varchar(100),Contenido varchar(100),NombreProducto varchar(100),ImagenProduc varchar(100))
begin

declare aux1  nvarchar(1);
declare aux2 nvarchar(1);
declare msj nvarchar(100);
declare prod,idf,idp nvarchar(30);


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
set idf=(select count(*) from Farmacia where  idfarm=IDFarmacia);
set idp=(select count(*) from Provedor where idprove=IDProveedor);

if(idf =0 or idp =0)then
set msj="Farmacia o Provedor no registrado";
select msj;
else

insert into abastecer values(idfarm,idprove);
set prod=(select count(*) from productos where producto=IDProducto);
if(prod=1)then
update productos
set Disponivilidad=Disponivilidad+cant where producto=IDProducto;
update productos
set Presio=precio where producto=IDProducto;
select * from productos;
else
insert into productos values(producto,cant,fechac,Tipo,Contenido,NombreProducto,ImagenProduc,precio,idfarm);
select * from productos;
end if;
end if;

if(aux1+aux2=0)then
set msj="Porfavor verifique, si no es Admin no puede Agregar Abastecer farmacias.";
select msj;
end if;
end if;
end; |
delimiter ;

-- call spabastecer("edgargarcia@farma.com",'Bon12',"Aztrazenec@farm.com","Tecamac1234", "Agua1234",18, 28, "e","e","e","e","e");-- abastecer producto existente
-- call spabastecer("edgargarcia@farma.com",'Bon12',"Aztrazenec@farm.com","Tecamac1234", "ma1",18, 28, "2029-06-01","prueba","prueba","prueba","prueba");-- abastecer producto nuevo

-- SP Registrar clientes

drop procedure if exists spafiliar;
delimiter |
create procedure spafiliar(in idemple nvarchar(30), in idclie nvarchar(30), in nomcli nvarchar(100), in apellpacli nvarchar(100),in apellmacli nvarchar(100))
begin
declare aux nvarchar(1);
declare msj nvarchar(100);

set aux=(select count(*) from Empleado where idemple=IDEmpleado);

if(aux=1)then
insert into cliente values(idclie,nomcli,apellpacli,apellmacli,idemple);
select * from Cliente;
else
set msj="Error de ID Empleado";
select msj;
end if;
end; |
delimiter ;

-- call spafiliar("juan@farma.com", "fer@gmail.com","Fernanda","Garcia","Marciano");

-- SP Compras

drop procedure if exists spcompras;
delimiter |
create procedure spcompras(in idemple nvarchar(30), in idclie nvarchar(30),in idprodu nvarchar(30),in cantidad int)
begin
declare aux,aux2 nvarchar(1);
declare msj nvarchar(100);
declare existe nvarchar(100);
declare monto int;
declare idf nvarchar(30);
declare disp,prec int;

set aux=(select count(*) from Empleado where idemple=IDEmpleado);
set aux2=(select count(*) from Cliente where idclie=IDCliente);
set existe=(select count(*) from Productos where idprodu=IDProducto);
set disp=(select Disponivilidad from Productos);
set prec=(select Presio from Productos);

if(aux=1)then
if(aux2=1)then
if(existe=1)then
if(disp>0 && disp >= cantidad)then
-- Actualiza el inventario
update Productos
set Disponivilidad=Disponivilidad-cantidad where idprodu=IDProducto;
select * from Productos;
-- Calcula el monto a pagar
set monto=cantidad*prec;
select monto;
-- Guardar el resistro en comprar
insert into Comprar values(idclie,idprodu);
select * from Comprar;
-- Guardar el registro de la compra en almacen de compras del cliente
set idf=(select IDFarmacia from Trabajar where idemple=IDEmpleado);
insert into Almacenar values(idprodu,cantidad,idclie,idf);
select * from Almacenar;
else
set msj="Sin disponivilidad o producto insuficiente.";
select msj;
end if;
else
set msj="Producto no registrado";
select msj;
end if;
else
set msj="Cliente No registrado";
select msj;
end if;
else
set msj="Error ID Empleado";
select msj;
end if;

end; |
delimiter ;

-- call spcompras("juan@farma.com","paty@gmail.com","Agua1234",15);

-- view de productos
drop view if exists Mostraproductos;
create view Mostraproductos as select IDProducto,NombreProducto,Contenido,Tipo,Caducidad,Disponivilidad,ImagenProduc,Presio from Productos order by 1;

-- select * from Mostraproductos;

-- view de farmacias
drop view if exists Mostrarfarmacias;
create view Mostrarfarmacias as select f.IDFarmacia as "ID",f.NombreFarm as "Nombre",f.TelefonoFarm as "Telefono",u.Numero as "Numero",u.Calle as "Calle",p.Colonia as "Colonia",p.Ciudad as "Ciudad",p.Estado as "Estado",p.Codigo_Postal as "Codigo Postal" from Farmacia f,Ubicacion u, Postal p order by 1;
-- select * from Mostrarfarmacias;

-- view de provedores
drop view if exists Mostrarprovedores;
create view Mostrarprovedores as select IDProveedor,NombreProveedor,TelefonoProveedor,PaisProve from Provedor order by 1;
-- select * from Mostrarprovedores;

-- view de empleados
drop view if exists Mostrarempleados;
create view Mostrarempleados as select e.IDEmpleado as "ID", e.NombreEmpleado as "Nombres",e.ApellidoPaEmp as "Apellido Paterno", e.ApellidoMaEmp as "Apellido Materno", t.IDFarmacia as "ID de Farmacia laboral", f.NombreFarm as "Sucursal",f.TelefonoFarm as "Telefono",u.Numero as "Numero",u.Calle as "Calle",p.Colonia as "Colonia",p.Ciudad as "Ciudad",p.Estado as "Estado",p.Codigo_Postal as "Codigo Postal" from Empleado e, Trabajar t, Farmacia f,Ubicacion u, Postal p where e.IDEmpleado=t.IDEmpleado order by 1;
-- select * from Mostrarempleados;