import { Component, OnInit } from '@angular/core';
import { Store } from "@ngrx/store";
import { editPromotion, getPromotions } from "../../store/promotions/promotions.actions";
import { TokenStorageService } from "../../services/token-storage.service";
import { Observable } from "rxjs";
import { MyEvent, Promotion, PromotionStatus, PromotionStatus2LabelMapping } from "../../model/Models";
import { selectPromotions } from "../../store/promotions/promotions.selectors";
import { MatDialog } from "@angular/material/dialog";
import { EditPromotionComponent } from "../edit-promotion/edit-promotion.component";
import { EditPromotionDto } from "../../dto/Dtos";
import { backendAddress } from "../../services/event.service";

@Component({
  selector: 'app-promotions',
  templateUrl: './promotions.component.html',
  styleUrls: ['./promotions.component.scss']
})
export class PromotionsComponent implements OnInit {

  promotions$: Observable<Promotion[]>;

  public promotionStatus2LabelMapping = PromotionStatus2LabelMapping;

  constructor(private store$: Store,
              private tokenStorage: TokenStorageService,
              private dialog: MatDialog,) {
    this.promotions$ = this.store$.select(selectPromotions);
  }

  ngOnInit(): void {
    this.store$.dispatch(getPromotions({id: this.tokenStorage.getId()}));
  }

  showPausePromotionButton(promotion: Promotion): boolean {
    return promotion.status == PromotionStatus.ACTIVE;
  }

  showStartPromotionButton(promotion: Promotion): boolean {
    return promotion.status == PromotionStatus.PAUSED;
  }

  showDeactivatePromotionButton(promotion: Promotion): boolean {
    return promotion.status == PromotionStatus.PAUSED ||
      promotion.status == PromotionStatus.ACTIVE ||
      promotion.status == PromotionStatus.PENDING;
  }

  showEditButton(promotion: Promotion) : boolean {
    return promotion.status != PromotionStatus.INACTIVE;
  }

  pausePromotion(promotion: Promotion): void {
    let dto: EditPromotionDto = {
      status: PromotionStatus.PAUSED
    }
    this.store$.dispatch(editPromotion({id: promotion.id, dto: dto}));
  }

  startPromotion(promotion: Promotion): void {
    let dto: EditPromotionDto = {
      status: PromotionStatus.ACTIVE
    }
    this.store$.dispatch(editPromotion({id: promotion.id, dto: dto}));
  }

  deactivatePromotion(promotion: Promotion): void {
    let dto: EditPromotionDto = {
      status: PromotionStatus.INACTIVE
    }
    this.store$.dispatch(editPromotion({id: promotion.id, dto: dto}));
  }

  openEditPromotionDialog(promotion: Promotion) {
    this.dialog.open(EditPromotionComponent, {
      data: promotion
    });
  }

  readableDate(date: string) {
    let readable = new Date(date);
    return readable.toDateString();
  }

  getUrl(event: MyEvent): string {
    if(!event.imageId) return "";
    return backendAddress + "/images/" + event.imageId;
  }

}
