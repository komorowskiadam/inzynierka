package com.komorowski.backend;

import com.komorowski.backend.model.ERole;
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
        MyRole roleAdmin = new MyRole(ERole.ROLE_ADMIN);

        return args -> {
            roleRepository.save(roleUser);
            roleRepository.save(roleAdmin);
        };
    }

}
