package com.errormate.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "similar_errors")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class SimilarError {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "similar_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "error_id", nullable = false)
    private ErrorInfo error;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "similar_error_id", nullable = false)
    private ErrorInfo sError;


}
