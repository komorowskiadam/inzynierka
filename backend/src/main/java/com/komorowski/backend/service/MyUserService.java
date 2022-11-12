package com.komorowski.backend.service;

import com.komorowski.backend.model.ERole;
import com.komorowski.backend.model.MyRole;
import com.komorowski.backend.model.MyUser;
import com.komorowski.backend.repository.MyUserRepository;
import com.komorowski.backend.repository.RoleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class MyUserService {

    private final MyUserRepository myUserRepository;

    private final RoleRepository roleRepository;

    public boolean isUser(MyUser user) {
        MyRole userRole = roleRepository.findByName(ERole.ROLE_USER)
                .orElseThrow(() -> new RuntimeException("Error: Role is not found."));

        return user.getRoles().contains(userRole);
    }

    public boolean isCreator(MyUser user) {
        MyRole creatorRole = roleRepository.findByName(ERole.ROLE_CREATOR)
                .orElseThrow(() -> new RuntimeException("Error: Role is not found."));

        return user.getRoles().contains(creatorRole);
    }
}
