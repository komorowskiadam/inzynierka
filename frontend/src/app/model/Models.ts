export interface MyEvent {
  id: number;
  organizer: Creator;
  name: string;
  participants: MyUser[];
  interested: MyUser[];
  ticketPools: TicketPool[];
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
}

export interface TicketPool {
  id: number;
  tickets: Ticket[];
  name: string;
  status: TicketPoolStatus;
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
