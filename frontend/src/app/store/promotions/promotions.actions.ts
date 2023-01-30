import { createAction, props } from "@ngrx/store";
import { CreatePromotionDto, EditPromotionDto } from "../../dto/Dtos";
import { Promotion } from "../../model/Models";

export enum PromotionActionTypes {
  CREATE_PROMOTION = "[Promotions] Create promotion",
  CREATE_PROMOTION_SUCCESS = "[Promotions] Create promotion success",
  CREATE_PROMOTION_ERROR = "[Promotions] Create promotion error",
  GET_PROMOTIONS = "[Promotions] Get promotions",
  GET_PROMOTIONS_SUCCESS = "[Promotions] Get promotions success",
  GET_PROMOTIONS_ERROR = "[Promotions] Get promotions error",
  EDIT_PROMOTION = "[Promotions] Edit promotion",
  EDIT_PROMOTION_SUCCESS = "[Promotions] Edit promotion success",
  EDIT_PROMOTION_ERROR = "[Promotions] Edit promotion error",
}

export const createPromotion = createAction(
  PromotionActionTypes.CREATE_PROMOTION,
  props<{ dto: CreatePromotionDto }>()
);

export const createPromotionSuccess = createAction(
  PromotionActionTypes.CREATE_PROMOTION_SUCCESS,
  props<{ promotion: Promotion }>()
);

export const createPromotionError = createAction(
  PromotionActionTypes.CREATE_PROMOTION_ERROR,
  props<{ message: string }>()
);

export const getPromotions = createAction(
  PromotionActionTypes.GET_PROMOTIONS,
  props<{ id: number }>()
);

export const getPromotionsSuccess = createAction(
  PromotionActionTypes.GET_PROMOTIONS_SUCCESS,
  props<{ promotions: Promotion[] }>()
);

export const getPromotionsError = createAction(
  PromotionActionTypes.GET_PROMOTIONS_ERROR,
  props<{ message: string }>()
);

export const editPromotion = createAction(
  PromotionActionTypes.EDIT_PROMOTION,
  props<{ id: number, dto: EditPromotionDto }>()
);

export const editPromotionSuccess = createAction(
  PromotionActionTypes.EDIT_PROMOTION_SUCCESS,
  props<{ promotion: Promotion }>()
);

export const editPromotionError = createAction(
  PromotionActionTypes.EDIT_PROMOTION_ERROR,
  props<{ message: string }>()
);
