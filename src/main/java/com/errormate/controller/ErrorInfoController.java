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

    @GetMapping("/search")
    public ErrorInfoResponse search(@RequestParam String name) {
        return errorInfoService.findByName(name);
    }

    @GetMapping("/search/partial")
    public List<ErrorInfoResponse> searchPartial(@RequestParam String keyword) {
        return errorInfoService.searchByName(keyword);
    }

    @GetMapping("/{id}")
    public ErrorDetailResponse findById(@PathVariable Long id) {
        return errorInfoService.findDetailById(id);
    }
}
