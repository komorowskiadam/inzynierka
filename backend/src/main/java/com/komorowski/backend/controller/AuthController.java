package com.komorowski.backend.controller;

import com.komorowski.backend.model.enums.ERole;
import com.komorowski.backend.model.MyRole;
import com.komorowski.backend.model.MyUser;
import com.komorowski.backend.payload.request.LoginRequest;
import com.komorowski.backend.payload.request.SignupRequest;
import com.komorowski.backend.payload.response.JwtResponse;
import com.komorowski.backend.payload.response.MessageResponse;
import com.komorowski.backend.repository.MyUserRepository;
import com.komorowski.backend.repository.RoleRepository;
import com.komorowski.backend.security.jwt.JwtUtils;
import com.komorowski.backend.security.services.UserDetailsImpl;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthenticationManager authenticationManager;

    private final MyUserRepository myUserRepository;

    private final RoleRepository roleRepository;

    private final PasswordEncoder encoder;

    private final JwtUtils jwtUtils;

    @PostMapping("/login")
    public ResponseEntity<?> authenticateUser(@Valid @RequestBody LoginRequest loginRequest) {

        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(loginRequest.getUsername(), loginRequest.getPassword()));

        SecurityContextHolder.getContext().setAuthentication(authentication);
        String jwt = jwtUtils.generateJwtToken(authentication);

        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        List<String> roles = userDetails.getAuthorities().stream()
                .map(item -> item.getAuthority())
                .collect(Collectors.toList());

        return ResponseEntity.ok(new JwtResponse(jwt,
                userDetails.getId(),
                userDetails.getUsername(),
                roles));
    }

    @PostMapping("/signup")
    public ResponseEntity<?> registerUser(@Valid @RequestBody SignupRequest signUpRequest) {
        if (myUserRepository.existsByUsername(signUpRequest.getUsername())) {
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Error: Username is already taken!"));
        }

        MyUser user = new MyUser(signUpRequest.getUsername(),
                encoder.encode(signUpRequest.getPassword()));

        Set<String> strRoles = signUpRequest.getRole();
        Set<MyRole> roles = new HashSet<>();

        if (strRoles == null) {
            MyRole userRole = roleRepository.findByName(ERole.ROLE_USER)
                    .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
            roles.add(userRole);
        } else {
            strRoles.forEach(role -> {
                if ("creator".equals(role)) {
                    MyRole creatorRole = roleRepository.findByName(ERole.ROLE_CREATOR)
                            .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
                    roles.add(creatorRole);

                    user.setName(signUpRequest.getName());
                    user.setDescription(signUpRequest.getDescription());
                } else {
                    MyRole userRole = roleRepository.findByName(ERole.ROLE_USER)
                            .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
                    roles.add(userRole);

                    user.setName(signUpRequest.getName());
                    user.setSurname(signUpRequest.getSurname());
                }
            });
        }

        user.setRoles(roles);
        myUserRepository.save(user);

        return ResponseEntity.ok(new MessageResponse("User registered successfully!"));
    }

    @GetMapping("users")
    public ResponseEntity<List<MyUser>> getAllUsers() {

        MyRole userRole = roleRepository.findByName(ERole.ROLE_USER)
                .orElseThrow(() -> new RuntimeException("Error: Role is not found."));

        List<MyUser> users = myUserRepository.findAll()
                .stream()
                .filter(myUser -> myUser.getRoles().contains(userRole))
                .toList();

        return ResponseEntity.ok(users);
    }

    @GetMapping("creators")
    public ResponseEntity<List<MyUser>> getAllCreators() {
        MyRole creatorRole = roleRepository.findByName(ERole.ROLE_CREATOR)
                .orElseThrow(() -> new RuntimeException("Error: Role is not found."));

        List<MyUser> users = myUserRepository.findAll()
                .stream()
                .filter(myUser -> myUser.getRoles().contains(creatorRole))
                .toList();

        return ResponseEntity.ok(users);
    }

    @GetMapping("users/{id}")
    public ResponseEntity<?> getUserById(@PathVariable Long id) {
        if(!myUserRepository.existsById(id)){
            return ResponseEntity.badRequest().body("No user with that id.");
        }
        MyUser user = myUserRepository.findById(id).get();

        return ResponseEntity.ok(user);
    }
}
