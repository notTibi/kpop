--
-- PostgreSQL database dump
--

\restrict u2PoMSb0oNLf6Cp5gQnBFyJfInMmuY7SCf9j3VKicJCq7xxdW6XHuw31F4rFc4B

-- Dumped from database version 18.0 (Debian 18.0-1.pgdg13+3)
-- Dumped by pg_dump version 18.0 (Debian 18.0-1.pgdg13+3)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: ALBUM_TYPE; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."ALBUM_TYPE" AS ENUM (
    'Studio',
    'EP',
    'Soundtrack',
    'Live',
    'Compilation',
    'Reissue',
    'Single'
);


ALTER TYPE public."ALBUM_TYPE" OWNER TO postgres;

--
-- Name: AUTHOR_TYPE; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."AUTHOR_TYPE" AS ENUM (
    'person',
    'band'
);


ALTER TYPE public."AUTHOR_TYPE" OWNER TO postgres;

--
-- Name: BAND_GENDER; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."BAND_GENDER" AS ENUM (
    'boys',
    'girls',
    'mixed'
);


ALTER TYPE public."BAND_GENDER" OWNER TO postgres;

--
-- Name: album_duration(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.album_duration() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
    affected_album integer;
BEGIN
	IF TG_OP = 'DELETE' THEN
        affected_album := OLD.album_id;
    ELSE
        affected_album := NEW.album_id;
    END IF;
	
    UPDATE public.albums
    SET duration = (
        SELECT SUM(t.duration)
        FROM public.album_tracks at
        JOIN public.tracks t ON at.track_id = t.id
        WHERE at.album_id = affected_album
    )
    WHERE id = affected_album;
    RETURN NULL;
END;$$;


ALTER FUNCTION public.album_duration() OWNER TO postgres;

--
-- Name: generate_band_name(text[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_band_name(words text[] DEFAULT NULL::text[]) RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE
    word_count integer;
    word1 text;
    word2 text;
    use_two boolean := random() < 0.5;
    rand_num integer := floor(random() * 10);
    default_words text[] := ARRAY['star', 'dream', 'moon', 'shine', 'pulse'];
BEGIN
    IF words IS NULL OR array_length(words, 1) = 0 THEN
        words := default_words;
    END IF;

    word_count := array_length(words, 1);
    word1 := words[floor(random() * word_count + 1)];

    IF use_two AND word_count > 1 THEN
        LOOP
            word2 := words[floor(random() * word_count + 1)];
            EXIT WHEN word2 <> word1;
        END LOOP;
        RETURN initcap(word1) || initcap(word2) || rand_num;
    ELSE
        RETURN initcap(word1) || rand_num;
    END IF;
END;$$;


ALTER FUNCTION public.generate_band_name(words text[]) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: album_tracks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.album_tracks (
    id integer NOT NULL,
    album_id integer NOT NULL,
    track_id integer NOT NULL,
    track_number smallint NOT NULL,
    CONSTRAINT track_number_positive CHECK ((track_number > 0))
);


ALTER TABLE public.album_tracks OWNER TO postgres;

--
-- Name: album_tracks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.album_tracks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.album_tracks_id_seq OWNER TO postgres;

--
-- Name: album_tracks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.album_tracks_id_seq OWNED BY public.album_tracks.id;


--
-- Name: albums; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.albums (
    id integer NOT NULL,
    title text NOT NULL,
    released date NOT NULL,
    label_id integer NOT NULL,
    type public."ALBUM_TYPE" NOT NULL,
    duration interval(0)
);


ALTER TABLE public.albums OWNER TO postgres;

--
-- Name: TABLE albums; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.albums IS 'if duration is null there are no tracks in the album';


--
-- Name: albums_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.albums_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.albums_id_seq OWNER TO postgres;

--
-- Name: albums_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.albums_id_seq OWNED BY public.albums.id;


--
-- Name: band_members; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.band_members (
    id integer NOT NULL,
    band_id integer NOT NULL,
    person_id integer NOT NULL,
    joined date NOT NULL,
    "left" date,
    founder boolean DEFAULT false NOT NULL
);


ALTER TABLE public.band_members OWNER TO postgres;

--
-- Name: band_members_band_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.band_members_band_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.band_members_band_id_seq OWNER TO postgres;

--
-- Name: band_members_band_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.band_members_band_id_seq OWNED BY public.band_members.band_id;


--
-- Name: band_members_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.band_members_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.band_members_id_seq OWNER TO postgres;

--
-- Name: band_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.band_members_id_seq OWNED BY public.band_members.id;


--
-- Name: band_members_person_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.band_members_person_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.band_members_person_id_seq OWNER TO postgres;

--
-- Name: band_members_person_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.band_members_person_id_seq OWNED BY public.band_members.person_id;


--
-- Name: bands; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bands (
    id integer NOT NULL,
    name text NOT NULL,
    korean_name text,
    formed date NOT NULL,
    origin text,
    gender public."BAND_GENDER" NOT NULL,
    website text
);


ALTER TABLE public.bands OWNER TO postgres;

--
-- Name: bands_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bands_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bands_id_seq OWNER TO postgres;

--
-- Name: bands_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bands_id_seq OWNED BY public.bands.id;


--
-- Name: lables; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lables (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.lables OWNER TO postgres;

--
-- Name: lables_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lables_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lables_id_seq OWNER TO postgres;

--
-- Name: lables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lables_id_seq OWNED BY public.lables.id;


--
-- Name: people; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.people (
    id integer CONSTRAINT members_id_not_null NOT NULL,
    alias text CONSTRAINT members_alias_not_null NOT NULL,
    name text,
    korean_name text,
    born date,
    deceased date,
    retired boolean DEFAULT false NOT NULL
);


ALTER TABLE public.people OWNER TO postgres;

--
-- Name: members_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.members_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.members_id_seq OWNER TO postgres;

--
-- Name: members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.members_id_seq OWNED BY public.people.id;


--
-- Name: track_authors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.track_authors (
    id integer NOT NULL,
    type public."AUTHOR_TYPE" NOT NULL,
    person_id integer,
    band_id integer,
    track_id integer
);


ALTER TABLE public.track_authors OWNER TO postgres;

--
-- Name: track_authors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.track_authors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.track_authors_id_seq OWNER TO postgres;

--
-- Name: track_authors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.track_authors_id_seq OWNED BY public.track_authors.id;


--
-- Name: tracks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tracks (
    id integer NOT NULL,
    title text NOT NULL,
    duration interval(0) CONSTRAINT tracks_length_not_null NOT NULL,
    lyrics text,
    released date NOT NULL
);


ALTER TABLE public.tracks OWNER TO postgres;

--
-- Name: tracks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tracks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tracks_id_seq OWNER TO postgres;

--
-- Name: tracks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tracks_id_seq OWNED BY public.tracks.id;


--
-- Name: album_tracks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.album_tracks ALTER COLUMN id SET DEFAULT nextval('public.album_tracks_id_seq'::regclass);


--
-- Name: albums id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.albums ALTER COLUMN id SET DEFAULT nextval('public.albums_id_seq'::regclass);


--
-- Name: band_members id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.band_members ALTER COLUMN id SET DEFAULT nextval('public.band_members_id_seq'::regclass);


--
-- Name: bands id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bands ALTER COLUMN id SET DEFAULT nextval('public.bands_id_seq'::regclass);


--
-- Name: lables id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lables ALTER COLUMN id SET DEFAULT nextval('public.lables_id_seq'::regclass);


--
-- Name: people id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.people ALTER COLUMN id SET DEFAULT nextval('public.members_id_seq'::regclass);


--
-- Name: track_authors id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.track_authors ALTER COLUMN id SET DEFAULT nextval('public.track_authors_id_seq'::regclass);


--
-- Name: tracks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tracks ALTER COLUMN id SET DEFAULT nextval('public.tracks_id_seq'::regclass);


--
-- Data for Name: album_tracks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.album_tracks (id, album_id, track_id, track_number) FROM stdin;
\.


--
-- Data for Name: albums; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.albums (id, title, released, label_id, type, duration) FROM stdin;
2	a1	2025-10-16	1	Single	\N
\.


--
-- Data for Name: band_members; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.band_members (id, band_id, person_id, joined, "left", founder) FROM stdin;
\.


--
-- Data for Name: bands; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bands (id, name, korean_name, formed, origin, gender, website) FROM stdin;
\.


--
-- Data for Name: lables; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lables (id, name) FROM stdin;
1	l1
\.


--
-- Data for Name: people; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.people (id, alias, name, korean_name, born, deceased, retired) FROM stdin;
\.


--
-- Data for Name: track_authors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.track_authors (id, type, person_id, band_id, track_id) FROM stdin;
\.


--
-- Data for Name: tracks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tracks (id, title, duration, lyrics, released) FROM stdin;
1	asdfgh	00:01:30	\N	2025-10-16
\.


--
-- Name: album_tracks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.album_tracks_id_seq', 4, true);


--
-- Name: albums_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.albums_id_seq', 2, true);


--
-- Name: band_members_band_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.band_members_band_id_seq', 1, false);


--
-- Name: band_members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.band_members_id_seq', 1, false);


--
-- Name: band_members_person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.band_members_person_id_seq', 1, false);


--
-- Name: bands_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bands_id_seq', 1, false);


--
-- Name: lables_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lables_id_seq', 1, true);


--
-- Name: members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.members_id_seq', 1, false);


--
-- Name: track_authors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.track_authors_id_seq', 1, false);


--
-- Name: tracks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tracks_id_seq', 2, true);


--
-- Name: album_tracks album_tracks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.album_tracks
    ADD CONSTRAINT album_tracks_pkey PRIMARY KEY (id);


--
-- Name: albums albums_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.albums
    ADD CONSTRAINT albums_pkey PRIMARY KEY (id);


--
-- Name: band_members band_members_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.band_members
    ADD CONSTRAINT band_members_pkey PRIMARY KEY (id);


--
-- Name: bands bands_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bands
    ADD CONSTRAINT bands_pkey PRIMARY KEY (id);


--
-- Name: lables lables_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lables
    ADD CONSTRAINT lables_pkey PRIMARY KEY (id);


--
-- Name: people members_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT members_pkey PRIMARY KEY (id);


--
-- Name: track_authors track_authors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.track_authors
    ADD CONSTRAINT track_authors_pkey PRIMARY KEY (id);


--
-- Name: tracks tracks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tracks
    ADD CONSTRAINT tracks_pkey PRIMARY KEY (id);


--
-- Name: album_tracks set_album_duration; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_album_duration AFTER INSERT OR DELETE OR UPDATE ON public.album_tracks FOR EACH ROW EXECUTE FUNCTION public.album_duration();


--
-- Name: album_tracks album_tracks_album_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.album_tracks
    ADD CONSTRAINT album_tracks_album_id_fkey FOREIGN KEY (album_id) REFERENCES public.albums(id) ON DELETE CASCADE NOT VALID;


--
-- Name: album_tracks album_tracks_track_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.album_tracks
    ADD CONSTRAINT album_tracks_track_id_fkey1 FOREIGN KEY (track_id) REFERENCES public.tracks(id) ON DELETE CASCADE NOT VALID;


--
-- Name: albums albums_label_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.albums
    ADD CONSTRAINT albums_label_id_fkey FOREIGN KEY (label_id) REFERENCES public.lables(id);


--
-- Name: band_members band_members_band_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.band_members
    ADD CONSTRAINT band_members_band_id_fkey FOREIGN KEY (band_id) REFERENCES public.bands(id);


--
-- Name: band_members band_members_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.band_members
    ADD CONSTRAINT band_members_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: track_authors track_authors_band_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.track_authors
    ADD CONSTRAINT track_authors_band_id_fkey FOREIGN KEY (band_id) REFERENCES public.bands(id);


--
-- Name: track_authors track_authors_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.track_authors
    ADD CONSTRAINT track_authors_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: track_authors track_authors_track_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.track_authors
    ADD CONSTRAINT track_authors_track_id_fkey FOREIGN KEY (track_id) REFERENCES public.tracks(id) NOT VALID;


--
-- PostgreSQL database dump complete
--

\unrestrict u2PoMSb0oNLf6Cp5gQnBFyJfInMmuY7SCf9j3VKicJCq7xxdW6XHuw31F4rFc4B

