import { Injectable } from '@angular/core';

const TOKEN_KEY = 'token';
const USERNAME_KEY = 'username';
const AUTHORITIES_KEY = 'roles';
const ID_KEY = 'id';

@Injectable({
  providedIn: 'root'
})
export class TokenStorageService {

  private roles: Array<String> = [];

  constructor() {
  }

  public saveToken(token: string) {
    window.sessionStorage.removeItem(TOKEN_KEY);
    window.sessionStorage.setItem(TOKEN_KEY, token);
  }

  public getToken(): string {
    return <string>window.sessionStorage.getItem(TOKEN_KEY);
  }

  public saveUsername(username: string) {
    window.sessionStorage.removeItem(USERNAME_KEY);
    window.sessionStorage.setItem(USERNAME_KEY, username);
  }

  public getUsername(): string {
    return <string>sessionStorage.getItem(USERNAME_KEY);
  }

  public saveId(id: number) {
    window.sessionStorage.removeItem(ID_KEY);
    window.sessionStorage.setItem(ID_KEY,id as unknown as string);
  }

  public getId(): number {
    return sessionStorage.getItem(ID_KEY) as unknown as number;
  }

  public saveAuthorities(authorities: string[]) {
    window.sessionStorage.removeItem(AUTHORITIES_KEY);
    window.sessionStorage.setItem(AUTHORITIES_KEY, JSON.stringify(authorities));
  }

  public getAuthorities(): string[] {
    this.roles = [];

    if (sessionStorage.getItem(TOKEN_KEY)) {
      let array = JSON.parse(<string>sessionStorage.getItem(AUTHORITIES_KEY));
      for(let i in array){
        this.roles.push(array[i]);
      }
    }

    return <string[]>this.roles;
  }

  clear(): void {
    window.sessionStorage.clear();
  }
}
