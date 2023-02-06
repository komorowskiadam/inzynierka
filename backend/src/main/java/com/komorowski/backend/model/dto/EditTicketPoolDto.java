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
public class EditTicketPoolDto {
    private TicketPoolStatus status;
    private String name;
    private Long imageId;
}
