package com.errormate.service;

import com.errormate.domain.*;
import com.errormate.dto.error.ErrorDetailResponse;
import com.errormate.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ErrorInfoService {

    private final ErrorInfoRepository errorInfoRepository;
    private final ErrorCauseRepository errorCauseRepository;
    private final SolutionRepository solutionRepository;
    private final CodeExampleRepository codeExampleRepository;
    private final SimilarErrorRepository similarErrorRepository;

    // 컨트롤러에서 값을 받아오면 다시 레파지토리로 넘김


    public ErrorInfo findByName(String name) {
        return errorInfoRepository.findByName(name)
                .orElseThrow(() -> new IllegalArgumentException("해당 에러를 찾을 수 없습니다."));
        // name 변수로 값이 들어오면 레파지토리에 name으로 검색하는 기능 orElseThrow 레파지토리에 Optional에서 검색하고 있으면
        // 그 값을 호출한 곳에 반환 없으면 예외발생
    }

    public List<ErrorInfo> searchByName(String keyword) {
        return errorInfoRepository.findByNameContainingIgnoreCase(keyword);
        // 검색시 앞 글자만 검색시 여러 후보가 나오는 부분
    }

    public ErrorInfo findById(Long id) {
        return errorInfoRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("해당 에러를 찾을 수 없습니다"));
        // id 기준으로 찾기
    }

    public List<ErrorCause> findCausesByErrorId(Long errorId) {
        return errorCauseRepository.findByErrorId(errorId);
    }

    public ErrorDetailResponse findDetailById(Long id) {

        ErrorInfo errorInfo = errorInfoRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("해당 에러를 찾을 수 없습니다."));

        List<ErrorCause> errorCauses = errorCauseRepository.findByErrorId(id);

        List<Solution> solutions = solutionRepository.findByErrorId(id);

        List<CodeExample> codeExamples = codeExampleRepository.findByErrorId(id);

        List<SimilarError> similarErrors = similarErrorRepository.findByErrorId(id);

        return new ErrorDetailResponse(errorInfo, errorCauses, solutions, codeExamples, similarErrors);

        // 에러 존재하면 에러에 대한 정보와 발생원인을 포함한 새로운 객체 생성
    }



}
