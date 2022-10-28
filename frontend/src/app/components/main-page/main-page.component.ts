import { Component, OnInit } from '@angular/core';
import { TokenStorageService } from "../../services/token-storage.service";
import { Router } from "@angular/router";

@Component({
  selector: 'app-main-page',
  templateUrl: './main-page.component.html',
  styleUrls: ['./main-page.component.scss']
})
export class MainPageComponent implements OnInit {

  constructor(private tokenStorage: TokenStorageService,
              private router:  Router) { }

  ngOnInit(): void {
  }

  logout(){
    this.tokenStorage.clear();
    this.router.navigate(['/']);
  }

}
