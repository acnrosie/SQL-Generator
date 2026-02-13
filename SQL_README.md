# OctoFit Tracker SQL Database

## Overview

This repository contains SQL scripts for creating and populating the OctoFit Tracker database - a fitness tracking application for Mergington High School.

## Files

- **`create_database.sql`** - Main database schema creation script
- **`sample_data.sql`** - Sample data with superhero-themed test users (Marvel vs DC teams)
- **`DATABASE.md`** - Detailed database documentation

## Quick Start

### Prerequisites

- MySQL 5.7+ or MariaDB 10.2+
- Database access with CREATE DATABASE privileges

### Installation

1. **Create the Database Structure**
   ```bash
   mysql -u root -p < create_database.sql
   ```

2. **Load Sample Data (Optional)**
   ```bash
   mysql -u root -p < sample_data.sql
   ```

### What Gets Created

#### Database: `octofit_db`

**Tables:**
- `users` - User profiles and credentials
- `teams` - Team information (Team Marvel, Team DC)
- `activities` - Workout activity types
- `workouts` - Individual workout sessions
- `leaderboard` - Rankings by period
- `achievements` - Available badges/milestones
- `user_achievements` - User-earned achievements

**Views:**
- `user_statistics` - Aggregated user stats
- `team_rankings` - Team leaderboard
- `recent_activity_feed` - Recent workout activity

**Default Data:**
- 10 Activity types (running, swimming, strength training, etc.)
- 8 Achievement badges

## Sample Data

The sample data includes:

### Teams (2)
- **Team Marvel** - Earth's Mightiest Heroes
- **Team DC** - Justice League of Fitness

### Users (12)
**Team Marvel:**
- Spider-Man (Peter Parker)
- Iron Man (Tony Stark)
- Captain America (Steve Rogers)
- Black Widow (Natasha Romanoff)
- Hulk (Bruce Banner)
- Thor (Thor Odinson)

**Team DC:**
- Superman (Clark Kent)
- Batman (Bruce Wayne)
- Wonder Woman (Diana Prince)
- Flash (Barry Allen)
- Aquaman (Arthur Curry)
- Green Lantern (Hal Jordan)

### Workouts (23)
Each hero has 2-3 sample workouts demonstrating different activity types.

### Achievements (16 awarded)
Users automatically earn achievements based on their activity.

## Example Queries

### Get Top Users
```sql
USE octofit_db;
SELECT username, first_name, last_name, total_points
FROM users
ORDER BY total_points DESC
LIMIT 10;
```

### View Team Rankings
```sql
SELECT * FROM team_rankings
ORDER BY team_rank;
```

### Get User's Workout History
```sql
SELECT w.*, a.activity_name
FROM workouts w
JOIN activities a ON w.activity_id = a.id
WHERE w.user_id = 1
ORDER BY w.workout_date DESC;
```

### Recent Activity Feed
```sql
SELECT * FROM recent_activity_feed
LIMIT 20;
```

### User Statistics
```sql
SELECT * FROM user_statistics
WHERE username = 'captain_america';
```

## Database Features

### Constraints
- Unique email addresses
- Unique usernames
- Foreign key relationships with referential integrity
- Cascading deletes for user data
- Restricted deletes for activity types

### Indexes
- Email and username lookups
- Team membership
- Workout date ranges
- Leaderboard rankings

### Auto-calculated Fields
- User total points (from workouts)
- Team total points (from user points)
- Leaderboard rankings
- Workout statistics

## Testing the Database

After loading the data, verify it's working:

```bash
# Check table counts
mysql -u root -p octofit_db -e "
SELECT 'Teams' as entity, COUNT(*) as count FROM teams
UNION ALL
SELECT 'Users', COUNT(*) FROM users
UNION ALL
SELECT 'Workouts', COUNT(*) FROM workouts
UNION ALL
SELECT 'Achievements', COUNT(*) FROM user_achievements;
"
```

Expected output:
```
+-------------+-------+
| entity      | count |
+-------------+-------+
| Teams       |     2 |
| Users       |    12 |
| Workouts    |    23 |
| Achievements|    16 |
+-------------+-------+
```

## Technology Stack

- **Database:** MySQL 8.0+ (InnoDB engine)
- **Character Set:** UTF-8 (utf8mb4)
- **Collation:** utf8mb4_unicode_ci

## Application Integration

This SQL database can be used as an alternative to MongoDB for the OctoFit Tracker application. The schema is designed to work with:

- Django ORM (via mysqlclient or PyMySQL)
- Node.js (via mysql2 or Sequelize)
- Any MySQL-compatible ORM

## Development vs Production

### Development
The sample data is perfect for:
- Testing application features
- Demonstrating leaderboard functionality
- UI/UX prototyping
- API endpoint testing

### Production
For production use:
1. Run only `create_database.sql`
2. Skip `sample_data.sql`
3. Set up proper user authentication
4. Configure appropriate database permissions
5. Enable SSL connections
6. Set up regular backups

## Troubleshooting

### Permission Errors
```bash
# Grant privileges to a user
mysql -u root -p -e "
GRANT ALL PRIVILEGES ON octofit_db.* TO 'your_user'@'localhost';
FLUSH PRIVILEGES;
"
```

### Reset Database
```bash
mysql -u root -p -e "DROP DATABASE IF EXISTS octofit_db;"
mysql -u root -p < create_database.sql
mysql -u root -p < sample_data.sql
```

### Check Database Size
```sql
SELECT 
    table_schema AS 'Database',
    ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS 'Size (MB)'
FROM information_schema.tables
WHERE table_schema = 'octofit_db'
GROUP BY table_schema;
```

## License

This project is part of the OctoFit Tracker application, licensed under the MIT License.

## Contributing

When adding new features:
1. Update the schema in `create_database.sql`
2. Add corresponding sample data in `sample_data.sql`
3. Update documentation in `DATABASE.md`
4. Test all changes locally before committing

## Support

For issues or questions:
- Check `DATABASE.md` for detailed schema documentation
- Review example queries above
- Test with the provided sample data

---

**Note:** This database schema supports the OctoFit Tracker fitness tracking application for Mergington High School.
