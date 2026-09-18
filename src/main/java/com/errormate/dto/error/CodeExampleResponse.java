package com.errormate.dto.error;

public record CodeExampleResponse(
        String badCode,
        String goodCode,
        String explanation
) {
}
