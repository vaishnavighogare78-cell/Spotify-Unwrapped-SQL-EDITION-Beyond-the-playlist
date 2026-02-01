-- 1. Create the new table (Standalone, no inheritance)
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



--Q1 Listing the Most Listened-to Artists From The Database:
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

--Q1 Listing the Most Listened-to Artists From The Database:
SELECT artists_name, SUM(streams) AS total_streams
FROM "spotify-2023"
GROUP BY artists_name
ORDER BY total_streams DESC;


--Q2 Counts Of Songs Released Annually:
Select released_year, COUNT(*) AS song_count 
from "spotify-2023"
group by released_year
;

-- Q3New Songs: Lists of the newest songs based on their release date:

Select track_name, artists_name , released_year, released_month, released_day 
From "spotify-2023"
Order By released_year DESC, released_month DESC, released_day DESC 
LIMIT 10
;

--Q4 Most Popular Songs on Spotify and Apple Music:

Select track_name, artists_name, in_spotify_charts AS spotify_rank, in_apple_charts AS apple_rank 
From "spotify-2023"
Order By released_year DESC, released_month DESC, released_day DESC
LIMIT 10
;

--Q5 High-Tempo Songs: Lists high-tempo (high BPM) songs:

Select track_name, artists_name, bpm 
From "spotify-2023"
where bpm > 150 
order by bpm DESC 
LIMIT 10
;

--Q6 Songs that are most frequently found in Spotify and Apple Music playlists:

Select track_name, artists_name, in_spotify_playlists AS spotify_playlists, in_apple_playlists AS apple_playlists 
From "spotify-2023"
order by in_spotify_playlists + in_apple_playlists DESC 
LIMIT 10
;

-----------------------------------------------------------
--Q7 Energetic Songs: List of songs with a high energy level:

SELECT track_name, artists_name, energy_persent 
FROM "spotify-2023"
WHERE energy_persent > 80 
ORDER BY energy_persent DESC 
LIMIT 10
;

-----------------------------------------------------------
--Q8 Acoustic Songs: List of songs with a low acoustic ratio:

SELECT track_name, artists_name, acousticness_persent 
FROM "spotify-2023"
WHERE acousticness_persent < 10 
ORDER BY acousticness_persent DESC 
LIMIT 10
;

-----------------------------------
--Q9 Songs with High Lyrical Content:

SELECT track_name, artists_name, speechiness_persent 
FROM "spotify-2023"
WHERE speechiness_persent > 10 
ORDER BY speechiness_persent DESC 
LIMIT 10
;
