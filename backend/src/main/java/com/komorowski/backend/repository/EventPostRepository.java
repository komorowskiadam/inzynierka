package com.komorowski.backend.repository;

import com.komorowski.backend.model.EventPost;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface EventPostRepository extends JpaRepository<EventPost, Long> {
}
