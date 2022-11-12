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
}

export interface EditEventDto {
  name: string;
}
