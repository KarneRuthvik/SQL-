--1 all columns
SELECT *
FROM health_sleep;
--2. Average sleep duration by gender
SELECT gender, ROUND(AVG(sleep_duration), 2) AS avg_sleep_duration
FROM health_sleep
GROUP BY gender;
--3. Sleep duration by age group
SELECT
  CASE
    WHEN age < 18 THEN 'Under 18'
--4. Sleep duration by gender
SELECT gender, ROUND(AVG(sleep_duration), 2) AS avg_sleep_duration
FROM health_sleep
GROUP BY gender;
--5. Sleep duration by age group
SELECT
  CASE
    WHEN age < 18 THEN 'Under 18'
    WHEN age BETWEEN 18 AND 30 THEN '18–30'
-- 6. Average sleep duration by age group
SELECT
  CASE
    WHEN age < 18 THEN 'Under 18'
    WHEN age BETWEEN 18 AND 30 THEN '18–30'
    WHEN age BETWEEN 31 AND 45 THEN '31–45'
    WHEN age BETWEEN 46 AND 60 THEN '46–60'
    ELSE '60+'
  END AS age_group,
  ROUND(AVG(sleep_duration), 2) AS avg_sleep_duration
FROM health_sleep
GROUP BY age_group
ORDER BY avg_sleep_duration;

-- 7. Occupations with highest average stress levels
SELECT occupation, ROUND(AVG(stress_level), 2) AS avg_stress
FROM health_sleep
GROUP BY occupation
ORDER BY avg_stress DESC;

-- 8. Gender-wise average sleep quality
SELECT gender, ROUND(AVG(sleep_quality), 2) AS avg_sleep_quality
FROM health_sleep
GROUP BY gender;

-- 9. Count of people sleeping <6 hrs and mental health score <5
SELECT COUNT(*) AS high_risk_group
FROM health_sleep
WHERE sleep_duration < 6 AND mental_health_score < 5;

-- 10. Top 5 people with worst combined sleep & mental health
SELECT person_id, sleep_quality, mental_health_score,
       (sleep_quality + mental_health_score) AS combined_score
FROM health_sleep
ORDER BY combined_score ASC
LIMIT 5;

-- 11. Distribution of sleep quality
SELECT sleep_quality, COUNT(*) AS count_people
FROM health_sleep
GROUP BY sleep_quality
ORDER BY sleep_quality;

-- 12. Sleep quality ranks within each city
SELECT person_id, city, sleep_quality,
       RANK() OVER (PARTITION BY city ORDER BY sleep_quality DESC) AS city_rank
FROM health_sleep;

-- 13. Percentage of active people (activity ≥ 4) with good sleep (≥ 7)
SELECT
  ROUND(100 * SUM(CASE WHEN physical_activity_level >= 4 AND sleep_quality >= 7 THEN 1 ELSE 0 END) / COUNT(*), 2)
  AS percent_active_good_sleep
FROM health_sleep;

-- 14. Sleep duration category breakdown
SELECT
  CASE
    WHEN sleep_duration < 6 THEN 'Short Sleep'
    WHEN sleep_duration BETWEEN 6 AND 8 THEN 'Optimal Sleep'
    ELSE 'Long Sleep'
  END AS sleep_category,
  COUNT(*) AS count_people
FROM health_sleep
GROUP BY sleep_category;

-- 15. Average physical activity by occupation
SELECT occupation, ROUND(AVG(physical_activity_level), 2) AS avg_activity
FROM health_sleep
GROUP BY occupation
ORDER BY avg_activity DESC;

-- 16. People with low sleep (≤4) but high activity (≥4)
SELECT COUNT(*) AS unusual_case
FROM health_sleep
WHERE sleep_quality <= 4 AND physical_activity_level >= 4;

-- 17. Average mental health score per city
SELECT city, ROUND(AVG(mental_health_score), 2) AS avg_mental_score
FROM health_sleep
GROUP BY city
ORDER BY avg_mental_score DESC;

-- 18. Top 3 cities with best average sleep quality
SELECT city, ROUND(AVG(sleep_quality), 2) AS avg_sleep_quality
FROM health_sleep
GROUP BY city
ORDER BY avg_sleep_quality DESC
LIMIT 3;

-- 19. Creating view for sleep-health summary
CREATE VIEW sleep_summary AS
SELECT person_id, age, sleep_duration, sleep_quality, stress_level, mental_health_score,
       CASE
         WHEN sleep_duration < 6 THEN 'Short'
         WHEN sleep_duration BETWEEN 6 AND 8 THEN 'Optimal'
         ELSE 'Long'
       END AS sleep_type
FROM health_sleep;

-- 20. Most common stress level and its frequency
SELECT stress_level, COUNT(*) AS freq
FROM health_sleep
GROUP BY stress_level
ORDER BY freq DESC
LIMIT 1;

-- 21. People with top 10 mental health scores
SELECT person_id, mental_health_score
FROM health_sleep
ORDER BY mental_health_score DESC
LIMIT 10;

-- 22. Compare stress level between genders
SELECT gender, ROUND(AVG(stress_level), 2) AS avg_stress
FROM health_sleep
GROUP BY gender;

-- 23. Percentage of people who sleep optimally (6-8 hrs)
SELECT
  ROUND(100 * COUNT(*) FILTER (WHERE sleep_duration BETWEEN 6 AND 8) / COUNT(*), 2) AS percent_optimal_sleep
FROM health_sleep;

-- 24. Average sleep quality for each occupation
SELECT occupation, ROUND(AVG(sleep_quality), 2) AS avg_sleep_quality
FROM health_sleep
GROUP BY occupation
ORDER BY avg_sleep_quality DESC;

-- 25. People aged 30–40 with low sleep quality
SELECT person_id, age, sleep_quality
FROM health_sleep
WHERE age BETWEEN 30 AND 40 AND sleep_quality <= 4;

-- 26. Finding gender with the highest avg mental health score
SELECT gender, ROUND(AVG(mental_health_score), 2) AS avg_mental
FROM health_sleep
GROUP BY gender
ORDER BY avg_mental DESC
LIMIT 1;

-- 27. Stress level distribution by sleep type
SELECT
  CASE
    WHEN sleep_duration < 6 THEN 'Short'
    WHEN sleep_duration BETWEEN 6 AND 8 THEN 'Optimal'
    ELSE 'Long'
  END AS sleep_type,
  ROUND(AVG(stress_level), 2) AS avg_stress
FROM health_sleep
GROUP BY sleep_type;

-- 28. Median sleep duration (if supported, e.g. MySQL 8+)
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sleep_duration) AS median_sleep
FROM health_sleep;

-- 29. List of occupations with below average sleep quality
SELECT occupation
FROM health_sleep
GROUP BY occupation
HAVING AVG(sleep_quality) < (
  SELECT AVG(sleep_quality) FROM health_sleep
);

-- 30. Count of people by sleep quality and physical activity level
SELECT sleep_quality, physical_activity_level, COUNT(*) AS person_count
FROM health_sleep
GROUP BY sleep_quality, physical_activity_level
ORDER BY sleep_quality, physical_activity_level;
