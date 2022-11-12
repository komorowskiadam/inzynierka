import { Injectable } from "@angular/core";
import { Actions, createEffect, ofType } from "@ngrx/effects";
import { ToastrService } from "ngx-toastr";
import { Store } from "@ngrx/store";
import { EventService } from "../../services/event.service";
import {
  addEventError,
  addEventSuccess, editEventError, editEventSuccess,
  EventActionTypes,
  getEventError,
  getEventSuccess,
  getUserEventsError,
  getUserEventsSuccess
} from "./events.actions";
import { catchError, map, of, switchMap } from "rxjs";
import { CreateEventDto } from "../../dto/Dtos";
import { Router } from "@angular/router";

@Injectable({providedIn: 'root'})
export class EventsEffects {

  getEvent$ = createEffect(() => this.actions$.pipe(
    ofType(EventActionTypes.GET_EVENT),
    switchMap(({id}) => this.eventService.getEventById(id).pipe(
      map(event => getEventSuccess({event})),
      catchError(err => {
        this.toastr.error("Could not get event. Error: " + err.message);
        return of(getEventError({message: err.message}));
      })
    ))
  ));

  getUserEvents$ = createEffect(() => this.actions$.pipe(
    ofType(EventActionTypes.GET_USER_EVENTS),
    switchMap(({userId}) => this.eventService.getAllUserEvents(userId).pipe(
      map(events => getUserEventsSuccess({events})),
      catchError(err => {
        this.toastr.error("Could not get your events. Error: " + err.message);
        return of(getUserEventsError({message: err.message}));
      })
    ))
  ));

  addEvent$ = createEffect(() => this.actions$.pipe(
    ofType(EventActionTypes.ADD_EVENT),
    switchMap(({createEventDto}) => this.eventService.createEvent(createEventDto).pipe(
      map(event => {
        this.router.navigate(['/event/' + event.id]);
        this.toastr.success("Event created successfully.");
        return addEventSuccess({event});
      }),
      catchError(err => {
        this.toastr.error("Could not create event. Error: " + err.message);
        return of(addEventError({message: err.message}));
      })
    ))
  ));

  editEvent$ = createEffect(() => this.actions$.pipe(
    ofType(EventActionTypes.EDIT_EVENT),
    switchMap(({editEventDto, id}) => this.eventService.editEvent(id, editEventDto).pipe(
      map(event => {
        this.toastr.success("Event edited successfully.");
        return editEventSuccess({event});
      }),
      catchError(err => {
        this.toastr.error("Could not edit event. Error: " + err.message);
        return of(editEventError({message: err.message}));
      })
    ))
  ))

  constructor(private actions$: Actions,
              private toastr: ToastrService,
              private store$: Store,
              private eventService: EventService,
              private router: Router) {}
}