package com.komorowski.backend.repository;

import com.komorowski.backend.model.Event;
import com.komorowski.backend.model.Promotion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PromotionRepository extends JpaRepository<Promotion, Long> {
    boolean existsByEvent(Event event);
    List<Promotion> findByEvent(Event event);
}
