package com.sourcing.sourcingimm.controller;


import com.sourcing.sourcingimm.models.DTOs.StudentUserCreationRequest;
import com.sourcing.sourcingimm.models.DTOs.StudentUserCreationResponse;
import com.sourcing.sourcingimm.utils.exception.DuplicateResourceException;
import com.sourcing.sourcingimm.utils.exception.UserCreationException;
import com.sourcing.sourcingimm.utils.exception.ValidationException;

import com.sourcing.sourcingimm.models.DTOs.EnterPriseUserCreationRequest;
import com.sourcing.sourcingimm.models.DTOs.EnterpriseUserCreationResponse;
import com.sourcing.sourcingimm.models.UserModel;
import com.sourcing.sourcingimm.services.UserCreateCompleteService;
import com.sourcing.sourcingimm.services.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/")
@Tag(name = "Users", description = "Management of users")
@Slf4j
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private UserCreateCompleteService userCreate;

    @PostMapping("/new/company")
    @Operation(summary = "Create a new company")
    public ResponseEntity<EnterpriseUserCreationResponse> createCompany(
            @Valid @RequestBody EnterPriseUserCreationRequest request) {

        try {
            EnterpriseUserCreationResponse response =
                    userCreate.createCompanyUser(request);

            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (UserCreationException e) {
            if (e.getCause() instanceof DuplicateResourceException) {
                return ResponseEntity.status(HttpStatus.CONFLICT)
                        .body(EnterpriseUserCreationResponse.builder()
                                .message("User already exists")
                                .build());
            }
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(EnterpriseUserCreationResponse.builder()
                            .message(e.getMessage())
                            .build());
        } catch (ValidationException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(EnterpriseUserCreationResponse.builder()
                            .message("Validation error: " + e.getMessage())
                            .build());
        } catch (Exception e) {
            log.error("Unexpected error in createCompany", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(EnterpriseUserCreationResponse.builder()
                            .message("Internal server error")
                            .build());
        }
    }

    @PostMapping("/new/student")
    @Operation(summary = "Create a new student")
    public ResponseEntity<StudentUserCreationResponse> createStudent(
            @Valid @RequestBody StudentUserCreationRequest request
    ) {
        try {
            StudentUserCreationResponse response =
                    userCreate.createStudentUser(request);

            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (UserCreationException e) {
            if (e.getCause() instanceof DuplicateResourceException) {
                return ResponseEntity.status(HttpStatus.CONFLICT)
                        .body(StudentUserCreationResponse.builder()
                                .message("User already exists")
                                .build());
            }
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(StudentUserCreationResponse.builder()
                            .message(e.getMessage())
                            .build());
        } catch (ValidationException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(StudentUserCreationResponse.builder()
                            .message("Validation error: " + e.getMessage())
                            .build());
        } catch (Exception e) {
            log.error("Unexpected error in createCompany", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(StudentUserCreationResponse.builder()
                            .message("Internal server error")
                            .build());
        }
    }

    @GetMapping
    @Operation(summary = "List users")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<UserModel>> getAllUsers() {
        List<UserModel> users = userService.getAllUsers();
        return ResponseEntity.ok(users);
    }

    @GetMapping("/email/{email}")
    @Operation(summary = "Get a user by email")
//    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<UserModel> getUserByEmail(@PathVariable String email) {
        UserModel user = userService.getUserByEmail(email);
        return ResponseEntity.ok(user);
    }


    @PutMapping("/{email}")
    @Operation(summary = "Update user")
    public ResponseEntity<UserModel> updateUser(
            @PathVariable String email,
            @Valid @RequestBody UserModel user
    ) {
        UserModel updatedUser = userService.updateUser(email, user);
        return ResponseEntity.ok(updatedUser);
    }

    @GetMapping("/role/{roleName}")
    @Operation(summary = "Get user by role")
    public ResponseEntity<List<UserModel>> getUsersByRole(@PathVariable String roleName) {
        List<UserModel> users = userService.getUsersByRole(roleName);
        return ResponseEntity.ok(users);
    }
}
