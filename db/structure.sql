--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: date_is_in_range(date, date, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION date_is_in_range(birthdate date, start_date date, end_date date) RETURNS boolean
    LANGUAGE plpgsql
    AS $$

      declare
        base_date date := start_date;
        result boolean;
      begin
        if ((date_part('year', start_date) < date_part('year', end_date)) and
          (date_part('month', birthdate) < date_part('month', start_date))) then
          base_date := end_date;
        end if;

        select (
          date_trunc('year', base_date)
          + age(birthdate, '1900-01-01')
          - (extract(year from age(birthdate, '1900-01-01')) || ' years'
            )::interval
        )::date between start_date and end_date into result;
        return result;
      end;
      $$;


--
-- Name: replace_year_of(date, date, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION replace_year_of(bdate date, sdate date, edate date) RETURNS date
    LANGUAGE plpgsql
    AS $$
declare
base_date date := sdate;
begin
if (date_part('year', sdate) < date_part('year', edate)) then
if (date_part('month', bday) < date_part('year', sdate)) then
base_date := edate;
end if;
end if;
select (date_trunc('year', base_date::date)
+ age(bdate, 'epoch'::date)
- (extract(year from age(bdate, 'epoch'::date)) || ' years')::interval)::date;
end;
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: emails; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE emails (
    id integer NOT NULL,
    category character varying,
    address character varying,
    member_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: emails_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE emails_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: emails_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE emails_id_seq OWNED BY emails.id;


--
-- Name: event_registrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE event_registrations (
    id integer NOT NULL,
    event_id integer,
    member_id integer,
    confirmed boolean DEFAULT true,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: event_registrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE event_registrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_registrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE event_registrations_id_seq OWNED BY event_registrations.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE events (
    id integer NOT NULL,
    title character varying NOT NULL,
    description text,
    cost integer DEFAULT 0,
    information text,
    departure_place character varying,
    arrival_place character varying,
    venue character varying,
    start_date date,
    start_time time without time zone,
    end_date date,
    end_time time without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    group_id integer
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_id_seq OWNED BY events.id;


--
-- Name: footers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE footers (
    id integer NOT NULL,
    "left" character varying,
    middle character varying,
    "right" character varying,
    pdf_template_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: footers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE footers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: footers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE footers_id_seq OWNED BY footers.id;


--
-- Name: groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE groups (
    id integer NOT NULL,
    name character varying,
    description text,
    website character varying,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    email character varying,
    phone character varying
);


--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE groups_id_seq OWNED BY groups.id;


--
-- Name: groups_members; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE groups_members (
    group_id integer NOT NULL,
    member_id integer NOT NULL
);


--
-- Name: header_columns; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE header_columns (
    id integer NOT NULL,
    content character varying,
    title character varying,
    size character varying,
    orientation character varying,
    pdf_template_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: header_columns_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE header_columns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: header_columns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE header_columns_id_seq OWNED BY header_columns.id;


--
-- Name: headers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE headers (
    id integer NOT NULL,
    "left" character varying,
    middle character varying,
    "right" character varying,
    pdf_template_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: headers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE headers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: headers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE headers_id_seq OWNED BY headers.id;


--
-- Name: members; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE members (
    id integer NOT NULL,
    first_name character varying NOT NULL,
    date_of_birth date,
    phone character varying,
    email character varying,
    information text,
    organization_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    title character varying
);


--
-- Name: members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE members_id_seq OWNED BY members.id;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE organizations (
    id integer NOT NULL,
    name character varying NOT NULL,
    street character varying NOT NULL,
    zip character varying NOT NULL,
    town character varying NOT NULL,
    country character varying NOT NULL,
    email character varying,
    website character varying,
    information text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer,
    phone character varying
);


--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE organizations_id_seq OWNED BY organizations.id;


--
-- Name: pdf_templates; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pdf_templates (
    id integer NOT NULL,
    title character varying,
    associated_class character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    orientation character varying
);


--
-- Name: pdf_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pdf_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pdf_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pdf_templates_id_seq OWNED BY pdf_templates.id;


--
-- Name: phones; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE phones (
    id integer NOT NULL,
    category character varying,
    number character varying,
    member_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: phones_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE phones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: phones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE phones_id_seq OWNED BY phones.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY emails ALTER COLUMN id SET DEFAULT nextval('emails_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_registrations ALTER COLUMN id SET DEFAULT nextval('event_registrations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY events ALTER COLUMN id SET DEFAULT nextval('events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY footers ALTER COLUMN id SET DEFAULT nextval('footers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY groups ALTER COLUMN id SET DEFAULT nextval('groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY header_columns ALTER COLUMN id SET DEFAULT nextval('header_columns_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY headers ALTER COLUMN id SET DEFAULT nextval('headers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY members ALTER COLUMN id SET DEFAULT nextval('members_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY organizations ALTER COLUMN id SET DEFAULT nextval('organizations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pdf_templates ALTER COLUMN id SET DEFAULT nextval('pdf_templates_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY phones ALTER COLUMN id SET DEFAULT nextval('phones_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: emails_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY emails
    ADD CONSTRAINT emails_pkey PRIMARY KEY (id);


--
-- Name: event_registrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY event_registrations
    ADD CONSTRAINT event_registrations_pkey PRIMARY KEY (id);


--
-- Name: events_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: footers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY footers
    ADD CONSTRAINT footers_pkey PRIMARY KEY (id);


--
-- Name: groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: header_columns_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY header_columns
    ADD CONSTRAINT header_columns_pkey PRIMARY KEY (id);


--
-- Name: headers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY headers
    ADD CONSTRAINT headers_pkey PRIMARY KEY (id);


--
-- Name: members_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY members
    ADD CONSTRAINT members_pkey PRIMARY KEY (id);


--
-- Name: organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: pdf_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pdf_templates
    ADD CONSTRAINT pdf_templates_pkey PRIMARY KEY (id);


--
-- Name: phones_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY phones
    ADD CONSTRAINT phones_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_emails_on_member_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_emails_on_member_id ON emails USING btree (member_id);


--
-- Name: index_event_registrations_on_event_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_event_registrations_on_event_id ON event_registrations USING btree (event_id);


--
-- Name: index_event_registrations_on_member_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_event_registrations_on_member_id ON event_registrations USING btree (member_id);


--
-- Name: index_footers_on_pdf_template_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_footers_on_pdf_template_id ON footers USING btree (pdf_template_id);


--
-- Name: index_groups_members_on_group_id_and_member_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_groups_members_on_group_id_and_member_id ON groups_members USING btree (group_id, member_id);


--
-- Name: index_groups_members_on_member_id_and_group_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_groups_members_on_member_id_and_group_id ON groups_members USING btree (member_id, group_id);


--
-- Name: index_header_columns_on_pdf_template_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_header_columns_on_pdf_template_id ON header_columns USING btree (pdf_template_id);


--
-- Name: index_headers_on_pdf_template_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_headers_on_pdf_template_id ON headers USING btree (pdf_template_id);


--
-- Name: index_phones_on_member_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_phones_on_member_id ON phones USING btree (member_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_2c9130a575; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY headers
    ADD CONSTRAINT fk_rails_2c9130a575 FOREIGN KEY (pdf_template_id) REFERENCES pdf_templates(id);


--
-- Name: fk_rails_5fa75df821; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY header_columns
    ADD CONSTRAINT fk_rails_5fa75df821 FOREIGN KEY (pdf_template_id) REFERENCES pdf_templates(id);


--
-- Name: fk_rails_63e3e6d47a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY emails
    ADD CONSTRAINT fk_rails_63e3e6d47a FOREIGN KEY (member_id) REFERENCES members(id);


--
-- Name: fk_rails_e95d38b832; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY phones
    ADD CONSTRAINT fk_rails_e95d38b832 FOREIGN KEY (member_id) REFERENCES members(id);


--
-- Name: fk_rails_fb5764f941; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY footers
    ADD CONSTRAINT fk_rails_fb5764f941 FOREIGN KEY (pdf_template_id) REFERENCES pdf_templates(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20151228172735');

INSERT INTO schema_migrations (version) VALUES ('20151230184228');

INSERT INTO schema_migrations (version) VALUES ('20151230185141');

INSERT INTO schema_migrations (version) VALUES ('20151231110934');

INSERT INTO schema_migrations (version) VALUES ('20151231123546');

INSERT INTO schema_migrations (version) VALUES ('20151231123804');

INSERT INTO schema_migrations (version) VALUES ('20160101153047');

INSERT INTO schema_migrations (version) VALUES ('20160101190210');

INSERT INTO schema_migrations (version) VALUES ('20160102152022');

INSERT INTO schema_migrations (version) VALUES ('20160102152217');

INSERT INTO schema_migrations (version) VALUES ('20160102185544');

INSERT INTO schema_migrations (version) VALUES ('20160102190145');

INSERT INTO schema_migrations (version) VALUES ('20160103120300');

INSERT INTO schema_migrations (version) VALUES ('20160112050117');

INSERT INTO schema_migrations (version) VALUES ('20160116193636');

INSERT INTO schema_migrations (version) VALUES ('20160529162605');

INSERT INTO schema_migrations (version) VALUES ('20160530182957');

INSERT INTO schema_migrations (version) VALUES ('20160709140209');

INSERT INTO schema_migrations (version) VALUES ('20160709140316');

INSERT INTO schema_migrations (version) VALUES ('20160709140343');

INSERT INTO schema_migrations (version) VALUES ('20160709140418');

INSERT INTO schema_migrations (version) VALUES ('20160709195816');

