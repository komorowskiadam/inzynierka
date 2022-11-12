import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators } from "@angular/forms";
import { Router } from "@angular/router";
import { AuthService } from "../../services/auth.service";
import { RegisterData } from "../../dto/Dtos";
import { catchError } from "rxjs";

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.scss']
})
export class RegisterComponent implements OnInit {

  registerForm = this.formBuilder.group({
    username: ['', [Validators.required, Validators.minLength(4)]],
    password: ['', [ Validators.required, Validators.minLength(4)]],
    name: ['', [ Validators.required, Validators.minLength(3)]],
    description: ['', Validators.required],
  });

  errorMessage = "";
  successMessage = "";

  constructor(private formBuilder: FormBuilder,
              private router: Router,
              private authService: AuthService) { }

  ngOnInit(): void {
  }

  register() {
    let registerData: RegisterData = {
      username: this.registerForm.value.username || "",
      password: this.registerForm.value.password || "",
      roles: ['creator'],
      name: this.registerForm.value.name || "",
      description: this.registerForm.value.description || "",
    }

    this.authService.register(registerData).subscribe(response => {
      this.successMessage =  response.message;
    });
  }

}
