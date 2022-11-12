import { createEntityAdapter, EntityState } from "@ngrx/entity";
import { MyEvent } from "../../model/Models";
import { createReducer, on } from "@ngrx/store";
import {
  addEventSuccess,
  editEventSuccess,
  getEventSuccess,
  getUserEventsSuccess,
  selectEvent
} from "./events.actions";

export interface EventsState extends EntityState<MyEvent>{
  selectedEventId: number;
}

export const eventsAdapter = createEntityAdapter<MyEvent>();

export const initialState: EventsState = eventsAdapter.getInitialState({
  selectedEventId: -1
});

export const eventsReducer = createReducer(
  initialState,
  on(getUserEventsSuccess, (state, action) => eventsAdapter.setMany(action.events, state)),
  on(getEventSuccess, (state, action) => eventsAdapter.setOne(action.event, state)),
  on(addEventSuccess, (state, action) => eventsAdapter.addOne(action.event, state)),
  on(editEventSuccess, (state, action) => eventsAdapter.upsertOne(action.event, state)),
  on(selectEvent, (state, action) => ({...state, selectedEventId: action.id}))
);

export const {
  selectAll,
  selectEntities
} = eventsAdapter.getSelectors();
