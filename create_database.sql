-- ====================================
-- OctoFit Tracker Database Creation Script
-- ====================================
-- This SQL script creates the database schema for the OctoFit Tracker application
-- A fitness tracking application for Mergington High School
-- ====================================

-- Create the database
CREATE DATABASE IF NOT EXISTS octofit_db;

-- Use the database
USE octofit_db;

-- ====================================
-- Table: users
-- Stores user profile information
-- ====================================
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    username VARCHAR(100) NOT NULL UNIQUE,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    password_hash VARCHAR(255) NOT NULL,
    date_of_birth DATE,
    height_cm DECIMAL(5,2),
    weight_kg DECIMAL(5,2),
    fitness_level ENUM('beginner', 'intermediate', 'advanced') DEFAULT 'beginner',
    team_id INT,
    total_points INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_username (username),
    INDEX idx_team_id (team_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ====================================
-- Table: teams
-- Stores team information for competitions
-- ====================================
CREATE TABLE IF NOT EXISTS teams (
    id INT AUTO_INCREMENT PRIMARY KEY,
    team_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    captain_id INT,
    total_points INT DEFAULT 0,
    member_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_team_name (team_name),
    INDEX idx_captain_id (captain_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ====================================
-- Table: activities
-- Stores different types of activities/exercises
-- ====================================
CREATE TABLE IF NOT EXISTS activities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    activity_name VARCHAR(100) NOT NULL UNIQUE,
    activity_type ENUM('running', 'walking', 'cycling', 'swimming', 'strength_training', 'yoga', 'sports', 'other') NOT NULL,
    description TEXT,
    base_points_per_minute DECIMAL(5,2) DEFAULT 1.0,
    intensity_multiplier DECIMAL(3,2) DEFAULT 1.0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_activity_type (activity_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ====================================
-- Table: workouts
-- Stores individual workout sessions logged by users
-- ====================================
CREATE TABLE IF NOT EXISTS workouts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    activity_id INT NOT NULL,
    duration_minutes INT NOT NULL,
    distance_km DECIMAL(6,2),
    calories_burned INT,
    points_earned INT DEFAULT 0,
    intensity ENUM('low', 'moderate', 'high', 'very_high') DEFAULT 'moderate',
    notes TEXT,
    workout_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_user_id (user_id),
    INDEX idx_activity_id (activity_id),
    INDEX idx_workout_date (workout_date),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (activity_id) REFERENCES activities(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ====================================
-- Table: leaderboard
-- Stores leaderboard rankings for users and teams
-- ====================================
CREATE TABLE IF NOT EXISTS leaderboard (
    id INT AUTO_INCREMENT PRIMARY KEY,
    entity_type ENUM('user', 'team') NOT NULL,
    entity_id INT NOT NULL,
    entity_name VARCHAR(100) NOT NULL,
    period_type ENUM('daily', 'weekly', 'monthly', 'all_time') NOT NULL,
    period_start_date DATE NOT NULL,
    period_end_date DATE,
    total_points INT DEFAULT 0,
    total_workouts INT DEFAULT 0,
    total_duration_minutes INT DEFAULT 0,
    rank_position INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_entity_type_id (entity_type, entity_id),
    INDEX idx_period_type (period_type),
    INDEX idx_rank_position (rank_position),
    UNIQUE KEY unique_leaderboard_entry (entity_type, entity_id, period_type, period_start_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ====================================
-- Table: achievements
-- Stores achievement badges and milestones
-- ====================================
CREATE TABLE IF NOT EXISTS achievements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    achievement_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    badge_icon VARCHAR(255),
    achievement_type ENUM('distance', 'duration', 'points', 'consistency', 'special') NOT NULL,
    threshold_value INT NOT NULL,
    points_reward INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_achievement_type (achievement_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ====================================
-- Table: user_achievements
-- Tracks which users have earned which achievements
-- ====================================
CREATE TABLE IF NOT EXISTS user_achievements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    achievement_id INT NOT NULL,
    earned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_id (user_id),
    INDEX idx_achievement_id (achievement_id),
    UNIQUE KEY unique_user_achievement (user_id, achievement_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (achievement_id) REFERENCES achievements(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ====================================
-- Add foreign key constraints
-- ====================================
ALTER TABLE users
    ADD CONSTRAINT fk_users_team
    FOREIGN KEY (team_id) REFERENCES teams(id) ON DELETE SET NULL;

ALTER TABLE teams
    ADD CONSTRAINT fk_teams_captain
    FOREIGN KEY (captain_id) REFERENCES users(id) ON DELETE SET NULL;

-- ====================================
-- Create views for common queries
-- ====================================

-- View: User Statistics
CREATE OR REPLACE VIEW user_statistics AS
SELECT 
    u.id,
    u.username,
    u.email,
    u.first_name,
    u.last_name,
    t.team_name,
    u.total_points,
    COUNT(DISTINCT w.id) as total_workouts,
    SUM(w.duration_minutes) as total_duration_minutes,
    SUM(w.distance_km) as total_distance_km,
    SUM(w.calories_burned) as total_calories_burned,
    COUNT(DISTINCT ua.achievement_id) as achievements_count
FROM users u
LEFT JOIN teams t ON u.team_id = t.id
LEFT JOIN workouts w ON u.id = w.user_id
LEFT JOIN user_achievements ua ON u.id = ua.user_id
GROUP BY u.id, u.username, u.email, u.first_name, u.last_name, t.team_name, u.total_points;

-- View: Team Rankings
CREATE OR REPLACE VIEW team_rankings AS
SELECT 
    t.id,
    t.team_name,
    t.total_points,
    t.member_count,
    COUNT(DISTINCT w.id) as total_team_workouts,
    SUM(w.duration_minutes) as total_team_duration_minutes,
    RANK() OVER (ORDER BY t.total_points DESC) as team_rank
FROM teams t
LEFT JOIN users u ON t.id = u.team_id
LEFT JOIN workouts w ON u.id = w.user_id
GROUP BY t.id, t.team_name, t.total_points, t.member_count;

-- View: Recent Activity Feed
CREATE OR REPLACE VIEW recent_activity_feed AS
SELECT 
    w.id as workout_id,
    u.username,
    u.first_name,
    u.last_name,
    a.activity_name,
    a.activity_type,
    w.duration_minutes,
    w.distance_km,
    w.points_earned,
    w.workout_date,
    w.created_at
FROM workouts w
INNER JOIN users u ON w.user_id = u.id
INNER JOIN activities a ON w.activity_id = a.id
ORDER BY w.created_at DESC;

-- ====================================
-- Insert default activity types
-- ====================================
INSERT INTO activities (activity_name, activity_type, description, base_points_per_minute, intensity_multiplier) VALUES
('Running', 'running', 'Outdoor or treadmill running', 2.0, 1.5),
('Walking', 'walking', 'Casual or brisk walking', 1.0, 1.0),
('Cycling', 'cycling', 'Road or stationary cycling', 1.8, 1.3),
('Swimming', 'swimming', 'Lap swimming or water aerobics', 2.2, 1.6),
('Strength Training', 'strength_training', 'Weight lifting or bodyweight exercises', 1.5, 1.2),
('Yoga', 'yoga', 'Various yoga practices', 1.2, 1.0),
('Basketball', 'sports', 'Basketball games or practice', 2.0, 1.4),
('Soccer', 'sports', 'Soccer games or practice', 2.1, 1.5),
('Tennis', 'sports', 'Tennis matches or practice', 1.8, 1.3),
('Jump Rope', 'other', 'Skipping rope exercises', 2.5, 1.7);

-- ====================================
-- Insert default achievements
-- ====================================
INSERT INTO achievements (achievement_name, description, achievement_type, threshold_value, points_reward) VALUES
('First Steps', 'Complete your first workout', 'special', 1, 10),
('5K Runner', 'Run a total of 5 kilometers', 'distance', 5, 25),
('Marathon Ready', 'Run a total of 42 kilometers', 'distance', 42, 100),
('Consistency King', 'Work out 7 days in a row', 'consistency', 7, 50),
('Century Club', 'Earn 100 total points', 'points', 100, 20),
('Point Master', 'Earn 1000 total points', 'points', 1000, 200),
('Time Warrior', 'Complete 10 hours of workouts', 'duration', 600, 75),
('Endurance Champion', 'Complete 50 hours of workouts', 'duration', 3000, 300);

-- ====================================
-- Database creation completed
-- ====================================
