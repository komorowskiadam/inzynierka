package com.komorowski.backend.model.dto.client;

import com.komorowski.backend.model.enums.TicketPoolStatus;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class TicketPoolDto {
    private Long id;
    private String name;
    private Integer availableTickets;
    private TicketPoolStatus status;
}
