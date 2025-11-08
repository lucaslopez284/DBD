/*Ejercicio 7
Club = (codigoClub, nombre, anioFundacion, codigoCiudad(FK))
Ciudad = (codigoCiudad, nombre)
Estadio = (codigoEstadio, codigoClub(FK), nombre, direccion)
Jugador = (DNI, nombre, apellido, edad, codigoCiudad(FK))
ClubJugador = (codigoClub (FK), DNI (FK), desde, hasta)

1. Reportar nombre y año de fundación de aquellos clubes de la ciudad de La Plata que no poseen
estadio.
*/
SELECT cl.nombre, cl.anioFundacion
FROM Club cl 
INNER JOIN Ciudad ciu ON (cl.codigoCiudad = ciu.codigoCiudad)
WHERE ciu.nombre = 'La Plata' AND cl.codigoClub NOT IN (
  SELECT cl2.codigoClub
  FROM Club cl2
  INNER JOIN Estadio e ON (cl2.codigoClub = e.codigoClub)
  INNER JOIN Ciudad ciu2 ON (cl2.codigoCiudad = ciu2.codigoCiudad)
  WHERE ciu2.nombre = 'La Plata')
/*
2. Listar nombre de los clubes que no hayan tenido ni tengan jugadores de la ciudad de Berisso.
*/
SELECT cl.nombre
FROM Club cl 
WHERE cl.codigoClub NOT IN (
  SELECT cl2.codigoClub
  FROM Club cl2
  INNER JOIN ClubJugador cj ON (cl2.codigoClub = cj.codigoClub)
  INNER JOIN Jugador j ON (cj.DNI = j.DNI)
  INNER JOIN Ciudad ciu ON (j.codigoCiudad = ciu.codigoCiudad)
  WHERE ciu.nombre = 'Berisso')
/*
3. Mostrar DNI, nombre y apellido de aquellos jugadores que jugaron o juegan en el club Gimnasia
y Esgrima La Plata.
*/
SELECT DISTINCT j.DNI, j.nombre, j.apellido
FROM Jugador j
INNER JOIN ClubJugador cj ON (j.DNI = cj.DNI)
INNER JOIN Club c ON (cj.codigoClub = c.codigoClub)
WHERE c.nombre = 'Gimnasia y Esgrima La Plata'
/*
4. Mostrar DNI, nombre y apellido de aquellos jugadores que tengan más de 29 años y hayan
jugado o juegan en algún club de la ciudad de Córdoba.
*/
SELECT DISTINCT j.DNI, j.nombre, j.apellido
FROM Jugador j
INNER JOIN ClubJugador cj ON (j.DNI = cj.DNI)
INNER JOIN Club clu ON (cj.codigoClub = clu.codigoClub)
INNER JOIN Ciudad ciu ON (clu.codigoCiudad = ciu.codigoCiudad)
WHERE ciu.nombre = 'Cordoba' AND j.edad > 29
/*
5. Mostrar para cada club, nombre de club y la edad promedio de los jugadores que juegan
actualmente en cada uno.
*/
SELECT cl.nombre, AVG(j.edad) AS edadPromedio
FROM Club cl
INNER JOIN ClubJugador cj ON (cl.codigoClub = cj.codigoClub)
INNER JOIN Jugador j ON (cj.DNI = j.DNI)
WHERE cj.hasta IS NULL 
GROUP BY cl.codigoClub, cl.nombre
/*
6. Listar para cada jugador nombre, apellido, edad y cantidad de clubes diferentes en los que jugó.
(incluido el actual)
*/
SELECT j.nombre, j.apellido, j.edad, COUNT(DISTINCT cj.codigoClub) AS cantClubesJugo
FROM Jugador j
LEFT JOIN ClubJugador cj ON (j.DNI = cj.DNI)
GROUP BY j.DNI, j.nombre, j.apellido, j.edad
/*
7. Mostrar el nombre de los clubes que nunca hayan tenido jugadores de la ciudad de Mar del
Plata.
*/
SELECT cl.nombre
FROM Club cl 
WHERE cl.codigoClub NOT IN (
  SELECT cl2.codigoClub
  FROM Club cl2
  INNER JOIN ClubJugador cj ON (cl2.codigoClub = cj.codigoClub)
  INNER JOIN Jugador j ON (cj.DNI = j.DNI)
  INNER JOIN Ciudad ciu ON (j.codigoCiudad = ciu.codigoCiudad)
  WHERE ciu.nombre = 'Mar del Plata')
/*
8. Reportar el nombre y apellido de aquellos jugadores que hayan jugado en todos los clubes de la
ciudad de Córdoba.
*/
SELECT j.nombre, j.apellido
FROM Jugador j
INNER JOIN ClubJugador cj ON (j.DNI = cj.DNI)
INNER JOIN Club cl ON (cj.codigoClub = cl.codigoClub)
INNER JOIN Ciudad ciu ON (cl.codigoCiudad = ciu.codigoCiudad)
WHERE ciu.nombre = 'Cordoba'
GROUP BY j.DNI, j.nombre, j.apellido
HAVING COUNT(DISTINCT cl.codigoClub) = (
  SELECT COUNT(DISTINCT cl2.codigoClub)
  FROM Club cl2
  INNER JOIN Ciudad ciu2 ON (cl2.codigoCiudad = ciu2.codigoCiudad)
  WHERE ciu2.nombre = 'Cordoba'
)

/*
9. Agregar el club “Estrella de Berisso”, con código 1234, que se fundó en 1921 y que pertenece a
la ciudad de Berisso. Puede asumir que el codigoClub 1234 no existe en la tabla Club.
*/
INSERT INTO Club (codigoClub, nombre, anioFundacion, codigoCiudad)
VALUES (1234, 'Estrella de Berisso', 1921, 2)