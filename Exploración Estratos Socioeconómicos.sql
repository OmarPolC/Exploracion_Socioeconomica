-- 1. Primero, crearemos las tablas y agregaremos la información desde los csv

-- 1.1 Creamos la tabla ingresos si no existe ya
CREATE TABLE IF NOT EXISTS public.ingresos
(
    id integer NOT NULL,
    folioviv bigint,
    foliohog integer,
    numren integer,
    clave character varying(4),
    ing_tri real,
    CONSTRAINT ingresos_pkey PRIMARY KEY (id)
)


-- 1.1.1 Importamos los datos desde el csv
COPY ingresos(id, folioviv, foliohog, numren, clave, ing_tri)
FROM 'C:\Users\omarp\Documents\Proyectos\SQL\ingresos.csv' 
DELIMITER ','
CSV HEADER;

-- 1.2 Creamos la tabla claves_estados si no existe ya
CREATE TABLE IF NOT EXISTS public.claves_estados
(
    clave integer NOT NULL,
    estado character varying COLLATE pg_catalog."default",
    CONSTRAINT claves_estados_pkey PRIMARY KEY (clave)
)

-- 1.2.1 Importamos los datos desde el csv
COPY claves_estados(clave, estado)
FROM 'C:\Users\omarp\Documents\Proyectos\SQL\claves_estados.csv' 
DELIMITER ','
CSV HEADER;


-- 1.3 Creamos la tabla trabajos si no existe ya
CREATE TABLE IF NOT EXISTS public.trabajos
(
    id_col numeric NOT NULL,
    folioviv bigint,
    foliohog numeric NOT NULL,
    numren numeric NOT NULL,
    subor numeric,
    indep numeric,
    personal numeric,
    pago numeric,
    contrato numeric,
    tipocontrato numeric,
    incapacidad numeric,
    aguinaldo numeric,
    vacaciones numeric,
    ptu numeric,
    afore numeric,
    seguro_vida numeric,
    sin_prestaciones numeric,
    htrab numeric,
    clas_emp numeric,
    tam_emp numeric,
    no_ingresos numeric,
    tiene_sueldo numeric,
    tipoact numeric,
    imss numeric,
    isste numeric,
    privado numeric,
    sin_servicio numeric,
    CONSTRAINT trabajos_pkey PRIMARY KEY (id_col)
)

-- 1.3.1 Importamos los datos desde el csv
COPY trabajos(id_col,folioviv,foliohog,numren,subor,indep,personal,pago,contrato,
tipocontrato,incapacidad,aguinaldo,vacaciones,ptu,afore,seguro_vida,sin_prestaciones,
htrab,clas_emp,tam_emp,no_ingresos,tiene_sueldo,tipoact,imss,isste,privado,sin_servicio
)
FROM 'C:\Users\omarp\Documents\Proyectos\SQL\trabajos.csv' 
DELIMITER ','
CSV HEADER;


-- 1.4 Creamos la tabla viviendas si no existe ya

CREATE TABLE IF NOT EXISTS public.viviendas
(
    id_col integer NOT NULL,
    folioviv numeric NOT NULL,
    tipo_vivienda integer,
    mat_pared integer,
    mat_techos integer,
    mat_pisos integer,
    antiguedad integer,
    cocina integer,
    cocina_dor integer,
    cuart_dorm integer,
    num_cuarto integer,
    disp_agua integer,
    dotac_agua integer,
    excusado integer,
    bano_comp integer,
    bano_excus integer,
    bano_regad integer,
    drenaje integer,
    disp_elect integer,
    eli_basura integer,
    tenencia integer,
    renta integer,
    estim_pago integer,
    tipo_adqui integer,
    viv_usada integer,
    tipo_finan integer,
    escrituras integer,
    tot_resid integer,
    tot_hom integer,
    tot_muj integer,
    ubica_geo integer,
    tam_loc integer,
    est_socio integer,
    CONSTRAINT viviendas_pkey PRIMARY KEY (id_col)
)

-- 1.4.1 Importamos los datos desde el csv
COPY viviendas(id_col,folioviv,tipo_vivienda,mat_pared,mat_techos,mat_pisos,
antiguedad,cocina,cocina_dor,cuart_dorm,num_cuarto,disp_agua,dotac_agua,excusado,
bano_comp,bano_excus,bano_regad,drenaje,disp_elect,eli_basura,tenencia,renta,
estim_pago,tipo_adqui,viv_usada,tipo_finan,escrituras,tot_resid,tot_hom,tot_muj,
ubica_geo,tam_loc,est_socio
)
FROM 'C:\Users\omarp\Documents\Proyectos\SQL\viviendas.csv' 
DELIMITER ','
CSV HEADER;


