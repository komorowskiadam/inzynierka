import { EventService } from "../../services/event.service";
import { ToastrService } from "ngx-toastr";
import { Actions, createEffect, ofType } from "@ngrx/effects";
import { Router } from "@angular/router";
import {
  createPromotionError,
  createPromotionSuccess, editPromotionError,
  editPromotionSuccess, getPromotionsError, getPromotionsSuccess,
  PromotionActionTypes
} from "./promotions.actions";
import { catchError, map, of, switchMap } from "rxjs";
import { Injectable } from "@angular/core";

@Injectable({providedIn: 'root'})
export class PromotionsEffects {

  getPromotions$ = createEffect(() => this.actions$.pipe(
    ofType(PromotionActionTypes.GET_PROMOTIONS),
    switchMap(({id}) => this.eventService.getUserPromotions(id).pipe(
      map(promotions => {
        return getPromotionsSuccess({promotions});
      }),
      catchError(err => {
        this.toastr.error("Could not load promotion list. Reason: " + err.message);
        return of(getPromotionsError({message: err.message}));
      })
    ))
  ));

  createPromotion$ = createEffect(() => this.actions$.pipe(
    ofType(PromotionActionTypes.CREATE_PROMOTION),
    switchMap(({dto}) => this.eventService.createPromotion(dto).pipe(
      map(promotion => {
        this.router.navigate(["/promotions"]);
        this.toastr.success("Promotion created successfully");
        return createPromotionSuccess({promotion});
      }),
      catchError(err => {
        this.toastr.error("Could not create promotion. Reason: " + err.message);
        return of(createPromotionError({message: err.message}));
      })
    ))
  ));

  editPromotion$ = createEffect(() => this.actions$.pipe(
    ofType(PromotionActionTypes.EDIT_PROMOTION),
    switchMap(({id, dto}) => this.eventService.editPromotion(id, dto).pipe(
      map(promotion => {
        this.toastr.success("Promotion edited successfully");
        return editPromotionSuccess({promotion});
      }),
      catchError(err => {
        this.toastr.error("Could not edit promotion. Reason: " + err.message);
        return of(editPromotionError({message: err.message}));
      })
    ))
  ));



  constructor(private eventService: EventService,
              private toastr: ToastrService,
              private actions$: Actions,
              private router: Router) {}
}
