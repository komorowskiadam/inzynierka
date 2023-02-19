import { Injectable } from '@angular/core';
import { HttpClient } from "@angular/common/http";
import {
  ChangeTicketPoolQuantityDto,
  EditTicketPoolDto,
  CreateEventDto,
  CreateTicketPoolDto,
  EditEventDto, CreateEventPostDto, CreatePromotionDto, EditPromotionDto
} from "../dto/Dtos";
import { Observable } from "rxjs";
import { MyEvent, Promotion } from "../model/Models";


export const backendAddress = 'http://localhost:8080';

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

  editTicketPool(eventId: number, poolId: number, status: EditTicketPoolDto): Observable<MyEvent> {
    return this.http.patch<MyEvent>(backendAddress + "/events/" + eventId + "/editTicketPool/" + poolId, status);
  }

  changeTicketPoolQuantity(eventId: number, poolId: number, quantity: ChangeTicketPoolQuantityDto): Observable<MyEvent> {
    return this.http.patch<MyEvent>(backendAddress + "/events/" + eventId + "/changeTicketsQuantity/" + poolId, quantity);
  }

  createEventPost(eventId: number, dto: CreateEventPostDto): Observable<MyEvent> {
    return this.http.post<MyEvent>(backendAddress + "/events/" + eventId + "/addPost", dto);
  }

  uploadImage(imageData: any): Observable<number> {
    return this.http.post<number>(backendAddress + "/images", imageData);
  }

  createPromotion(dto: CreatePromotionDto): Observable<Promotion> {
    return this.http.post<Promotion>(backendAddress + "/promotions", dto);
  }

  getUserPromotions(id: number): Observable<Promotion[]> {
    return this.http.get<Promotion[]>(backendAddress + "/promotions/" + id);
  }

  editPromotion(id: number, dto: EditPromotionDto): Observable<Promotion> {
    return this.http.patch<Promotion>(backendAddress + "/promotions/" + id, dto);
  }


  payByPaypal(amount: number): Observable<string> {
    return this.http.post<string>(backendAddress + "/orders?totalAmount=" + amount, null);
  }

}
