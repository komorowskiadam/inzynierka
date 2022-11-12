import { Injectable } from '@angular/core';
import { HttpClient } from "@angular/common/http";
import { CreateEventDto, EditEventDto } from "../dto/Dtos";
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

}
