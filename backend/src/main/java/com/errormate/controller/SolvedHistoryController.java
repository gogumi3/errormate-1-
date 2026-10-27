package com.errormate.controller;

import com.errormate.dto.error.ErrorInfoResponse;
import com.errormate.service.SolvedHistoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/solved")
public class SolvedHistoryController {

    private final SolvedHistoryService solvedHistoryService;

    @PostMapping("/{errorId}")
    public void addSolved(@PathVariable Long errorId) {
        solvedHistoryService.addSolved(errorId);
    }

    @GetMapping
    public List<ErrorInfoResponse> getSolvedHistory() {
        return solvedHistoryService.getSolvedHistory();
    }

    @DeleteMapping("/{errorId}")
    public void removeSolved(@PathVariable Long errorId) {
        solvedHistoryService.removeSolved(errorId);
    }

    @GetMapping("/{errorId}/check")
    public boolean isSolved(@PathVariable Long errorId) {
        return solvedHistoryService.isSolved(errorId);
    }
}