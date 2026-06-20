-- V1: Create users table
-- Users authenticate with email + password (bcrypt hashed).
-- Email is the unique login identifier — no separate username.

CREATE TABLE users
(
    id            BIGSERIAL PRIMARY KEY,
    email         VARCHAR(255)             NOT NULL,
    password_hash VARCHAR(255)             NOT NULL,
    created_at    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_users_email UNIQUE (email)
);

-- Index on email: every login does a lookup by email — this must be fast.
CREATE INDEX idx_users_email ON users (email);
