package com.komorowski.backend.model.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CreateEventPostDto {
    private String content;
    private String date;
    private Long authorId;
}
