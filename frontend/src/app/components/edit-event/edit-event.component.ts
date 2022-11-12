import { Component, Inject } from '@angular/core';
import { FormBuilder, Validators } from "@angular/forms";
import { Store } from "@ngrx/store";
import { EditEventDto } from "../../dto/Dtos";
import { editEvent } from "../../store/events/events.actions";
import { MAT_DIALOG_DATA, MatDialogRef } from "@angular/material/dialog";
import { MyEvent } from "../../model/Models";

@Component({
  selector: 'app-edit-event',
  templateUrl: './edit-event.component.html',
  styleUrls: ['./edit-event.component.scss']
})
export class EditEventComponent {

  editForm = this.formBuilder.group({
    name: ['', [Validators.required, Validators.minLength(5)]]
  });

  constructor(private formBuilder: FormBuilder,
              private store$: Store,
              private dialogRef: MatDialogRef<EditEventComponent>,
              @Inject(MAT_DIALOG_DATA) public event: MyEvent) {
    this.editForm.setValue({
      name: event.name
    })
  }

  edit() {
    let name = this.editForm.value.name;
    if(!name) return;
    let editEventDto: EditEventDto = {
      name: name
    }
    this.store$.dispatch(editEvent({editEventDto, id: this.event.id}));
    this.dialogRef.close();
  }

}
