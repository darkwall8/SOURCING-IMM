package com.sourcing.sourcingimm.controller;

import com.sourcing.sourcingimm.models.UserModel;
import com.sourcing.sourcingimm.services.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/users")
@Tag(name = "Users", description = "Management of users")
public class UserController {

    @Autowired
    private UserService userService;

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

    @PostMapping
    @Operation(summary = "Create a new user")
    public ResponseEntity<UserModel> createUser(@Valid @RequestBody UserModel user) {
        UserModel createdUser = userService.createUser(user);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdUser);
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
