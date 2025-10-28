/* Ejercicio 3
Banda = (codigoB, nombreBanda, genero_musical, anio_creacion)
Integrante = (DNI, nombre, apellido, dirección, email, fecha_nacimiento, codigoB(fk))
Escenario = (nroEscenario, nombre_escenario, ubicación, cubierto, m2, descripción)
Recital = (fecha, hora, nroEscenario (fk), codigoB (fk)) 

1. Listar DNI, nombre, apellido,dirección y email de integrantes nacidos entre 1980 y 1990 y que
hayan realizado algún recital durante 2023.
*/
SELECT DISTINCT  i.DNI, i.nombre, i.apellido, i.direccion, i.email
FROM Integrante i
INNER JOIN Banda b ON (i.codigoB = b.codigoB)
INNER JOIN Recital r ON (r.codigoB = b.codigoB)
WHERE i.fecha_nacimiento >= '1980-1-1' AND i.fecha_nacimiento <='1990-12-31'
AND r.fecha >= '2023-1-1' AND r.fecha <='2023-12-31'
/*
2. Reportar nombre, género musical y año de creación de bandas que hayan realizado recitales
durante 2023, pero no hayan tocado durante 2022 .
*/
SELECT DISTINCT b.nombreBanda, b.genero_musical, b.anio_creacion
FROM Banda b 
INNER JOIN Recital r ON (b.codigoB = r.codigoB)
WHERE r.fecha >= '2023-1-1' AND r.fecha <= '2023-12-31'
AND b.codigoB NOT IN (SELECT b2.codigoB
                      FROM Banda b2
                      INNER JOIN Recital r2 ON (b2.codigoB = r2.codigoB)
                      WHERE r2.fecha >= '2022-1-1' AND r2.fecha <= '2022-12-31')
/*
3. Listar el cronograma de recitales del día 04/12/2023. Se deberá listar nombre de la banda que
ejecutará el recital, fecha, hora, y el nombre y ubicación del escenario correspondiente.
*/
SELECT b.nombreBanda, r.fecha, r.hora, e.nombre_escenario, e.ubicacion
FROM Banda b
INNER JOIN Recital r ON (r.codigoB = b.codigoB)
INNER JOIN Escenario e ON (r.nroEscenario = e.nroEscenario)
WHERE r.fecha = '2023-12-4'
ORDER BY r.fecha, r.hora  
/*
4. Listar DNI, nombre, apellido,email de integrantes que hayan tocado en el escenario con nombre
‘Gustavo Cerati’ y en el escenario con nombre ‘Carlos Gardel’.
*/
SELECT i.DNI, i.nombre, i.apellido, i.email
FROM Integrante i
INNER JOIN Banda b ON (i.codigoB = b.codigoB)
INNER JOIN Recital r ON (b.codigoB = r.codigoB)
INNER JOIN Escenario e ON (r.nroEscenario = e.nroEscenario)
WHERE e.nombre_escenario = 'Gustavo Cerati'
INTERSECT
SELECT i.DNI, i.nombre, i.apellido, i.email
FROM Integrante i
INNER JOIN Banda b ON (i.codigoB = b.codigoB)
INNER JOIN Recital r ON (b.codigoB = r.codigoB)
INNER JOIN Escenario e ON (r.nroEscenario = e.nroEscenario)
WHERE e.nombre_escenario = 'Carlos Gardel'
/*
5. Reportar nombre, género musical y año de creación de bandas que tengan más de 5 integrantes.
*/
SELECT b.nombreBanda, b.genero_musical, b.anio_creacion
FROM Banda b
INNER JOIN Integrante i ON (b.codigoB = i.codigoB)
GROUP BY b.codigoB, b.nombreBanda, b.genero_musical, b.anio_creacion
HAVING COUNT(*)>5
/*
6. Listar nombre de escenario, ubicación y descripción de escenarios que solo tuvieron recitales
con el género musical rock and roll. Ordenar por nombre de escenario
*/

/*
7. Listar nombre, género musical y año de creación de bandas que hayan realizado recitales en
escenarios cubiertos durante 2023.// cubierto es true, false según corresponda
*/

/*
8. Reportar para cada escenario, nombre del escenario y cantidad de recitales durante 2024.
*/

/*
9. Modificar el nombre de la banda ‘Mempis la Blusera’ a: ‘Memphis la Blusera’. 
*/