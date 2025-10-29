/*Ejercicio 4
Persona = (DNI, Apellido, Nombre, Fecha_Nacimiento, Estado_Civil, Genero)
Alumno = (DNI (fk), Legajo, Anio_Ingreso)
Página 2 de 8
Profesor = (DNI (fk), Matricula, Nro_Expediente)
Titulo = (Cod_Titulo, Nombre, Descripcion)
Titulo-Profesor = (Cod_Titulo (fk), DNI (fk), Fecha)
Curso = (Cod_Curso, Nombre, Descripcion, Fecha_Creacion, Duracion)
Alumno-Curso = (DNI (fk), Cod_Curso (fk), Anio, Desempenio, Calificacion)
Profesor-Curso = (DNI (fk), Cod_Curso (fk), Fecha_Desde, Fecha_Hasta?)
1. Listar DNI, legajo y apellido y nombre de todos los alumnos que tengan año de ingreso inferior a
2014.
*/
SELECT a.DNI, a.Legajo, p.Apellido, p.Nombre
FROM Alumno a
INNER JOIN Persona p ON (a.DNI = p.DNI)
WHERE a.Anio_Ingreso < 2014
/*
2. Listar DNI, matrícula, apellido y nombre de los profesores que dictan cursos que tengan más de
100 horas de duración. Ordenar por DNI.
*/
SELECT DISTINCT p.DNI, p.Matricula, per.Apellido, per.Nombre
FROM Profesor p 
INNER JOIN Persona per ON (p.DNI = per.DNI)
INNER JOIN Profesor_Curso pc ON (p.DNI = pc.DNI)
INNER JOIN Curso c ON(pc.Cod_Curso = c.Cod_Curso)
WHERE c.Duracion > 100
ORDER BY p.DNI
/*
3. Listar el DNI, Apellido, Nombre, Género y Fecha de nacimiento de los alumnos inscriptos al
curso con nombre “Diseño de Bases de Datos” en 2023.
*/
SELECT a.DNI, p.Apellido, p.Nombre, p.Genero, p.Fecha_Nacimiento
FROM Alumno a
INNER JOIN Persona p ON (a.DNI = p.DNI)
INNER JOIN Alumno_Curso ac ON (a.DNI = ac.DNI)
INNER JOIN Curso c ON (ac.Cod_Curso = c.Cod_Curso)
WHERE c.Nombre = 'Diseño de Bases de Datos' AND ac.Anio = 2023
/*
4. Listar el DNI, Apellido, Nombre y Calificación de aquellos alumnos que obtuvieron una
calificación superior a 8 en algún curso que dicta el profesor “Juan Garcia”. Dicho listado deberá
estar ordenado por Apellido y nombre.
*/
SELECT a.DNI, p.Apellido, p.Nombre, ac.Calificacion
FROM Alumno a
INNER JOIN Persona p ON (a.DNI = p.DNI)
INNER JOIN Alumno_Curso ac ON (a.DNI = ac.DNI)
INNER JOIN Profesor_Curso pc ON (ac.Cod_Curso = pc.Cod_Curso)
INNER JOIN Persona p2 ON (pc.DNI = p2.DNI)
WHERE (p2.Nombre = 'Juan') AND (p2.Apellido = 'Garcia')
AND (ac.Calificacion > 8)
ORDER BY p.Apellido, p.Nombre
/*
5. Listar el DNI, Apellido, Nombre y Matrícula de aquellos profesores que posean más de 3 títulos.
Dicho listado deberá estar ordenado por Apellido y Nombre.
*/
SELECT p.DNI, per.Apellido, per.Nombre, p.Matricula 
FROM Profesor p
INNER JOIN Persona per ON (p.DNI = per.DNI)
INNER JOIN Titulo_Profesor tp ON (p.DNI = tp.DNI)
GROUP BY p.DNI, per.Apellido, per.Nombre, p.Matricula
HAVING (COUNT(*)>3)
ORDER BY Apellido, Nombre
/*
6. Listar el DNI, Apellido, Nombre, Cantidad de horas y Promedio de horas que dicta cada profesor.
La cantidad de horas se calcula como la suma de la duración de todos los cursos que dicta.
*/
SELECT p.DNI, per.Apellido, per.Nombre, 
SUM(c.Duracion) AS CantHoras, AVG(c.Duracion) AS PromedioHoras
FROM Profesor p
INNER JOIN Persona per ON (p.DNI = per.DNI)
INNER JOIN Profesor_Curso pc ON (p.DNI = pc.DNI)
INNER JOIN Curso c ON (pc.Cod_Curso = c.Cod_Curso)
GROUP BY p.DNI, per.Apellido, per.Nombre
/*
7. Listar Nombre y Descripción del curso que posea más alumnos inscriptos y del que posea
menos alumnos inscriptos durante 2024.
*/

/*
8. Listar el DNI, Apellido, Nombre y Legajo de alumnos que realizaron cursos con nombre
conteniendo el string ‘BD’ durante 2022 pero no realizaron ningún curso durante 2023.
*/
SELECT a.DNI, p.Apellido, p.Nombre, a.Legajo
FROM Alumno a
INNER JOIN Persona p ON (a.DNI = p.DNI)
INNER JOIN Alumno_Curso ac ON (a.DNI = ac.DNI)
INNER JOIN Curso c ON (ac.Cod_Curso = c.Cod_Curso)
WHERE (c.Nombre LIKE '%BD%') AND (ac.Anio = 2022)
EXCEPT
SELECT a.DNI, p.Apellido, p.Nombre, a.Legajo
FROM Alumno a
INNER JOIN Persona p ON (a.DNI = p.DNI)
INNER JOIN Alumno_Curso ac ON (a.DNI = ac.DNI)
WHERE (ac.Anio = 2023)
/*
9. Agregar un profesor con los datos que prefiera y agregarle el título con código: 25.
*/
INSERT INTO Profesor (DNI, Matricula, Nro_Expediente)
VALUES (4628, 'AA10', 284)

INSERT INTO Persona (DNI, Apellido, Nombre, Fecha_Nacimiento, Estado_Civil, Genero)
VALUES (4628, 'Lopez', 'Lucas', '2005-9-9', 'Casado', 'M')

INSERT INTO Titulo (Cod_Titulo, Nombre, Descripcion)
VALUES (25, 'Licenciatura en Sistemas', 'UNLP')

INSERT INTO Titulo_Profesor (Cod_Titulo, DNI, Fecha)
VALUES (25, 4628, '2030-6-20')
/*
10. Modificar el estado civil del alumno cuyo legajo es ‘2020/09’, el nuevo estado civil es divorciado.
*/
UPDATE Persona SET Estado_Civil = 'divorciado' 
WHERE DNI IN (SELECT DNI
              FROM Alumno a
              WHERE a.Legajo = '2020/09')
/*
11. Dar de baja el alumno con DNI 30568989. Realizar todas las bajas necesarias para no dejar el
conjunto de relaciones en un estado inconsistente.
*/
DELETE FROM Alumno_Curso WHERE DNI = 30568989;
DELETE FROM Persona  WHERE DNI = 30568989;
DELETE FROM Alumno WHERE DNI = 30568989;
