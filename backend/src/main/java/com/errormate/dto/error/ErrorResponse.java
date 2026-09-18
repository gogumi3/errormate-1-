package com.errormate.dto.error;

public record ErrorResponse(
        int status,         // http 상태 코드
        String message,      // 사용자에게 전달할 오류 설명
        String description,   // 에러 설명서
        String suggestion    // 해결 방안
) {
}
