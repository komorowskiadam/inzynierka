package com.komorowski.backend.model.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class EditPromotionDto {
    private String dateStart;
    private String dateEnd;
    private String status;
}
