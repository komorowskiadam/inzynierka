import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { WelcomePageComponent } from "./components/welcome-page/welcome-page.component";
import { LoginComponent } from "./components/login/login.component";
import { RegisterComponent } from "./components/register/register.component";
import { MainPageComponent } from "./components/main-page/main-page.component";
import { CreateEventComponent } from "./components/create-event/create-event.component";
import { EventDetailsComponent } from "./components/event-details/event-details.component";
import { PromotionsComponent } from "./components/promotions/promotions.component";
import { UserDetailsComponent } from "./components/user-details/user-details.component";

const routes: Routes = [
  { path: '', redirectTo: 'login', pathMatch: 'full' },
  { path: 'login', component: LoginComponent },
  { path: 'register', component: RegisterComponent },
  { path: 'main-page', component: MainPageComponent },
  { path: 'create-event', component: CreateEventComponent },
  { path: 'event/:id', component: EventDetailsComponent },
  { path: 'promotions', component: PromotionsComponent },
  { path: 'user-details', component: UserDetailsComponent }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
