package com.sourcing.sourcingimm.controller;

import com.sourcing.sourcingimm.models.CandidacyModel;
import com.sourcing.sourcingimm.models.CandidatureOfferModel;
import com.sourcing.sourcingimm.models.entities.CandidacyEntity;
import com.sourcing.sourcingimm.models.entities.CandidatureOfferEntity;
import com.sourcing.sourcingimm.services.CandidacyOfferService;
import com.sourcing.sourcingimm.services.CandidacyService;
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
@RequestMapping("/candidacy")
@Tag(name = "Candidature", description = "Management of candidacy")
@Slf4j
public class CandidacyController {

    @Autowired
    private CandidacyService candidacyService;

    @Autowired
    private CandidacyOfferService candidacyOfferService;

    @PostMapping("/all")
    @Operation(summary = "get all candidacy")
    public ResponseEntity<List<CandidacyModel>> getAllCandidacy() {
        try {
            List<CandidacyModel> entities = candidacyService.getAllCandidacy();

            return entities.isEmpty() ? ResponseEntity.noContent().build() : ResponseEntity.ok(entities);
        } catch (Exception e) {
            log.error(e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PostMapping("/new")
    @Operation(summary = "Create a new candidacy")
    public ResponseEntity<CandidacyModel> createCandidacy(@RequestBody CandidacyModel model) {

        try {
            CandidacyModel createdCandidacy = candidacyService.createCandidacy(model);

            return ResponseEntity.status(HttpStatus.CREATED).body(createdCandidacy);
        } catch (Exception e) {
            log.error(e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(null);
        }
    }

    @PutMapping("/update/{id}")
    @Operation(summary = "Update candidacy")
    private ResponseEntity<CandidacyModel> updateCandidacy(@RequestBody CandidacyModel model, @PathVariable UUID id) {
        CandidacyModel updatedCandidacy = candidacyService.updateCandidacy(id, model);
        return ResponseEntity.ok(updatedCandidacy);
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get candidacy by id")
    public ResponseEntity<CandidacyModel> getCandidacyById(@PathVariable UUID id) {
        CandidacyModel candidacyModel = candidacyService.getCandidacyById(id);
        return ResponseEntity.ok(candidacyModel);
    }

    @PostMapping("/offer/create")
    @Operation(summary = "Create candidacy offer")
    public ResponseEntity<CandidatureOfferModel> createCandidacyOffer(@RequestBody CandidatureOfferModel model) {
        try {
            CandidatureOfferModel createdCandidacy = candidacyOfferService.createCandidacy(model);

            return ResponseEntity.status(HttpStatus.CREATED).body(createdCandidacy);
        } catch (Exception e) {
            log.error(e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(null);
        }
    }


    @PutMapping("/offer/update/{offerId}/{candidacyId}")
    @Operation(summary = "Update candidacy")
    public ResponseEntity<CandidatureOfferModel> updateCandidacy(
            @RequestBody CandidatureOfferModel model,
            @PathVariable UUID offerId,
            @PathVariable UUID candidacyId) {

        CandidatureOfferModel updatedCandidacy = candidacyOfferService.updateCandidacy(offerId ,candidacyId, model);
        return ResponseEntity.ok(updatedCandidacy);
    }

    @PostMapping("/offer/all")
    @Operation(summary = "get all candidacyOffer")
    public ResponseEntity<List<CandidatureOfferModel>> getAllCandidacyOffer() {
        try {
            List<CandidatureOfferModel> entities = candidacyOfferService.findAll();

            return entities.isEmpty() ? ResponseEntity.noContent().build() : ResponseEntity.ok(entities);
        } catch (Exception e) {
            log.error(e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
