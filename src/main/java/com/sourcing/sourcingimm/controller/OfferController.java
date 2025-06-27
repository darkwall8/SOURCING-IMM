package com.sourcing.sourcingimm.controller;

import com.sourcing.sourcingimm.models.OfferModel;
import com.sourcing.sourcingimm.services.OfferService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/offer")
@Tag(name = "Offer", description = "Management of offer")
@Slf4j
public class OfferController {

    @Autowired
    private OfferService offerService;

    @PostMapping("/all")
    @Operation(summary = "get all offers")
    public ResponseEntity<List<OfferModel>> getAllOffers() {
        try {
            List<OfferModel> entities = offerService.getAllOffers();

            return entities.isEmpty() ? ResponseEntity.noContent().build() : ResponseEntity.ok(entities);
        } catch (Exception e) {
            log.error(e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PostMapping("/new")
    @Operation(summary = "Create a new candidacy")
    public ResponseEntity<OfferModel> createCandidacy(@RequestBody OfferModel model) {

        try {
            OfferModel createOffer = offerService.createCandidacy(model);

            return ResponseEntity.status(HttpStatus.CREATED).body(createOffer);
        } catch (Exception e) {
            log.error(e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(null);
        }
    }

    @PutMapping("/update/{id}")
    @Operation(summary = "Update offer")
    private ResponseEntity<OfferModel> updateOffer(@RequestBody OfferModel model, @PathVariable UUID id) {
        OfferModel updateOffer = offerService.updateOffer(id ,model);
        return ResponseEntity.ok(updateOffer);
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get candidacy by id")
    public ResponseEntity<OfferModel> getOfferById(@PathVariable UUID id) {
        OfferModel offerModel = offerService.getOfferById(id);
        return ResponseEntity.ok(offerModel);
    }

}
