package com.sourcing.sourcingimm.services;

import com.sourcing.sourcingimm.generated.user_management.tables.User;
import com.sourcing.sourcingimm.utils.exception.DuplicateResourceException;
import com.sourcing.sourcingimm.models.UserModel;
import com.sourcing.sourcingimm.models.entities.UserEntity;
import com.sourcing.sourcingimm.models.mappers.UserMappers;
import com.sourcing.sourcingimm.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.webmvc.ResourceNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
@Transactional
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserMappers userMappers;


    @Transactional(readOnly = true)
    public List<UserModel> getAllUsers() {
        List<UserEntity> entities = userRepository.findAll();
        return userMappers.entitiesToModels(entities);
    }


    @Transactional(readOnly = true)
    public UserModel getUserByEmail(String email) {
        UserEntity entity = userRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with email " + email));
        return userMappers.entityToModel(entity);
    }

    public UserModel createUser(UserModel user) {
        if (userRepository.existsByEmail(user.getEmail())) {
            throw new DuplicateResourceException();

        }

        UserEntity entity = userMappers.modelToEntity(user);


        entity.setHasPremium(false);
        entity.setIsActivated(false);

        UserEntity savedEntity = userRepository.save(entity);
        return userMappers.entityToModel(savedEntity);
    }

    public UserModel updateUser(String email, UserModel userModel){
        UserEntity existingEntity = userRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with email " + email));

        userMappers.updateEntityFromModel(userModel, existingEntity);


        UserEntity savedEntity = userRepository.save(existingEntity);
        return userMappers.entityToModel(savedEntity);
    }

    @Transactional(readOnly = true)
    public List<UserModel> getUsersByRole(UUID roleId) {
        List<UserEntity> entities = userRepository.findByRoleId(roleId);
        return userMappers.entitiesToModels(entities);
    }
}
