import { Component, OnInit } from '@angular/core';
import { TokenStorageService } from "../../services/token-storage.service";
import { Router } from "@angular/router";

@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.scss']
})
export class HeaderComponent implements OnInit {

  constructor(public tokenStorage: TokenStorageService,
              private router: Router) { }

  ngOnInit(): void {
  }

  logout(){
    this.tokenStorage.clear();
    this.router.navigate(['/']);
  }

}
