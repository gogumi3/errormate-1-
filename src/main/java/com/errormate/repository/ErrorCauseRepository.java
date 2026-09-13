package com.errormate.repository;

import com.errormate.domain.ErrorCause;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ErrorCauseRepository extends JpaRepository<ErrorCause, Long> {

    List<ErrorCause> findByErrorId(Long errorId);

}
