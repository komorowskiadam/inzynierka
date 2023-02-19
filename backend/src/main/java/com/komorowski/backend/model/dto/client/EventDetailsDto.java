package com.komorowski.backend.model.dto.client;

import com.komorowski.backend.model.dto.EventPostDto;
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
public class EventDetailsDto {
    private Long id;
    private String name;
    private String description;
    private List<TicketPoolDto> ticketPools;
    private List<Integer> interested;
    private List<Integer> participants;
    private List<EventPostDto> posts;
    private String dateStart;
    private String dateEnd;
    private String timeStart;
    private String timeEnd;
    private Long imageId;
    private String location;
    private EventCategory category;
}
