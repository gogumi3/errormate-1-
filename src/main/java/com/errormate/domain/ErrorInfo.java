package com.errormate.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "errors")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class ErrorInfo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "error_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "language_id", nullable = false)
    private Language language;

    @Column(nullable = false, unique = true, length = 225)
    private String name;

    @Column(length = 100)
    private String type;

    @Column(length = 100)
    private String category;

    @Column(name = "message_pattern", length = 500)
    private String messagePattern;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updateAt;

}
