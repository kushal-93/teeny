package dev.kushal.teeny.shared.domain;

import io.micronaut.data.annotation.*;

import java.time.Instant;

@MappedEntity("urls")
public record Url(
        @Id
        @GeneratedValue(GeneratedValue.Type.AUTO)
        Long id,

        String shortCode,
        String originalUrl,
        Long userId,
        boolean isActive,
        Instant expiresAt,

        @DateCreated
        Instant createdAt,

        @DateUpdated
        Instant updatedAt
) {}
