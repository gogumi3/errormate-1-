package com.errormate.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "solved_history")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class SolvedHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "solved_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "error_id", nullable = false)
    private ErrorInfo error;

    @Column(name = "solved_at", nullable = false)
    private LocalDateTime solvedAt;
}
