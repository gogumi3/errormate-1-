package com.errormate.dto.error;

import com.errormate.domain.ErrorCause;
import com.errormate.domain.ErrorInfo;
import lombok.Getter;

import java.util.List;

@Getter
public class ErrorDetailResponse {

    private final Long id;
    private final String name;
    private final String language;
    private final String type;
    private final String category;
    private final String messagePattern;
    private final String description;
    private final List<String> causes;

    public ErrorDetailResponse(
            ErrorInfo errorInfo,
            List<ErrorCause> errorCauses
    ) {
        this.id = errorInfo.getId();
        this.name = errorInfo.getName();
        this.language = errorInfo.getLanguage().getName();
        this.type = errorInfo.getType();
        this.category = errorInfo.getCategory();
        this.messagePattern = errorInfo.getMessagePattern();
        this.description = errorInfo.getDescription();

        this.causes = errorCauses.stream()
                .map(ErrorCause::getCauseText)
                .toList();
    }
}
