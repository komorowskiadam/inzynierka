package com.komorowski.backend.model;

import com.komorowski.backend.model.enums.EventCategory;
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

    @Lob
    private String description;

    private String location;

    @OneToMany
    private List<MyUser> participants = Collections.emptyList();

    @OneToMany
    private List<MyUser> interested = Collections.emptyList();

    @OneToMany
    private List<MyUser> likes = Collections.emptyList();

    @OneToMany
    private List<TicketPool> ticketPools = Collections.emptyList();;

    @OneToMany
    private List<EventPost> posts = Collections.emptyList();

    private String dateStart;
    private String dateEnd;
    private String timeStart;
    private String timeEnd;

    private Long imageId;

    private EventCategory category;

}
