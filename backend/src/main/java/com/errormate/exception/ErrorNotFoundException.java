package com.errormate.exception;

public class ErrorNotFoundException extends RuntimeException {

    public ErrorNotFoundException (String message) {
        super(message);
    } // RuntimeException 으로 예외 던지기
}
