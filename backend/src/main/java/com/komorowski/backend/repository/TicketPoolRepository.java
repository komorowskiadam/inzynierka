package com.komorowski.backend.repository;

import com.komorowski.backend.model.TicketPool;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TicketPoolRepository extends JpaRepository<TicketPool, Long> {
}
