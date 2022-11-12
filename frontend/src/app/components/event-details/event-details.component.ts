import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from "@angular/router";
import { EventService } from "../../services/event.service";
import { MyEvent } from "../../model/Models";
import { Store } from "@ngrx/store";
import { getUserEvents, selectEvent } from "../../store/events/events.actions";
import { Observable } from "rxjs";
import { selectSelectedEvent } from "../../store/events/events.selectors";
import { MatDialog } from "@angular/material/dialog";
import { EditEventComponent } from "../edit-event/edit-event.component";
import { TokenStorageService } from "../../services/token-storage.service";

@Component({
  selector: 'app-event-details',
  templateUrl: './event-details.component.html',
  styleUrls: ['./event-details.component.scss']
})
export class EventDetailsComponent implements OnInit {

  selectedEvent$: Observable<MyEvent | undefined>;

  constructor(private route: ActivatedRoute,
              private eventService: EventService,
              private store$: Store,
              private dialog: MatDialog,
              private tokenStorage: TokenStorageService) {
    this.selectedEvent$ = this.store$.select(selectSelectedEvent)
  }

  ngOnInit(): void {
    const id = Number(this.route.snapshot.paramMap.get('id'));
    this.store$.dispatch(getUserEvents({userId: this.tokenStorage.getId()}));
    this.store$.dispatch(selectEvent({id}));
  }

  openEditDialog() {
    let event;
    this.selectedEvent$.subscribe(res => event = res);

    this.dialog.open(EditEventComponent, {
      data: event,
      width: '500px'
    });
  }

}
