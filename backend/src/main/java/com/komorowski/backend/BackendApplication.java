package com.komorowski.backend;

import com.komorowski.backend.model.enums.ERole;
import com.komorowski.backend.model.MyRole;
import com.komorowski.backend.repository.RoleRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class BackendApplication {

    public static void main(String[] args) {
        SpringApplication.run(BackendApplication.class, args);
    }

    @Bean
    public CommandLineRunner roleData(RoleRepository roleRepository){

        MyRole roleUser = new MyRole(ERole.ROLE_USER);
        MyRole roleCreator = new MyRole(ERole.ROLE_CREATOR);

        if(roleRepository.findByName(ERole.ROLE_CREATOR).isPresent() || roleRepository.findByName(ERole.ROLE_USER).isPresent()){
            return args -> {};
        }

        return args -> {
            roleRepository.save(roleUser);
            roleRepository.save(roleCreator);
        };
    }

}