-- 2. Limpiar tablas y agregar columnas

-- 2.1 Limpiar tabla ingresos y agregar columnas

--2.1.1 Agregar columna ingreso mensual

ALTER TABLE ingresos ADD COLUMN ing_mensual numeric;
UPDATE TABLE ingresos SET ing_mensual = (ing_tri/3);

-- 2.2 Limpiar tabla trabajos y agregar columnas

-- 2.2.1 Los "NO" están representados como 2, cambiarlos por 0

UPDATE trabajos SET subor = 0 WHERE (subor=2) OR (subor IS NULL) ;
UPDATE trabajos SET indep = 0 WHERE (subor=2) OR (subor IS NULL) ;
UPDATE trabajos SET tiene_sueldo = 0 WHERE (tiene_sueldo = 2);

-- 2.2.2 Hay valores nulos, cambiarlos por 0
UPDATE trabajos SET aguinaldo = 0 where aguinaldo is null;
UPDATE trabajos SET vacaciones = 0 where vacaciones is null;
UPDATE trabajos SET ptu = 0 where ptu is null;
UPDATE trabajos SET afore = 0 where afore is null;
UPDATE trabajos SET seguro_vida = 0 where seguro_vida is null;
UPDATE trabajos SET sin_prestaciones = 0 where sin_prestaciones is null;
UPDATE trabajos SET no_ingresos = 0 where no_ingresos is null;


-- 2.3 Limpiar tabla viviendas y agregar columnas. Eliminar columnas no útiles. 
-- 2.3.1 Eliminar columnas que no se usarán
ALTER TABLE viviendas DROP COLUMN antiguedad;
ALTER TABLE viviendas DROP COLUMN cocina_dor;
ALTER TABLE viviendas DROP COLUMN viv_usada;

-- 2.3.2 Extraer el código de estado y transformarlo en integer
ALTER TABLE viviendas ADD COLUMN ubicacion_string VARCHAR(5);
UPDATE viviendas SET ubicacion_string = CAST(ubica_geo AS VARCHAR(5));
ALTER TABLE viviendas add column estado varchar(2);
UPDATE viviendas SET estado = left(ubicacion_string,(length(ubicacion_string)-3))
ALTER TABLE viviendas ADD COLUMN estado_num INTEGER;
UPDATE viviendas SET estado_num = CAST(estado AS INTEGER);
ALTER TABLE viviendas DROP COLUMN estado;

-- 3. Crear tablas con claves numéricas

-- 3.1 Crear tabla claves_trabajos
CREATE TABLE IF NOT EXISTS claves_trabajos
(
    clave integer NOT NULL,
    pago text COLLATE pg_catalog."default",
    tipocontrato text COLLATE pg_catalog."default",
    clas_emp text COLLATE pg_catalog."default",
    tam_emp text COLLATE pg_catalog."default",
    no_ingresos text COLLATE pg_catalog."default",
    CONSTRAINT claves_trabajos_pkey PRIMARY KEY (clave)
)

-- 3.1.2 Llenar tabla claves_trabajos
COPY claves_trabajos 
FROM 'C:\Users\omarp\Documents\Proyectos\SQL\Datos\claves_trabajos.csv'
DELIMITER ','
CSV HEADER;


-- 3.2 Crear tabla claves_viviendas
CREATE TABLE claves_viviendas (
    clave int, tipo_vivienda text, 
    mat_pared text, mat_techos text, 
    mat_pisos text, disp_agua text, 
    dotac_agua text, drenaje text, 
    disp_elect text, eli_basura text, 
    tenencia text, tipo_adqui text, 
    tipo_finan text, escrituras text, 
    tam_loc text, est_socio text);

-- 3.2.2 Llenar tabla claves_viviendas
COPY claves_viviendas 
FROM 'C:\Users\omarp\Documents\Proyectos\SQL\Datos\claves_viviendas.csv'
DELIMITER ','
CSV HEADER;



-- 4. Exploración


-- 4.1 Ingresos promedio por estrato social

-- 4.1.1 ¿Cuál es el promedio de ingreso mensual por vivienda 
-- para cada estrato social?

