import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators } from "@angular/forms";
import { CreateEventDto } from "../../dto/Dtos";
import { TokenStorageService } from "../../services/token-storage.service";
import { EventService } from "../../services/event.service";
import { Router } from "@angular/router";
import { Store } from "@ngrx/store";
import { addEvent } from "../../store/events/events.actions";

@Component({
  selector: 'app-create-event',
  templateUrl: './create-event.component.html',
  styleUrls: ['./create-event.component.scss']
})
export class CreateEventComponent implements OnInit {

  createEventForm = this.formBuilder.group({
    name: ['', [Validators.required, Validators.minLength(5)]],
    description: ['', Validators.required]
  });

  constructor(private formBuilder: FormBuilder,
              private tokenStorage: TokenStorageService,
              private eventService: EventService,
              private router: Router,
              private store$: Store) { }

  ngOnInit(): void {
  }

  createEvent() {
    let name = this.createEventForm.value.name;
    let description = this.createEventForm.value.description;

    if(!name || !description) return;

    let createEventDto: CreateEventDto = {
      name,
      organizerId: this.tokenStorage.getId(),
      description
    }

    this.store$.dispatch(addEvent({createEventDto}));
  }

}
