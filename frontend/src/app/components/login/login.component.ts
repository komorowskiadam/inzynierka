import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators } from "@angular/forms";
import { LoginData } from "../../dto/Dtos";
import { AuthService } from "../../services/auth.service";
import { TokenStorageService } from "../../services/token-storage.service";
import { Router } from "@angular/router";

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {

  loginForm = this.formBuilder.group({
    username: ['', [Validators.required, Validators.minLength(4)]],
    password: ['',[ Validators.required, Validators.minLength(4)]]
  });

  constructor(private formBuilder: FormBuilder,
              private authService: AuthService,
              private tokenStorage: TokenStorageService,
              private router: Router,) { }

  ngOnInit(): void {
    if(this.tokenStorage.getToken() && this.tokenStorage.getUsername()){
      this.router.navigate(['/main-page']);
    }
  }

  login() {
    this.authService.login(this.loginForm.value as unknown as LoginData).subscribe(response => {
      this.tokenStorage.saveToken(response.token);
      this.tokenStorage.saveUsername(response.username);
      this.tokenStorage.saveAuthorities(response.roles);
      this.tokenStorage.saveId(response.id);
      this.router.navigate(['/main-page']);
    });
  }

}
