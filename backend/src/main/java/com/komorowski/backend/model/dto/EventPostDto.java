package com.komorowski.backend.model.dto;

import lombok.*;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class EventPostDto {
    private Long id;
    private String author;
    private List<Long> likes;
    private String content;
    private String date;
}
