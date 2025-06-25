package com.sourcing.sourcingimm.utils.exception;

public class DuplicateResourceException extends RuntimeException {

    public DuplicateResourceException() {
        super("Resource already exists");
    }

    public DuplicateResourceException(String message) {
        super(message);
    }

    public DuplicateResourceException(String message, Throwable cause) {
        super(message, cause);
    }
}