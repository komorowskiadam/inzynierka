package com.komorowski.backend.controller;

import com.komorowski.backend.model.*;
import com.komorowski.backend.model.dto.*;
import com.komorowski.backend.model.enums.TicketStatus;
import com.komorowski.backend.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.transaction.Transactional;
import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("events")
@RequiredArgsConstructor
public class EventController {

    private final MyUserRepository myUserRepository;

    private final EventRepository eventRepository;

    private final TicketRepository ticketRepository;

    private final TicketPoolRepository ticketPoolRepository;

    private final EventPostRepository eventPostRepository;

    @PostMapping("create")
    public ResponseEntity<?> createEvent(@RequestBody CreateEventDto createEventDto){

        MyUser organizer = myUserRepository.findById(createEventDto.getOrganizerId())
                .orElseThrow(() -> new RuntimeException("No user with that id."));

        Event newEvent = new Event();
        newEvent.setOrganizer(organizer);
        newEvent.setName(createEventDto.getName());
        newEvent.setDescription(createEventDto.getDescription());
        newEvent.setDateStart(createEventDto.getDateStart());
        newEvent.setDateEnd(createEventDto.getDateEnd());
        newEvent.setTimeStart(createEventDto.getTimeStart());
        newEvent.setTimeEnd(createEventDto.getTimeEnd());
        newEvent.setLocation(createEventDto.getLocation());

        if(createEventDto.getImageId() != null) {
            newEvent.setImageId(createEventDto.getImageId());
        }

        eventRepository.save(newEvent);

        return ResponseEntity.ok(newEvent);
    }

