package com.errormate.dto.analysis;

public record ErrorAnalysisResponse(
        String errorName, // 에러 이름
        String location,   // 문제 위치
        String problematicCode, // 문제 코드
        String summary, // 에러 요약
        String cause,   // 에러 왜 발생했는지
        String solution // 어떻게 해결하는지
) {
}