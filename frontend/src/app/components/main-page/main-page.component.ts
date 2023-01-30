import { Component, OnInit } from '@angular/core';
import { TokenStorageService } from "../../services/token-storage.service";
import { Router } from "@angular/router";
import { Creator } from "../../model/Models";
import { AuthService } from "../../services/auth.service";

@Component({
  selector: 'app-main-page',
  templateUrl: './main-page.component.html',
  styleUrls: ['./main-page.component.scss']
})
export class MainPageComponent implements OnInit {

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
