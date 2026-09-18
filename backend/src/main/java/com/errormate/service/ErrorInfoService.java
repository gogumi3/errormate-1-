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

    public ErrorInfoResponse findByName(String name) {
        validateSearchKeyword(name);
        ErrorInfo errorInfo = errorInfoRepository.findByName(name)
                .orElseThrow(() -> new ErrorNotFoundException("해당 에러를 찾을 수 없습니다."));

        return new ErrorInfoResponse(
                errorInfo.getId(),
                errorInfo.getName(),
                errorInfo.getLanguage().getName(),
                errorInfo.getType(),
                errorInfo.getCategory(),
                errorInfo.getMessagePattern(),
                errorInfo.getDescription()
        );
    }

    public List<ErrorInfoResponse> searchByName(String keyword) {
        validateSearchKeyword(keyword);
        return errorInfoRepository.findByNameContainingIgnoreCase(keyword)
                .stream()
                .map(errorInfo -> new ErrorInfoResponse(
                        errorInfo.getId(),
                        errorInfo.getName(),
                        errorInfo.getLanguage().getName(),
                        errorInfo.getType(),
                        errorInfo.getCategory(),
                        errorInfo.getMessagePattern(),
                        errorInfo.getDescription()
                ))
                .toList();
    }

    public ErrorInfo findById(Long id) {
        return errorInfoRepository.findById(id)
                .orElseThrow(() -> new ErrorNotFoundException("해당 에러를 찾을 수 없습니다"));
    }

    public List<ErrorCause> findCausesByErrorId(Long errorId) {
        return errorCauseRepository.findByErrorId(errorId);
    }

    public ErrorDetailResponse findDetailById(Long id) {
        ErrorInfo errorInfo = errorInfoRepository.findById(id)
                .orElseThrow(() -> new ErrorNotFoundException("해당 에러를 찾을 수 없습니다."));

        List<String> causes = errorCauseRepository.findByErrorId(id)
                .stream()
                .map(errorCause -> errorCause.getCauseText())
                .toList();

        List<String> solutions = solutionRepository.findByErrorId(id)
                .stream()
                .map(solution -> solution.getSolutionText())
                .toList();

        List<CodeExampleResponse> codeExamples = codeExampleRepository.findByErrorId(id)
                .stream()
                .map(codeExample -> new CodeExampleResponse(
                        codeExample.getBadCode(),
                        codeExample.getGoodCode(),
                        codeExample.getExplanation()
                ))
                .toList();

        List<String> similarErrors = similarErrorRepository.findByErrorId(id)
                .stream()
                .map(similarError -> similarError.getSError().getName())
                .toList();

        return new ErrorDetailResponse(
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

    public void validateSearchKeyword(String keyword) {
        if (keyword == null || keyword.isBlank()) {
            throw new InvalidSearchKeywordException(
                    "검색어를 입력해 주세요."
            );
        }
    }


}
