package com.komorowski.backend.controller;

import com.komorowski.backend.model.*;
import com.komorowski.backend.model.dto.TransferTicketDto;
import com.komorowski.backend.model.dto.client.*;
import com.komorowski.backend.model.enums.TicketStatus;
import com.komorowski.backend.repository.*;
import com.komorowski.backend.service.EventService;
import com.komorowski.backend.service.MyUserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("client")
@RequiredArgsConstructor
public class ClientController {

    private final EventRepository eventRepository;

    private final EventService eventService;

    private final MyUserRepository myUserRepository;

    private final MyUserService userService;

    private final TransactionRepository transactionRepository;

    private final TicketRepository ticketRepository;

    private final TicketPoolRepository ticketPoolRepository;

    @GetMapping("events")
    public ResponseEntity<?> getAllEvents() {
        List<Event> events = eventRepository.findAll();
        List<EventDto> eventDtos = events
                .stream()
                .map(eventService::getClientEventDto)
                .toList();
        return ResponseEntity.ok(eventDtos);
    }

    @GetMapping("events/{id}")
    public ResponseEntity<?> getEventById(@PathVariable Long id) {
        Event event = eventRepository.findById(id).orElseThrow(() -> new RuntimeException("No event with that id."));

        return ResponseEntity.ok(eventService.getEventDetailsDto(event));
    }

    @PostMapping("interested/{eventId},{userId}")
    public ResponseEntity<?> markInterestedInEvent(@PathVariable Long eventId, @PathVariable Long userId) {
        Event event = eventRepository.findById(eventId)
                .orElseThrow(() -> new RuntimeException("No event with that id."));

        MyUser user = myUserRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("No user with that id."));

        if(userService.isCreator(user)) {
            throw new RuntimeException("Creators can not be interested in event.");
        }

        if(event.getInterested().contains(user)){
            event.getInterested().remove(user);
        } else {
            event.getParticipants().remove(user);
            event.getInterested().add(user);
        }
        eventRepository.save(event);

