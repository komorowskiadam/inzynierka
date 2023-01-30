import { Component, OnInit } from '@angular/core';
import { Creator } from "../../model/Models";
import { TokenStorageService } from "../../services/token-storage.service";
import { Router } from "@angular/router";
import { AuthService } from "../../services/auth.service";

@Component({
  selector: 'app-user-details',
  templateUrl: './user-details.component.html',
  styleUrls: ['./user-details.component.scss']
})
export class UserDetailsComponent implements OnInit {

  creator: Creator = {} as unknown as Creator;

  constructor(private tokenStorage: TokenStorageService,
              private router:  Router,
              private authService: AuthService) { }

  ngOnInit(): void {
    this.authService.getUserById(this.tokenStorage.getId()).subscribe(res => {
      this.creator = res;
    });
  }

}
