package com.komorowski.backend.model.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CreateTicketPoolDto {
    private Integer quantity;

    private Long price;

    private String poolName;

    private Integer startSeatNumber;
}
