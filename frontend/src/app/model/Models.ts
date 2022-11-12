export interface MyEvent {
  id: number;
  organizer: Creator;
  name: string;
  participants: MyUser[];
  interested: MyUser[];
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
