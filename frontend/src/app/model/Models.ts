export interface MyEvent {
  id: number;
  organizer: Creator;
  name: string;
  participants: MyUser[];
  interested: MyUser[];
  ticketPools: TicketPool[];
  posts: EventPost[];
  location: string;
  description: string;
  timeStart: string;
  dateStart: string;
  timeEnd?: string;
  dateEnd?: string;
  imageId?: number;
  category: EventCategory;
}

export interface MyUser {
  id: number;
  name: string;
  surname: string;
}

export interface Creator {
  id: number;
  name: string;
  description: string;
}

export interface Ticket {
  id: number;
  price: number;
  status: TicketStatus;
  seatNumber?: number;
}

export interface TicketPool {
  id: number;
  tickets: Ticket[];
  name: string;
  status: TicketPoolStatus;
  seatReservation: boolean;
  imageId?: number;
}

export enum TicketStatus {
  AVAILABLE = 'AVAILABLE',
  SOLD = 'SOLD'
}

export enum TicketPoolStatus {
  ACTIVE = 'ACTIVE',
  INACTIVE = 'INACTIVE',
  SOLD_OUT = 'SOLD_OUT'
}

export const TicketPoolStatus2LabelMapping: Record<TicketPoolStatus, string> = {
  [TicketPoolStatus.ACTIVE]: "Active",
  [TicketPoolStatus.INACTIVE]: "Inactive",
  [TicketPoolStatus.SOLD_OUT]: "Sold out",
}

export interface EventPost {
  id: number;
  date: string;
  content: string;
  author: MyUser;
  likes: any[];
}

export interface Promotion {
  id: number;
  event: MyEvent;
  dateStart: string;
  dateEnd: string;
  status: PromotionStatus;
  visits: number;
  payed: boolean;
  value?: number;
}

export enum PromotionStatus {
  PENDING = "PENDING",
  ACTIVE = "ACTIVE",
  PAUSED = "PAUSED",
  INACTIVE = "INACTIVE",
}

export const PromotionStatus2LabelMapping: Record<PromotionStatus, string> = {
  [PromotionStatus.PENDING]: "Pending",
  [PromotionStatus.ACTIVE]: "Active",
  [PromotionStatus.PAUSED]: "Paused",
  [PromotionStatus.INACTIVE]: "Inactive"
}

export enum EventCategory {
  PARTY = "PARTY",
  CONCERT = "CONCERT",
  SPORT = "SPORT",
  FOR_KIDS = "FOR_KIDS",
  CABARET = "CABARET",
  CINEMA = "CINEMA",
  OTHER = "OTHER"
}

export const EventCategory2LabelMapping: Record<EventCategory, string> = {
  [EventCategory.PARTY]: "Party",
  [EventCategory.CONCERT]: "Concert",
  [EventCategory.SPORT]: "Sport",
  [EventCategory.FOR_KIDS]: "For kids",
  [EventCategory.CABARET]: "Cabaret",
  [EventCategory.CINEMA]: "Cinema",
  [EventCategory.OTHER]: "Other",
}
