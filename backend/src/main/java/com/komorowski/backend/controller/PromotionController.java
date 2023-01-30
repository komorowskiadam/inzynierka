package com.komorowski.backend.controller;

import com.komorowski.backend.model.Promotion;
import com.komorowski.backend.model.dto.CreatePromotionDto;
import com.komorowski.backend.model.dto.EditPromotionDto;
import com.komorowski.backend.model.dto.client.PromotionDto;
import com.komorowski.backend.service.PromotionService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("promotions")
@RequiredArgsConstructor
public class PromotionController {

    private final PromotionService promotionService;

    @PostMapping
    public ResponseEntity<Promotion> createPromotion(@RequestBody CreatePromotionDto dto) {
        return promotionService.createPromotion(dto);
    }

    @GetMapping
    public ResponseEntity<List<PromotionDto>> getAllPromotions() {
        return promotionService.getAllPromotions();
    }

    @GetMapping("/{creatorId}")
    public ResponseEntity<List<Promotion>> getCreatorsPromotions(@PathVariable Long creatorId) {
        return promotionService.getCreatorPromotions(creatorId);
    }

    @PatchMapping("/{id}")
    public ResponseEntity<Promotion> editPromotion(@PathVariable Long id, @RequestBody EditPromotionDto dto) {
        return promotionService.editPromotion(id, dto);
    }

    @GetMapping("{id}/visit")
    public ResponseEntity<?> visitPromotion(@PathVariable Long id) {
        return this.promotionService.visitPromotion(id);
    }

}
