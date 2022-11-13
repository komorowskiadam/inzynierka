import {NgModule} from '@angular/core';
import {BrowserModule} from '@angular/platform-browser';

import {AppRoutingModule} from './app-routing.module';
import {AppComponent} from './app.component';
import {LoginComponent} from './components/login/login.component';
import {BrowserAnimationsModule} from '@angular/platform-browser/animations';
import {MatFormFieldModule} from "@angular/material/form-field";
import {MatInputModule} from "@angular/material/input";
import {MatButtonModule} from "@angular/material/button";
import { WelcomePageComponent } from './components/welcome-page/welcome-page.component';
import { RegisterComponent } from './components/register/register.component';
import { httpInterceptorProviders } from "./services/http.interceptor";
import { ReactiveFormsModule } from "@angular/forms";
import { HttpClientModule } from "@angular/common/http";
import { MainPageComponent } from './components/main-page/main-page.component';
import { CreateEventComponent } from './components/create-event/create-event.component';
import { UserEventsListComponent } from './components/user-events-list/user-events-list.component';
import { EventDetailsComponent } from './components/event-details/event-details.component';
import { Store, StoreModule } from "@ngrx/store";
import { EffectsModule } from "@ngrx/effects";
import { ToastrModule } from "ngx-toastr";
import { eventsReducer } from "./store/events/events.reducer";
import { EventsEffects } from "./store/events/events.effects";
import { EditEventComponent } from './components/edit-event/edit-event.component';
import { MatDialogModule } from "@angular/material/dialog";
import { CreateTicketPoolComponent } from './components/create-ticket-pool/create-ticket-pool.component';
import { ChangeTicketPoolStatusComponent } from './components/change-ticket-pool-status/change-ticket-pool-status.component';
import { MatSelectModule } from "@angular/material/select";
import { ChangeTicketPoolQuantityComponent } from './components/change-ticket-pool-quantity/change-ticket-pool-quantity.component';

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    WelcomePageComponent,
    RegisterComponent,
    MainPageComponent,
    CreateEventComponent,
    UserEventsListComponent,
    EventDetailsComponent,
    EditEventComponent,
    CreateTicketPoolComponent,
    ChangeTicketPoolStatusComponent,
    ChangeTicketPoolQuantityComponent
  ],
    imports: [
        BrowserModule,
        AppRoutingModule,
        BrowserAnimationsModule,
        MatFormFieldModule,
        MatInputModule,
        MatButtonModule,
        ReactiveFormsModule,
        HttpClientModule,
        StoreModule.forRoot({}),
        StoreModule.forFeature("events", eventsReducer),
        EffectsModule.forRoot([]),
        EffectsModule.forFeature([EventsEffects]),
        ToastrModule.forRoot({
            positionClass: 'toast-bottom-right'
        }),
        MatDialogModule,
        MatSelectModule
    ],
  providers: [httpInterceptorProviders],
  bootstrap: [AppComponent]
})
export class AppModule { }
