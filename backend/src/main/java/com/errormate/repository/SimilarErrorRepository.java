package com.errormate.repository;

import com.errormate.domain.SimilarError;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface SimilarErrorRepository extends JpaRepository<SimilarError, Long> {

    List<SimilarError> findByErrorId(Long errorId);
}

