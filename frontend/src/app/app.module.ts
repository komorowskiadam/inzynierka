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
import { EditTicketPoolComponent } from './components/edit-ticket-pool/edit-ticket-pool.component';
import { MatSelectModule } from "@angular/material/select";
import { ChangeTicketPoolQuantityComponent } from './components/change-ticket-pool-quantity/change-ticket-pool-quantity.component';
import { EditorModule } from "@tinymce/tinymce-angular";
import { SanitizerPipe } from "./services/sanitizer.pipe";
import { CreateNewPostComponent } from './components/create-new-post/create-new-post.component';
import { CreatePromotionComponent } from './components/create-promotion/create-promotion.component';
import { promotionsReducer } from "./store/promotions/promotions.reducer";
import { PromotionsComponent } from './components/promotions/promotions.component';
import { PromotionsEffects } from "./store/promotions/promotions.effects";
import { EditPromotionComponent } from './components/edit-promotion/edit-promotion.component';
import { MatIconModule } from "@angular/material/icon";
import { MatTooltipModule } from "@angular/material/tooltip";
import { HeaderComponent } from './components/header/header.component';
import { UserDetailsComponent } from './components/user-details/user-details.component';
import { AddTicketImageComponent } from './components/add-ticket-image/add-ticket-image.component';

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
    EditTicketPoolComponent,
    ChangeTicketPoolQuantityComponent,
    SanitizerPipe,
    CreateNewPostComponent,
    CreatePromotionComponent,
    PromotionsComponent,
    EditPromotionComponent,
    HeaderComponent,
    UserDetailsComponent,
    AddTicketImageComponent
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
    StoreModule.forFeature("promotions", promotionsReducer),
    EffectsModule.forRoot([]),
    EffectsModule.forFeature([EventsEffects, PromotionsEffects]),
    ToastrModule.forRoot({
      positionClass: 'toast-bottom-right'
    }),
    MatDialogModule,
    MatSelectModule,
    EditorModule,
    MatIconModule,
    MatTooltipModule,
  ],
  providers: [httpInterceptorProviders],
  bootstrap: [AppComponent]
})
export class AppModule { }
