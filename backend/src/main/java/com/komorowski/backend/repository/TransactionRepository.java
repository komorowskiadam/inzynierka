package com.komorowski.backend.repository;

import com.komorowski.backend.model.MyTransaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TransactionRepository extends JpaRepository<MyTransaction, Long> {
}
