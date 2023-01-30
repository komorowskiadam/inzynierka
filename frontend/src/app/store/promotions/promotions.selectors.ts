import { createFeatureSelector, createSelector } from "@ngrx/store";
import * as fromStore from "./promotions.reducer";

export const selectFeature = createFeatureSelector<fromStore.PromotionsState>("promotions");

export const selectPromotions = createSelector(selectFeature, fromStore.selectAll);
