package com.errormate.service;

import com.errormate.domain.ErrorInfo;
import com.errormate.domain.Favorite;
import com.errormate.domain.User;
import com.errormate.dto.error.ErrorInfoResponse;
import com.errormate.exception.ErrorNotFoundException;
import com.errormate.repository.ErrorInfoRepository;
import com.errormate.repository.FavoriteRepository;
import com.errormate.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class FavoriteService {

    private final FavoriteRepository favoriteRepository;
    private final UserRepository userRepository;
    private final ErrorInfoRepository errorInfoRepository;

    // 로그인 구현 전까지 사용할 임시 사용자
    private static final Long DEMO_USER_ID = 1L;

    // 즐겨찾기 추가
    @Transactional
    public void addFavorite(Long errorId) {
        User user = userRepository.findById(DEMO_USER_ID)
                .orElseThrow(() -> new IllegalStateException("테스트 사용자를 찾을 수 없습니다."));
        // ex) user_id 가 들어와서 있는지 확인

        ErrorInfo error = errorInfoRepository.findById(errorId)
                .orElseThrow(() -> new ErrorNotFoundException("해당 에러를 찾을 수 없습니다."));
        // ex) user가 존재하면 Long errorId 여기로 들어온 에러가 있는지 확인

        // 이미 즐겨찾기 되어 있으면 또 저장하지 않음
        if (favoriteRepository.existsByUserIdAndErrorId(DEMO_USER_ID, errorId)) {
            return;
        }

        Favorite favorite = new Favorite(user, error);
        // ex) 즐겨찾기가 안되어 있으면 등록

        favoriteRepository.save(favorite);
        // DB테이블에 저장
    }

    // 내 즐겨찾기 전체 조회
    public List<ErrorInfoResponse> getFavorites() {

        return favoriteRepository.findByUserId(DEMO_USER_ID)
                .stream()
                .map(favorite -> {
                    ErrorInfo error = favorite.getError();

                    return new ErrorInfoResponse(
                            error.getId(),
                            error.getName(),
                            error.getLanguage().getName(),
                            error.getType(),
                            error.getCategory(),
                            error.getMessagePattern(),
                            error.getDescription()
                    );
                })
                .toList();
    }

    // 즐겨찾기 삭제
    @Transactional
    public void removeFavorite(Long errorId) {

        Favorite favorite = favoriteRepository
                .findByUserIdAndErrorId(DEMO_USER_ID, errorId)
                .orElseThrow(() ->
                        new IllegalArgumentException("즐겨찾기에 등록되지 않은 에러입니다.")
                );

        favoriteRepository.delete(favorite);
    }

    // 현재 즐겨찾기인지 확인
    public boolean isFavorite(Long errorId) {
        return favoriteRepository.existsByUserIdAndErrorId(
                DEMO_USER_ID,
                errorId
        );
    }
}