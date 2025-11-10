/*Ejercicio 8
Equipo = (codigoE, nombreE, descripcionE)
Integrante = (DNI, nombre, apellido, ciudad, email, telefono, codigoE(fk))
Laguna = (nroLaguna, nombreL, ubicación, extension, descripción)
TorneoPesca = (codTorneo, fecha, hora, nroLaguna(fk), descripcion)
Inscripcion = (codTorneo(fk), codigoE(fk), asistio, gano) // asistio y gano son true o false según
corresponda
*/

/*
1. Listar DNI, nombre, apellido y email de integrantes que sean de la ciudad ‘La Plata’ y estén
inscriptos en torneos disputados en 2023.
*/
SELECT i.DNI, i.nombre, i.apellido, i.email
FROM Integrante i
WHERE i.ciudad = 'La Plata'
AND i.DNI IN (
    SELECT i2.DNI
    FROM Integrante i2 
    INNER JOIN Equipo e ON (i2.codigoE = e.codigoE)
    INNER JOIN Inscripcion ins ON (e.codigoE = ins.codigoE)
    INNER JOIN TorneoPesca tp ON (ins.codTorneo = tp.codTorneo)
    WHERE YEAR (tp.fecha) = 2023 )
/*
2. Reportar nombre y descripción de equipos que solo se hayan inscripto en torneos de 2020.
*/
SELECT DISTINCT e.nombreE, e.descripcionE
FROM Equipo e
INNER JOIN Inscripcion ins ON (e.codigoE = ins.codigoE)
INNER JOIN TorneoPesca tp ON (ins.codTorneo = tp.codTorneo)
WHERE YEAR (tp.fecha) = 2020
AND e.codigoE NOT IN (
       SELECT e2.codigoE
       FROM Equipo e2
       INNER JOIN Inscripcion ins2 ON (e2.codigoE = ins2.codigoE)
       INNER JOIN TorneoPesca tp2 ON (ins2.codTorneo = tp2.codTorneo)
       WHERE YEAR (tp2.fecha) <> 2020)
/*
3. Listar DNI, nombre, apellido,email y ciudad de integrantes que asistieron a torneos en la laguna con
nombre ‘La Salada, Coronel Granada’ y su equipo no tenga inscripciones a torneos disputados en
2023.
*/
SELECT DISTINCT i.DNI, i.nombre , i.apellido, i.ciudad
FROM Integrante i
INNER JOIN Equipo e ON (i.codigoE = e.codigoE)
INNER JOIN Inscripcion ins ON (e.codigoE = ins.codigoE)
INNER JOIN TorneoPesca tp ON (ins.codTorneo = tp.codTorneo)
INNER JOIN Laguna l ON (tp.nroLaguna = l.nroLaguna)
WHERE l.nombreL = 'La Salada, Coronel Granada'
AND e.codigoE NOT IN (
    SELECT e2.codigoE
    FROM Equipo e2
    INNER JOIN Inscripcion ins2 ON (e2.codigoE = ins2.codigoE)
    INNER JOIN TorneoPesca tp2 ON (ins2.codTorneo = tp2.codTorneo)
    WHERE YEAR (tp2.fecha) = 2023)
/*
4. Reportar nombre y descripción de equipos que tengan al menos 5 integrantes. Ordenar por nombre.
*/
SELECT e.nombreE, e.descripcionE
FROM Equipo e
INNER JOIN Integrante i ON (e.codigoE = i.codigoE)
GROUP BY e.codigoE, e.nombreE, e.descripcionE
HAVING COUNT(*) > 4
ORDER BY e.nombreE
/*
5. Reportar nombre y descripción de equipos que tengan inscripciones en todas las lagunas.
*/
SELECT e.nombreE, e.descripcionE
FROM Equipo e 
INNER JOIN Inscripcion ins ON (e.codigoE = ins.codigoE)
INNER JOIN TorneoPesca tp ON (ins.codTorneo = tp.codTorneo)
GROUP BY e.codigoE, e.nombreE, e.descripcionE
HAVING COUNT(DISTINCT tp.nroLaguna) = (
   SELECT COUNT(*)
   FROM Laguna )
/*
6. Eliminar el equipo con código 10000.
*/
DELETE FROM Inscripcion WHERE codigoE = 1000
DELETE FROM Equipo WHERE codigoE = 1000
/*
7. Listar nombre, ubicación,extensión y descripción de lagunas que no tuvieron torneos.
*/
SELECT l.nombreL, l.ubicacion, l.extension, l.descripcion
FROM Laguna l
WHERE l.nroLaguna NOT IN (
   SELECT l2.nroLaguna
   FROM Laguna l2
   INNER JOIN TorneoPesca tp ON (l2.nroLaguna = tp.nroLaguna))
/*
8. Reportar nombre y descripción de equipos que tengan inscripciones a torneos a disputarse durante
2024, pero no tienen inscripciones a torneos de 2023.
*/
SELECT DISTINCT e.nombreE, e.descripcionE
FROM Equipo e
INNER JOIN Inscripcion ins ON (e.codigoE = ins.codigoE)
INNER JOIN TorneoPesca tp ON (ins.codTorneo = tp.codTorneo)
WHERE YEAR (tp.fecha) = 2024
AND e.codigoE NOT IN (
    SELECT e2.codigoE
    FROM Equipo e2
    INNER JOIN Inscripcion ins2 ON (e2.codigoE = ins2.codigoE)
    INNER JOIN TorneoPesca tp2 ON (ins2.codTorneo = tp2.codTorneo)
    WHERE YEAR (tp2.fecha) = 2023)
/*
9. Listar DNI, nombre, apellido, ciudad y email de integrantes que ganaron algún torneo que se disputó
en la laguna con nombre: ‘Laguna de Chascomús’.
*/
SELECT DISTINCT i.DNI, i.nombre, i.apellido, i.ciudad, i.email
FROM Integrante i
INNER JOIN Equipo e ON (i.codigoE = e.codigoE)
INNER JOIN Inscripcion ins ON (e.codigoE = ins.codigoE)
INNER JOIN TorneoPesca tp ON (ins.codTorneo = tp.codTorneo)
INNER JOIN Laguna l ON (tp.nroLaguna = l.nroLaguna)
WHERE l.nombreL = 'Laguna de Chascomús'
AND ins.gano = true