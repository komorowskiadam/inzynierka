import { createEntityAdapter, EntityState } from "@ngrx/entity";
import { Promotion } from "../../model/Models";
import { createReducer, on } from "@ngrx/store";
import { createPromotionSuccess, editPromotionSuccess, getPromotionsSuccess } from "./promotions.actions";

export interface PromotionsState extends EntityState<Promotion>{}

export const promotionsAdapter = createEntityAdapter<Promotion>();

export const initialState: PromotionsState = promotionsAdapter.getInitialState();

export const promotionsReducer = createReducer(
  initialState,
  on(createPromotionSuccess, (state, action) => promotionsAdapter.setOne(action.promotion, state)),
  on(getPromotionsSuccess, (state, action) => promotionsAdapter.setAll(action.promotions, state)),
  on(editPromotionSuccess, (state, action) => promotionsAdapter.upsertOne(action.promotion, state))
);

export const {
  selectAll,
  selectEntities
} = promotionsAdapter.getSelectors();
