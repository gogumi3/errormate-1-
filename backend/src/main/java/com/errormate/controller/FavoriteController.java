package com.errormate.controller;

import com.errormate.dto.error.ErrorInfoResponse;
import com.errormate.service.FavoriteService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/favorites")
public class FavoriteController {

    private final FavoriteService favoriteService;

    // 즐겨찾기 추가
    @PostMapping("/{errorId}")
    public void addFavorite(@PathVariable Long errorId) {
        favoriteService.addFavorite(errorId);
    }

    // 즐겨찾기 전체 조회
    @GetMapping
    public List<ErrorInfoResponse> getFavorites() {
        return favoriteService.getFavorites();
    }

    // 즐겨찾기 삭제
    @DeleteMapping("/{errorId}")
    public void removeFavorite(@PathVariable Long errorId) {
        favoriteService.removeFavorite(errorId);
    }

    // 특정 에러가 즐겨찾기인지 확인
    @GetMapping("/{errorId}/check")
    public boolean isFavorite(@PathVariable Long errorId) {
        return favoriteService.isFavorite(errorId);
    }
}