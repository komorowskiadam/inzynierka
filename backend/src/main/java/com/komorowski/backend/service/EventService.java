package com.komorowski.backend.service;

import com.komorowski.backend.model.*;
import com.komorowski.backend.model.dto.EventPostDto;
import com.komorowski.backend.model.dto.client.EventDetailsDto;
import com.komorowski.backend.model.dto.client.EventDto;
import com.komorowski.backend.model.dto.client.TicketDto;
import com.komorowski.backend.model.dto.client.TicketPoolDto;
import com.komorowski.backend.model.enums.TicketStatus;
import com.komorowski.backend.repository.EventRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

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
        clientEventDto.setLocation(event.getLocation());
        clientEventDto.setDateStart(event.getDateStart());
        clientEventDto.setTimeStart(event.getTimeStart());
        clientEventDto.setDateEnd(event.getDateEnd());
        clientEventDto.setTimeEnd(event.getTimeEnd());
        clientEventDto.setCategory(event.getCategory());
        clientEventDto.setImageId(event.getImageId());

        List<Integer> likes = event.getLikes()
                .stream()
                .map(myUser -> myUser.getId().intValue() )
                .toList();

        clientEventDto.setLikes(likes);

        return clientEventDto;
    }

    public EventDetailsDto getEventDetailsDto(Event event) {
        EventDetailsDto details = new EventDetailsDto();

        details.setId(event.getId());
        details.setName(event.getName());
        details.setDescription(event.getDescription());
        details.setLocation(event.getLocation());
        details.setDateStart(event.getDateStart());
        details.setTimeStart(event.getTimeStart());
        details.setDateEnd(event.getDateEnd());
        details.setTimeEnd(event.getTimeEnd());
        details.setImageId(event.getImageId());
        details.setCategory(event.getCategory());

        List<TicketPoolDto> ticketPoolDtos = event.getTicketPools()
                .stream()
                .map(ticketPool -> getTicketPoolDto(ticketPool, event.getId()))
                .toList();

        List<Integer> interested = event.getInterested()
                .stream()
                .map(myUser -> myUser.getId().intValue() )
                .toList();

        List<Integer> participants = event.getParticipants()
                .stream()
                .map(myUser -> myUser.getId().intValue() )
                .toList();

        List<EventPostDto> posts = event.getPosts()
                .stream()
                .map(this::getEventPostDto)
                .toList();

        details.setInterested(interested);
        details.setParticipants(participants);
        details.setTicketPools(ticketPoolDtos);
        details.setPosts(posts);

        return details;
    }

    public TicketPoolDto getTicketPoolDto(TicketPool ticketPool, Long eventId) {
        TicketPoolDto dto = new TicketPoolDto();

        dto.setImageId(ticketPool.getImageId());
        dto.setId(ticketPool.getId());
        dto.setStatus(ticketPool.getStatus());
        dto.setName(ticketPool.getName());
        dto.setAvailableTickets(ticketPool.getTickets()
                .stream()
                .filter(ticket -> ticket.getStatus().equals(TicketStatus.AVAILABLE))
                .toList()
                .size());
        dto.setSoldTickets(ticketPool.getTickets()
                .stream()
                .filter(ticket -> ticket.getStatus().equals(TicketStatus.SOLD))
                .toList()
                .size());
        dto.setSeatReservation(ticketPool.isSeatReservation());
        if(ticketPool.isSeatReservation()) {
            dto.setAvailableSeats(ticketPool.getTickets()
                    .stream()
                    .filter(ticket -> ticket.getStatus().equals(TicketStatus.AVAILABLE))
                    .map(Ticket::getSeatNumber)
                    .toList());
        }
        dto.setEventId(eventId);

        return dto;
    }

    public TicketDto getTicketDto(Ticket ticket) {
        Event event = eventRepository.findById(ticket.getEventId())
                .orElseThrow(() -> new RuntimeException("No event with that id."));

        return TicketDto.builder()
                .eventName(event.getName())
                .id(ticket.getId())
                .seatNumber(ticket.getSeatNumber())
                .status(ticket.getStatus())
                .build();
    }

    public EventPostDto getEventPostDto(EventPost eventPost) {
        String name = eventPost.getAuthor().getName();
        if(eventPost.getAuthor().getSurname() != null){
            name += " " + eventPost.getAuthor().getSurname();
        }
        List<Long> likes = eventPost.getLikes()
                .stream()
                .map(MyUser::getId)
                .toList();

        return EventPostDto.builder()
                .author(name)
                .content(eventPost.getContent())
                .date(eventPost.getDate())
                .likes(likes)
                .id(eventPost.getId())
                .build();
    }

}
