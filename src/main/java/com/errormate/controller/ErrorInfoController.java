package com.errormate.controller;

import com.errormate.domain.ErrorInfo;
import com.errormate.dto.error.ErrorDetailResponse;
import com.errormate.dto.error.ErrorInfoResponse;
import com.errormate.service.ErrorInfoService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequiredArgsConstructor
public class ErrorInfoController {

    private final ErrorInfoService errorInfoService;
    // 컨트롤러로 입력한 값이 들어오면 서비스 쪽으로 보내기 위해 변수 생성
                                            // 정확한 이름으로 하나 찾기
    @GetMapping("/errors/search")           // << URL 로 검색이 들어오면
    public ErrorInfoResponse search(@RequestParam String name) {
                                            // << 여기서 name 변수로 받음
        ErrorInfo errorInfo =
                errorInfoService.findByName(name);
        // 서비스의 name로 조회하는 기능을 errorInfo로 저장

        return new ErrorInfoResponse(errorInfo);
    }

    @GetMapping("/errors/search/partial")   // << 일부 글자로 여러 개 찾기
    public List<ErrorInfoResponse> searchPartial(@RequestParam String keyword) {
        List<ErrorInfo> errorInfos = errorInfoService.searchByName(keyword);

        List<ErrorInfoResponse> responses = new ArrayList<>();

        for (ErrorInfo errorInfo : errorInfos) {
            responses.add(new ErrorInfoResponse(errorInfo));
        }

        return responses;
    }

    @GetMapping("/errors/{id}")     // 선택한 에러 하나의 상세정보 보기
    public ErrorDetailResponse findById(@PathVariable Long id) {

        return errorInfoService.findDetailById(id);
    }
}
