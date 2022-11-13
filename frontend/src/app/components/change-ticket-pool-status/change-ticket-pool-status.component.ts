import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, Validators } from "@angular/forms";
import { Store } from "@ngrx/store";
import { MAT_DIALOG_DATA, MatDialogRef } from "@angular/material/dialog";
import { MyEvent, TicketPool, TicketPoolStatus, TicketPoolStatus2LabelMapping } from "../../model/Models";
import { ChangeTicketPoolStatusDto } from "../../dto/Dtos";
import { changeTicketPoolStatus } from "../../store/events/events.actions";

@Component({
  selector: 'app-change-ticket-pool-status',
  templateUrl: './change-ticket-pool-status.component.html',
  styleUrls: ['./change-ticket-pool-status.component.scss']
})
export class ChangeTicketPoolStatusComponent {

  statusForm = this.formBuilder.group({
    status: ['', Validators.required]
  });

  selectedPool: TicketPool;

  public TicketPoolStatus2LabelMapping = TicketPoolStatus2LabelMapping;

  public ticketPoolStatus = Object.values(TicketPoolStatus);

  constructor(private formBuilder: FormBuilder,
              private store$: Store,
              private dialogRef: MatDialogRef<ChangeTicketPoolStatusComponent>,
              @Inject(MAT_DIALOG_DATA) public data: { event: MyEvent, poolId: number }) {
    this.selectedPool = this.data.event.ticketPools.filter(p => p.id == this.data.poolId)[0];
    this.statusForm.setValue({status: this.selectedPool.status});
  }

  changeStatus() {
    let status = this.statusForm.value.status as unknown as TicketPoolStatus;

    let dto: ChangeTicketPoolStatusDto = {
      newStatus: status
    }

    this.store$.dispatch(changeTicketPoolStatus({
      eventId: this.data.event.id,
      poolId: this.data.poolId,
      status: dto}));

    this.dialogRef.close();
  }

}
