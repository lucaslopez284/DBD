/* Ejercicio 6
Técnico = (codTec, nombre, especialidad) // técnicos
Repuesto = (codRep, nombre, stock, precio) // repuestos
RepuestoReparacion = (nroReparac (fk), codRep (fk), cantidad, precio) // repuestos utilizados en
reparaciones.
Reparación = (nroReparac, codTec (fk), precio_total, fecha) // reparaciones realizadas.
1. Listar los repuestos, informando el nombre, stock y precio. Ordenar el resultado por precio.
*/
SELECT r.nombre, r.stock, r.precio
FROM Repuesto r
ORDER BY r.precio
/*
2. Listar nombre, stock y precio de repuestos que se usaron en reparaciones durante 2023 y que no
se usaron en reparaciones del técnico ‘José Gonzalez’.
*/
SELECT r.nombre, r.stock, r.precio
FROM Repuesto r
INNER JOIN RepuestoReparacion r2 ON (r.codRep = r2.codRep)
INNER JOIN Reparacion r3 ON (r2.nroReparac = r3.nroReparac)
WHERE YEAR (r3.fecha) = 2023
EXCEPT
SELECT r.nombre, r.stock, r.precio
FROM Repuesto r
INNER JOIN RepuestoReparacion r2 ON (r.codRep = r2.codRep)
INNER JOIN Reparacion r3 ON (r2.nroReparac = r3.nroReparac)
INNER JOIN Tecnico t ON (r3.codTec = t.codTec)
WHERE t.nombre = 'Jose Gonzalez'
/*
3. Listar el nombre y especialidad de técnicos que no participaron en ninguna reparación. Ordenar
por nombre ascendentemente.
*/
SELECT t.nombre, t.especialidad
FROM Tecnico t
EXCEPT (SELECT t.nombre, t.especialidad
        FROM Tecnico t
        INNER JOIN Reparacion r ON (t.codTec = r.codTec))
ORDER BY nombre 
/*
4. Listar el nombre y especialidad de los técnicos que solamente participaron en reparaciones
durante 2022.
*/
SELECT t.nombre, t.especialidad
FROM Tecnico t
INNER JOIN Reparacion r ON (t.codTec = r.codTec)
WHERE YEAR (r.fecha) = 2022
EXCEPT (SELECT t.nombre, t.especialidad
        FROM Tecnico t
        INNER JOIN Reparacion r ON (t.codTec = r.codTec)
        WHERE YEAR (r.fecha) <> 2022)
ORDER BY nombre 
/*
5. Listar para cada repuesto nombre, stock y cantidad de técnicos distintos que lo utilizaron. Si un
repuesto no participó en alguna reparación igual debe aparecer en dicho listado.
*/
SELECT rep.nombre, rep.stock, COUNT(repa.codTec) AS CantTecnicos
FROM Repuesto rep 
LEFT JOIN RepuestoReparacion rr ON (rep.codRep = rr.codRep)
LEFT JOIN Reparacion repa ON (rr.nroReparac = repa.nroReparac)
GROUP BY rep.codRep, rep.nombre, rep.stock

/*
6. Listar nombre y especialidad del técnico con mayor cantidad de reparaciones realizadas y el
técnico con menor cantidad de reparaciones.
*/
SELECT t.nombre, t.especialidad, count(r.nroReparac)
FROM Tecnico t
LEFT JOIN Reparacion r ON (t.codTec = r.codTec)
GROUP BY t.codTec, t.nombre, t.especialidad
HAVING COUNT(r.nroReparac) >= ALL (SELECT COUNT(r.nroReparac)
                                   FROM Tecnico t
                                   LEFT JOIN Reparacion r ON (t.codTec = r.codTec)
                                   GROUP BY t.codTec)
OR COUNT(r.nroReparac) <= ALL (SELECT COUNT(r.nroReparac)
                               FROM Tecnico t
                               LEFT JOIN Reparacion r ON (t.codTec = r.codTec)
                               GROUP BY t.codTec)

/*
7. Listar nombre, stock y precio de todos los repuestos con stock mayor a 0 y que dicho repuesto
no haya estado en reparaciones con un precio total superior a $10000.
*/
SELECT r.nombre, r.stock, r.precio
FROM Repuesto r
WHERE r.stock > 0
EXCEPT
SELECT r.nombre, r.stock, r.precio
FROM Repuesto r
INNER JOIN RepuestoReparacion rr ON (r.codRep = rr.codRep)
INNER JOIN Reparacion rep ON (rr.nroReparac = rep.nroReparac)
WHERE rep.precio_total >10000
/*
8. Proyectar número, fecha y precio total de aquellas reparaciones donde se utilizó algún repuesto
con precio en el momento de la reparación mayor a $10000 y menor a $15000.
*/
SELECT DISTINCT repa.nroReparac, repa.fecha, repa.precio_total
FROM Reparacion repa
INNER JOIN RepuestoReparacion rr ON (repa.nroReparac = rr.nroReparac)
WHERE rr.precio > 10000 AND rr.precio < 15000

/*
9. Listar nombre, stock y precio de repuestos que hayan sido utilizados por todos los técnicos.
*/
SELECT rep.nombre, rep.stock, rep.precio
FROM Repuesto rep
WHERE NOT EXISTS (SELECT *
                  FROM Tecnico t
                  WHERE NOT EXISTS (SELECT *
                                    FROM RepuestoReparacion rr 
                                    INNER JOIN Reparacion repa ON (rr.nroReparac = repa.nroReparac)
                                    WHERE (rep.codRep = rr.codRep) AND (repa.codTec = t.codTec))
                  )
/*
10. Listar fecha, técnico y precio total de aquellas reparaciones que necesitaron al menos 4
repuestos distintos.
*/
SELECT repa.fecha, t.nombre, repa.precio_total
FROM Reparacion repa
INNER JOIN Tecnico t ON (repa.codTec = t.codTec)
INNER JOIN RepuestoReparacion rr ON (repa.nroReparac = rr.nroReparac)
GROUP BY repa.nroReparac, repa.fecha, t.nombre, repa.precio_total
HAVING COUNT(*) >= 4
