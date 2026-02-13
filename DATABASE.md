# OctoFit Tracker Database Documentation

## Overview

This document describes the SQL database schema for the OctoFit Tracker application, a fitness tracking application for Mergington High School.

## Database Structure

The database `octofit_db` consists of the following tables:

### Core Tables

1. **users** - User profile information
   - Stores user credentials, personal information, and fitness data
   - Unique constraints on email and username
   - Links to teams

2. **teams** - Team information for competitions
   - Stores team details and statistics
   - Links to team captain (user)

3. **activities** - Activity types and exercise categories
   - Defines available workout activities
   - Includes point calculation parameters

4. **workouts** - Individual workout sessions
   - Logs user workout sessions
   - Tracks duration, distance, calories, and points

5. **leaderboard** - Rankings for users and teams
   - Stores rankings for different time periods
   - Supports daily, weekly, monthly, and all-time rankings

6. **achievements** - Achievement badges and milestones
   - Defines available achievements
   - Includes threshold values and rewards

7. **user_achievements** - User achievement tracking
   - Links users to their earned achievements

## Usage

### Creating the Database

To create the database structure, run the SQL script:

```bash
# Using MySQL command line
mysql -u root -p < create_database.sql

# Or login to MySQL and source the file
mysql -u root -p
source /path/to/create_database.sql;
```

### Database Features

#### Foreign Key Relationships

- Users can belong to teams
- Teams have captains (users)
- Workouts link to users and activities
- User achievements link users and achievements

#### Indexes

The database includes indexes on:
- Email addresses (unique)
- Usernames (unique)
- Team IDs
- Workout dates
- Leaderboard rankings

#### Views

Three views are provided for common queries:

1. **user_statistics** - Aggregated user workout statistics
2. **team_rankings** - Team rankings with workout totals
3. **recent_activity_feed** - Recent workout activity

#### Default Data

The script includes:
- 10 default activity types (running, walking, cycling, etc.)
- 8 default achievements for users to earn

## Data Model

### Entity Relationships

```
users ←→ teams (many-to-one)
users → workouts (one-to-many)
activities → workouts (one-to-many)
users ←→ achievements (many-to-many through user_achievements)
users/teams → leaderboard (referenced by entity_type and entity_id)
```

### Key Fields

#### Users
- Fitness level (beginner, intermediate, advanced)
- Total points accumulated
- Team membership

#### Workouts
- Duration in minutes
- Distance in kilometers
- Calories burned
- Points earned
- Intensity level (low, moderate, high, very_high)

#### Leaderboard
- Period types (daily, weekly, monthly, all_time)
- Rankings for both users and teams
- Workout statistics per period

## Example Queries

### Get Top 10 Users by Points

```sql
SELECT username, first_name, last_name, total_points
FROM users
WHERE is_active = TRUE
ORDER BY total_points DESC
LIMIT 10;
```

### Get Team Rankings

```sql
SELECT * FROM team_rankings
ORDER BY team_rank;
```

### Get User's Recent Workouts

```sql
SELECT w.*, a.activity_name
FROM workouts w
JOIN activities a ON w.activity_id = a.id
WHERE w.user_id = ?
ORDER BY w.workout_date DESC, w.created_at DESC
LIMIT 20;
```

### Get User Statistics

```sql
SELECT * FROM user_statistics
WHERE id = ?;
```

## Notes

- The database uses UTF-8 (utf8mb4) character encoding
- All timestamps use the server's timezone
- Cascading deletes are enabled for user-related data
- Activity types cannot be deleted if they have associated workouts (RESTRICT)

## Migration from MongoDB

This SQL schema provides an alternative to the MongoDB implementation. Key differences:

- MongoDB uses collections; SQL uses tables
- MongoDB ObjectIds map to AUTO_INCREMENT integer IDs
- MongoDB embedded documents are normalized into separate tables
- Foreign key constraints enforce referential integrity

## Database Engine

The schema uses InnoDB engine for:
- ACID compliance
- Foreign key support
- Row-level locking
- Crash recovery
