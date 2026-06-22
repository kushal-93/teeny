-- +goose Up
-- +goose StatementBegin
CREATE SEQUENCE url_code_seq START 100000;

CREATE TABLE urls
(
    id           BIGSERIAL PRIMARY KEY,
    short_code   VARCHAR(10)              NOT NULL,
    original_url TEXT                     NOT NULL,
    user_id      BIGINT                   NOT NULL,
    is_active    BOOLEAN                  NOT NULL DEFAULT TRUE,
    expires_at   TIMESTAMP WITH TIME ZONE,
    created_at   TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_urls_short_code UNIQUE (short_code),
    CONSTRAINT fk_urls_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);

CREATE INDEX idx_urls_short_code ON urls (short_code);
CREATE INDEX idx_urls_user_id ON urls (user_id);
CREATE INDEX idx_urls_expires_at ON urls (expires_at)
    WHERE expires_at IS NOT NULL AND is_active = TRUE;
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE IF EXISTS urls;
DROP SEQUENCE IF EXISTS url_code_seq;
-- +goose StatementEnd
