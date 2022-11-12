package com.komorowski.backend.controller;

import com.komorowski.backend.model.Event;
import com.komorowski.backend.model.MyUser;
import com.komorowski.backend.model.dto.CreateEventDto;
import com.komorowski.backend.model.dto.EditEventDto;
import com.komorowski.backend.repository.EventRepository;
import com.komorowski.backend.repository.MyUserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

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

}
