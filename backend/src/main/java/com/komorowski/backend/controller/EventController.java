package com.komorowski.backend.controller;

import com.komorowski.backend.model.Event;
import com.komorowski.backend.model.MyUser;
import com.komorowski.backend.model.Ticket;
import com.komorowski.backend.model.TicketPool;
import com.komorowski.backend.model.dto.*;
import com.komorowski.backend.model.enums.TicketStatus;
import com.komorowski.backend.repository.EventRepository;
import com.komorowski.backend.repository.MyUserRepository;
import com.komorowski.backend.repository.TicketPoolRepository;
import com.komorowski.backend.repository.TicketRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.concurrent.atomic.AtomicInteger;
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

    @PostMapping("create")
    public ResponseEntity<?> createEvent(@RequestBody CreateEventDto createEventDto){

        MyUser organizer = myUserRepository.findById(createEventDto.getOrganizerId())
                .orElseThrow(() -> new RuntimeException("No user with that id."));

        Event newEvent = new Event();
        newEvent.setOrganizer(organizer);
        newEvent.setName(createEventDto.getName());
        eventRepository.save(newEvent);

        return ResponseEntity.ok(newEvent);
    }

    @GetMapping("user/{id}")
    public ResponseEntity<?> getEventsByOrganizerId(@PathVariable Long id){
        if(!myUserRepository.existsById(id)){
            return ResponseEntity.badRequest().body("No user with that id.");
        }

        List<Event> events = eventRepository.findAll();
        events = events.stream().filter(event -> Objects.equals(event.getOrganizer().getId(), id)).collect(Collectors.toList());

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
            ticketRepository.save(ticket);
            tickets.add(ticket);
        }

        TicketPool ticketPool = new TicketPool();
        ticketPool.setTickets(tickets);
        ticketPool.setName(createTicketPoolDto.getPoolName());
        ticketPoolRepository.save(ticketPool);

        event.getTicketPools().add(ticketPool);
        eventRepository.save(event);

        return ResponseEntity.ok(event);
    }

    @PostMapping("{eventId}/changePoolStatus/{poolId}")
    public ResponseEntity<?> changeTicketPoolStatus(@PathVariable Long eventId,
                                                    @PathVariable Long poolId,
                                                    @RequestBody NewTicketPoolStatusDto newTicketPoolStatusDto) {
        Event event = eventRepository.findById(eventId)
                .orElseThrow(() -> new RuntimeException("No event with that id."));

        TicketPool ticketPool = ticketPoolRepository.findById(poolId)
                .orElseThrow(() -> new RuntimeException("No ticket pool with that id."));

        ticketPool.setStatus(newTicketPoolStatusDto.getNewStatus());
        ticketPoolRepository.save(ticketPool);

        return ResponseEntity.ok(event);
    }

    @PostMapping("{eventId}/changeTicketsQuantity/{poolId}")
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

            if (availableTickets.size() < amount * -1) {
                return ResponseEntity.badRequest().body("Can not reduce number of tickets because there is too few available tickets.");
            }

            int toDelete = amount * -1;

            while(toDelete > 0){
                for(int i = 0; i < ticketPool.getTickets().size(); i++) {
                    Ticket ticket = ticketPool.getTickets().get(i);
                    if(ticket.getStatus().equals(TicketStatus.SOLD)) continue;
                    ticketPool.getTickets().remove(ticket);
                    ticketRepository.delete(ticket);
                    toDelete--;
                }
            }

        } else {
            for(int i = 0; i < amount; i++){
                Ticket ticket = new Ticket(price);
                ticketRepository.save(ticket);
                ticketPool.getTickets().add(ticket);
            }
        }

        ticketPoolRepository.save(ticketPool);

        return ResponseEntity.ok(event);

    }

}
