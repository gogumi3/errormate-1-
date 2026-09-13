package com.errormate.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "error_causes")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class ErrorCause {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "cause_id")
    private Long cause;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "error_id", nullable = false)
    private ErrorInfo error;

    @Column(name = "cause_text", nullable = false, columnDefinition = "TEXT")
    private String causeText;
}
