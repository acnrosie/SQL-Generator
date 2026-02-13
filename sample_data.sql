-- ====================================
-- OctoFit Tracker Sample Data Script
-- ====================================
-- This script populates the database with sample superhero-themed test data
-- Teams: Marvel and DC
-- ====================================

USE octofit_db;

-- ====================================
-- Insert Teams
-- ====================================
INSERT INTO teams (team_name, description, total_points, member_count) VALUES
('Team Marvel', 'Earth''s Mightiest Heroes - Fighting for fitness!', 0, 0),
('Team DC', 'Justice League of Fitness - Saving the day one workout at a time!', 0, 0);

-- ====================================
-- Insert Users (Marvel Heroes)
-- ====================================
INSERT INTO users (email, username, first_name, last_name, password_hash, date_of_birth, height_cm, weight_kg, fitness_level, team_id, total_points) VALUES
('peter.parker@marvel.com', 'spiderman', 'Peter', 'Parker', '$2b$12$dummy_hash_1', '2008-08-10', 175.26, 74.84, 'advanced', 1, 850),
('tony.stark@marvel.com', 'ironman', 'Tony', 'Stark', '$2b$12$dummy_hash_2', '1970-05-29', 185.42, 102.06, 'intermediate', 1, 720),
('steve.rogers@marvel.com', 'captain_america', 'Steve', 'Rogers', '$2b$12$dummy_hash_3', '1918-07-04', 188.00, 109.00, 'advanced', 1, 1200),
('natasha.romanoff@marvel.com', 'black_widow', 'Natasha', 'Romanoff', '$2b$12$dummy_hash_4', '1984-11-22', 170.18, 59.42, 'advanced', 1, 980),
('bruce.banner@marvel.com', 'hulk', 'Bruce', 'Banner', '$2b$12$dummy_hash_5', '1969-12-18', 175.26, 58.97, 'intermediate', 1, 450),
('thor.odinson@marvel.com', 'thor', 'Thor', 'Odinson', '$2b$12$dummy_hash_6', '0965-01-01', 198.12, 290.30, 'advanced', 1, 1150);

-- ====================================
-- Insert Users (DC Heroes)
-- ====================================
INSERT INTO users (email, username, first_name, last_name, password_hash, date_of_birth, height_cm, weight_kg, fitness_level, team_id, total_points) VALUES
('clark.kent@dc.com', 'superman', 'Clark', 'Kent', '$2b$12$dummy_hash_7', '1986-06-18', 190.50, 106.59, 'advanced', 2, 1300),
('bruce.wayne@dc.com', 'batman', 'Bruce', 'Wayne', '$2b$12$dummy_hash_8', '1982-02-19', 188.00, 95.25, 'advanced', 2, 1100),
('diana.prince@dc.com', 'wonder_woman', 'Diana', 'Prince', '$2b$12$dummy_hash_9', '1200-10-15', 183.00, 75.00, 'advanced', 2, 1050),
('barry.allen@dc.com', 'flash', 'Barry', 'Allen', '$2b$12$dummy_hash_10', '1989-03-14', 183.00, 81.65, 'advanced', 2, 1250),
('arthur.curry@dc.com', 'aquaman', 'Arthur', 'Curry', '$2b$12$dummy_hash_11', '1986-01-29', 185.42, 147.42, 'advanced', 2, 890),
('hal.jordan@dc.com', 'green_lantern', 'Hal', 'Jordan', '$2b$12$dummy_hash_12', '1985-02-20', 188.00, 90.72, 'intermediate', 2, 670);

-- ====================================
-- Update team captains and member counts
-- ====================================
UPDATE teams SET captain_id = (SELECT id FROM users WHERE username = 'captain_america'), member_count = 6 WHERE team_name = 'Team Marvel';
UPDATE teams SET captain_id = (SELECT id FROM users WHERE username = 'superman'), member_count = 6 WHERE team_name = 'Team DC';

-- ====================================
-- Insert Sample Workouts (Marvel Team)
-- ====================================
-- Spider-Man's workouts
INSERT INTO workouts (user_id, activity_id, duration_minutes, distance_km, calories_burned, points_earned, intensity, notes, workout_date) VALUES
((SELECT id FROM users WHERE username = 'spiderman'), (SELECT id FROM activities WHERE activity_name = 'Running'), 45, 8.5, 520, 135, 'high', 'Web-slinging practice through the city', '2026-02-10'),
((SELECT id FROM users WHERE username = 'spiderman'), (SELECT id FROM activities WHERE activity_name = 'Strength Training'), 60, NULL, 450, 108, 'very_high', 'Upper body workout for web-shooting', '2026-02-11'),
((SELECT id FROM users WHERE username = 'spiderman'), (SELECT id FROM activities WHERE activity_name = 'Jump Rope'), 20, NULL, 280, 85, 'very_high', 'Agility training', '2026-02-12');

