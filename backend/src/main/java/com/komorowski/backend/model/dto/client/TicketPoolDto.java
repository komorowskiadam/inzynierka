package com.komorowski.backend.model.dto.client;

import com.komorowski.backend.model.enums.TicketPoolStatus;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Collections;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class TicketPoolDto {
    private Long id;
    private String name;
    private Integer availableTickets;
    private Integer soldTickets;
    private TicketPoolStatus status;
    private Long eventId;
    private boolean seatReservation;
    private List<Integer> availableSeats = Collections.emptyList();
    private Long imageId;
}
