-- Connect to the mqconfig database
\c mqconfig;

-- Verify the data inserted into each table
SELECT * FROM queues;
SELECT * FROM messages;
SELECT * FROM users;
SELECT * FROM system_settings;

