import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, Validators } from "@angular/forms";
import { Store } from "@ngrx/store";
import { MAT_DIALOG_DATA, MatDialogRef } from "@angular/material/dialog";
import { MyEvent } from "../../model/Models";
import { CreateTicketPoolDto } from "../../dto/Dtos";
import { createTicketPool } from "../../store/events/events.actions";

@Component({
  selector: 'app-create-ticket-pool',
  templateUrl: './create-ticket-pool.component.html',
  styleUrls: ['./create-ticket-pool.component.scss']
})
export class CreateTicketPoolComponent {

  createPoolForm = this.formBuilder.group({
    quantity: ['', [Validators.required, Validators.min(1)]],
    price: ['', [Validators.required, Validators.min(0)]],
    name: ['', [Validators.required, Validators.minLength(5)]]
  });

  constructor(private formBuilder: FormBuilder,
              private store$: Store,
              private dialogRef: MatDialogRef<CreateTicketPoolComponent>,
              @Inject(MAT_DIALOG_DATA) public event: MyEvent) { }

  createPool() {
    let price = Number(this.createPoolForm.value.price);
    let quantity = Number(this.createPoolForm.value.quantity);
    let poolName = this.createPoolForm.value.name;
    if(!quantity || !price || !poolName) return;

    let createTicketPoolDto: CreateTicketPoolDto = {
      quantity,
      price,
      poolName
    }

    this.store$.dispatch(createTicketPool({eventId: this.event.id, createTicketPoolDto}));
    this.dialogRef.close();
  }
}