WITH 

    a AS (SELECT folioviv, ROUND(SUM(ing_mensual),2) FROM ingresos GROUP BY 1),

    b AS (SELECT viviendas.est_socio, ROUND(AVG(a.round),2) AS ingreso_promedio FROM a 
    INNER JOIN viviendas ON a.folioviv = viviendas.folioviv GROUP BY 1 ORDER BY 1)

SELECT c.est_socio as Nivel_socioeconomico, b.ingreso_promedio  FROM b 
INNER JOIN claves_viviendas c ON b.est_socio = c.clave;


--  nivel_socioeconomico | ingreso_promedio
-- ----------------------+------------------
--  Bajo                 |          9476.16
--  Medio bajo           |         13399.68
--  Medio alto           |         17957.90
--  Alto                 |         27232.39




-- 4.1.2 ¿Cuál es el promedio de ingreso mensual por persona en la vivienda 
-- para cada estrato social?

WITH 
    i AS (SELECT folioviv, SUM(ing_mensual) FROM ingresos GROUP BY 1),
    p AS (SELECT i.folioviv, v.est_socio, c.est_socio AS estrato, 
        i.sum/v.tot_resid AS ingreso_por_persona from i INNER JOIN 
        viviendas v ON v.folioviv = i.folioviv INNER JOIN claves_viviendas c 
        ON c.clave = v.est_socio)

SELECT estrato, ROUND(AVG(ingreso_por_persona),2) AS ingreso_por_persona FROM p GROUP BY 1 ORDER BY 2 DESC;


--   estrato   | ingreso_por_persona
-- ------------+---------------------
--  Alto       |            10312.88
--  Medio alto |             6403.33
--  Medio bajo |             4310.22
--  Bajo       |             2826.85



-- 4.2 ¿Cuál es el número promedio de habitantes por vivienda 
-- para cada estrato social?

WITH a AS (SELECT v.est_socio, AVG(v.tot_resid) FROM viviendas v GROUP BY 1)
SELECT c.est_socio, ROUND(a.avg,2) AS numero_residentes 
    FROM a INNER JOIN claves_viviendas c ON c.clave = a.est_socio;


--  est_socio  | numero_residentes
-- ------------+-------------------
--  Bajo       |              3.86
--  Medio bajo |              3.64
--  Medio alto |              3.29
--  Alto       |              3.16




-- 4.3 ¿Cómo es la vivienda común en México? ¿Cuáles son sus ingresos, quiénes
-- son sus integrantes, cómo se ve su casa?
SELECT tot_resid, COUNT(tot_resid) FROM viviendas GROUP BY 1 ORDER BY 2 DESC;
SELECT tot_muj, COUNT(tot_muj) FROM viviendas WHERE tot_resid = 4 GROUP BY 1 ORDER BY 2 DESC;
SELECT c.est_socio AS estrato, v.est_socio, COUNT(v.est_socio) FROM viviendas v 
INNER JOIN claves_viviendas c ON c.clave = v.est_socio GROUP BY 1, 2 ORDER BY 3 DESC;
SELECT c.tipo_vivienda, COUNT(v.tipo_vivienda) FROM viviendas v INNER JOIN 
claves_viviendas c ON c.clave = v.tipo_vivienda GROUP BY 1,2 ORDER BY 3 DESC;
SELECT num_cuarto, COUNT(num_cuarto) FROM viviendas WHERE tot_resid = 4 GROUP BY 1 ORDER BY 2 DESC;
SELECT cuart_dorm, COUNT(cuart_dorm) FROM viviendas WHERE tot_resid = 4 GROUP BY 1 ORDER BY 2 DESC;
SELECT v.tenencia, c.tenencia, COUNT(v.tenencia) FROM viviendas v INNER JOIN claves_viviendas c 
ON c.clave = v.tenencia GROUP BY 1,2 ORDER BY 3 DESC;

-- La vivienda típica en México tiene cuatro habitantes, dos hombres y dos mujeres. 
-- La familia es de nivel socioeconómico medio bajo, con un ingreso de alrededor de 14 mil pesos
-- mensuales. Vive en una casa independiente y propia con 4 cuartos, de los cuales 2 se usan 
-- para dormir.   

-- 4.4 Clases sociales por estado

