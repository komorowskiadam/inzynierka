package com.komorowski.backend.model.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CreatePromotionDto {
    private Long eventId;
    private String dateStart;
    private String dateEnd;
}
