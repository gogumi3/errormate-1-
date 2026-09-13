package com.errormate.dto.error;

import com.errormate.domain.ErrorInfo;
import lombok.Getter;

@Getter
public class ErrorInfoResponse {
    private final Long id;
    private final String name;
    private final String language;
    private final String type;
    private final String category;
    private final String messagePattern;
    private final String description;

    public ErrorInfoResponse(ErrorInfo errorInfo) {     // << 불필요한 값을 제외하고 저장
                                                        // 생성자 호출 시 전체 값이 아닌 필요한 값만 전달
        this.id = errorInfo.getId();
        this.name = errorInfo.getName();
        this.language = errorInfo.getLanguage().getName();
        this.type = errorInfo.getType();
        this.category = errorInfo.getCategory();
        this.messagePattern = errorInfo.getMessagePattern();
        this.description = errorInfo.getDescription();
    }
}