-- Captain America's workouts
INSERT INTO workouts (user_id, activity_id, duration_minutes, distance_km, calories_burned, points_earned, intensity, notes, workout_date) VALUES
((SELECT id FROM users WHERE username = 'captain_america'), (SELECT id FROM activities WHERE activity_name = 'Running'), 60, 12.0, 720, 180, 'very_high', 'Morning super soldier run', '2026-02-10'),
((SELECT id FROM users WHERE username = 'captain_america'), (SELECT id FROM activities WHERE activity_name = 'Strength Training'), 90, NULL, 680, 162, 'very_high', 'Shield training exercises', '2026-02-11'),
((SELECT id FROM users WHERE username = 'captain_america'), (SELECT id FROM activities WHERE activity_name = 'Basketball'), 45, NULL, 510, 126, 'high', 'Team sports for strategy', '2026-02-12');

-- Black Widow's workouts
INSERT INTO workouts (user_id, activity_id, duration_minutes, distance_km, calories_burned, points_earned, intensity, notes, workout_date) VALUES
((SELECT id FROM users WHERE username = 'black_widow'), (SELECT id FROM activities WHERE activity_name = 'Running'), 40, 7.5, 460, 120, 'high', 'Stealth cardio training', '2026-02-10'),
((SELECT id FROM users WHERE username = 'black_widow'), (SELECT id FROM activities WHERE activity_name = 'Yoga'), 60, NULL, 220, 72, 'moderate', 'Flexibility and balance', '2026-02-11'),
((SELECT id FROM users WHERE username = 'black_widow'), (SELECT id FROM activities WHERE activity_name = 'Strength Training'), 50, NULL, 380, 90, 'high', 'Combat conditioning', '2026-02-12');

-- Thor's workouts
INSERT INTO workouts (user_id, activity_id, duration_minutes, distance_km, calories_burned, points_earned, intensity, notes, workout_date) VALUES
((SELECT id FROM users WHERE username = 'thor'), (SELECT id FROM activities WHERE activity_name = 'Strength Training'), 120, NULL, 920, 216, 'very_high', 'Asgardian hammer training', '2026-02-10'),
((SELECT id FROM users WHERE username = 'thor'), (SELECT id FROM activities WHERE activity_name = 'Running'), 30, 6.0, 420, 90, 'high', 'Thunder god sprint', '2026-02-11');

-- ====================================
-- Insert Sample Workouts (DC Team)
-- ====================================
-- Superman's workouts
INSERT INTO workouts (user_id, activity_id, duration_minutes, distance_km, calories_burned, points_earned, intensity, notes, workout_date) VALUES
((SELECT id FROM users WHERE username = 'superman'), (SELECT id FROM activities WHERE activity_name = 'Running'), 30, 15.0, 550, 90, 'very_high', 'Faster than a speeding bullet training', '2026-02-10'),
((SELECT id FROM users WHERE username = 'superman'), (SELECT id FROM activities WHERE activity_name = 'Strength Training'), 120, NULL, 950, 216, 'very_high', 'Kryptonian strength maintenance', '2026-02-11'),
((SELECT id FROM users WHERE username = 'superman'), (SELECT id FROM activities WHERE activity_name = 'Swimming'), 45, NULL, 580, 149, 'very_high', 'Underwater rescue practice', '2026-02-12');

-- Batman's workouts
INSERT INTO workouts (user_id, activity_id, duration_minutes, distance_km, calories_burned, points_earned, intensity, notes, workout_date) VALUES
((SELECT id FROM users WHERE username = 'batman'), (SELECT id FROM activities WHERE activity_name = 'Running'), 50, 9.5, 600, 150, 'high', 'Gotham rooftop patrol simulation', '2026-02-10'),
((SELECT id FROM users WHERE username = 'batman'), (SELECT id FROM activities WHERE activity_name = 'Strength Training'), 75, NULL, 570, 135, 'very_high', 'Batcave workout routine', '2026-02-11'),
((SELECT id FROM users WHERE username = 'batman'), (SELECT id FROM activities WHERE activity_name = 'Cycling'), 40, 25.0, 520, 104, 'high', 'Batmobile backup cardio', '2026-02-12');

-- Flash's workouts
INSERT INTO workouts (user_id, activity_id, duration_minutes, distance_km, calories_burned, points_earned, intensity, notes, workout_date) VALUES
((SELECT id FROM users WHERE username = 'flash'), (SELECT id FROM activities WHERE activity_name = 'Running'), 20, 50.0, 800, 60, 'very_high', 'Speed force sprint intervals', '2026-02-10'),
((SELECT id FROM users WHERE username = 'flash'), (SELECT id FROM activities WHERE activity_name = 'Running'), 25, 55.0, 850, 75, 'very_high', 'Time travel cardio session', '2026-02-11'),
((SELECT id FROM users WHERE username = 'flash'), (SELECT id FROM activities WHERE activity_name = 'Jump Rope'), 15, NULL, 260, 64, 'very_high', 'Quick feet training', '2026-02-12');

