package com.komorowski.backend.model.dto.client;

import com.komorowski.backend.model.enums.MyTransactionStatus;
import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class TransactionDto {
    private Long id;
    private float totalPrice;
    private int quantity;
    private TicketPoolDto ticketPoolDto;
    private Long userId;
    private MyTransactionStatus status;
    private Integer seatNumber;
}
