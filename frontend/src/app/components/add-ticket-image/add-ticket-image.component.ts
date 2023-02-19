import { Component, Inject } from '@angular/core';
import { FormBuilder, Validators } from "@angular/forms";
import { MyEvent, TicketPool, TicketPoolStatus } from "../../model/Models";
import { Store } from "@ngrx/store";
import { MAT_DIALOG_DATA, MatDialogRef } from "@angular/material/dialog";
import { EditTicketPoolDto } from "../../dto/Dtos";
import { addEventImage, addTicketImage, changeTicketPoolStatus } from "../../store/events/events.actions";
import { EventService } from "../../services/event.service";

@Component({
  selector: 'app-add-ticket-image',
  templateUrl: './add-ticket-image.component.html',
  styleUrls: ['./add-ticket-image.component.scss']
})
export class AddTicketImageComponent {

  selectedPool: TicketPool;

  selectedImage?: File;

  imgUrl: string | ArrayBuffer | null = "";


  constructor(private formBuilder: FormBuilder,
              private store$: Store,
              private dialogRef: MatDialogRef<AddTicketImageComponent>,
              private eventService: EventService,
              @Inject(MAT_DIALOG_DATA) public data: { event: MyEvent, poolId: number }) {
    this.selectedPool = this.data.event.ticketPools.filter(p => p.id == this.data.poolId)[0];
  }

  add() {
    let uploadImageData = undefined;

    let dto: EditTicketPoolDto = {
      status: this.selectedPool.status,
      name: this.selectedPool.name
    }

    if(this.selectedImage && this.selectedImage.name) {
      uploadImageData = new FormData();
      uploadImageData.append('imageFile', this.selectedImage, this.selectedImage.name);

      this.store$.dispatch(addTicketImage({
        eventId: this.data.event.id,
        poolId: this.data.poolId,
        status: dto,
        image: uploadImageData
      }));
    }

    this.dialogRef.close();
  }

  onFileChange(event: any){
    this.selectedImage = event.target.files[0];
    if(this.selectedImage){

      let reader = new FileReader();
      reader.readAsDataURL(this.selectedImage);
      reader.onload = (_event) => {
        this.imgUrl = reader.result;
      }

      if(this.selectedImage.size > 10000000){
        this.selectedImage = undefined;
        event.target.value = '';
      }
    }
  }
}
