package com.errormate.service;

import com.errormate.domain.ErrorInfo;
import com.errormate.domain.SolvedHistory;
import com.errormate.domain.User;
import com.errormate.dto.error.ErrorInfoResponse;
import com.errormate.exception.ErrorNotFoundException;
import com.errormate.repository.ErrorInfoRepository;
import com.errormate.repository.SolvedHistoryRepository;
import com.errormate.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class SolvedHistoryService {

    // 즐겨찾기랑 거의 비슷

    private final SolvedHistoryRepository solvedHistoryRepository;
    private final UserRepository userRepository;
    private final ErrorInfoRepository errorInfoRepository;

    private static final Long DEMO_USER_ID = 1L;

    @Transactional
    public void addSolved(Long errorId) {

        User user = userRepository.findById(DEMO_USER_ID)
                .orElseThrow(() ->
                        new IllegalStateException("테스트 사용자를 찾을 수 없습니다.")
                );

        ErrorInfo error = errorInfoRepository.findById(errorId)
                .orElseThrow(() ->
                        new ErrorNotFoundException("해당 에러를 찾을 수 없습니다.")
                );
        // 사용자를 먼저 찾고 사용자가 있으면 사용자가 해결했다고 누른 에러를 찾고 있는지 검사
        if (solvedHistoryRepository
                .existsByUserIdAndErrorId(DEMO_USER_ID, errorId)) {
            return;
        }

        solvedHistoryRepository.save(
                new SolvedHistory(user, error)
        );
    }

    public List<ErrorInfoResponse> getSolvedHistory() {

        return solvedHistoryRepository.findByUserId(DEMO_USER_ID)
                .stream()
                .map(history -> {

                    ErrorInfo error = history.getError();

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

    @Transactional
    public void removeSolved(Long errorId) {

        SolvedHistory history =
                solvedHistoryRepository
                        .findByUserIdAndErrorId(
                                DEMO_USER_ID,
                                errorId
                        )
                        .orElseThrow(() ->
                                new IllegalArgumentException(
                                        "해결 기록에 없는 에러입니다."
                                )
                        );

        solvedHistoryRepository.delete(history);
    }

    public boolean isSolved(Long errorId) {
        return solvedHistoryRepository
                .existsByUserIdAndErrorId(
                        DEMO_USER_ID,
                        errorId
                );
    }
}