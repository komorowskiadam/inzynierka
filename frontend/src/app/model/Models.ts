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
