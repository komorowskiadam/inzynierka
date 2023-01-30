package com.komorowski.backend.model.dto.client;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class BuyTicketDto {
    private Long userId;
    private Long ticketPoolId;
    private int quantity;
    private Integer seatNumber;
}
