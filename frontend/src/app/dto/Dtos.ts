import { PromotionStatus, TicketPoolStatus } from "../model/Models";

export interface LoginData {
  username: string;
  password: string;
}

export interface RegisterData {
  username: string;
  password: string;
  roles: string[];
  name: string;
  description: string;
}

export interface RegisterResponse {
  message: string;
}

export interface JwtResponse {
  id: number;
  token: string;
  username: string;
  roles: string[];
}

export interface CreateEventDto {
  organizerId: number;
  name: string;
  description: string;
  timeStart: string;
  dateStart: string;
  location: string;
  timeEnd?: string;
  dateEnd?: string;
  imageId?: number;
}

export interface EditEventDto {
  name: string;
  description: string;
  timeStart: string;
  dateStart: string;
  location: string;
  timeEnd?: string;
  dateEnd?: string;
}

export interface CreateTicketPoolDto {
  quantity: number;
  price: number;
  poolName: string;
  startSeatNumber?: number;
}

export interface EditTicketPoolDto {
  status: TicketPoolStatus;
  name: string;
}

export interface ChangeTicketPoolQuantityDto {
  quantity: number;
}

export interface CreateEventPostDto {
  authorId: number;
  date: string;
  content: string;
}

export interface CreatePromotionDto {
  eventId: number;
  dateStart?: string | null;
  dateEnd: string;
}

export interface EditPromotionDto {
  status?: PromotionStatus | null;
  dateStart?: string | null;
  dateEnd?: string | null;
}
