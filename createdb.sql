-- Connect to the default PostgreSQL database
\c postgres;

-- Check if the mqconfig database exists and create it if necessary
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_database WHERE datname = 'mqconfig') THEN
        CREATE DATABASE mqconfig;
    END IF;
END $$;

