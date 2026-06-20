-- V2: Create url_code_seq sequence and urls table

-- Separate sequence for Base62 short code generation.
-- Deliberately NOT using urls.id for this — decoupling the short code from the PK
-- means we can change ID strategy later without affecting code generation.
-- Starting at 100000 so the first encoded short code is at least 4 chars (not "1", "2" etc.)
CREATE SEQUENCE url_code_seq START 100000;

CREATE TABLE urls
(
    id           BIGSERIAL PRIMARY KEY,
    short_code   VARCHAR(10)              NOT NULL,
    original_url TEXT                     NOT NULL,
    user_id      BIGINT                   NOT NULL,
    is_active    BOOLEAN                  NOT NULL DEFAULT TRUE,
    expires_at   TIMESTAMP WITH TIME ZONE,          -- NULL means never expires
    created_at   TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_urls_short_code UNIQUE (short_code),

    -- Idempotency constraint: same user submitting same URL gets the same short code back.
    -- This is enforced at the DB level (not application level) to handle race conditions.
    CONSTRAINT uq_urls_user_original UNIQUE (user_id, original_url),

    CONSTRAINT fk_urls_user FOREIGN KEY (user_id) REFERENCES users (id)
);

-- Primary read path: redirect lookup by short_code — must be as fast as possible.
CREATE INDEX idx_urls_short_code ON urls (short_code);

-- Lookup all URLs for a given user (for the metadata/management API).
CREATE INDEX idx_urls_user_id ON urls (user_id);

-- Partial index for expiry cleanup job: only index rows that have an expiry set and are active.
-- The scheduled cleanup job uses this to find expired URLs efficiently.
CREATE INDEX idx_urls_expires_at ON urls (expires_at)
    WHERE expires_at IS NOT NULL AND is_active = TRUE;
