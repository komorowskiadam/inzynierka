package com.komorowski.backend.model;

import com.komorowski.backend.model.enums.TicketStatus;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Getter
@Setter
@NoArgsConstructor
@Entity
public class Ticket {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Long price;

    private Long eventId;

    private TicketStatus status = TicketStatus.AVAILABLE;

    private Integer seatNumber;

    public Ticket(Long price){
        this.price = price;
    }

    public Ticket(Long price, Integer seatNumber){
        this.price = price;
        this.seatNumber = seatNumber;
    }
}
