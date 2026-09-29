package com.errormate.service;

import com.errormate.dto.analysis.ErrorAnalysisResponse;
import org.springframework.stereotype.Service;

@Service
public class ErrorAnalysisService {

    /*
        컨트롤러가 String 형태의 에러 로그를 Service에게 넘기면
        Service가 처리하고 ErrorAnalysisResponse 형태로 결과를 돌려줌
     */
    public ErrorAnalysisResponse analyze(String errorLog) {

        // ai 연결 전이라 임시 글
        return new ErrorAnalysisResponse(
                "Analysis ready",
                "AI is not connected yet",
                "Connect AI API next"
        );
    }
}
