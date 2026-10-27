package com.errormate.repository;

import com.errormate.domain.Favorite;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface FavoriteRepository extends JpaRepository<Favorite, Long> {

    List<Favorite> findByUserId(Long userId);
    // 특정 사용자의 즐겨찾기 전체 조회
    Optional<Favorite> findByUserIdAndErrorId(Long userId, Long errorId);
    // 특정 사용자가 특정 에러를 즐겨찾기 했는지 찾는 부분
    boolean existsByUserIdAndErrorId(Long userId, Long errorId);
    // 이미 즐겨찾기 되어 있는지 확인
}
