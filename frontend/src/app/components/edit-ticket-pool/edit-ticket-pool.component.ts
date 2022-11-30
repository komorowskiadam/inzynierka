import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, Validators } from "@angular/forms";
import { Store } from "@ngrx/store";
import { MAT_DIALOG_DATA, MatDialogRef } from "@angular/material/dialog";
import { MyEvent, TicketPool, TicketPoolStatus, TicketPoolStatus2LabelMapping } from "../../model/Models";
import { EditTicketPoolDto } from "../../dto/Dtos";
import { changeTicketPoolStatus } from "../../store/events/events.actions";

@Component({
  selector: 'app-change-ticket-pool-status',
  templateUrl: './edit-ticket-pool.component.html',
  styleUrls: ['./edit-ticket-pool.component.scss']
})
export class EditTicketPoolComponent {

  statusForm = this.formBuilder.group({
    status: ['', Validators.required],
    name: ['', [Validators.required, Validators.minLength(5)]],
  });

  selectedPool: TicketPool;

  public TicketPoolStatus2LabelMapping = TicketPoolStatus2LabelMapping;

  public ticketPoolStatus = Object.values(TicketPoolStatus);

  constructor(private formBuilder: FormBuilder,
              private store$: Store,
              private dialogRef: MatDialogRef<EditTicketPoolComponent>,
              @Inject(MAT_DIALOG_DATA) public data: { event: MyEvent, poolId: number }) {
    this.selectedPool = this.data.event.ticketPools.filter(p => p.id == this.data.poolId)[0];
    this.statusForm.setValue({status: this.selectedPool.status, name: this.selectedPool.name});
  }

  changeStatus() {
    let status = this.statusForm.value.status as unknown as TicketPoolStatus;
    let name = this.statusForm.value.name as unknown as string;

    let dto: EditTicketPoolDto = {
      status,
      name
    }

    this.store$.dispatch(changeTicketPoolStatus({
      eventId: this.data.event.id,
      poolId: this.data.poolId,
      status: dto}));

    this.dialogRef.close();
  }

}
