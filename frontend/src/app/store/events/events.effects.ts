import { Injectable } from "@angular/core";
import { Actions, createEffect, ofType } from "@ngrx/effects";
import { ToastrService } from "ngx-toastr";
import { Store } from "@ngrx/store";
import { EventService } from "../../services/event.service";
import {
  addEvent,
  addEventError,
  addEventSuccess, createTicketPoolError, createTicketPoolSuccess, editEventError, editEventSuccess,
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
  ));

  createTicketPool$ = createEffect(() => this.actions$.pipe(
    ofType(EventActionTypes.CREATE_TICKET_POOL),
    switchMap(({eventId, createTicketPoolDto}) => this.eventService.createTicketPool(eventId, createTicketPoolDto).pipe(
      map(event => {
        this.toastr.success("Ticket pool created successfully.");
        return createTicketPoolSuccess({event});
      }),
      catchError(err => {
        this.toastr.error("Could not create ticket pool. Error: " + err.message);
        return of(createTicketPoolError({message: err.message}));
      })
    ))
  ));

  changeTicketPoolStatus$ = createEffect(() => this.actions$.pipe(
    ofType(EventActionTypes.CHANGE_TICKET_POOL_STATUS),
    switchMap(({eventId, poolId, status}) => this.eventService.editTicketPool(eventId, poolId, status).pipe(
      map(event => {
        this.toastr.success("Ticket pool status changed successfully.");
        return editEventSuccess({event});
      }),
      catchError(err => {
        this.toastr.error("Could not change pool status. Error: " + err.error);
        return of(editEventError({message: err.error}));
      })
    ))
  ));

  changeTicketPoolQuantity$ = createEffect(() => this.actions$.pipe(
    ofType(EventActionTypes.CHANGE_TICKET_POOL_QUANTITY),
    switchMap(({eventId, poolId, quantity}) => this.eventService.changeTicketPoolQuantity(eventId, poolId, quantity).pipe(
      map(event => {
        this.toastr.success("Tickets quantity in pool changed successfully.");
        return editEventSuccess({event});
      }),
      catchError(err => {
        this.toastr.error("Could not change ticket quantity in pool. Error: " + err.error);
        return of(editEventError({message: err.error}));
      })
    ))
  ));

  createEventPost$ = createEffect(() => this.actions$.pipe(
    ofType(EventActionTypes.CREATE_EVENT_POST),
    switchMap(({eventId, dto}) => this.eventService.createEventPost(eventId, dto).pipe(
      map(event => {
        this.toastr.success("Post created successfully.");
        return editEventSuccess({event});
      }),
      catchError(err => {
        this.toastr.error("Could not create post. Error: " + err.error);
        return of(editEventError({message: err.error}));
      })
    ))
  ));

  addEventImage$ = createEffect(() => this.actions$.pipe(
    ofType(EventActionTypes.ADD_EVENT_IMAGE),
    switchMap(({eventDto, image}: {eventDto: CreateEventDto, image: FormData}) => this.eventService.uploadImage(image).pipe(
      map((imageId) => {
        return addEvent({createEventDto: {...eventDto, imageId}});
      }),
      catchError(err => {
        this.toastr.error("Could not upload image. Error: " + err.message);
        return of(addEventError({message: err.message}))
      })
    ))
  ));

  constructor(private actions$: Actions,
              private toastr: ToastrService,
              private store$: Store,
              private eventService: EventService,
              private router: Router) {}
}
