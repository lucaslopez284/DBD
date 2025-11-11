/* Ejercicio 9
Proyecto = (codProyecto, nombrP,descripcion, fechaInicioP, fechaFinP?, fechaFinEstimada,
DNIResponsable(FK), equipoBackend(FK), equipoFrontend(FK)) // DNIResponsable corresponde a un
empleado, equipoBackend y equipoFrontend corresponden a equipos
Equipo = (codEquipo, nombreE, descTecnologias, DNILider(FK)) // DNILider corresponde a un empleado
Empleado = (DNI, nombre, apellido, telefono, direccion, fechaIngreso)
Empleado_Equipo = (codEquipo(FK), DNI(FK), fechaInicio, fechaFin, descripcionRol)
*/

/*
1. Listar nombre, descripción, fecha de inicio y fecha de fin de proyectos ya finalizados que no
fueron terminados antes de la fecha de fin estimada.
*/
SELECT p.nombrP, p.descripcion, p.fechaInicioP, p.fechaFinP
FROM Proyecto p
WHERE p.fechaFinP IS NOT NULL 
AND p.fechaFinP < p.fechaFinEstimada
/*
2. Listar DNI, nombre, apellido, teléfono, dirección y fecha de ingreso de empleados que no son, ni
fueron responsables de proyectos. Ordenar por apellido y nombre.
*/
SELECT e.DNI, e.nombre, e.apellido, e.telefono, e.direccion, e.fechaIngreso
FROM Empleado e 
WHERE e.DNI NOT IN (
      SELECT p.DNIResponsable
      FROM Proyecto p)
ORDER BY e.apellido, e.nombre
/*
3. Listar DNI, nombre, apellido, teléfono y dirección de líderes de equipo que tenga más de un
equipo a cargo.
*/
SELECT e.DNI, e.nombre, e.apellido, e.telefono, e.direccion
FROM Empleado e
INNER JOIN Equipo eq ON (e.DNI = eq.DNILider)
GROUP BY e.DNI, e.nombre, e.apellido, e.telefono, e.direccion
HAVING COUNT(eq.codEquipo) >= 2
/*
4. Listar DNI, nombre, apellido, teléfono y dirección de todos los empleados que trabajan en el
proyecto con nombre ‘Proyecto X’. No es necesario informar responsable y líderes.
*/
SELECT e.DNI, e.nombre, e.apellido, e.telefono, e.direccion
FROM Proyecto p
INNER JOIN Equipo eq ON (p.equipoBackend = eq.codEquipo)
INNER JOIN Empleado_Equipo ee ON (eq.codEquipo = ee.codEquipo)
INNER JOIN Empleado e ON (ee.DNI = e.DNI)
WHERE p.nombrP = 'Proyecto X'
UNION
SELECT e.DNI, e.nombre, e.apellido, e.telefono, e.direccion
FROM Proyecto p
INNER JOIN Equipo eq ON (p.equipoFrontend = eq.codEquipo)
INNER JOIN Empleado_Equipo ee ON (eq.codEquipo = ee.codEquipo)
INNER JOIN Empleado e ON (ee.DNI = e.DNI)
WHERE p.nombrP = 'Proyecto X'
UNION
SELECT e.DNI, e.nombre, e.apellido, e.telefono, e.direccion
FROM Proyecto p
INNER JOIN Empleado e ON (p.DNIResponsable = e.DNI)
/*
5. Listar nombre de equipo y datos personales de líderes de equipos que no tengan empleados
asignados y trabajen con tecnología ‘Java’.
*/
SELECT eq.nombreE, emp.DNI, emp.nombre, emp.apellido, emp.telefono, emp.direccion, emp.fechaIngreso
FROM Equipo eq
INNER JOIN Empleado emp ON (eq.DNILider = emp.DNI)
WHERE eq.descTecnologias = 'Java'
AND eq.codEquipo NOT IN (
    SELECT codEquipo
    FROM Empleado_Equipo )
/*
6. Modificar nombre, apellido y dirección del empleado con DNI 40568965 con los datos que desee.
*/
UPDATE Empleado 
SET nombre = 'Esteban', 
    apellido = 'Fernandez', 
    direccion = 'Julio Humberto Grondona'
WHERE DNI = 40568965   
/*
7. Listar DNI, nombre, apellido, teléfono y dirección de empleados que son responsables de
proyectos pero no han sido líderes de equipo.
*/
SELECT DISTINCT e.DNI, e.nombre, e.apellido, e.telefono, e.direccion
FROM Empleado e
INNER JOIN Proyecto p ON (e.DNI = p.DNIResponsable)
WHERE e.DNI NOT IN (
      SELECT eq.DNILider
      FROM Equipo eq)

/*
8. Listar nombre de equipo y descripción de tecnologías de equipos que hayan sido asignados
como equipos frontend y backend.
*/
SELECT DISTINCT eqb.nombreE, eqb.descTecnologias
FROM Proyecto p
INNER JOIN Equipo eqb ON (p.equipoBackend = eqb.codEquipo)
WHERE eqb.codEquipo IN (
      SELECT eqf.codEquipo
      FROM Proyecto p2
      INNER JOIN Equipo eqf ON (p2.equipoFrontend = eqf.codEquipo))
/*
9. Listar nombre, descripción, fecha de inicio, nombre y apellido de responsables de proyectos que
se estiman finalizar durante 2025.
*/
SELECT p.nombrP, p.descripcion, p.fechaInicioP, e.nombre, e.apellido
FROM Proyecto p
INNER JOIN Empleado e ON (p.DNIResponsable = e.DNI)
WHERE YEAR (p.fechaFinEstimada) = 2025