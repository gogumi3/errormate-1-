package com.errormate.exception;

public class InvalidSearchKeywordException extends RuntimeException {

    public InvalidSearchKeywordException(String message) {
        super(message);
    }
}
