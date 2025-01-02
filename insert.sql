-- Connect to the mqconfig database
\c mqconfig;

-- Start a transaction to ensure atomicity
BEGIN;

-- Insert data into the queues table
INSERT INTO queues (queue_name, queue_type, max_message_size)
SELECT 'QueueA', 'Standard', 1024
WHERE NOT EXISTS (SELECT 1 FROM queues WHERE queue_name = 'QueueA');

INSERT INTO queues (queue_name, queue_type, max_message_size)
SELECT 'QueueB', 'FIFO', 2048
WHERE NOT EXISTS (SELECT 1 FROM queues WHERE queue_name = 'QueueB');

INSERT INTO queues (queue_name, queue_type, max_message_size)
SELECT 'QueueC', 'Standard', 512
WHERE NOT EXISTS (SELECT 1 FROM queues WHERE queue_name = 'QueueC');

-- Insert data into the messages table with conflict handling
INSERT INTO messages (queue_id, message_content, priority)
SELECT q.queue_id, 'Message 1 for QueueA', 1
FROM queues q WHERE q.queue_name = 'QueueA'
ON CONFLICT (queue_id, message_content) DO NOTHING;

INSERT INTO messages (queue_id, message_content, priority)
SELECT q.queue_id, 'Message 1 for QueueB', 1
FROM queues q WHERE q.queue_name = 'QueueB'
ON CONFLICT (queue_id, message_content) DO NOTHING;

-- Insert data into the users table with conflict handling
INSERT INTO users (username, password_hash, role)
VALUES
    ('admin', 'hash_of_password_1', 'Administrator'),
    ('user1', 'hash_of_password_2', 'User'),
    ('user2', 'hash_of_password_3', 'User')
ON CONFLICT (username) DO NOTHING;

-- Insert data into the system_settings table with conflict handling
INSERT INTO system_settings (setting_name, setting_value)
VALUES
    ('max_connections', '100'),
    ('timeout', '30'),
    ('maintenance_mode', 'false')
ON CONFLICT (setting_name) DO NOTHING;

-- Commit the transaction
COMMIT;