--4.4.1 ¿Qué porcentaje de las viviendas de cada estado pertenecen a cada estrato social?
WITH numerico AS (
SELECT estado_num, est_socio, COUNT(*) as cuenta, 
SUM(COUNT(*)) over (partition by estado_num) as cuenta_estado,
100 * COUNT(*)/SUM(COUNT(*)) over (partition by estado_num) as porcentaje
FROM viviendas GROUP BY 1,2 ORDER BY 1,2)

SELECT c1.estado, c2.est_socio, n.cuenta, 
n.cuenta_estado, CAST(round(n.porcentaje, 2) AS text) ||'%' porcentaje
FROM numerico n INNER JOIN claves_estados c1 on c1.clave = n.estado_num
INNER JOIN claves_viviendas c2 ON n.est_socio = c2.clave LIMIT 20;

-- Se muestra solo una fracción de los resultados por legibilidad

--             estado              | est_socio  | cuenta | cuenta_estado | porcentaje
-- ---------------------------------+------------+--------+---------------+------------
--  Aguascalientes                  | Alto       |    233 |          2626 | 8.87%
--  Aguascalientes                  | Medio alto |    712 |          2626 | 27.11%
--  Aguascalientes                  | Medio bajo |   1681 |          2626 | 64.01%
--  Baja California                 | Alto       |    329 |          4110 | 8.00%
--  Baja California                 | Medio alto |    696 |          4110 | 16.93%
--  Baja California                 | Medio bajo |   2390 |          4110 | 58.15%
--  Baja California                 | Bajo       |    695 |          4110 | 16.91%
--  Baja California Sur             | Alto       |    337 |          2684 | 12.56%
--  Baja California Sur             | Medio alto |    626 |          2684 | 23.32%
--  Baja California Sur             | Medio bajo |   1317 |          2684 | 49.07%
--  Baja California Sur             | Bajo       |    404 |          2684 | 15.05%
--  Campeche                        | Alto       |    130 |          2148 | 6.05%
--  Campeche                        | Medio alto |    203 |          2148 | 9.45%
--  Campeche                        | Medio bajo |   1047 |          2148 | 48.74%
--  Campeche                        | Bajo       |    768 |          2148 | 35.75%
--  Coahuila de Zaragoza            | Alto       |    344 |          3881 | 8.86%
--  Coahuila de Zaragoza            | Medio alto |   1326 |          3881 | 34.17%
--  Coahuila de Zaragoza            | Medio bajo |   2011 |          3881 | 51.82%
--  Coahuila de Zaragoza            | Bajo       |    200 |          3881 | 5.15%
--  Colima                          | Alto       |    281 |          3225 | 8.71%

--4.4.2 ¿Qué estados tienen el mayor porcentaje de viviendas en el estrato social alto?

WITH numerico AS (
SELECT estado_num, est_socio, COUNT(*) as cuenta, 
SUM(COUNT(*)) over (partition by estado_num) as cuenta_estado,
100 * COUNT(*)/SUM(COUNT(*)) over (partition by estado_num) as porcentaje
FROM viviendas GROUP BY 1,2 ORDER BY 1,2),
porcentajes AS (
SELECT c1.estado, c2.est_socio, n.cuenta, 
n.cuenta_estado, round(n.porcentaje, 2) porcentaje
FROM numerico n INNER JOIN claves_estados c1 on c1.clave = n.estado_num
INNER JOIN claves_viviendas c2 ON n.est_socio = c2.clave)
SELECT estado, porcentaje FROM porcentajes WHERE est_socio = 'Alto'
ORDER BY 2 DESC LIMIT 10;

--        estado        | porcentaje
-- ----------------------+------------
--  Sinaloa              |      12.71
--  Baja California Sur  |      12.56
--  Ciudad de Mexico     |      10.88
--  Nuevo Leon           |      10.60
--  Queretaro            |       9.53
--  Aguascalientes       |       8.87
--  Coahuila de Zaragoza |       8.86
--  Sonora               |       8.76
--  Colima               |       8.71
--  Chihuahua            |       8.59


-- 4.4 Condiciones de los trabajadores

-- 4.4.1 ¿Qué porcentaje de los trabajadores reportó tener un contrato, y de qué tipo es?

WITH contratos AS 
(SELECT t.contrato num, c.contrato,t.tipocontrato, 
COUNT(t.contrato) FROM trabajos t 
INNER JOIN claves_trabajos C on (t.contrato = c.clave) 
GROUP BY 1,2,3),
total AS
(SELECT count(*) FROM trabajos),
total_not_null AS
(SELECT count(contrato) FROM trabajos WHERE contrato IS NOT NULL)
 

