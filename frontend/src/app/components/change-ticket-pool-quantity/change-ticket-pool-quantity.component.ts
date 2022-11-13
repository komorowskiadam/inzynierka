import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, Validators } from "@angular/forms";
import { Store } from "@ngrx/store";
import { MAT_DIALOG_DATA, MatDialogRef } from "@angular/material/dialog";
import { MyEvent } from "../../model/Models";
import { ChangeTicketPoolStatusComponent } from "../change-ticket-pool-status/change-ticket-pool-status.component";
import { ChangeTicketPoolQuantityDto } from "../../dto/Dtos";
import { changeTicketPoolQuantity } from "../../store/events/events.actions";

@Component({
  selector: 'app-change-ticket-pool-quantity',
  templateUrl: './change-ticket-pool-quantity.component.html',
  styleUrls: ['./change-ticket-pool-quantity.component.scss']
})
export class ChangeTicketPoolQuantityComponent {

  quantityForm = this.formBuilder.group({
    quantity: [1, Validators.required],
    operation: ['add', [Validators.required, Validators.min(1)]]
  })

  constructor(private formBuilder: FormBuilder,
              private store$: Store,
              private dialogRef: MatDialogRef<ChangeTicketPoolQuantityComponent>,
              @Inject(MAT_DIALOG_DATA) public data: { event: MyEvent, poolId: number }) { }

  change() {
    let quantity = this.quantityForm.value.quantity;
    if(!quantity) return;

    if(this.quantityForm.value.operation == 'remove') {
      quantity = quantity * -1;
    }

    let dto: ChangeTicketPoolQuantityDto = {
      quantity: quantity
    }

    this.store$.dispatch(changeTicketPoolQuantity({
      quantity: dto,
      eventId: this.data.event.id,
      poolId: this.data.poolId}));

    this.dialogRef.close();
  }

}
