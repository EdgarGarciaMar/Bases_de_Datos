--
-- PostgreSQL database dump
--

-- Dumped from database version 13.4
-- Dumped by pg_dump version 13.4

-- Started on 2021-10-28 17:27:42 CDT

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 208 (class 1255 OID 16469)
-- Name: seleccionarcategoria(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.seleccionarcategoria(id integer) RETURNS TABLE(idcategorria integer, nombrecategoria character varying, descripcioncategoria character varying)
    LANGUAGE sql
    AS $$
select * from categoria where  idcategorria =id;
$$;


ALTER FUNCTION public.seleccionarcategoria(id integer) OWNER TO postgres;

--
-- TOC entry 207 (class 1255 OID 16468)
-- Name: seleccionatodocategoria(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.seleccionatodocategoria() RETURNS TABLE(idcategorria integer, nombrecategoria character varying, descripcioncategoria character varying)
    LANGUAGE sql
    AS $$
    SELECT * FROM categoria;
$$;


ALTER FUNCTION public.seleccionatodocategoria() OWNER TO postgres;

--
-- TOC entry 205 (class 1255 OID 16466)
-- Name: spactualizarcategoria(character varying, character varying, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.spactualizarcategoria(nombre character varying, descripcion character varying, id integer)
    LANGUAGE sql
    AS $$
    update  categoria set nombrecategoria = nombre, descripcioncategoria = descripcion where idcategorria  = id;
$$;


ALTER PROCEDURE public.spactualizarcategoria(nombre character varying, descripcion character varying, id integer) OWNER TO postgres;

--
-- TOC entry 206 (class 1255 OID 16467)
-- Name: speliminarcategoria(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.speliminarcategoria(id integer)
    LANGUAGE sql
    AS $$
delete from categoria where  idcategorria =id;
$$;


ALTER PROCEDURE public.speliminarcategoria(id integer) OWNER TO postgres;

--
-- TOC entry 204 (class 1255 OID 16465)
-- Name: spinsertarcategoria(character varying, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.spinsertarcategoria(nombre character varying, descripcion character varying)
    LANGUAGE sql
    AS $$
    insert into categoria (nombrecategoria, descripcioncategoria) values (nombre, descripcion);
$$;


ALTER PROCEDURE public.spinsertarcategoria(nombre character varying, descripcion character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 201 (class 1259 OID 16397)
-- Name: categoria; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categoria (
    idcategorria integer NOT NULL,
    nombrecategoria character varying(50) NOT NULL,
    descripcioncategoria character varying(100) NOT NULL
);


ALTER TABLE public.categoria OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 16395)
-- Name: categoria_idcategorria_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categoria_idcategorria_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categoria_idcategorria_seq OWNER TO postgres;

--
-- TOC entry 3273 (class 0 OID 0)
-- Dependencies: 200
-- Name: categoria_idcategorria_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categoria_idcategorria_seq OWNED BY public.categoria.idcategorria;


--
-- TOC entry 203 (class 1259 OID 16451)
-- Name: producto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.producto (
    idproducto integer NOT NULL,
    nombreproducto character varying(50) NOT NULL,
    descripcionproducto character varying(100) NOT NULL,
    precio double precision NOT NULL,
    existencia integer NOT NULL,
    stockminimo integer DEFAULT 10,
    clavecategoria integer NOT NULL
);


ALTER TABLE public.producto OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 16449)
-- Name: producto_idproducto_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.producto_idproducto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.producto_idproducto_seq OWNER TO postgres;

--
-- TOC entry 3274 (class 0 OID 0)
-- Dependencies: 202
-- Name: producto_idproducto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.producto_idproducto_seq OWNED BY public.producto.idproducto;


--
-- TOC entry 3126 (class 2604 OID 16400)
-- Name: categoria idcategorria; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria ALTER COLUMN idcategorria SET DEFAULT nextval('public.categoria_idcategorria_seq'::regclass);


--
-- TOC entry 3127 (class 2604 OID 16454)
-- Name: producto idproducto; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto ALTER COLUMN idproducto SET DEFAULT nextval('public.producto_idproducto_seq'::regclass);


--
-- TOC entry 3265 (class 0 OID 16397)
-- Dependencies: 201
-- Data for Name: categoria; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categoria (idcategorria, nombrecategoria, descripcioncategoria) FROM stdin;
15	PS5	Video Juegos
14	XBOX Series X	Video Juegos
13	Swich Nintendo	Video Juegos
22	Pc	Pc Gamers con Nvidia
23	Linea blanca	Articulos de cocina
25	Oficina	ArtÃ­culos de oficina
27	medicina	Productos de farmacia
37	a	a
\.


--
-- TOC entry 3267 (class 0 OID 16451)
-- Dependencies: 203
-- Data for Name: producto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.producto (idproducto, nombreproducto, descripcionproducto, precio, existencia, stockminimo, clavecategoria) FROM stdin;
1	pc	pc de juegos	1000	100	10	22
12	Horno	Horno	222	22	22	23
14	Lampara potente	Lampara potente	100	15	15	25
16	Teclado rgb	teclado con iluminacion rgb	500	17	17	25
\.


--
-- TOC entry 3275 (class 0 OID 0)
-- Dependencies: 200
-- Name: categoria_idcategorria_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categoria_idcategorria_seq', 37, true);


--
-- TOC entry 3276 (class 0 OID 0)
-- Dependencies: 202
-- Name: producto_idproducto_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.producto_idproducto_seq', 19, true);


--
-- TOC entry 3130 (class 2606 OID 16402)
-- Name: categoria categoria_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (idcategorria);


--
-- TOC entry 3132 (class 2606 OID 16457)
-- Name: producto producto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_pkey PRIMARY KEY (idproducto);


--
-- TOC entry 3133 (class 2606 OID 16458)
-- Name: producto producto_clavecategoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_clavecategoria_fkey FOREIGN KEY (clavecategoria) REFERENCES public.categoria(idcategorria) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2021-10-28 17:27:43 CDT

--
-- PostgreSQL database dump complete
--

