/* Ejercicio 2
Localidad = (codigoPostal, nombreL, descripcion, nroHabitantes)
Arbol = (nroArbol, especie, anios, calle, nro, codigoPostal(fk))
Podador = (DNI, nombre, apellido, telefono, fnac, codigoPostalVive(fk))
Poda = (codPoda, fecha, DNI(fk), nroArbol(fk))

1. Listar especie, años, calle, nro y localidad de árboles podados por el podador ‘Juan Perez’ y por
el podador ‘Jose Garcia’.
*/
SELECT a.especie, a.anios, a.calle, a.nro, l.nombreL
FROM Arbol a 
INNER JOIN Localidad l ON (a.codigoPostal = l.codigoPostal)
INNER JOIN Poda p ON (a.nroArbol = p.nroArbol)
INNER JOIN Podador pr ON (p.DNI = pr.DNI)
WHERE pr.nombre = 'Juan' AND pr.apellido = 'Perez'
AND a.nroArbol IN (SELECT a2.nroArbol
                   FROM Arbol a2 
                   INNER JOIN Poda p ON (a2.nroArbol = p.nroArbol)
                   INNER JOIN Podador pr ON (p.DNI = pr.DNI)
                   WHERE pr.nombre = 'Jose' AND pr.apellido = 'Garcia')
                                                   
/*
2. Reportar DNI, nombre, apellido, fecha de nacimiento y localidad donde viven de aquellos
podadores que tengan podas realizadas durante 2023.
*/
SELECT DISTINCT pr.DNI, pr.apellido, pr.fnac , l.nombreL
FROM Podador pr   
INNER JOIN Localidad l ON (pr.codigoPostalVive =  l.codigoPostal) 
INNER JOIN Poda p ON (pr.DNI = p.DNI)
WHERE p.fecha >= '2023-1-1' AND '2023-12-31'
                                         
/*
3. Listar especie, años, calle, nro y localidad de árboles que no fueron podados nunca.
*/
SELECT a.especie, anios, a.calle, a.nroArbol, l.nombreL                      
FROM Arbol a
INNER JOIN Localidad l ON (a.codigoPostal = l.codigoPostal)
WHERE a.nroArbol NOT IN (SELECT a2.nroArbol
                         FROM Arbol a2
                         INNER JOIN Poda p ON (a2.nroArbol = p.nroArbol))
/*
4. Reportar especie, años,calle, nro y localidad de árboles que fueron podados durante 2022 y no
fueron podados durante 2023.
*/
SELECT a.especie, a.anios, a.nro, l.nombreL
FROM Arbol a
INNER JOIN Localidad l ON  (a.codigoPostal = l.codigoPostal)
INNER JOIN Poda p ON (a.nroArbol = p.nroArbol)
WHERE p.fecha >= '2022-1-1' AND p.fecha <='2022-12-31'
AND a.nroArbol NOT IN (SELECT a2.nroArbol
                       FROM Arbol a2
                       INNER JOIN Poda p2 ON (a2.nroArbol = p2.nroArbol)
                       WHERE p2.fecha >= '2023-1-1' AND p2.fecha <= '2023-12-31')


/*
5. Reportar DNI, nombre, apellido, fecha de nacimiento y localidad donde viven de aquellos
podadores con apellido terminado con el string ‘ata’ y que tengan al menos una poda durante
2024. Ordenar por apellido y nombre.
*/
SELECT DISTINCT pr.DNI, pr.nombre, pr.apellido, pr.fnac, l.nombreL
FROM Podador pr
INNER JOIN Localidad l ON (pr.codigoPostalVive = l.codigoPostal)
INNER JOIN Poda p ON (pr.DNI = p.DNI)
WHERE pr.apellido LIKE '%ata'
AND p.fecha >= '2024-1-1' AND p.fecha <='2024-12-31'
ORDER BY pr.apellido, pr.nombre
/*
6. Listar DNI, apellido, nombre, teléfono y fecha de nacimiento de podadores que solo podaron
árboles de especie ‘Coníferas’.
*/
SELECT DISTINCT pr.DNI, pr.apellido, pr.nombre, pr.telefono, pr.fnac
FROM Podador pr
INNER JOIN Poda p ON (pr.DNI = p.DNI)
INNER JOIN Arbol a On (p.nroArbol = a.nroArbol)
WHERE a.especie = 'Conifera'
AND pr.DNI NOT IN (SELECT pr2.DNI
                   FROM Podador pr2 
                   INNER JOIN Poda p2 ON (pr2.DNI = p2.DNI)
                   INNER JOIN Arbol a2 On (p2.nroArbol = a2.nroArbol)
                   WHERE a2.especie <> 'Conifera')
/*
7. Listar especies de árboles que se encuentren en la localidad de ‘La Plata’ y también en la
localidad de ‘Salta’.
*/
SELECT a.especie
FROM Arbol a
INNER JOIN Localidad l ON (a.codigoPostal = l.codigoPostal)
WHERE l.nombreL = 'La Plata'
INTERSECT (SELECT a.especie
           FROM Arbol a
           INNER JOIN Localidad l ON (a.codigoPostal = l.codigoPostal)
           WHERE l.nombreL = 'Salta')
/*
8. Eliminar el podador con DNI 22234566.
*/
DELETE 
FROM Poda p
WHERE p.DNI = 22234566

DELETE
FROM Podador p
WHERE p.DNI = 22234566
/*
9. Reportar nombre, descripción y cantidad de habitantes de localidades que tengan menos de 5
árboles.
*/
SELECT l.nombreL, l.descripcion, l.nroHabitantes
FROM Localidad l
INNER JOIN Arbol a ON (l.codigoPostal = a.codigoPostal)
GROUP BY l.codigoPostal, l.codigoPostal, l.nombreL, l.descripcion, l.nroHabitantes
HAVING COUNT(*) < 5