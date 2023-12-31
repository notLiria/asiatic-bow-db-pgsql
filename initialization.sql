-- bow_types table
CREATE TABLE bow_types (
   bow_type_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   model_name TEXT NOT NULL,
   manufacturer TEXT, 
   bow_link TEXT,
   CONSTRAINT uk_model_name UNIQUE (model_name, manufacturer)
);

CREATE TABLE samples (
   sample_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   bow_type_id INT NOT NULL REFERENCES bow_types(bow_type_id),
   unstrung_length FLOAT,
   strung_length FLOAT,
   min_box_length FLOAT,
   min_box_width FLOAT,
   min_box_depth FLOAT,
   siyah_effective_top_length FLOAT,
   siyah_effective_bottom_length FLOAT,
   siyah_effective_top_angle FLOAT,
   siyah_effective_bottom_angle FLOAT,
   bow_mass INT,
   grip_length FLOAT,
   grip_width FLOAT,
   grip_depth FLOAT,
   max_limb_thickness FLOAT,
   min_limb_thickness FLOAT,
   max_limb_width FLOAT,
   min_limb_width FLOAT,
   arrow_pass_width FLOAT,
   max_draw INT,
   stock_string_length_min FLOAT,
   stock_string_length_max FLOAT,
   brace_height FLOAT,
   contributor_contact_type TEXT,
   contributor_contact_info TEXT,
   manufacture_date TEXT,
   measurement_date TEXT,
   comments TEXT,
   asym BOOLEAN,
   asym_length_top FLOAT,
   asym_length_bottom FLOAT,
   df_data PATH NOT NULL,
   df_data_text TEXT GENERATED ALWAYS AS (df_data::text) STORED UNIQUE,
   central_differences PATH,
   longbow_point INT,
   stored_energy FLOAT[][],
   regression_curve PATH, 
   coeffs FLOAT[],
   regression_eqn TEXT, 
   regression_derivative TEXT, 
   regression_derivative_values PATH, 
   hysteresis FLOAT,
   virtual_mass FLOAT, 
   submodel TEXT
);

CREATE TABLE fps_data (
   fps_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   sample_id INT NOT NULL REFERENCES samples(sample_id),
   dl FLOAT,
   arrow_weight FLOAT,
   gpp FLOAT,
   fps FLOAT,
   measured_energy FLOAT,
   stored_energy FLOAT,
   efficiency FLOAT,
   draw_length_to_belly FLOAT
);

CREATE TABLE fps_regression_data (
   fps_regression_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   sample_id INT NOT NULL REFERENCES samples(sample_id),
   dl FLOAT,
   coefficients FLOAT[],
   fitted_line PATH
);

CREATE TABLE arrow_shafts (
    shaft_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    manufacturer TEXT NOT NULL,
    model TEXT NOT NULL,
    spine INT,
    gpi FLOAT,
    od FLOAT,
    stock_length FLOAT,
    insert_stem_length FLOAT,
    insert_rim_length FLOAT,
    bushing_nock_inner_length FLOAT,
    bushing_outer_length FLOAT,
    insert_weight FLOAT,
    bushing_nock_weight FLOAT,
    comments TEXT,
    UNIQUE(manufacturer, model, spine)
);

CREATE TABLE shaft_collars (
    collar_id int GENERATED always as identity primary key,
    manufacturer TEXT NOT NULL,
    model TEXT NOT NULL,
    shaft_size FLOAT,
    outsert_id FLOAT,
    outsert_od FLOAT,
    point_size FLOAT, 
    weight int
);


CREATE TABLE tags (
   tag_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   tag_name TEXT NOT NULL UNIQUE,
   tag_description TEXT
);

CREATE TABLE bow_type_tags (
   bow_type_id INT NOT NULL REFERENCES bow_types(bow_type_id),
   tag_id INT NOT NULL REFERENCES tags(tag_id),
   PRIMARY KEY (bow_type_id, tag_id)
);

CREATE TABLE bow_pictures (
   picture_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
   picture_link TEXT NOT NULL UNIQUE,
   bow_type_id INT NOT NULL REFERENCES bow_types(bow_type_id), 
   caption TEXT, 
   sample_id INT references samples(sample_id)
)

CREATE TABLE data_updates(
    update_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    bow_type_id INT REFERENCES bow_types,
    sample_id INT REFERENCES samples,
    picture_id INT REFERENCES bow_pictures, 
    fps_id INT REFERENCES fps_data,
    fps_regression_id INT REFERENCES fps_regression_data,
    modification_date TIMESTAMP NOT NULL
);

CREATE INDEX idx_modification_date ON data_updates(modification_date);

CREATE TABLE torsional_stability_data(
   ts_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
   sample_id INT REFERENCES samples NOT NULL,
   mass INT NOT NULL, 
   deflection FLOAT NOT NULL
);

CREATE TABLE users(
   user_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
   email TEXT NOT NULL, 
   salt TEXT NOT NULL, 
   phash TEXT NOT NULL,
)

-- pg_ctl -D "C:\Program Files\PostgreSQL\15\data" start
-- C:/Users/liria/code/asiatic-bow-data-dump/pgsql/initialization.sql

