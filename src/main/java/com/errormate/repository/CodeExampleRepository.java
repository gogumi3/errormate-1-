package com.errormate.repository;

import com.errormate.domain.CodeExample;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CodeExampleRepository extends JpaRepository<CodeExample, Long> {
    List<CodeExample> findByErrorId(Long errorId);
}
