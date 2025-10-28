/* Ejercicio 1
Cliente = (idCliente, nombre, apellido, DNI, telefono, direccion)
Factura = (nroTicket, total, fecha, hora, idCliente (fk))
Detalle = (nroTicket (fk), idProducto (fk), cantidad, preciounitario)
Producto = (idProducto, nombreP, descripcion, precio, stock) */

/*
1. Listar datos personales de clientes cuyo apellido comience con el string ‘Pe’. Ordenar por DNI */
SELECT * 
FROM Cliente 
WHERE (apellido LIKE 'Pe%')
ORDER BY DNI

/*
2. Listar nombre, apellido, DNI, teléfono y dirección de clientes que realizaron compras solamente
durante 2024.
*/
SELECT nombre, apellido, DNI, telefono, direccion
FROM Cliente c INNER JOIN Factura f ON (f.idCliente = c.idCliente)
WHERE (f.fecha >= '2024-01-01') AND (f.fecha <= '2024-12-31')
Except (
 SELECT nombre, apellido, DNI, telefono, direccion
 FROM Cliente c2 INNER JOIN Factura f2 ON (f2.idCliente = c2.idCliente)
 WHERE (f2.fecha <'2024-01-01') OR (f2.fecha > '2024-12-31')
 ) 
/*
3. Listar nombre, descripción, precio y stock de productos vendidos al cliente con DNI 45789456,
pero que no fueron vendidos a clientes de apellido ‘Garcia’.
*/

SELECT p.nombreP, p.descripcion, p.precio, p.stock
FROM Producto p INNER JOIN Detalle d ON (p.idProducto = d.idProducto)
                INNER JOIN Factura f ON (d.nroTicket = f.nroTicket)
                INNER JOIN Cliente c ON (f.idCliente = c.idCliente)
WHERE c.DNI = 45789456
EXCEPT ( SELECT p2.nombreP, p2.descripcion, p2.precio, p2.stock
         FROM Producto p2 INNER JOIN Detalle d ON (p2.idProducto = d.idProducto)
                INNER JOIN Factura f ON (d.nroTicket = f.nroTicket)
                INNER JOIN Cliente c ON (f.idCliente = c.idCliente)
         WHERE c.apellido = "Garcia")
/*
4. Listar nombre, descripción, precio y stock de productos no vendidos a clientes que tengan
teléfono con característica 221 (la característica está al comienzo del teléfono). Ordenar por
nombre.
*/
SELECT p.nombreP, p.descripcion, p.precio, p.stock
FROM Producto p 
EXCEPT ( SELECT p2.nombreP, p2.descripcion, p2.precio, p2.stock
         FROM Producto p2 INNER JOIN Detalle d ON (p2.idProducto = d.idProducto)
                INNER JOIN Factura f ON (d.nroTicket = f.nroTicket)
                INNER JOIN Cliente c ON (f.idCliente = c.idCliente)
         WHERE c.telefono LIKE '221%')
ORDER BY p.idProducto, p.nombreP, p.descripcion, p.precio, p.stock
/*
5. Listar para cada producto nombre, descripción, precio y cuantas veces fue vendido. Tenga en
cuenta que puede no haberse vendido nunca el producto.
*/ 
SELECT p.nombreP, p.descripcion, p.precio, COUNT(*) AS CantidadVendida
FROM Producto p 
LEFT JOIN Detalle d ON (p.idProducto = d.idProducto)
GROUP BY p.idProducto, p.nombreP, p.descripcion, p.precio;

SELECT p.nombreP, p.descripcion, p.precio, SUM(d.cantidad) AS CantidadVendida
FROM Producto p 
LEFT JOIN Detalle d ON (p.idProducto = d.idProducto)
GROUP BY p.idProducto, p.nombreP, p.descripcion, p.precio;
/*
6. Listar nombre, apellido, DNI, teléfono y dirección de clientes que compraron los productos con
nombre ‘prod1’ y ‘prod2’ pero nunca compraron el producto con nombre ‘prod3’.
*/
SELECT c.nombre, c.apellido, c.dni, c.telefono, c.direccion
FROM Cliente c
INNER JOIN Factura f ON (f.idCliente = c.idCliente)
INNER JOIN Detalle d ON (d.nroTicket = f.nroTicket)
INNER JOIN Producto p ON (p.idProducto = d.idProducto)
WHERE (p.nombreP ='prod1')
AND c.idCliente IN (
    SELECT c2.idCliente
    FROM Cliente c2
    INNER JOIN Factura f2 ON (f2.idCliente = c2.idCliente)
    INNER JOIN Detalle d2 ON (d2.nroTicket = f2.nroTicket)
    INNER JOIN Producto p2 ON (p2.idProducto = d2.idProducto)
    WHERE (p2.nombreP ='prod2') )
    AND c.idCliente NOT IN (
        SELECT c3.idCliente
        FROM Cliente c3
        INNER JOIN Factura f3 ON (f3.idCliente = c3.idCliente)
        INNER JOIN Detalle d3 ON (d3.nroTicket = f3.nroTicket)
        INNER JOIN Producto p3 ON (p3.idProducto = d3.idProducto)
        WHERE (p3.nombreP ='prod3') ) 
/*
7. Listar nroTicket, total, fecha, hora y DNI del cliente, de aquellas facturas donde se haya
comprado el producto ‘prod38’ o la factura tenga fecha de 2023. */
SELECT DISTINCT f.nroTicket, f.total, f.fecha, f.hora, c.DNI
FROM Factura f
INNER JOIN Cliente c ON (f.idCliente = c.idCliente)
INNER JOIN Detalle d ON (f.nroTicket = d.nroTicket)
INNER JOIN Producto p ON (d.idProducto = p.idProducto)
WHERE p.nombreP = 'prod38' OR (fecha <='2023-12-31' AND fecha>= '2023-1-1')
/*
8. Agregar un cliente con los siguientes datos: nombre:’Jorge Luis’, apellido:’Castor’, DNI:
40578999, teléfono: ‘221-4400789’, dirección:’11 entre 500 y 501 nro:2587’ y el id de cliente:
500002. Se supone que el idCliente 500002 no existe. */
INSERT INTO Cliente (idCliente, nombre, apellido, DNI, telefono, direccion)
VALUES (500002, 'Jorge Luis', 'Castor', 40578999, '221-4400789', '11 entre 500 y 501 nro:2587')
/*
9. Listar nroTicket, total, fecha, hora para las facturas del cliente ´Jorge Pérez´ donde no haya
comprado el producto ´Z´.
*/

SELECT f.nroTicket, f.total, , f.fecha, f.hora
FROM Factura f
INNER JOIN Cliente c ON (f.idCliente = c.idCliente)
INNER JOIN Detalle d ON (f.nroTicket = d.nroTicket)
INNER JOIN Producto p ON (d.idProducto = p.idProducto)
WHERE c.nombre = 'Jorge' AND c.apellido = 'Perez' AND p.nombreP <> 'Z' 
/*
10. Listar DNI, apellido y nombre de clientes donde el monto total comprado, teniendo en cuenta
todas sus facturas, supere $100000. */
SELECT c.DNI, c.apellido, c.nombre
FROM Cliente c
INNER JOIN Factura f ON (c.idCliente = f.idCliente)
GROUP BY c.idCliente
HAVING SUM(f.total) > 100000


