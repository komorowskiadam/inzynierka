import { Component, Inject } from '@angular/core';
import { FormBuilder, Validators } from "@angular/forms";
import { Store } from "@ngrx/store";
import { MAT_DIALOG_DATA, MatDialogRef } from "@angular/material/dialog";
import { Promotion } from "../../model/Models";
import { EditPromotionDto } from "../../dto/Dtos";
import { editPromotion } from "../../store/promotions/promotions.actions";

@Component({
  selector: 'app-edit-promotion',
  templateUrl: './edit-promotion.component.html',
  styleUrls: ['./edit-promotion.component.scss']
})
export class EditPromotionComponent  {

  form = this.formBuilder.group({
    dateStart: [this.promotion.dateStart],
    dateEnd: [this.promotion.dateEnd, Validators.required]
  });

  today: string;

  constructor(private formBuilder: FormBuilder,
              private store$: Store,
              private dialogRef: MatDialogRef<EditPromotionComponent>,
              @Inject(MAT_DIALOG_DATA) public promotion: Promotion) {
    this.today = new Date().toISOString().slice(0, 10);
  }

  create() {
    let dateStart = this.form.value.dateStart;
    let dateEnd = this.form.value.dateEnd;

    let dto: EditPromotionDto = {
      status: null,
      dateEnd: dateEnd!.length > 0 ? dateEnd : null,
      dateStart: dateStart!.length > 0 ? dateStart : null
    }

    this.store$.dispatch(editPromotion({id: 1, dto}));

    this.dialogRef.close();
  }

  minEndDate(): string {
    let dateStart = this.form.value.dateStart;
    if(!dateStart) return this.today;
    else return dateStart;
  }

  isEndDateCorrect(): boolean {
    let dateStart = this.form.value.dateStart;
    let dateEnd = this.form.value.dateEnd;

    if(!dateEnd) return false;
    if(!dateStart || dateStart.length < 1){
      dateStart = new Date().toISOString().slice(0, 10);
    }
    let date1 = new Date(dateStart);
    let date2 = new Date(dateEnd);

    return date2 > date1;
  }

}

