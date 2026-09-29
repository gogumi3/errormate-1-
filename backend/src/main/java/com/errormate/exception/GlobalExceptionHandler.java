package com.errormate.exception;

import com.errormate.dto.error.ErrorResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice // 여러 컨트롤러에서 발생한 예외를 공통으로 처리
public class GlobalExceptionHandler {

    // ErrorNotFoundException 발생시 아래 메서드가 처리
    @ExceptionHandler(ErrorNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleErrorNotFound(
            ErrorNotFoundException exception
    ) {
        ErrorResponse response = new ErrorResponse( // 프론트에 보낼 에러 응답 dto
                HttpStatus.NOT_FOUND.value(),   // ex) 404
                exception.getMessage(),         // 에러 메세지
                "요청한 이름이나 ID에 해당하는 에러 정보가 없습니다.", // 설명
                "에러 이름의 철자를 확인하거나 이름 일부로 다시 검색해 보세요. 아직 등록되지 않은 에러일 수도 있습니다." // 해결방안
        );

        return ResponseEntity
                .status(HttpStatus.NOT_FOUND)
                .body(response);
        // HTTP 상태코드를 404로 보내고, body에는 방금 만든 ErrorResponse 넣기
    }

    // 검색어가 비어있거나 잘못 되었을때 아래 메서드가 처리
    @ExceptionHandler(InvalidSearchKeywordException.class)
    public ResponseEntity<ErrorResponse> handleInvalidSearchKeyword(
            InvalidSearchKeywordException exception
    ) {
        ErrorResponse response = new ErrorResponse(
                HttpStatus.BAD_REQUEST.value(), // 400
                "검색어를 입력해 주세요.",
                "검색어가 비어 있거나 공백만 입력되었습니다.",
                "검색창에 찾고 싶은 에러 이름이나 이름 일부를 입력해 주세요."
        );

        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(response);
    }

    // 필요한 파라미터 자체를 안 보냈을때 아래 메서드가 처리
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