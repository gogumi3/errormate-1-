package com.errormate.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity  // DB 테이블과 연결되는 클래스
@Table(name = "languages")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
// 기본 생성자 생성후 외부에서 사용하지 못하게 막음
public class Language {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "language_id")
    private Long id;

    @Column(name = "name", nullable = false, unique = true, length = 50)
    private String name;
}
