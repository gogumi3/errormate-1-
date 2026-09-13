package com.errormate.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "search_history")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class SearchHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "history_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "error_id")
    private ErrorInfo error;

    @Column(nullable = false, length = 255)
    private String keyword;

    @Column(name = "searched_at", nullable = false)
    private LocalDateTime searchedAt;
}
