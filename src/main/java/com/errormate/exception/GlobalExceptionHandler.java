package com.errormate.exception;

import com.errormate.dto.error.ErrorResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice // 여러 컨트롤러에서 발생한 예외를 공통으로 처리
public class GlobalExceptionHandler {

    @ExceptionHandler(ErrorNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleErrorNotFound(
            ErrorNotFoundException exception
    ) {
        ErrorResponse response = new ErrorResponse(
                HttpStatus.NOT_FOUND.value(),
                exception.getMessage(),
                "요청한 이름이나 ID에 해당하는 에러 정보가 없습니다.",
                "에러 이름의 철자를 확인하거나 이름 일부로 다시 검색해 보세요. 아직 등록되지 않은 에러일 수도 있습니다."
        );

        return ResponseEntity
                .status(HttpStatus.NOT_FOUND)
                .body(response);

    }

    @ExceptionHandler(InvalidSearchKeywordException.class)
    public ResponseEntity<ErrorResponse> handleInvalidSearchKeyword(
            InvalidSearchKeywordException exception
    ) {
        ErrorResponse response = new ErrorResponse(
                HttpStatus.BAD_REQUEST.value(),
                "검색어를 입력해 주세요.",
                "검색어가 비어 있거나 공백만 입력되었습니다.",
                "검색창에 찾고 싶은 에러 이름이나 이름 일부를 입력해 주세요."
        );

        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(response);
    }

    @ExceptionHandler(MissingServletRequestParameterException.class)
    public ResponseEntity<ErrorResponse> handleMissingRequestParameter(
            MissingServletRequestParameterException exception
    ) {
        ErrorResponse response = new ErrorResponse(
                HttpStatus.BAD_REQUEST.value(),
                "필수 입력 정보가 전달되지 않았습니다.",
                "요청을 처리하는 데 필요한 정보가 빠져 있습니다.",
                "입력 내용을 확인한 뒤 다시 시도해 주세요."
        );

        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(response);
    }
}