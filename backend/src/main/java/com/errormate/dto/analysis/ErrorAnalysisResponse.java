package com.errormate.dto.analysis;

public record ErrorAnalysisResponse(
        String summary, // 에러 요약
        String cause,   // 에러 왜 발생했는지
        String solution // 어떻게 해결하는지
) {
}