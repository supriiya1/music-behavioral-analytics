-- Project Name   : Spotify Global Music Behavioral Analysis
-- Author Name    : Supriya
-- Tool Used     : Microsoft SQL Server Management Studio (v16)
-- Database Name : Music_Behavioral
-- Table Name    : universal_top_spotify_songs
-- Dataset       : Top Spotify Songs in 73 Countries (Daily Updated)
--                Source: Kaggle – asaniczka/top-spotify-songs-in-73-countries-daily-updated
-- Size          : > 2.1M Rows | 73 Countries | Daily Snapshots
-- Period        : 2024 – 2025
-- ============================================================
-- This project examines global music consumption behavior.
-- Based on daily chart data from Spotify in 73 countries,
-- artist influence, consumer behavior, regional tastes, and
-- the audio fingerprint of chart success were examined.

USE Music_Behavioral;
GO

-- ============================================================
-- Query 1: Dataset Overview
-- Business Question:
-- What is the size of the Spotify dataset?

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT spotify_id) AS unique_tracks,
    COUNT(DISTINCT artists) AS unique_artists,
    COUNT(DISTINCT country) AS countries_covered,
    MIN(snapshot_date) AS earliest_snapshot,
    MAX(snapshot_date) AS latest_snapshot
FROM universal_top_spotify_songs;


/*
Main Point:
The dataset has millions of Spotify chart entries from various countries and different artists.
Impact on Business:
Having such a diverse dataset allows conducting large-scale analysis of behavior in terms of preferences for songs and music.
*/

-- ===================================
-- Query 2: Global Artist Dominance

SELECT TOP 15
    artists,

    COUNT(*) AS total_chart_appearances,

    COUNT(DISTINCT country) AS countries_charted,

    ROUND(AVG(CAST(daily_rank AS FLOAT)),1) AS avg_daily_rank,

    ROUND(AVG(CAST(popularity AS FLOAT)),1) AS avg_popularity,

    MIN(daily_rank) AS best_rank_ever

FROM universal_top_spotify_songs

GROUP BY artists

ORDER BY total_chart_appearances DESC;


/*
Important Point:
Artists who dominate on a global level always show up in many different countries and have high popularity ratings.

Impact on Business:
The streaming company can use these artists for promotion and collaboration around the world.
*/

-- ============================================================
-- Query 3: Artists With The Most Number 1s

SELECT TOP 10
    artists,

    COUNT(DISTINCT country) AS countries_hit_number_one,

    COUNT(*) AS total_number_one_days

FROM universal_top_spotify_songs

WHERE daily_rank = 1

GROUP BY artists

ORDER BY countries_hit_number_one DESC;


/*
Key Insight:
Few artists have consistently held #1 spots in the world, indicating a high level of international fan involvement.

Business Application:
Music companies could leverage this data to determine artists with substantial international commercial clout.
*/

-- ============================================================
-- Query 4: Jimin Global Chart Performance


SELECT
    country,

    COUNT(*) AS chart_days,

    MIN(daily_rank) AS peak_rank,

    ROUND(AVG(CAST(daily_rank AS FLOAT)),1) AS avg_rank,

    ROUND(AVG(CAST(popularity AS FLOAT)),1) AS avg_popularity

FROM universal_top_spotify_songs

WHERE artists LIKE '%Jimin%'

GROUP BY country

ORDER BY chart_days DESC;


/*
Important Finding:
Jimin shows good international chart performance in many different nations.

Business Relevance:
K-pop music gaining global fame presents chances for marketing music internationally.
*/

-- ============================================================
-- Query 5: The Weeknd Song Longevity

SELECT TOP 10
    name AS song_name,

    COUNT(DISTINCT snapshot_date) AS days_on_chart,

    COUNT(DISTINCT country) AS countries_reached,

    MIN(daily_rank) AS peak_rank,

    ROUND(AVG(CAST(popularity AS FLOAT)),1) AS avg_popularity

FROM universal_top_spotify_songs

WHERE artists LIKE '%The Weeknd%'

GROUP BY name

ORDER BY days_on_chart DESC;


/*
Insight:
Songs that have chart longevity keep listeners interested for a long time.

Impact:
Songs that last long earn money and keep listeners engaged over a period of time.
*/

-- ============================================================
-- Query 6: Explicit vs Clean Songs


SELECT
    CASE
        WHEN is_explicit = 1 THEN 'Explicit'
        ELSE 'Clean'
    END AS content_type,

    COUNT(*) AS total_entries,

    ROUND(AVG(CAST(daily_rank AS FLOAT)),1) AS avg_rank,

    ROUND(AVG(CAST(popularity AS FLOAT)),1) AS avg_popularity,

    MIN(daily_rank) AS peak_rank

