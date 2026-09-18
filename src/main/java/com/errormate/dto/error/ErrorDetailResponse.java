package com.errormate.dto.error;

import java.util.List;

public record ErrorDetailResponse(
        Long id,
        String name,
        String language,
        String type,
        String category,
        String messagePattern,
        String description,
        List<String> causes,
        List<String> solutions,
        List<CodeExampleResponse> codeExamples,
        List<String> similarErrors
) {
}
