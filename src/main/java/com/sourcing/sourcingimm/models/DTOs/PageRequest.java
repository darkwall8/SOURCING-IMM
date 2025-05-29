package com.sourcing.sourcingimm.models.DTOs;

public record PageRequest(
        int page,
        int size,
        String sortBy,
        String sortDirection
) {
    public static PageRequest of(int page, int size) {
        return new PageRequest(page, size, "id", "ASC");
    }

    public static PageRequest of(int page, int size, String sortBy, String sortDirection) {
        return new PageRequest(page, size, sortBy, sortDirection);
    }
}
