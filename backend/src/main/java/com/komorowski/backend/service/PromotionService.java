package com.komorowski.backend.service;

import com.komorowski.backend.model.Event;
import com.komorowski.backend.model.MyUser;
import com.komorowski.backend.model.Promotion;
import com.komorowski.backend.model.dto.CreatePromotionDto;
import com.komorowski.backend.model.dto.EditPromotionDto;
import com.komorowski.backend.model.dto.client.PromotionDto;
import com.komorowski.backend.model.enums.PromotionStatus;
import com.komorowski.backend.repository.EventRepository;
import com.komorowski.backend.repository.MyUserRepository;
import com.komorowski.backend.repository.PromotionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.List;

@Service
@RequiredArgsConstructor
public class PromotionService {

    private final PromotionRepository promotionRepository;

    private final EventRepository eventRepository;

    private final EventService eventService;

    private final MyUserRepository userRepository;

    public ResponseEntity<Promotion> createPromotion(CreatePromotionDto dto) {
        Event event = eventRepository.findById(dto.getEventId())
                .orElseThrow(() -> new RuntimeException("No event with that id."));

        if(promotionRepository.existsByEvent(event)){
            List<Promotion> promotions = promotionRepository.findByEvent(event);
            for(Promotion p: promotions){
                if(p.getStatus() != PromotionStatus.INACTIVE){
                    throw new RuntimeException("This event already have a promotion");
                }
            }
        }

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDate dateStart;
        LocalDate dateEnd;

        if(dto.getDateStart() != null) {
            dateStart = LocalDate.parse(dto.getDateStart(), formatter);
        } else {
            dateStart = LocalDate.now();
        }

        if(dto.getDateEnd() == null) {
            throw new RuntimeException("You have to specify the end date of promotion");
        }
        dateEnd = LocalDate.parse(dto.getDateEnd(), formatter);

        Promotion promotion = new Promotion();
        promotion.setDateStart(dateStart);
        promotion.setDateEnd(dateEnd);
        if(isDateToday(dateStart)){
            promotion.setStatus(PromotionStatus.ACTIVE);
        } else {
            promotion.setStatus(PromotionStatus.PENDING);
        }
        promotion.setEvent(event);

        promotionRepository.save(promotion);

        return ResponseEntity.ok(promotion);
    }

    @Transactional
    public ResponseEntity<List<Promotion>> getCreatorPromotions(Long creatorId) {

        MyUser user = userRepository.findById(creatorId)
                .orElseThrow(() -> new RuntimeException("No user with that id."));

        List<Event> events = eventRepository.findByOrganizer_Id(user.getId());

        List<Promotion> promotions = new java.util.ArrayList<>(Collections.emptyList());

        for(Event e: events) {
            if(promotionRepository.existsByEvent(e)){
                List<Promotion> promotionList = promotionRepository.findByEvent(e);
                promotions.addAll(promotionList);
            }
        }

        return ResponseEntity.ok(promotions);
    }

    public ResponseEntity<Promotion> editPromotion(Long id, EditPromotionDto dto) {
        if(!promotionRepository.existsById(id)){
            throw new RuntimeException("No promotion with that id.");
        }

        Promotion promotion = promotionRepository.findById(id).orElseThrow();

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        if(dto.getDateStart() != null) {
            LocalDate dateStart = LocalDate.parse(dto.getDateStart(), formatter);
            promotion.setDateStart(dateStart);
            if(isDateToday(dateStart)){
                promotion.setStatus(PromotionStatus.ACTIVE);
            }
        }
        if(dto.getDateEnd() != null) {
            LocalDate dateEnd = LocalDate.parse(dto.getDateEnd(), formatter);
            promotion.setDateEnd(dateEnd);
        }

        if(dto.getStatus() != null) {
            changePromotionStatus(promotion.getId(), dto.getStatus());
        }
        if(dto.isPayed()) {
            promotion.setPayed(true);
        }

        promotionRepository.save(promotion);

        return ResponseEntity.ok(promotion);
    }

    @Transactional
    public ResponseEntity<List<PromotionDto>> getAllPromotions() {
        List<PromotionDto> dtos =  promotionRepository.findAll()
                .stream()
                .filter(promotion -> promotion.getStatus().equals(PromotionStatus.ACTIVE))
                .map(this::getPromotionDto)
                .toList();

        return ResponseEntity.ok(dtos);
    }

    @Transactional
    public ResponseEntity<?> visitPromotion(Long id) {
        Promotion promotion = promotionRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("No promotion with that id."));

        promotion.setVisits(promotion.getVisits() + 1);
        promotionRepository.save(promotion);

        return ResponseEntity.ok("Promotion clicked");
    }

    public PromotionDto getPromotionDto(Promotion promotion) {
        PromotionDto dto = new PromotionDto();
        dto.setId(promotion.getId());
        dto.setEvent(eventService.getClientEventDto(promotion.getEvent()));

        return dto;
    }

    @Scheduled(cron = "0 0 0 * * ?")
    public void scheduleCheckPromotions() {
        List<Promotion> promotions = promotionRepository.findAll();

        for(Promotion p: promotions) {
            if(isDateToday(p.getDateStart())){
                p.setStatus(PromotionStatus.ACTIVE);
                promotionRepository.save(p);
                continue;
            }
            if(isDateToday(p.getDateEnd())) {
                p.setStatus(PromotionStatus.INACTIVE);
                promotionRepository.save(p);
            }
        }
    }

    private void changePromotionStatus(Long id, String status) {
        Promotion promotion = promotionRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("No promotion with that id."));

        PromotionStatus newStatus = PromotionStatus.valueOf(status);

        promotion.setStatus(newStatus);
        promotionRepository.save(promotion);
    }

    private boolean isDateToday(LocalDate date) {
        LocalDate now = LocalDate.now();
        return now.isEqual(date);
    }
}
