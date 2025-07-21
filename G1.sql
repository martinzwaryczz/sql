-- Creo las tablas

CREATE TABLE Clientes (
    id_cli INT PRIMARY KEY,
    nom_cli VARCHAR(100),
    loc_cli VARCHAR(100),
    email_cli VARCHAR(100)
);

CREATE TABLE Rubros (
    cod_rub INT PRIMARY KEY,
    nom_rub VARCHAR(100)
);

CREATE TABLE Articulos (
    cod_art INT PRIMARY KEY,
    cod_rub INT,
    descrip_art VARCHAR(255),
    stock_art INT,
    precio_art DECIMAL(10, 2)
);

CREATE TABLE Facturas (
    num_fac INT PRIMARY KEY,
    fec_fac DATE,
    imp_fac DECIMAL(10, 2),
    id_cli INT
);

CREATE TABLE Detalles (
    num_fac INT,
    cod_art INT,
    cant_det INT,
    PRIMARY KEY (num_fac, cod_art),
);

INSERT INTO Clientes (id_cli, nom_cli, loc_cli, email_cli) VALUES
(1, 'Juan Pérez', 'Buenos Aires', 'juan.perez@example.com'),
(2, 'María López', 'Córdoba', 'maria.lopez@example.com'),
(3, 'Carlos Sánchez', 'Rosario', 'carlos.sanchez@example.com'),
(4, 'Ana Gómez', 'Mendoza', 'ana.gomez@example.com'),
(5, 'Pedro Martínez', 'La Plata', 'pedro.martinez@example.com');

INSERT INTO Rubros (cod_rub, nom_rub) VALUES
(1, 'Electrónica'),
(2, 'Ropa'),
(3, 'Alimentos'),
(4, 'Hogar'),
(5, 'Deportes');

INSERT INTO Articulos (cod_art, cod_rub, descrip_art, stock_art, precio_art) VALUES
(101, 1, 'Televisor LED 55"', 10, 599.99),
(102, 2, 'Camisa de algodón', 25, 29.99),
(103, 3, 'Paquete de arroz 1kg', 50, 1.49),
(104, 4, 'Sofá de 3 plazas', 5, 299.99),
(105, 5, 'Bicicleta de montaña', 8, 399.99);

INSERT INTO Facturas (num_fac, fec_fac, imp_fac, id_cli) VALUES
(1001, '2023-10-01', 629.98, 1),
(1002, '2023-10-02', 29.99, 2),
(1003, '2023-10-03', 1.49, 3),
(1004, '2023-10-04', 299.99, 4),
(1005, '2023-10-05', 399.99, 5);

INSERT INTO Detalles (num_fac, cod_art, cant_det) VALUES
(1001, 101, 1),
(1002, 102, 1),
(1003, 103, 1),
(1004, 104, 1),
(1005, 105, 1);

-- 1. Listar los artículos con un stock menor a 20, ordenados por su código.

SELECT descrip_art FROM Articulos WHERE stock_art < 20 ORDER BY cod_art; /* No aclara en la consigna si el orden es creciente o decreciente */

-- 2. Listar los datos de los clientes que hicieron alguna compra junto con el código de artículo y su correspondiente cantidad.

SELECT C.*, D.cod_art, D.cant_det FROM Clientes C, Facturas F, Detalles D 
WHERE  C.id_cli = F.id_cli 
  AND F.num_fac = F.num_fac;

-- 3. Listar los datos de los artículos y rubro de clientes que hayan realizado alguna compra el 18/12/2032.

SELECT A.*, R.nom_rub from Articulos A, Rubros R, Facturas F, Detalles D
WHERE F.num_fac = D.num_fac and D.cod_art = A.cod_art and
A.cod_rub = R.cod_rub AND F.fec_fac = '2032/12/18';

-- 4. Listar los datos de los artículos que NO hayan sido comprado por ningún cliente. 

SELECT A.* FROM ARTICULOS A WHERE A.cod_art 
NOT IN(SELECT ART.COD_ART FROM ARTICULOS ART, DETALLES D
       WHERE D.COD_ART = A.COD_ART); /* Cuidado con el cambio de contexto y los alias */
	   
-- 5. Listar el total facturado día a día, durante abril del 2023, ordenados en forma decreciente.	

SELECT FEC_FAC, SUM(IMP_FAC) TOTAL FROM FACTURAS F
WHERE FEC_FAC BETWEEN '2023/04/01' and '2023/04/30'
GROUP BY FEC_FAC ORDER BY TOTAL DESC; /* ORDER BY es descendente si no ponemos nada */

-- 6. Listar el total facturado día a día, durante abril del 2023, que se vendió más de $10000 (ordenados en forma creciente).

SELECT FEC_FAC, SUM(IMP_FAC) TOTAL FROM FACTURAS F
WHERE FEC_FAC BETWEEN '2023/04/01' and '2023/04/30'
GROUP BY FEC_FAC HAVING TOTAL > 10000 ORDER BY TOTAL ASC;

-- 7. Listar los datos de los artículos cuyo precio sea el más bajo.

SELECT A.* FROM ARTICULOS A WHERE A.PRECIO_ART = (SELECT MIN(PRECIO_ART) FROM ARTICULOS);

-- 8. Obtener la fecha en la que más se facturó.

SELECT F.FEC_FAC, SUM(imp_fac) TOTAL_FACTURADO
FROM  Facturas F GROUP BY F.FEC_FAC 
HAVING MAX(NUM_FAC) IN (SELECT MAX(NUM_FAC) FROM Facturas);

-- 9. Hallar cuantos rubros diferentes hay

SELECT COUNT(DISTINCT COD_RUB) FROM RUBROS;

-- 11. Listar los artículos que tengan un precio mayor al precio promedio y un stock menor a 100 unidades.

SELECT * FROM ARTICULOS A WHERE A.PRECIO_ART > (SELECT AVG(PRECIO_ART) FROM ARTICULOS) AND A.STOCK_ART < 100;







