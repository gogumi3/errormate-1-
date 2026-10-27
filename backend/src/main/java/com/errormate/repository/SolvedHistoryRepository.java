package com.errormate.repository;

import com.errormate.domain.SolvedHistory;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface SolvedHistoryRepository
        extends JpaRepository<SolvedHistory, Long> {

    List<SolvedHistory> findByUserId(Long userId);
    // 해결 기록 가져오기
    Optional<SolvedHistory> findByUserIdAndErrorId(
            Long userId,
            Long errorId
    );
    // 특정 사용자가 특정 에러를 해결기록에 넣었는지 찾기

    boolean existsByUserIdAndErrorId(
            Long userId,
            Long errorId
    );
    // 있는지 없는지 검사
}