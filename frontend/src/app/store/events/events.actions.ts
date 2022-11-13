import { createAction, props } from "@ngrx/store";
import { MyEvent } from "../../model/Models";
import {
  ChangeTicketPoolQuantityDto,
  ChangeTicketPoolStatusDto,
  CreateEventDto,
  CreateTicketPoolDto,
  EditEventDto
} from "../../dto/Dtos";

export enum EventActionTypes {
  GET_EVENT = '[Events] Get event',
  GET_EVENT_SUCCESS = '[Events] Get event success',
  GET_EVENT_ERROR = '[Events] Get event error',
  ADD_EVENT = '[Events] Add event',
  ADD_EVENT_SUCCESS = '[Events] Add event success',
  ADD_EVENT_ERROR = '[Events] Add event error',
  SELECT_EVENT = '[Events] Select event',
  GET_USER_EVENTS = '[Events] Get user events',
  GET_USER_EVENTS_SUCCESS = '[Events] Get user events success',
  GET_USER_EVENTS_ERROR = '[Events] Get user events error',
  EDIT_EVENT = '[Events] Edit event',
  EDIT_EVENT_SUCCESS = '[Events] Edit event success',
  EDIT_EVENT_ERROR = '[Events] Edit event error',
  CREATE_TICKET_POOL = '[Events] Create ticket pool',
  CREATE_TICKET_POOL_SUCCESS = '[Events] Create ticket pool success',
  CREATE_TICKET_POOL_ERROR = '[Events] Create ticket pool error',
  CHANGE_TICKET_POOL_STATUS = '[Events] Change ticket pool status',
  CHANGE_TICKET_POOL_QUANTITY = '[Events] Change ticket pool quantity',
}

export const getEvent = createAction(
  EventActionTypes.GET_EVENT,
  props<{ id: number }>()
);

export const getEventSuccess = createAction(
  EventActionTypes.GET_EVENT_SUCCESS,
  props<{ event: MyEvent }>()
);

export const getEventError = createAction(
  EventActionTypes.GET_EVENT_ERROR,
  props<{ message: string }>()
);

export const addEvent = createAction(
  EventActionTypes.ADD_EVENT,
  props<{ createEventDto: CreateEventDto }>()
);

export const addEventSuccess = createAction(
  EventActionTypes.ADD_EVENT_SUCCESS,
  props<{ event: MyEvent }>()
);

export const addEventError = createAction(
  EventActionTypes.ADD_EVENT_ERROR,
  props<{ message: string }>()
);

export const selectEvent = createAction(
  EventActionTypes.SELECT_EVENT,
  props<{ id: number }>()
);

export const getUserEvents = createAction(
  EventActionTypes.GET_USER_EVENTS,
  props<{ userId: number }>()
);

export const getUserEventsSuccess = createAction(
  EventActionTypes.GET_USER_EVENTS_SUCCESS,
  props<{ events: MyEvent[] }>()
);

export const getUserEventsError = createAction(
  EventActionTypes.GET_USER_EVENTS_ERROR,
  props<{ message: string }>()
);

export const editEvent = createAction(
  EventActionTypes.EDIT_EVENT,
  props<{ editEventDto: EditEventDto, id: number }>()
);

export const editEventSuccess = createAction(
  EventActionTypes.EDIT_EVENT_SUCCESS,
  props<{ event: MyEvent }>()
);

export const editEventError = createAction(
  EventActionTypes.EDIT_EVENT_ERROR,
  props<{ message: string }>()
);

export const createTicketPool = createAction(
  EventActionTypes.CREATE_TICKET_POOL,
  props<{ eventId: number, createTicketPoolDto: CreateTicketPoolDto }>()
);

export const createTicketPoolSuccess = createAction(
  EventActionTypes.CREATE_TICKET_POOL_SUCCESS,
  props<{ event: MyEvent }>()
);

export const createTicketPoolError = createAction(
  EventActionTypes.CREATE_TICKET_POOL_ERROR,
  props<{ message: string }>()
);

export const changeTicketPoolStatus = createAction(
  EventActionTypes.CHANGE_TICKET_POOL_STATUS,
  props<{ eventId: number, poolId: number, status: ChangeTicketPoolStatusDto }>()
);

export const changeTicketPoolQuantity = createAction(
  EventActionTypes.CHANGE_TICKET_POOL_QUANTITY,
  props<{ eventId: number, poolId: number, quantity: ChangeTicketPoolQuantityDto }>()
);
