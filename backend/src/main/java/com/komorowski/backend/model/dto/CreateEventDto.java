package com.komorowski.backend.model.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class CreateEventDto {
    private String name;
    private Long organizerId;
    private String description;
    private String dateStart;
    private String dateEnd;
    private String timeStart;
    private String timeEnd;
    private Long imageId;
    private String location;
}
