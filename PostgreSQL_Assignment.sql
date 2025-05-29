-- Active: 1747906155646@@127.0.0.1@5432@conservation_db
CREATE DATABASE conservation_db;

-- Tables Creation --

CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(100) NOT NULL
);

CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(150) NOT NULL,
    scientific_name VARCHAR(150) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(30) NOT NULL
);

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INT NOT NULL,
    species_id INT NOT NULL,
    sighting_time TIMESTAMP NOT NULL,
    location VARCHAR(50),
    notes TEXT,
    FOREIGN KEY (ranger_id) REFERENCES rangers (ranger_id),
    FOREIGN KEY (species_id) REFERENCES species (species_id)
);

-- Inserting Data to Tables --

INSERT INTO
    rangers (name, region)
VALUES (
        'Alice Green',
        'Northern Hills'
    ),
    ('Bob White', 'River Delta'),
    (
        'Carol King',
        'Mountain Range'
    );

INSERT INTO
    species (
        common_name,
        scientific_name,
        discovery_date,
        conservation_status
    )
VALUES (
        'Snow Leopard',
        'Panthera uncia',
        '1775-01-01',
        'Endangered'
    ),
    (
        'Bengal Tiger',
        'Panthera tigris',
        '1758-01-01',
        'Endangered'
    ),
    (
        'Red Panda',
        'Ailurus fulgens',
        '1825-01-01',
        'Vulnerable'
    ),
    (
        'Asiatic Elephant',
        'Elephas maximus indicus',
        '1758-01-01',
        'Endangered'
    );

INSERT INTO
    sightings (
        ranger_id,
        species_id,
        sighting_time,
        location,
        notes
    )
VALUES (
        1,
        1,
        '2024-05-10 07:45:00',
        'Peak Ridge',
        'Camera trap image captured'
    ),
    (
        2,
        2,
        '2024-05-12 16:20:00',
        'Bankwood Area',
        'Juvenile seen'
    ),
    (
        3,
        3,
        '2024-05-15 09:10:00',
        'Bamboo Grove East',
        'Feeding observed'
    ),
    (
        2,
        1,
        '2024-05-18 18:30:00',
        'Snowfall Pass',
        NULL
    );

----------------------------------------- Problems ------------------------------------------------------

-- Problem 1 --

INSERT INTO
    rangers (name, region)
VALUES ('Derek Fox', 'Coastal Plains');

-- Problem 2 --

SELECT COUNT(DISTINCT species_id) AS unique_species_count
FROM sightings;

-- Problem 3 --

SELECT * FROM sightings WHERE location LIKE '%Pass%';

-- Problem 4 --

SELECT r.name, count(s.species_id) AS total_sightings
FROM rangers r
    JOIN sightings s ON r.ranger_id = s.ranger_id
GROUP BY
    r.name
ORDER BY r.name;

-- Problem 5 --

SELECT sp.common_name
FROM species sp
    LEFT JOIN sightings si ON sp.species_id = si.species_id
WHERE
    si.species_id IS NULL;

-- Problem 6 --

SELECT sp.common_name, si.sighting_time, r.name
FROM
    species sp
    JOIN sightings si ON sp.species_id = si.species_id
    JOIN rangers r ON r.ranger_id = si.ranger_id
ORDER BY si.sighting_time DESC
LIMIT 2;

-- Problem 7 --

UPDATE species
SET
    conservation_status = 'Historic'
WHERE
    discovery_date < '1799-12-31';

-- Problem 8 --

CREATE OR REPLACE FUNCTION time_of_day(td TIMESTAMP)
RETURNS TEXT AS $$
BEGIN
  IF EXTRACT(HOUR FROM td) < 12 THEN
    RETURN 'Morning';
  ELSIF EXTRACT(HOUR FROM td) BETWEEN 12 AND 17 THEN
    RETURN 'Afternoon';
  ELSE
    RETURN 'Evening';
  END IF;
END;
$$ LANGUAGE plpgsql;

SELECT sighting_id, time_of_day (sighting_time) FROM sightings;

-- Problem 9 --

DELETE FROM rangers
WHERE
    ranger_id IN (
        SELECT rangers.ranger_id
        FROM rangers
            LEFT JOIN sightings ON rangers.ranger_id = sightings.ranger_id
        WHERE
            sightings.ranger_id IS NULL
    );