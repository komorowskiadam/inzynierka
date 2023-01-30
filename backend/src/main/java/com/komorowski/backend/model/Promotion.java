package com.komorowski.backend.model;

import com.komorowski.backend.model.enums.PromotionStatus;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Promotion {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    private Event event;

    private Integer visits = 0;
    private PromotionStatus status;
    private LocalDate dateStart;
    private LocalDate dateEnd;
}
