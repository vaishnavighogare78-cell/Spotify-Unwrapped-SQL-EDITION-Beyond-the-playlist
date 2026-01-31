-- 1. Delete the broken table completely
DROP TABLE IF EXISTS "spotify-2023";

-- 2. Create the new table (Standalone, no inheritance)
-- Note: We are setting 'streams' to TEXT immediately to handle the bad data in your file.
CREATE TABLE "spotify-2023" (
    track_name VARCHAR(255),
    artists_name VARCHAR(255),
    artist_count INT,
    released_year INT,
    released_month INT,
    released_day INT,
    in_spotify_playlists INT,
    in_spotify_charts INT,
    streams TEXT,             -- <-- This is now TEXT to prevent the import crash!
    in_apple_playlists INT,
    in_apple_charts INT,
    in_deezer_playlists VARCHAR(50),
    in_deezer_charts INT,
    in_shazam_charts VARCHAR(50),
    bpm INT,
    key VARCHAR(50),
    mode VARCHAR(50),
    danceability_persent INT,
    valence_persent INT,
    energy_persent INT,
    acousticness_persent INT,
    instrumentalness_persent INT,
    liveness_persent INT,
    speechiness_persent INT
);



-- Listing the Most Listened-to Artists From The Database:
SELECT artists_name, SUM(CAST(streams AS BIGINT)) AS total_streams
FROM "spotify-2023"    -- changed from spotify_data to "spotify-2023"
GROUP BY artists_name
ORDER BY total_streams DESC;

-- Step 1: Delete the "garbage" row that is causing the error
DELETE FROM "spotify-2023"
WHERE streams LIKE '%BPM%';

-- Step 2: Convert the 'streams' column to a real Number (so you don't need to CAST anymore)
ALTER TABLE "spotify-2023"
ALTER COLUMN streams TYPE BIGINT
USING streams::bigint;

-- Step 3: Run your analysis (It will work now!)
SELECT artists_name, SUM(streams) AS total_streams
FROM "spotify-2023"
GROUP BY artists_name
ORDER BY total_streams DESC;