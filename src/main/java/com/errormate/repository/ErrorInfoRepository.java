package com.errormate.repository;

import com.errormate.domain.ErrorInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.ListCrudRepository;

import java.util.List;
import java.util.Optional;

// jpa가 구현을 해주기때문에 인터페이스로 생성하고 정의만 함
public interface ErrorInfoRepository extends JpaRepository<ErrorInfo, Long> {

    Optional<ErrorInfo> findByName(String name);
    // 에러 이름을 다 적어야 검색가능 + 정확히 에러 하나만 검색
    // NullPointException >>> Null 만 검색해도 찾을 수 있게 + Null 관련 여러 에러 예외 검색
    List<ErrorInfo> findByNameContainingIgnoreCase(String keyword);
                   // 찾다 name필드 기준으로 해당 문자열이 포함되었는지 대소문자 무시
}
