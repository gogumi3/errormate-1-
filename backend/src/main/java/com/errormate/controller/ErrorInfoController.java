package com.errormate.controller;

import com.errormate.dto.error.ErrorDetailResponse;
import com.errormate.dto.error.ErrorInfoResponse;
import com.errormate.service.ErrorInfoService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/errors")
public class ErrorInfoController {

    private final ErrorInfoService errorInfoService;

    // 정확한 이름 검색
    @GetMapping("/search")
    public ErrorInfoResponse search(@RequestParam String name) {
        return errorInfoService.findByName(name);
        // 메서드 호출시 errorInfoService.findByName() (호출 name 변수 담아서)
    }

    // 부분 검색
    @GetMapping("/search/partial")
    public List<ErrorInfoResponse> searchPartial(@RequestParam String keyword) {
        return errorInfoService.searchByName(keyword);
        // 메서드 호출시 errorInfoService.searchByName() (호출 keyword 변수 담아서)
    }

    // 선택한 에러의 상세 정보 조회
    @GetMapping("/{id}")
    public ErrorDetailResponse findById(@PathVariable Long id) {
        return errorInfoService.findDetailById(id);
        // 메서드 호출시 errorInfoService.findDetailById() (호출 id 변수 담아서)
    }
}
