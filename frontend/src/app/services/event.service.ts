import { Injectable } from '@angular/core';
import { HttpClient } from "@angular/common/http";
import {
  ChangeTicketPoolQuantityDto,
  ChangeTicketPoolStatusDto,
  CreateEventDto,
  CreateTicketPoolDto,
  EditEventDto
} from "../dto/Dtos";
import { Observable } from "rxjs";
import { MyEvent } from "../model/Models";


const backendAddress = 'http://localhost:8080';

@Injectable({
  providedIn: 'root'
})
export class EventService {

  constructor(private http: HttpClient) { }

  createEvent(createEventDto: CreateEventDto): Observable<MyEvent> {
    return this.http.post<MyEvent>(backendAddress + "/events" + "/create", createEventDto);
  }

  getAllUserEvents(id: number): Observable<MyEvent[]> {
    return this.http.get<MyEvent[]>(backendAddress + "/events" + "/user/" + id)
  }

  getEventById(id: number): Observable<MyEvent> {
    return this.http.get<MyEvent>(backendAddress + "/events" + "/" + id);
  }

  editEvent(id: number, editEventDto: EditEventDto): Observable<MyEvent> {
    return this.http.patch<MyEvent>(backendAddress + "/events" + "/edit/" + id, editEventDto);
  }

  createTicketPool(eventId: number, createTicketPoolDto: CreateTicketPoolDto) : Observable<MyEvent> {
    return this.http.post<MyEvent>(backendAddress + "/events/" + eventId + "/createPool", createTicketPoolDto);
  }

  changeTicketPoolStatus(eventId: number, poolId: number, status: ChangeTicketPoolStatusDto): Observable<MyEvent> {
    return this.http.post<MyEvent>(backendAddress + "/events/" + eventId + "/changePoolStatus/" + poolId, status);
  }

  changeTicketPoolQuantity(eventId: number, poolId: number, quantity: ChangeTicketPoolQuantityDto): Observable<MyEvent> {
    return this.http.post<MyEvent>(backendAddress + "/events/" + eventId + "/changeTicketsQuantity/" + poolId, quantity);
  }

}