    @GetMapping("user/{id}")
    @Transactional
    public ResponseEntity<?> getEventsByOrganizerId(@PathVariable Long id){
        if(!myUserRepository.existsById(id)){
            return ResponseEntity.badRequest().body("No user with that id.");
        }

        List<Event> events = eventRepository.findByOrganizer_Id(id);

        return ResponseEntity.ok(events);
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getEventById(@PathVariable Long id){
        Event event = eventRepository.findById(id).orElseThrow(() -> new RuntimeException("No event with that id."));

        return ResponseEntity.ok(event);
    }

    @PatchMapping("/edit/{id}")
    public ResponseEntity<?> editEvent(@PathVariable Long id, @RequestBody EditEventDto editEventDto){
        Event event = eventRepository.findById(id).orElseThrow(() -> new RuntimeException("No event with that id."));

        if(editEventDto.getName() != null){
            event.setName(editEventDto.getName());
        }
        if(editEventDto.getDescription() != null){
            event.setDescription(editEventDto.getDescription());
        }
        if(editEventDto.getDateStart() != null){
            event.setDateStart(editEventDto.getDateStart());
        }
        if(editEventDto.getDateEnd() != null) {
            event.setDateEnd(editEventDto.getDateEnd());
        }
        if(editEventDto.getTimeStart() != null){
            event.setTimeStart(editEventDto.getTimeStart());
        }
        if(editEventDto.getTimeEnd() != null) {
            event.setTimeEnd(editEventDto.getTimeEnd());
        }
        if(editEventDto.getLocation() != null) {
            event.setLocation(editEventDto.getLocation());
        }
        eventRepository.save(event);

        return ResponseEntity.ok(event);
    }

    @PostMapping("{eventId}/createPool")
    public ResponseEntity<?> createTicketPool(@PathVariable Long eventId,
                                              @RequestBody CreateTicketPoolDto createTicketPoolDto) {

        Event event = eventRepository.findById(eventId)
                .orElseThrow(() -> new RuntimeException("No event with that id."));

        if(createTicketPoolDto.getPrice() < 0){
            throw new RuntimeException("Price can not be less than zero!");
        }

        List<Ticket> tickets = new java.util.ArrayList<>(Collections.emptyList());

        for(int i = 0; i < createTicketPoolDto.getQuantity(); i++){
            Ticket ticket = new Ticket(createTicketPoolDto.getPrice());
            if(createTicketPoolDto.getStartSeatNumber() != null) {
                ticket.setSeatNumber(createTicketPoolDto.getStartSeatNumber() + i);
            }
            ticket.setEventId(event.getId());
            ticketRepository.save(ticket);
            tickets.add(ticket);
        }

        TicketPool ticketPool = new TicketPool();
        ticketPool.setTickets(tickets);
        ticketPool.setName(createTicketPoolDto.getPoolName());

        if(createTicketPoolDto.getStartSeatNumber() != null) {
            ticketPool.setSeatReservation(true);
        }

        ticketPoolRepository.save(ticketPool);

        event.getTicketPools().add(ticketPool);
        eventRepository.save(event);

        return ResponseEntity.ok(event);
    }

    @PatchMapping("{eventId}/editTicketPool/{poolId}")
    public ResponseEntity<?> editTicketPool(@PathVariable Long eventId,
                                                    @PathVariable Long poolId,
                                                    @RequestBody EditTicketPoolDto editTicketPoolDto) {
        Event event = eventRepository.findById(eventId)
                .orElseThrow(() -> new RuntimeException("No event with that id."));

        TicketPool ticketPool = ticketPoolRepository.findById(poolId)
                .orElseThrow(() -> new RuntimeException("No ticket pool with that id."));

        if (editTicketPoolDto.getStatus() != null) {
            ticketPool.setStatus(editTicketPoolDto.getStatus());
        }
        if (editTicketPoolDto.getName() != null) {
            ticketPool.setName(editTicketPoolDto.getName());
        }

        ticketPoolRepository.save(ticketPool);

        return ResponseEntity.ok(event);
    }

    @PatchMapping("{eventId}/changeTicketsQuantity/{poolId}")
    public ResponseEntity<?> changeTicketPoolTicketsQuantity(@PathVariable Long eventId,
                                                             @PathVariable Long poolId,
                                                             @RequestBody ChangeTicketPoolQuantityDto newQuantityDto) {

        Event event = eventRepository.findById(eventId)
                .orElseThrow(() -> new RuntimeException("No event with that id."));

        TicketPool ticketPool = ticketPoolRepository.findById(poolId)
                .orElseThrow(() -> new RuntimeException("No ticket pool with that id."));

        Long price = ticketPool.getTickets().get(0).getPrice();

        Integer amount = newQuantityDto.getQuantity();

        if(amount < 0) {
            List<Ticket> availableTickets = ticketPool.getTickets()
                    .stream()
                    .filter(ticket -> ticket.getStatus().equals(TicketStatus.AVAILABLE))
                    .toList();

            if (availableTickets.size() <= amount * -1) {
                return ResponseEntity.badRequest().body("Can not reduce number of tickets because there is too few available tickets.");
            }

            int toDelete = amount * -1;

            List<Long> ticketsToDelete = new java.util.ArrayList<>(Collections.emptyList());

            for(int i = 0; i < toDelete; i++) {
                ticketsToDelete.add(availableTickets.get(i).getId());
            }

            for (int i = 0; i < toDelete; i++) {
                Long idToDelete = ticketsToDelete.get(i);
                Ticket ticket = ticketRepository.findById(idToDelete).orElseThrow();
                ticketPool.getTickets().remove(ticket);
                ticketRepository.delete(ticket);
            }
        } else {
            for(int i = 0; i < amount; i++){
                Ticket ticket = new Ticket(price);
                ticket.setEventId(event.getId());
                ticketRepository.save(ticket);
                ticketPool.getTickets().add(ticket);
            }
        }

        ticketPoolRepository.save(ticketPool);

        return ResponseEntity.ok(event);
    }

    @PostMapping("{eventId}/addPost")
    public ResponseEntity<?> createPost(@PathVariable Long eventId, @RequestBody CreateEventPostDto dto) {
        Event event = eventRepository.findById(eventId)
                .orElseThrow(() -> new RuntimeException("No event with that id."));

        MyUser user = myUserRepository.findById(dto.getAuthorId())
                .orElseThrow(() -> new RuntimeException("No user with that id."));

        EventPost post = new EventPost();
        post.setAuthor(user);
        post.setDate(dto.getDate());
        post.setContent(dto.getContent());
        eventPostRepository.save(post);

        event.getPosts().add(post);
        eventRepository.save(event);

        return ResponseEntity.ok(event);
    }
}
