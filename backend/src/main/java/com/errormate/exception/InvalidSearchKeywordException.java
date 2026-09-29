package com.errormate.exception;

public class InvalidSearchKeywordException extends RuntimeException {

    public InvalidSearchKeywordException(String message) {
        super(message);
    } // RuntimeException 으로 예외 던지기
}
