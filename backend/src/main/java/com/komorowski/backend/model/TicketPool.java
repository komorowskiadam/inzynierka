package com.komorowski.backend.model;

import com.komorowski.backend.model.enums.TicketPoolStatus;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
public class TicketPool {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToMany(cascade = CascadeType.REMOVE, orphanRemoval = true)
    private List<Ticket> tickets;

    private String name;

    private TicketPoolStatus status = TicketPoolStatus.ACTIVE;

    private boolean seatReservation = false;

    private Long imageId;

}
