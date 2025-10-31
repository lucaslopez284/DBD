/*
Ejercicio 5
Agencia = (razon_social, dirección, telef, email)
Ciudad = (codigo_postal, nombreCiudad, anioCreacion)
Cliente = (dni, nombre, apellido, telefono, direccion)
Viaje = (fecha, hora, dni (fk), cpOrigen(fk), cpDestino(fk), razon_social(fk), descripcion) //cpOrigen y
cpDestino corresponden a la ciudades origen y destino del viaje

1. Listar razón social, dirección y teléfono de agencias que realizaron viajes desde la ciudad de ‘La
Plata’ (ciudad origen) y que el cliente tenga apellido ‘Roma’. Ordenar por razón social y luego por
teléfono.
*/
SELECT DISTINCT a.razon_social, a.direccion, a.telef
FROM Agencia a
INNER JOIN Viaje v ON (a.razon_social = v.razon_social)
INNER JOIN Ciudad c ON (v.cpOrigen = c.codigo_postal)
INNER JOIN Cliente cli ON (v.dni = cli.dni)
WHERE c.nombreCiudad = 'La Plata'
AND cli.apellido = 'Roma'
ORDER BY razon_social, telef
/*
2. Listar fecha, hora, datos personales del cliente, nombres de ciudades origen y destino de viajes
realizados en enero de 2019 donde la descripción del viaje contenga el String ‘demorado’.
*/
SELECT v.fecha, v.hora, cli.dni, cli.nombre, cli.apellido, 
cli.telefono, cli.direccion, ciu1.nombreCiudad, ciu2.nombreCiudad
FROM Viaje v
INNER JOIN Cliente cli ON (v.dni = cli.dni)
INNER JOIN Ciudad ciu1 ON (v.cpOrigen = ciu1.codigo_postal)
INNER JOIN Ciudad ciu2 ON (v.cpDestino = ciu2.codigo_postal)
WHERE v.fecha >= '2019-1-1' AND v.fecha <= '2019-1-31'
AND v.descripcion LIKE '%demorado%'
/*
3. Reportar información de agencias que realizaron viajes durante 2019 o que tengan dirección de
mail que termine con ‘@jmail.com’.
*/
SELECT a.razon_social, a.direccion, a.telef, a.email
FROM Agencia a
INNER JOIN Viaje v ON (a.razon_social = v.razon_social)
WHERE YEAR (v.fecha) = 2019
UNION 
SELECT a.razon_social, a.direccion, a.telef, a.email
FROM Agencia a
WHERE a.email LIKE '%@jmail.com'
/*
4. Listar datos personales de clientes que viajaron solo con destino a la ciudad de ‘Coronel
Brandsen’
*/
SELECT cli.dni, cli.nombre, cli.apellido, cli.telefono, cli.direccion
FROM Cliente cli 
INNER JOIN Viaje v ON (cli.dni = v.dni)
INNER JOIN Ciudad ciu ON (v.cpDestino = ciu.codigo_postal)
WHERE ciu.nombreCiudad = 'Coronel Brandsen'
EXCEPT 
SELECT cli.dni, cli.nombre, cli.apellido, cli.telefono, cli.direccion
FROM Cliente cli 
INNER JOIN Viaje v ON (cli.dni = v.dni)
INNER JOIN Ciudad ciu ON (v.cpDestino = ciu.codigo_postal)
WHERE ciu.nombreCiudad <> 'Coronel Brandsen'
/*
5. Informar cantidad de viajes de la agencia con razón social ‘TAXI Y’ realizados a ‘Villa Elisa’.
*/
SELECT COUNT(*) AS CantViajes
FROM Agencia a
INNER JOIN Viaje v ON (a.razon_social = v.razon_social)
INNER JOIN Ciudad ciu ON  (v.cpDestino = ciu.codigo_postal)
WHERE a.razon_social = 'TAXI Y' 
AND ciu.nombreCiudad = 'Villa Elisa'
/*
6. Listar nombre, apellido, dirección y teléfono de clientes que viajaron con todas las agencias.
*/

/*
7. Modificar el cliente con DNI 38495444 actualizando el teléfono a ‘221-4400897’.
*/
UPDATE Cliente 
SET telefono = '221-4400897' 
WHERE dni = 38495444
/*
8. Listar razón social, dirección y teléfono de la/s agencias que tengan mayor cantidad de viajes
realizados.
*/

/*
9. Reportar nombre, apellido, dirección y teléfono de clientes con al menos 5 viajes.
*/
SELECT cli.nombre, cli.apellido, cli.direccion, cli.telefono
FROM Cliente cli 
INNER JOIN Viaje v ON (cli.dni =  v.dni)
GROUP BY cli.dni, cli.nombre, cli.apellido, cli.direccion, cli.telefono
HAVING (COUNT(*)>= 5)
/*
10. Borrar al cliente con DNI 40325692.
*/
DELETE FROM Viaje 
WHERE dni = 40325692

DELETE FROM Cliente 
WHERE dni = 40325692
