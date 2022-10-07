package com.komorowski.backend.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("events")
public class EventController {

    @GetMapping("user")
    public String getUser(){
        return "User";
    }

    @GetMapping("admin")
    public String getAdmin(){
        return "Admin";
    }

    @GetMapping("all")
    public String getAll(){
        return "All";
    }

}
