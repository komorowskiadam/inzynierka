package com.komorowski.backend.repository;

import com.komorowski.backend.model.ERole;
import com.komorowski.backend.model.MyRole;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface RoleRepository extends JpaRepository<MyRole, Long> {
    Optional<MyRole> findByName(ERole name);
}
