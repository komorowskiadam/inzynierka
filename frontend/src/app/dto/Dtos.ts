export interface LoginData {
  username: string;
  password: string;
}

export interface RegisterData {
  username: string;
  password: string;
  roles: string[];
}

export interface RegisterResponse {
  message: string;
}

export interface JwtResponse {
  ranks: string;
  token: string;
  type: string;
  username: string;
  roles: string[];
}

