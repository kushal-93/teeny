package dev.kushal.teeny.shared.domain;


import io.micronaut.data.annotation.DateCreated;
import io.micronaut.data.annotation.GeneratedValue;
import io.micronaut.data.annotation.Id;
import io.micronaut.data.annotation.MappedEntity;

import java.time.Instant;

@MappedEntity("users")
public record User(
        @Id
        @GeneratedValue(GeneratedValue.Type.AUTO)
        Long id,

        String email,
        String passwordHash,

        @DateCreated
        Instant createdAt
) {}