FROM universal_top_spotify_songs

GROUP BY is_explicit

ORDER BY avg_rank ASC;

/*
Insight:
Songs that are explicit and clean exhibit clear distinctions with regards to their popularity and chart performance.

Impact on Business:
The preference of the listeners can help streaming services in improving their audience targeting techniques.
*/

-- ============================================================
-- Query 7: BTS vs Taylor Swift vs Billie Eilish vs The Weeknd

SELECT
    CASE
        WHEN artists LIKE '%BTS%' THEN 'BTS'
        WHEN artists LIKE '%Taylor Swift%' THEN 'Taylor Swift'
        WHEN artists LIKE '%Billie Eilish%' THEN 'Billie Eilish'
        WHEN artists LIKE '%The Weeknd%' THEN 'The Weeknd'
    END AS artist_group,

    CASE
        WHEN is_explicit = 1 THEN 'Explicit'
        ELSE 'Clean'
    END AS content_type,

    COUNT(*) AS chart_entries,

    ROUND(AVG(CAST(popularity AS FLOAT)),1) AS avg_popularity,

    ROUND(AVG(CAST(daily_rank AS FLOAT)),1) AS avg_rank,

    MIN(daily_rank) AS peak_rank,

    COUNT(DISTINCT country) AS countries_charted

FROM universal_top_spotify_songs

WHERE artists LIKE '%BTS%'
   OR artists LIKE '%Taylor Swift%'
   OR artists LIKE '%Billie Eilish%'
   OR artists LIKE '%The Weeknd%'

GROUP BY

    CASE
        WHEN artists LIKE '%BTS%' THEN 'BTS'
        WHEN artists LIKE '%Taylor Swift%' THEN 'Taylor Swift'
        WHEN artists LIKE '%Billie Eilish%' THEN 'Billie Eilish'
        WHEN artists LIKE '%The Weeknd%' THEN 'The Weeknd'
    END,

    CASE
        WHEN is_explicit = 1 THEN 'Explicit'
        ELSE 'Clean'
    END

ORDER BY avg_popularity DESC;


/*
Insight:
Different artists around the world have varying degrees of popularity, rankings, and even types of music on Spotify charts.

Implications:
The streaming company can customize its suggestions and marketing tactics based on the behaviors of their artists’ listeners.
*/


-- ============================================================
-- Query 9: Country Happy Songs

SELECT TOP 20
    country,

    ROUND(AVG(CAST(energy AS FLOAT)),3) AS avg_energy,

    ROUND(AVG(CAST(valence AS FLOAT)),3) AS avg_happiness,

    ROUND(AVG(CAST(danceability AS FLOAT)),3) AS avg_danceability,

    ROUND(AVG(CAST(acousticness AS FLOAT)),3) AS avg_acousticness,

    COUNT(DISTINCT spotify_id) AS unique_songs_charted

FROM universal_top_spotify_songs

WHERE country != 'global'

GROUP BY country

ORDER BY avg_energy DESC;


/*
Insight:
There are distinct variations in the emotional and behavioral preferences for music in different nations.

Implications:
Regional mood analysis can help music streaming services to provide better playlist recommendations for local audiences.
*/

-- ============================================================
-- Query 9: Countries That Like Upbeat Music


SELECT TOP 10
    country,

    ROUND(AVG(CAST(valence AS FLOAT)),3) AS avg_happiness,

    ROUND(AVG(CAST(energy AS FLOAT)),3) AS avg_energy,

    ROUND(AVG(CAST(danceability AS FLOAT)),3) AS avg_danceability

FROM universal_top_spotify_songs

WHERE country != 'global'

GROUP BY country

HAVING COUNT(*) > 500

ORDER BY avg_happiness DESC, avg_energy DESC;


/*
Insight:
There are some countries that always enjoy upbeat, lively, and danceable kinds of music.

Impact:
The streaming companies can create playlists based on consumer behavior.
*/


-- ============================================================
-- Query 10: Most Durable Songs in the World


SELECT TOP 15
    name AS song_name,

    artists,

    COUNT(DISTINCT snapshot_date) AS days_on_chart,

    COUNT(DISTINCT country) AS countries_reached,

    MIN(daily_rank) AS peak_rank,

    ROUND(AVG(CAST(popularity AS FLOAT)),1) AS avg_popularity

FROM universal_top_spotify_songs

