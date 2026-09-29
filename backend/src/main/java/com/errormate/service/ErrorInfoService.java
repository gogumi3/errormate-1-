package com.errormate.service;

import com.errormate.domain.*;
import com.errormate.dto.error.CodeExampleResponse;
import com.errormate.dto.error.ErrorDetailResponse;
import com.errormate.dto.error.ErrorInfoResponse;
import com.errormate.exception.InvalidSearchKeywordException;
import com.errormate.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.errormate.exception.ErrorNotFoundException;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ErrorInfoService {

    private final ErrorInfoRepository errorInfoRepository;
    private final ErrorCauseRepository errorCauseRepository;
    private final SolutionRepository solutionRepository;
    private final CodeExampleRepository codeExampleRepository;
    private final SimilarErrorRepository similarErrorRepository;

    // 자세한 검색
    public ErrorInfoResponse findByName(String name) {
        validateSearchKeyword(name); // 공백검사
        ErrorInfo errorInfo = errorInfoRepository.findByName(name)
                .orElseThrow(() -> new ErrorNotFoundException("해당 에러를 찾을 수 없습니다."));
        // 이 메서드 호출시 errorInfoRepository.findByName() 호출 찾는 에러 없을 시 예외
        // 있을시 errorInfo 객체 반환

        return new ErrorInfoResponse(
                errorInfo.getId(),
                errorInfo.getName(),
                errorInfo.getLanguage().getName(),
                errorInfo.getType(),
                errorInfo.getCategory(),
                errorInfo.getMessagePattern(),
                errorInfo.getDescription()
        );
        // errorInfo에서 필요한 값만 꺼내 ErrorInfoResponse에 담아서 반환
    }

    // 부분 검색
    public List<ErrorInfoResponse> searchByName(String keyword) {
        validateSearchKeyword(keyword); // 공백검사
        return errorInfoRepository.findByNameContainingIgnoreCase(keyword)
                .stream() // 키워드 들어간 모든 데이트가 검색 되기 때문에 리스트로 가져옴
                .map(errorInfo -> new ErrorInfoResponse( // errorInfo 엔티티를 하나씩 ErrorInfoResponse로 변경
                        errorInfo.getId(),
                        errorInfo.getName(),
                        errorInfo.getLanguage().getName(),
                        errorInfo.getType(),
                        errorInfo.getCategory(),
                        errorInfo.getMessagePattern(),
                        errorInfo.getDescription()
                ))
                .toList();
        // 바꾼 결과들을 다시 리스트로 묶음
    }

    // 에러 ID로 에러 하나를 찾는 메서드
    public ErrorInfo findById(Long id) {
        return errorInfoRepository.findById(id)
                .orElseThrow(() -> new ErrorNotFoundException("해당 에러를 찾을 수 없습니다"));
    }

    // 특정 에러의 원인들을 찾는 메서드
    public List<ErrorCause> findCausesByErrorId(Long errorId) {
        return errorCauseRepository.findByErrorId(errorId);
    }

    // 에러 하나의 상세정보 전체
    public ErrorDetailResponse findDetailById(Long id) {
        ErrorInfo errorInfo = errorInfoRepository.findById(id)
                .orElseThrow(() -> new ErrorNotFoundException("해당 에러를 찾을 수 없습니다."));

        List<String> causes = errorCauseRepository.findByErrorId(id)
                .stream() // 여러개의 원인을 하나씩 처리
                .map(errorCause -> errorCause.getCauseText())// 각 객체에서 causeText 만 꺼냄
                .toList();                  // 모아서 리스트로 다시 묶기

        List<String> solutions = solutionRepository.findByErrorId(id)
                .stream()// 여러개의 해결책을 하나씩 처리
                .map(solution -> solution.getSolutionText())// 각 해결책에서 solutionText 만 꺼냄
                .toList();                  // 모아서 리스트로 다시 묶기

        List<CodeExampleResponse> codeExamples = codeExampleRepository.findByErrorId(id)
                .stream()// 여러 개의 코드 예제를 하나씩 처리
                .map(codeExample -> new CodeExampleResponse( // 각 엔티티를 새로운 DTO로 변환
                        codeExample.getBadCode(), // 잘못된 코드
                        codeExample.getGoodCode(), // 수정된 코드
                        codeExample.getExplanation()    // 왜 그렇게 수정했는지에 대한 설명
                ))
                .toList();  // 모아서 리스트로 묶기

        List<String> similarErrors = similarErrorRepository.findByErrorId(id)
                .stream()
                .map(similarError -> similarError.getSError().getName())// similarError.getSError() 로 연결된 다른 여러 객체를 가져옴
                .toList();

        return new ErrorDetailResponse( // 지금까지 따로 가져온 정보를 하나의 상세조회로 묶음
                errorInfo.getId(),
                errorInfo.getName(),
                errorInfo.getLanguage().getName(),
                errorInfo.getType(),
                errorInfo.getCategory(),
                errorInfo.getMessagePattern(),
                errorInfo.getDescription(),
                causes,
                solutions,
                codeExamples,
                similarErrors
        );
    }

    // 공백검사
    public void validateSearchKeyword(String keyword) {
        if (keyword == null || keyword.isBlank()) {
            throw new InvalidSearchKeywordException(
                    "검색어를 입력해 주세요."
            );
        }
    }


}
