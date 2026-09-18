package com.errormate.dto.error;

public record ErrorInfoResponse(
        Long id,
        String name,
        String language,
        String type,
        String category,
        String messagePattern,
        String description
) {
}
