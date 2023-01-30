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
  includeEndDate = false;
  today: string;

  editForm = this.formBuilder.group({
    name: ['', [Validators.required, Validators.minLength(5)]],
    description: ['', Validators.required],
    timeStart: ['', Validators.required],
    dateStart: ['', Validators.required],
    timeEnd: [''],
    dateEnd: [''],
    location: ['', Validators.required]
  });

  constructor(private formBuilder: FormBuilder,
              private store$: Store,
              private dialogRef: MatDialogRef<EditEventComponent>,
              @Inject(MAT_DIALOG_DATA) public event: MyEvent) {
    this.editForm.setValue({
      name: event.name,
      description: event.description,
      timeStart: event.timeStart,
      dateStart: event.dateStart,
      timeEnd: event.timeEnd || '',
      dateEnd: event.dateEnd || '',
      location: event.location
    });
    this.today = new Date().toISOString().slice(0, 10);

    if(event.timeEnd && event.timeEnd.length > 1 && event.dateEnd && event.dateEnd.length > 1){
      this.includeEndDate = true;
    }
  }

  edit() {
    let name = this.editForm.value.name;
    let description = this.editForm.value.description;
    let timeStart = this.editForm.value.timeStart;
    let dateStart = this.editForm.value.dateStart;
    let timeEnd = this.editForm.value.timeEnd;
    let dateEnd = this.editForm.value.dateEnd;
    let location = this.editForm.value.location;

    if(!name || !description || !timeStart || !dateStart || !location) return;

    let editEventDto: EditEventDto = {
      name,
      description,
      timeStart,
      dateStart,
      timeEnd: '',
      dateEnd: '',
      location
    }
    if(this.includeEndDate) {
      if(!timeEnd || !dateEnd)  return;
      editEventDto = {
        ...editEventDto,
        timeEnd,
        dateEnd
      }
    }


    this.store$.dispatch(editEvent({editEventDto, id: this.event.id}));
    this.dialogRef.close();
  }

  isFormInvalid(): boolean {
    if(this.editForm.invalid) return true;
    if(!this.isEndDateCorrect()) return false;
    return EditEventComponent.tooManyChars;
  }

  isEndDateCorrect(): boolean {
    if(!this.includeEndDate) return true;
    else {
      let timeEnd = this.editForm.value.timeEnd;
      let dateEnd = this.editForm.value.dateEnd;
      if(!timeEnd || !dateEnd){
        return false;
      }
      if(timeEnd.length < 1 || dateEnd.length < 1){
        return false;
      }
      return true;
    }
  }

  minEndDate(): string {
    let dateStart = this.editForm.value.dateStart;
    if(!dateStart) return this.today;
    else return dateStart;
  }

  disabledEndInputs(): boolean {
    let timeStart = this.editForm.value.timeStart;
    let dateStart = this.editForm.value.dateStart;

    return !timeStart || !dateStart;
  }

  setup(editor: Editor) {
    // @ts-ignore
    editor.on('keyup', (event) => {
      let numChars = editor.plugins['wordcount']['body'].getCharacterCount();
      EditEventComponent.tooManyChars = numChars > 100;
    });
  }


}
