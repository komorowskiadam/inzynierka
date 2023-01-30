import { Component, Inject } from '@angular/core';
import { FormBuilder, Validators } from "@angular/forms";
import { Store } from "@ngrx/store";
import { MAT_DIALOG_DATA, MatDialogRef } from "@angular/material/dialog";
import { MyEvent } from "../../model/Models";
import { CreatePromotionDto } from "../../dto/Dtos";
import { createPromotion } from "../../store/promotions/promotions.actions";

@Component({
  selector: 'app-create-promotion',
  templateUrl: './create-promotion.component.html',
  styleUrls: ['./create-promotion.component.scss']
})
export class CreatePromotionComponent {

  form = this.formBuilder.group({
    dateStart: [''],
    dateEnd: ['', Validators.required]
  });

  today: string;

  constructor(private formBuilder: FormBuilder,
              private store$: Store,
              private dialogRef: MatDialogRef<CreatePromotionComponent>,
              @Inject(MAT_DIALOG_DATA) public event: MyEvent) {
    this.today = new Date().toISOString().slice(0, 10);
  }

  create() {
    let dateStart = this.form.value.dateStart;
    let dateEnd = this.form.value.dateEnd;

    if(!dateEnd) return;

    let dto: CreatePromotionDto = {
      eventId: this.event.id,
      dateEnd,
      dateStart: dateStart!.length > 0 ? dateStart : undefined
    }

    this.store$.dispatch(createPromotion({dto}));

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
