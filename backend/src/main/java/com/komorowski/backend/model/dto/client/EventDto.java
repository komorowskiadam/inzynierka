package com.komorowski.backend.model.dto.client;

import com.komorowski.backend.model.enums.EventCategory;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class EventDto {
    private Long id;
    private String name;
    private Integer interestedCount;
    private Integer participantsCount;
    private List<Integer> likes;
    private String dateStart;
    private String dateEnd;
    private String timeStart;
    private String timeEnd;
    private Long imageId;
    private String location;
    private EventCategory category;
}