-- Wonder Woman's workouts
INSERT INTO workouts (user_id, activity_id, duration_minutes, distance_km, calories_burned, points_earned, intensity, notes, workout_date) VALUES
((SELECT id FROM users WHERE username = 'wonder_woman'), (SELECT id FROM activities WHERE activity_name = 'Strength Training'), 80, NULL, 620, 144, 'very_high', 'Amazon warrior training', '2026-02-10'),
((SELECT id FROM users WHERE username = 'wonder_woman'), (SELECT id FROM activities WHERE activity_name = 'Running'), 45, 9.0, 530, 135, 'high', 'Themyscira sprint drills', '2026-02-11'),
((SELECT id FROM users WHERE username = 'wonder_woman'), (SELECT id FROM activities WHERE activity_name = 'Yoga'), 50, NULL, 200, 60, 'moderate', 'Warrior meditation and flexibility', '2026-02-12');

-- ====================================
-- Update user total points based on workouts
-- ====================================
UPDATE users u
SET total_points = (
    SELECT COALESCE(SUM(w.points_earned), 0)
    FROM workouts w
    WHERE w.user_id = u.id
);

-- ====================================
-- Update team total points based on member workouts
-- ====================================
UPDATE teams t
SET total_points = (
    SELECT COALESCE(SUM(u.total_points), 0)
    FROM users u
    WHERE u.team_id = t.id
);

-- ====================================
-- Insert Leaderboard entries for current week
-- ====================================
-- User leaderboard
INSERT INTO leaderboard (entity_type, entity_id, entity_name, period_type, period_start_date, period_end_date, total_points, total_workouts, total_duration_minutes, rank_position)
SELECT 
    'user' as entity_type,
    u.id as entity_id,
    u.username as entity_name,
    'weekly' as period_type,
    DATE_SUB(CURDATE(), INTERVAL DAYOFWEEK(CURDATE())-1 DAY) as period_start_date,
    DATE_ADD(DATE_SUB(CURDATE(), INTERVAL DAYOFWEEK(CURDATE())-1 DAY), INTERVAL 6 DAY) as period_end_date,
    COALESCE(SUM(w.points_earned), 0) as total_points,
    COUNT(w.id) as total_workouts,
    COALESCE(SUM(w.duration_minutes), 0) as total_duration_minutes,
    RANK() OVER (ORDER BY COALESCE(SUM(w.points_earned), 0) DESC) as rank_position
FROM users u
LEFT JOIN workouts w ON u.id = w.user_id AND w.workout_date >= DATE_SUB(CURDATE(), INTERVAL DAYOFWEEK(CURDATE())-1 DAY)
GROUP BY u.id, u.username;

-- Team leaderboard
INSERT INTO leaderboard (entity_type, entity_id, entity_name, period_type, period_start_date, period_end_date, total_points, total_workouts, total_duration_minutes, rank_position)
SELECT 
    'team' as entity_type,
    t.id as entity_id,
    t.team_name as entity_name,
    'weekly' as period_type,
    DATE_SUB(CURDATE(), INTERVAL DAYOFWEEK(CURDATE())-1 DAY) as period_start_date,
    DATE_ADD(DATE_SUB(CURDATE(), INTERVAL DAYOFWEEK(CURDATE())-1 DAY), INTERVAL 6 DAY) as period_end_date,
    COALESCE(SUM(w.points_earned), 0) as total_points,
    COUNT(w.id) as total_workouts,
    COALESCE(SUM(w.duration_minutes), 0) as total_duration_minutes,
    RANK() OVER (ORDER BY COALESCE(SUM(w.points_earned), 0) DESC) as rank_position
FROM teams t
LEFT JOIN users u ON t.id = u.team_id
LEFT JOIN workouts w ON u.id = w.user_id AND w.workout_date >= DATE_SUB(CURDATE(), INTERVAL DAYOFWEEK(CURDATE())-1 DAY)
GROUP BY t.id, t.team_name;

-- ====================================
-- Award some achievements
-- ====================================
-- First Steps achievement for all users who have workouts
INSERT INTO user_achievements (user_id, achievement_id)
SELECT DISTINCT u.id, a.id
FROM users u
JOIN workouts w ON u.id = w.user_id
CROSS JOIN achievements a
WHERE a.achievement_name = 'First Steps';

-- Century Club for users with 100+ points
INSERT INTO user_achievements (user_id, achievement_id)
SELECT u.id, a.id
FROM users u
CROSS JOIN achievements a
WHERE u.total_points >= 100 
  AND a.achievement_name = 'Century Club';

-- Point Master for users with 1000+ points
INSERT INTO user_achievements (user_id, achievement_id)
SELECT u.id, a.id
FROM users u
CROSS JOIN achievements a
WHERE u.total_points >= 1000 
  AND a.achievement_name = 'Point Master';

-- ====================================
-- Sample data insertion completed
-- ====================================

-- Display summary
SELECT 'Data insertion complete!' as status;
SELECT 'Teams created:' as info, COUNT(*) as count FROM teams;
SELECT 'Users created:' as info, COUNT(*) as count FROM users;
SELECT 'Workouts logged:' as info, COUNT(*) as count FROM workouts;
SELECT 'Achievements awarded:' as info, COUNT(*) as count FROM user_achievements;
