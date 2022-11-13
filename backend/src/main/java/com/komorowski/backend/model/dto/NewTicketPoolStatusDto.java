package com.komorowski.backend.model.dto;

import com.komorowski.backend.model.enums.TicketPoolStatus;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class NewTicketPoolStatusDto {
    private TicketPoolStatus newStatus;
}
