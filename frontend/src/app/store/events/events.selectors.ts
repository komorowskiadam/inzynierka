import { createFeatureSelector, createSelector } from "@ngrx/store";
import * as fromStore from "./events.reducer";

export const selectFeature = createFeatureSelector<fromStore.EventsState>('events');

export const selectSelectedEventId = createSelector(selectFeature, state => state.selectedEventId);

export const selectEvents = createSelector(selectFeature, fromStore.selectAll);

export const selectEventEntities = createSelector(selectFeature, fromStore.selectEntities);

export const selectSelectedEvent = createSelector(
  selectEventEntities,
  selectSelectedEventId,
  (eventEntities, selectedId) => eventEntities[selectedId]
);