SELECT c.contrato, a.tipocontrato, c.count cuenta,
ROUND(100*CAST(c.count AS numeric)/t2.count,2) AS porcentaje_total,
ROUND(100*CAST(c.count AS numeric)/SUM(c.count) 
OVER (PARTITION BY c.contrato),2) AS porcentaje_categoria
FROM contratos c
LEFT JOIN claves_trabajos a ON (a.clave = c.tipocontrato)
CROSS JOIN total t1 
CROSS JOIN total_not_null t2
ORDER BY 1 DESC;

--  contrato |                  tipocontrato                  | cuenta | porcentaje_total | porcentaje_cat
-- ----------+------------------------------------------------+--------+------------------+----------------
--  Si       | Es temporal o por obra determinada             |  11741 |            10.78 |         24.46
--  Si       | Es de base o planta o por tiempo Indeterminado |  36260 |            33.29 |         75.54
--  No       |                                                |  60927 |            55.93 |        100.00


-- 4.4.2 ¿Qué porcentaje de los trabajadores encuestados reportó tener cada tipo de prestación?

SELECT ROUND(SUM(incapacidad)/COUNT(*),2) incapacidad, 
ROUND(100*SUM(aguinaldo)/COUNT(*),2) aguinaldo, 
ROUND(100*SUM(vacaciones)/COUNT(*),2) vacaciones, 
ROUND(100*SUM(ptu)/COUNT(*),2) ptu, 
ROUND(100*SUM(afore)/COUNT(*),2) afore,
ROUND(100*SUM(seguro_vida)/COUNT(*),2) seguro_vida,
ROUND(100*SUM(sin_prestaciones)/COUNT(*),2) sin_prestaciones 
FROM trabajos;

--  incapacidad | aguinaldo | vacaciones |  ptu  | afore | seguro_vida | sin_prestaciones
-- -------------+-----------+------------+-------+-------+-------------+------------------
--         0.28 |     32.98 |      28.42 | 15.94 | 23.35 |       16.18 |            31.03

-- 4.4.2 ¿Qué porcentaje de los trabajadores encuestados reportó tener cada tipo de prestación, 
-- Dependiendo de si tienen contrato o no?
SELECT a.contrato,
ROUND(SUM(incapacidad)/COUNT(*),2) incapacidad, 
ROUND(100*SUM(aguinaldo)/COUNT(*),2) aguinaldo, 
ROUND(100*SUM(vacaciones)/COUNT(*),2) vacaciones, 
ROUND(100*SUM(ptu)/COUNT(*),2) ptu, 
ROUND(100*SUM(afore)/COUNT(*),2) afore,
ROUND(100*SUM(seguro_vida)/COUNT(*),2) seguro_vida,
ROUND(100*SUM(sin_prestaciones)/COUNT(*),2) sin_prestaciones 
FROM trabajos t  
INNER JOIN claves_trabajos a ON (a.clave = t.contrato)
WHERE t.contrato IS NOT NULL
GROUP BY 1;

--  contrato | incapacidad | aguinaldo | vacaciones |  ptu  | afore | seguro_vida | sin_prestaciones
-- ----------+-------------+-----------+------------+-------+-------+-------------+------------------
--  No       |        0.11 |     19.54 |      11.32 |  4.50 |  7.15 |        3.48 |            77.08
--  Si       |        0.83 |     88.32 |      83.10 | 48.93 | 71.00 |       51.06 |             6.97


-- 4.4.3 ¿Cuántas horas semanales trabajan en promedio las personas de cada estrato social?

SELECT c.est_socio, ROUND(AVG(t.htrab),2) promedio, 
ROUND(stddev_samp(t.htrab),2) desviacion_estandar 
FROM trabajos t INNER JOIN viviendas v 
ON v.folioviv = t.folioviv 
INNER JOIN claves_viviendas c
ON c.clave = v.est_socio
GROUP BY 1, v.est_socio
ORDER BY v.est_socio ASC;


--  est_socio  | promedio | desviacion_estandar
-- ------------+----------+---------------------
--  Bajo       |    35.16 |               20.94
--  Medio bajo |    41.21 |               20.00
--  Medio alto |    41.85 |               18.01
--  Alto       |    40.79 |               17.37