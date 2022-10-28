import { Injectable } from '@angular/core';
import { HttpClient } from "@angular/common/http";
import { Observable } from "rxjs";
import { JwtResponse, LoginData, RegisterData, RegisterResponse } from "../dto/Dtos";
import { TokenStorageService } from "./token-storage.service";

const backendAddress = 'http://localhost:8080';

@Injectable({
  providedIn: 'root'
})
export class AuthService {

  constructor(private http: HttpClient,
              private tokenStorage: TokenStorageService ) { }

  login(loginData: LoginData): Observable<JwtResponse> {
    return this.http.post<JwtResponse>(backendAddress + '/auth' + '/login', loginData);
  }

  register(registerData: RegisterData): Observable<RegisterResponse> {
    return this.http.post<RegisterResponse>(backendAddress + '/auth' + '/signup', registerData);
  }

  isUser(): boolean {
    let is = false;
    if (this.tokenStorage.getToken()) {
      let roles = this.tokenStorage.getAuthorities();
      roles.every(role => {
        if (role === 'ROLE_ADMIN' || role === 'ROLE_USER') {
          is = true;
        }
      });
    }
    return is;
  }

  isAdmin(): boolean {
    let is = false;
    if (this.tokenStorage.getToken()) {
      let roles = this.tokenStorage.getAuthorities();
      roles.every(role => {
        if (role === 'ROLE_ADMIN') {
          is = true
        }
      });
    }
    return is;
  }

}
