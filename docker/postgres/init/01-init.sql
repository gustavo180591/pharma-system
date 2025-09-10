-- Create admin user with password 'admin123' (change in production!)
CREATE USER pharma_admin WITH PASSWORD 'admin123' SUPERUSER;

-- Create database
CREATE DATABASE pharma_system OWNER pharma_admin;

-- Connect to the database
\c pharma_system

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Set up permissions
GRANT ALL PRIVILEGES ON DATABASE pharma_system TO pharma_admin;

-- Create read-only user for reporting
CREATE USER pharma_reader WITH PASSWORD 'readonly123';
GRANT CONNECT ON DATABASE pharma_system TO pharma_reader;
GRANT USAGE ON SCHEMA public TO pharma_reader;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO pharma_reader;

-- Create read-write user for application
CREATE USER pharma_app WITH PASSWORD 'app123';
GRANT CONNECT ON DATABASE pharma_system TO pharma_app;
GRANT USAGE, CREATE ON SCHEMA public TO pharma_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO pharma_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO pharma_app;

-- Update the .env file with the new credentials
-- DATABASE_URL="postgresql://pharma_app:app123@localhost:5432/pharma_system?schema=public"
