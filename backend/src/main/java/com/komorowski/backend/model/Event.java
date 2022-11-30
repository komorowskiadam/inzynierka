package com.komorowski.backend.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.util.Collections;
import java.util.List;

@Entity
@NoArgsConstructor
@Getter
@Setter
public class Event {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    @OneToOne
    private MyUser organizer;

    private String description;

    @OneToMany
    private List<MyUser> participants = Collections.emptyList();

    @OneToMany
    private List<MyUser> interested = Collections.emptyList();

    @OneToMany
    private List<TicketPool> ticketPools;

}
