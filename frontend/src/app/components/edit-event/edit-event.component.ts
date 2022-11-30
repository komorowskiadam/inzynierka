import { Component, Inject } from '@angular/core';
import { FormBuilder, Validators } from "@angular/forms";
import { Store } from "@ngrx/store";
import { EditEventDto } from "../../dto/Dtos";
import { editEvent } from "../../store/events/events.actions";
import { MAT_DIALOG_DATA, MatDialogRef } from "@angular/material/dialog";
import { MyEvent } from "../../model/Models";
import { Editor } from 'tinymce';

@Component({
  selector: 'app-edit-event',
  templateUrl: './edit-event.component.html',
  styleUrls: ['./edit-event.component.scss']
})
export class EditEventComponent {
  static tooManyChars = false;

  editForm = this.formBuilder.group({
    name: ['', [Validators.required, Validators.minLength(5)]],
    description: ['', Validators.required]
  });

  constructor(private formBuilder: FormBuilder,
              private store$: Store,
              private dialogRef: MatDialogRef<EditEventComponent>,
              @Inject(MAT_DIALOG_DATA) public event: MyEvent) {
    this.editForm.setValue({
      name: event.name,
      description: event.description
    })
  }

  edit() {
    let name = this.editForm.value.name;
    let description = this.editForm.value.description;
    if(!name || !description) return;
    let editEventDto: EditEventDto = {
      name,
      description
    }
    this.store$.dispatch(editEvent({editEventDto, id: this.event.id}));
    this.dialogRef.close();
  }

  isFormInvalid(): boolean {
    if(this.editForm.invalid) return true;
    return EditEventComponent.tooManyChars;
  }

  setup(editor: Editor) {
    // @ts-ignore
    editor.on('keyup', (event) => {
      let numChars = editor.plugins['wordcount']['body'].getCharacterCount();
      EditEventComponent.tooManyChars = numChars > 10;
    });
  }


}
