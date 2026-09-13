package com.errormate.repository;

import com.errormate.domain.Solution;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface SolutionRepository extends JpaRepository<Solution, Long> {

    List<Solution> findByErrorId(Long errorId);
}
