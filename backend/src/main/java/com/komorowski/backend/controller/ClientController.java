package com.komorowski.backend.controller;

import com.komorowski.backend.model.Event;
import com.komorowski.backend.model.MyUser;
import com.komorowski.backend.repository.EventRepository;
import com.komorowski.backend.repository.MyUserRepository;
import com.komorowski.backend.service.MyUserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("client")
@RequiredArgsConstructor
public class ClientController {

    private final EventRepository eventRepository;

    private final MyUserRepository myUserRepository;

    private final MyUserService userService;

    @PostMapping("interested/{eventId},{userId}")
    public ResponseEntity<?> markInterestedInEvent(@PathVariable Long eventId, @PathVariable Long userId) {
        Event event = eventRepository.findById(eventId)
                .orElseThrow(() -> new RuntimeException("No event with that id."));

        MyUser user = myUserRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("No user with that id."));

        if(userService.isCreator(user)) {
            throw new RuntimeException("Creators can not be interested in event.");
        }

        event.getParticipants().remove(user);
        event.getInterested().add(user);
        eventRepository.save(event);

        return ResponseEntity.ok(event);
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

        event.getInterested().remove(user);
        event.getParticipants().add(user);
        eventRepository.save(event);

        return ResponseEntity.ok(event);
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

        return ResponseEntity.ok(event);
    }

}
