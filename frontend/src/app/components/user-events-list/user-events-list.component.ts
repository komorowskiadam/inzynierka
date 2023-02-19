import { Component, OnInit } from '@angular/core';
import { backendAddress, EventService } from "../../services/event.service";
import { TokenStorageService } from "../../services/token-storage.service";
import { MyEvent } from "../../model/Models";
import { Store } from "@ngrx/store";
import { getUserEvents } from "../../store/events/events.actions";
import { Observable } from "rxjs";
import { selectEvents } from "../../store/events/events.selectors";

@Component({
  selector: 'app-user-events-list',
  templateUrl: './user-events-list.component.html',
  styleUrls: ['./user-events-list.component.scss']
})
export class UserEventsListComponent implements OnInit {

  events$: Observable<MyEvent[] | undefined>

  constructor(private tokenStorage: TokenStorageService,
              private store$: Store) {

    this.events$ = this.store$.select(selectEvents);

  }

  getUrl(event: MyEvent): string {
    if(!event.imageId) return "";
    return "url('" + backendAddress + "/images/" + event.imageId + "')";
  }

  ngOnInit(): void {
    const id = this.tokenStorage.getId();
    this.store$.dispatch(getUserEvents({userId: id}));
  }

}
