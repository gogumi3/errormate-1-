package com.errormate.controller;

import com.errormate.dto.analysis.ErrorAnalysisRequest;
import com.errormate.dto.analysis.ErrorAnalysisResponse;
import com.errormate.service.ErrorAnalysisService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api") // 분석 주소
public class ErrorAnalysisController {

    private final ErrorAnalysisService errorAnalysisService;

    /*  post 방식으로 /analyze 주소로 오는 (에러분석)요청을 받는 부분
        그 에러 로그를 @RequestBody ErrorAnalysisRequest request 이 부분이 받음
    */

    @PostMapping("/analyze")
    public ErrorAnalysisResponse response(@RequestBody ErrorAnalysisRequest request) {
        return errorAnalysisService.analyze(request.errorLog());
    }
}
