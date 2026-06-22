-- name: GetNextSequenceVal :one
SELECT nextval('url_code_seq');

-- name: CreateUrl :one
INSERT INTO urls (short_code, original_url, user_id, expires_at)
VALUES ($1, $2, $3, $4)
RETURNING *;

-- name: GetUrlByCode :one
SELECT * FROM urls
WHERE short_code = $1 LIMIT 1;

-- name: GetActiveUrlByCode :one
SELECT * FROM urls
WHERE short_code = $1 AND is_active = TRUE AND (expires_at IS NULL OR expires_at > NOW())
LIMIT 1;

-- name: ListUrlsByUserId :many
SELECT * FROM urls
WHERE user_id = $1 AND is_active = TRUE
ORDER BY created_at DESC;

-- name: UpdateUrlIsActive :exec
UPDATE urls
SET is_active = $2, updated_at = NOW()
WHERE id = $1;

-- name: DeleteUrlByCode :exec
-- Soft delete by marking is_active = false
UPDATE urls
SET is_active = FALSE, updated_at = NOW()
WHERE short_code = $1 AND user_id = $2;
