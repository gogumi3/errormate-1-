package com.errormate.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "code_examples")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class CodeExample {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "example_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "error_id", nullable = false)
    private ErrorInfo error;

    @Column(name = "bad_code", columnDefinition = "TEXT")
    private String badCode;

    @Column(name = "good_code", columnDefinition = "TEXT")
    private String goodCode;

    @Column(name = "explanation ", columnDefinition = "TEXT")
    private String explanation ;

}
