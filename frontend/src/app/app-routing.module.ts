import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { WelcomePageComponent } from "./components/welcome-page/welcome-page.component";
import { LoginComponent } from "./components/login/login.component";
import { RegisterComponent } from "./components/register/register.component";
import { MainPageComponent } from "./components/main-page/main-page.component";
import { CreateEventComponent } from "./components/create-event/create-event.component";
import { EventDetailsComponent } from "./components/event-details/event-details.component";

const routes: Routes = [
  { path: '', component: WelcomePageComponent },
  { path: 'login', component: LoginComponent },
  { path: 'register', component: RegisterComponent },
  { path: 'main-page', component: MainPageComponent },
  { path: 'create-event', component: CreateEventComponent },
  { path: 'event/:id', component: EventDetailsComponent },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
