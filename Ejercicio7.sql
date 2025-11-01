/*Ejercicio 7
Club = (codigoClub, nombre, anioFundacion, codigoCiudad(FK))
Ciudad = (codigoCiudad, nombre)
Estadio = (codigoEstadio, codigoClub(FK), nombre, direccion)
Página 4 de 8
Jugador = (DNI, nombre, apellido, edad, codigoCiudad(FK))
ClubJugador = (codigoClub (FK), DNI (FK), desde, hasta)
1. Reportar nombre y año de fundación de aquellos clubes de la ciudad de La Plata que no poseen
estadio.
*/

/*
2. Listar nombre de los clubes que no hayan tenido ni tengan jugadores de la ciudad de Berisso.
*/

/*
3. Mostrar DNI, nombre y apellido de aquellos jugadores que jugaron o juegan en el club Gimnasia
y Esgrima La Plata.
*/

/*
4. Mostrar DNI, nombre y apellido de aquellos jugadores que tengan más de 29 años y hayan
jugado o juegan en algún club de la ciudad de Córdoba.
*/

/*
5. Mostrar para cada club, nombre de club y la edad promedio de los jugadores que juegan
actualmente en cada uno.
*/

/*
6. Listar para cada jugador nombre, apellido, edad y cantidad de clubes diferentes en los que jugó.
(incluido el actual)
*/

/*
7. Mostrar el nombre de los clubes que nunca hayan tenido jugadores de la ciudad de Mar del
Plata.
*/

/*
8. Reportar el nombre y apellido de aquellos jugadores que hayan jugado en todos los clubes de la
ciudad de Córdoba.
*/

/*
9. Agregar el club “Estrella de Berisso”, con código 1234, que se fundó en 1921 y que pertenece a
la ciudad de Berisso. Puede asumir que el codigoClub 1234 no existe en la tabla Club.
*/