GROUP BY name, artists

ORDER BY days_on_chart DESC;


/*
Insight:
Songs that have a long lifespan continue to generate significant global interest in several different parts of the world.

Value to Business:
An understanding of the patterns of longevity can help in recognizing those songs that will sustain streaming.

*/
-- ============================================================
-- Query 11: Global Songs

SELECT
    name AS song_name,

    artists,

    COUNT(DISTINCT country) AS countries_charted,

    MIN(daily_rank) AS global_peak,

    ROUND(AVG(CAST(popularity AS FLOAT)),1) AS avg_popularity

FROM universal_top_spotify_songs

GROUP BY name, artists

HAVING COUNT(DISTINCT country) >= 50

ORDER BY countries_charted DESC;


/*
Important Point:
Very few songs become popular worldwide among many nations.

Business Relevance:
Determination of globally scalable songs helps in the international distribution and marketing of songs.
*/


-- ============================================================
-- Query 12: Formula of Successful Songs


SELECT
    'Top 10 Songs' AS tier,

    ROUND(AVG(CAST(energy AS FLOAT)),3) AS avg_energy,

    ROUND(AVG(CAST(valence AS FLOAT)),3) AS avg_valence,

    ROUND(AVG(CAST(danceability AS FLOAT)),3) AS avg_danceability,

    ROUND(AVG(CAST(acousticness AS FLOAT)),3) AS avg_acousticness,

    ROUND(AVG(CAST(duration_ms AS FLOAT))/60000,2) AS avg_duration_min,

    ROUND(AVG(CAST(popularity AS FLOAT)),1) AS avg_popularity

FROM universal_top_spotify_songs

WHERE daily_rank <= 10

UNION ALL

SELECT
    'Rank 11-50',

    ROUND(AVG(CAST(energy AS FLOAT)),3),

    ROUND(AVG(CAST(valence AS FLOAT)),3),

    ROUND(AVG(CAST(danceability AS FLOAT)),3),

    ROUND(AVG(CAST(acousticness AS FLOAT)),3),

    ROUND(AVG(CAST(duration_ms AS FLOAT))/60000,2),

    ROUND(AVG(CAST(popularity AS FLOAT)),1)

FROM universal_top_spotify_songs

WHERE daily_rank BETWEEN 11 AND 50

UNION ALL

SELECT
    'Rank 51-100',

    ROUND(AVG(CAST(energy AS FLOAT)),3),

    ROUND(AVG(CAST(valence AS FLOAT)),3),

    ROUND(AVG(CAST(danceability AS FLOAT)),3),

    ROUND(AVG(CAST(acousticness AS FLOAT)),3),

    ROUND(AVG(CAST(duration_ms AS FLOAT))/60000,2),

    ROUND(AVG(CAST(popularity AS FLOAT)),1)

FROM universal_top_spotify_songs

WHERE daily_rank BETWEEN 51 AND 100;


/*
Insight:
Songs that rank highly tend to be more energetic, danceable, and popular.

Impact:
This insight can help music producers and streaming services in formulating effective business strategies.
*/


-- ============================================================
-- Query 13: Song Length and Popularity


SELECT
    CASE
        WHEN duration_ms < 150000
        THEN 'Short (<2.5 min)'

        WHEN duration_ms BETWEEN 150000 AND 210000
        THEN 'Standard (2.5–3.5 min)'

        WHEN duration_ms BETWEEN 210001 AND 270000
        THEN 'Long (3.5–4.5 min)'

        ELSE 'Extended (4.5+ min)'
    END AS duration_bucket,

    COUNT(*) AS chart_entries,

    ROUND(AVG(CAST(daily_rank AS FLOAT)),1) AS avg_rank,

    ROUND(AVG(CAST(popularity AS FLOAT)),1) AS avg_popularity,

    MIN(daily_rank) AS peak_rank

FROM universal_top_spotify_songs

GROUP BY

    CASE
        WHEN duration_ms < 150000
        THEN 'Short (<2.5 min)'

        WHEN duration_ms BETWEEN 150000 AND 210000
        THEN 'Standard (2.5–3.5 min)'

        WHEN duration_ms BETWEEN 210001 AND 270000
        THEN 'Long (3.5–4.5 min)'

        ELSE 'Extended (4.5+ min)'
    END

ORDER BY avg_rank ASC;


/*
Insight:
Songs that are shorter generally do well on streaming platforms because of replayability and shorter attention spans.

Impact on Business:
Optimal song length can help artists and labels take full advantage of streaming platforms.
*/
