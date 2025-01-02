-- Connect to the mqconfig database
\c mqconfig;

-- Start a transaction to ensure atomicity
BEGIN;

-- Create the queues table if it doesn't exist
CREATE TABLE IF NOT EXISTS queues (
    queue_id SERIAL PRIMARY KEY,
    queue_name VARCHAR(100) UNIQUE NOT NULL, -- Unique constraint matches ON CONFLICT clause
    queue_type VARCHAR(50) NOT NULL,
    max_message_size INT NOT NULL CHECK (max_message_size > 0), -- Ensure positive size
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the messages table if it doesn't exist
CREATE TABLE IF NOT EXISTS messages (
    message_id SERIAL PRIMARY KEY,
    queue_id INT NOT NULL REFERENCES queues(queue_id) ON DELETE CASCADE, -- Cascade deletes from queues
    message_content TEXT NOT NULL,
    priority INT DEFAULT 0 CHECK (priority >= 0), -- Ensure priority is non-negative
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (queue_id, message_content) -- Unique constraint matches ON CONFLICT clause
);

-- Create the users table if it doesn't exist
CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL, -- Unique constraint matches ON CONFLICT clause
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL CHECK (role IN ('Administrator', 'User')), -- Ensure valid roles
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the system_settings table if it doesn't exist
CREATE TABLE IF NOT EXISTS system_settings (
    setting_id SERIAL PRIMARY KEY,
    setting_name VARCHAR(100) UNIQUE NOT NULL, -- Unique constraint matches ON CONFLICT clause
    setting_value TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Commit the transaction
COMMIT;

