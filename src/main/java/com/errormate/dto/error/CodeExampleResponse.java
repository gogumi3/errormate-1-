package com.errormate.dto.error;

import com.errormate.domain.CodeExample;
import lombok.Getter;

@Getter
public class CodeExampleResponse {

    private final String badCode;
    private final String goodCode;
    private final String explanation;

    public CodeExampleResponse(CodeExample codeExample) {
        this.badCode = codeExample.getBadCode();
        this.goodCode = codeExample.getGoodCode();
        this.explanation = codeExample.getExplanation();
    }
}
