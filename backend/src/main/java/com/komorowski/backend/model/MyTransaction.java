package com.komorowski.backend.model;

import com.komorowski.backend.model.enums.MyTransactionStatus;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class MyTransaction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    private MyUser user;

    @OneToOne
    private TicketPool ticketPool;

    private int quantity;
    private Integer seatNumber;
    private float totalPrice;
    private MyTransactionStatus status = MyTransactionStatus.NOT_PAID;

}
