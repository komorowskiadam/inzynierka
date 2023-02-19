package com.komorowski.backend.model.dto;

import com.komorowski.backend.model.enums.EventCategory;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class EditEventDto {
    private String name;
    private String description;
    private String dateStart;
    private String dateEnd;
    private String timeStart;
    private String timeEnd;
    private String location;
    private EventCategory category;
}
