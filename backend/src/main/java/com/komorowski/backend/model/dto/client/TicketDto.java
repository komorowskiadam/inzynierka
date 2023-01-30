package com.komorowski.backend.model.dto.client;

import com.komorowski.backend.model.enums.TicketStatus;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TicketDto {
    private Long id;
    private String eventName;
    private TicketStatus status;
    private Integer seatNumber;
}
