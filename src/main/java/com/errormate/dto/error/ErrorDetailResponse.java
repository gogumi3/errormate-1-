package com.errormate.dto.error;

import com.errormate.domain.*;
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
    private final List<String> solutions;

    private final List<CodeExampleResponse> codeExamples;
    private final List<String> similarErrors;

    public ErrorDetailResponse(
            ErrorInfo errorInfo,
            List<ErrorCause> errorCauses,
            List<Solution> solutions,
            List<CodeExample> codeExamples,
            List<SimilarError> similarErrors

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

        this.solutions = solutions.stream()// 객체 여러개를 하나씩 꺼내서 처리할 준비
                .map(Solution::getSolutionText) // 각 객체에서 텍스트만 꺼냄
                .toList();
        // 꺼낸 문자열들을 리스트로 만듦
        this.codeExamples = codeExamples.stream()
                .map(CodeExampleResponse::new)// 문자열 하나만 뽑을 수 없기 깨문에 객체 하나를 꺼낼때마다 new CodeExampleResponse(codeExample) 작동
                .toList();

        this.similarErrors = similarErrors.stream()
                .map(similarError -> similarError.getSError().getName())
                .toList();
    }
}
