import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, Validators } from "@angular/forms";
import { Store } from "@ngrx/store";
import { MAT_DIALOG_DATA, MatDialogRef } from "@angular/material/dialog";
import { MyEvent } from "../../model/Models";
import { TokenStorageService } from "../../services/token-storage.service";
import { CreateEventComponent } from "../create-event/create-event.component";
import { CreateEventPostDto } from "../../dto/Dtos";
import { createEventPost } from "../../store/events/events.actions";

@Component({
  selector: 'app-create-new-post',
  templateUrl: './create-new-post.component.html',
  styleUrls: ['./create-new-post.component.scss']
})
export class CreateNewPostComponent implements OnInit {

  form = this.formBuilder.group({
    content: ['', Validators.required]
  });

  constructor(private formBuilder: FormBuilder,
              private store$: Store,
              private dialogRef: MatDialogRef<CreateNewPostComponent>,
              private tokenStorage: TokenStorageService,
              @Inject(MAT_DIALOG_DATA) public event: MyEvent) { }

  ngOnInit(): void {
  }

  create() {
    let content = this.form.value.content;

    if(!content) return;

    let dto: CreateEventPostDto = {
      content,
      authorId: this.tokenStorage.getId(),
      date: Date.now().toString()
    };

    this.store$.dispatch(createEventPost({eventId: this.event.id, dto}));

    this.dialogRef.close();
  }

}
