package com.komorowski.backend.service;

import com.komorowski.backend.model.Event;
import com.komorowski.backend.model.TicketPool;
import com.komorowski.backend.model.dto.client.EventDetailsDto;
import com.komorowski.backend.model.dto.client.EventDto;
import com.komorowski.backend.model.dto.client.TicketPoolDto;
import com.komorowski.backend.repository.EventRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class EventService {

    private final EventRepository eventRepository;

    public EventDto getClientEventDto(Event event) {
        EventDto clientEventDto = new EventDto();
        clientEventDto.setId(event.getId());
        clientEventDto.setName(event.getName());
        clientEventDto.setInterestedCount(event.getInterested().size());
        clientEventDto.setParticipantsCount(event.getParticipants().size());

        return clientEventDto;
    }

    public EventDetailsDto getEventDetailsDto(Event event) {
        EventDetailsDto details = new EventDetailsDto();

        details.setId(event.getId());
        details.setName(event.getName());
        details.setDescription(event.getDescription());

        List<TicketPoolDto> ticketPoolDtos = event.getTicketPools()
                .stream()
                .map(this::getTicketPoolDto)
                .toList();

        details.setTicketPools(ticketPoolDtos);

        return details;
    }

    public TicketPoolDto getTicketPoolDto(TicketPool ticketPool) {
        TicketPoolDto dto = new TicketPoolDto();

        dto.setId(ticketPool.getId());
        dto.setStatus(ticketPool.getStatus());
        dto.setName(ticketPool.getName());
        dto.setAvailableTickets(ticketPool.getTickets().size());

        return dto;
    }

}