        return ResponseEntity.ok(eventService.getEventDetailsDto(event));
    }

    @PostMapping("takePart/{eventId},{userId}")
    public ResponseEntity<?> markTakePartInEvent(@PathVariable Long eventId, @PathVariable Long userId) {
        Event event = eventRepository.findById(eventId)
                .orElseThrow(() -> new RuntimeException("No event with that id."));

        MyUser user = myUserRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("No user with that id."));

        if(userService.isCreator(user)) {
            throw new RuntimeException("Creators can not take part in event.");
        }

        if(event.getParticipants().contains(user)){
            event.getParticipants().remove(user);
        } else {
            event.getInterested().remove(user);
            event.getParticipants().add(user);
        }
        eventRepository.save(event);

        return ResponseEntity.ok(eventService.getEventDetailsDto(event));
    }

    @PostMapping("likeEvent/{eventId},{userId}")
    public ResponseEntity<?> likeEvent(@PathVariable Long eventId, @PathVariable Long userId) {
        Event event = eventRepository.findById(eventId)
                .orElseThrow(() -> new RuntimeException("No event with that id."));

        MyUser user = myUserRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("No user with that id."));

        if(event.getLikes().contains(user)){
            event.getLikes().remove(user);
        } else {
            event.getLikes().add(user);
        }

        eventRepository.save(event);

        return ResponseEntity.ok(eventService.getClientEventDto(event));
    }

    @DeleteMapping("removeMark/{eventId},{userId}")
    public ResponseEntity<?> removeMarkFromEvent(@PathVariable Long eventId, @PathVariable Long userId) {
        Event event = eventRepository.findById(eventId)
                .orElseThrow(() -> new RuntimeException("No event with that id."));

        MyUser user = myUserRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("No user with that id."));

        if(userService.isCreator(user)) {
            throw new RuntimeException("Creators can not be interested nor take part in event.");
        }

        event.getInterested().remove(user);
        event.getParticipants().remove(user);
        eventRepository.save(event);

        return ResponseEntity.ok(eventService.getEventDetailsDto(event));
    }

    @PostMapping("{eventId}/buyTickets")
    public ResponseEntity<?> startNewTransaction(@RequestBody BuyTicketDto buyTicketDto, @PathVariable Long eventId) {
        Event event = eventRepository.findById(eventId)
                .orElseThrow(() -> new RuntimeException("No event with that id."));

        MyUser user = myUserRepository.findById(buyTicketDto.getUserId())
                .orElseThrow(() -> new RuntimeException("No user with that id."));

        TicketPool ticketPool = ticketPoolRepository.findById(buyTicketDto.getTicketPoolId())
                .orElseThrow(() -> new RuntimeException("No ticket pool with that id."));

        MyTransaction transaction = new MyTransaction();

        transaction.setUser(user);
        transaction.setTicketPool(ticketPool);

        if(buyTicketDto.getSeatNumber() != null) {
            ticketPool.getTickets()
                    .stream()
                    .filter(t -> t.getSeatNumber().equals(buyTicketDto.getSeatNumber()))
                    .findFirst()
                    .orElseThrow();
            transaction.setSeatNumber(buyTicketDto.getSeatNumber());

        } else {
            if(buyTicketDto.getQuantity() < 1){
                throw new RuntimeException("You cannot buy less than 1 tickets!");
            }

            int availableTickets = ticketPool.getTickets()
                    .stream()
                    .filter(ticket -> ticket.getStatus().equals(TicketStatus.AVAILABLE))
                    .toList()
                    .size();

            if(buyTicketDto.getQuantity() > availableTickets){
                throw new RuntimeException("No that many tickets available");
            }

            transaction.setQuantity(buyTicketDto.getQuantity());
        }

        float price = buyTicketDto.getQuantity() * ticketPool.getTickets().get(0).getPrice();

        transaction.setTotalPrice(price);
        transactionRepository.save(transaction);

        TransactionDto transactionDto = TransactionDto.builder()
                .totalPrice(price)
                .id(transaction.getId())
                .ticketPoolDto(eventService.getTicketPoolDto(ticketPool, event.getId()))
                .quantity(buyTicketDto.getQuantity())
                .seatNumber(buyTicketDto.getSeatNumber())
                .userId(user.getId())
                .status(transaction.getStatus())
                .build();

        return ResponseEntity.ok(transactionDto);
    }

    @PostMapping("pay/{transactionId}")
    public ResponseEntity<?> payForTransaction(@PathVariable Long transactionId){
        MyTransaction transaction = transactionRepository.findById(transactionId)
                .orElseThrow(() -> new RuntimeException("No transaction with that id."));

        MyUser user = myUserRepository.findById(transaction.getUser().getId())
                .orElseThrow(() -> new RuntimeException("No user with that id."));

        TicketPool ticketPool = ticketPoolRepository.findById(transaction.getTicketPool().getId())
                .orElseThrow(() -> new RuntimeException("No ticket pool with that id."));

        System.out.println(transaction.getSeatNumber());

        if(transaction.getSeatNumber() != null) {
            Ticket ticket =  ticketPool.getTickets()
                    .stream()
                    .filter(t -> t.getSeatNumber().equals(transaction.getSeatNumber()))
                    .findFirst()
                    .orElseThrow();
            ticket.setStatus(TicketStatus.SOLD);
            ticket.setSeatNumber(transaction.getSeatNumber());
            user.getTickets().add(ticket);
            myUserRepository.save(user);
            transactionRepository.delete(transaction);

            return ResponseEntity.ok("Transaction finished successfully!");
        }

        int quantity = transaction.getQuantity();;

        for(Ticket ticket: ticketPool.getTickets()){
            if(quantity < 1) break;
            if(ticket.getStatus().equals(TicketStatus.AVAILABLE)){
                ticket.setStatus(TicketStatus.SOLD);
                user.getTickets().add(ticket);
                quantity--;
            }
        }
        transactionRepository.delete(transaction);

        return ResponseEntity.ok("Transaction finished successfully!");
    }

    @GetMapping("{userId}/tickets")
    public ResponseEntity<?> getUserTickets(@PathVariable Long userId) {
        MyUser user = myUserRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("No user with that id."));

        List<TicketDto> dtos = user.getTickets()
                .stream()
                .map(eventService::getTicketDto)
                .toList();

        return ResponseEntity.ok(dtos);
    }

    @PostMapping("cancelTransaction/{transactionId}")
    public ResponseEntity<?> cancelTransaction(@PathVariable Long transactionId) {
        MyTransaction transaction = transactionRepository.findById(transactionId)
                .orElseThrow(() -> new RuntimeException("No transaction with that id!"));

        transactionRepository.delete(transaction);

        return ResponseEntity.ok("Transaction deleted succesfully!");
    }

    @PostMapping("transferTicket")
    public ResponseEntity<?> transferTicket(@RequestBody TransferTicketDto dto){
        MyUser userFrom = myUserRepository.findById(dto.getFromId())
                .orElseThrow(() -> new RuntimeException("No user with that id."));

        MyUser userTo = myUserRepository.findById(dto.getToId())
                .orElseThrow(() -> new RuntimeException("No user with that id."));

        Ticket ticket = ticketRepository.findById(dto.getTicketId())
                .orElseThrow(() -> new RuntimeException("No ticket with that id"));

        userFrom.getTickets().remove(ticket);
        userTo.getTickets().add(ticket);
        myUserRepository.save(userFrom);
        myUserRepository.save(userTo);

        return ResponseEntity.ok("Ticket transferred successfully.");
    }
}
