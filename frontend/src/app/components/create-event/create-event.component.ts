import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators } from "@angular/forms";
import { CreateEventDto } from "../../dto/Dtos";
import { TokenStorageService } from "../../services/token-storage.service";
import { Store } from "@ngrx/store";
import { addEvent, addEventImage } from "../../store/events/events.actions";
import { Editor } from "tinymce";
import { ToastrService } from "ngx-toastr";
import { EventCategory, EventCategory2LabelMapping } from "../../model/Models";

@Component({
  selector: 'app-create-event',
  templateUrl: './create-event.component.html',
  styleUrls: ['./create-event.component.scss']
})
export class CreateEventComponent implements OnInit {

  static tooManyChars = false;

  createEventForm = this.formBuilder.group({
    name: ['', [Validators.required, Validators.minLength(5)]],
    description: [''],
    timeStart: ['', Validators.required],
    dateStart: ['', Validators.required],
    timeEnd: [''],
    dateEnd: [''],
    location: ['', Validators.required],
    category: ['', Validators.required]
  });

  today: string;
  includeEndDate = false;
  imgUrl: string | ArrayBuffer | null = "";

  selectedImage?: File;

  public EventCategory2LabelMapping = EventCategory2LabelMapping;

  public categories = Object.values(EventCategory);

  constructor(private formBuilder: FormBuilder,
              private tokenStorage: TokenStorageService,
              private store$: Store,
              private toastr: ToastrService) {
    this.today = new Date().toISOString().slice(0, 10);
  }

  ngOnInit(): void {
  }

  minEndDate(): string {
    let dateStart = this.createEventForm.value.dateStart;
    if(!dateStart) return this.today;
    else return dateStart;
  }

  disabledEndInputs(): boolean {
    let timeStart = this.createEventForm.value.timeStart;
    let dateStart = this.createEventForm.value.dateStart;

    return !timeStart || !dateStart;
  }

  isEndDateCorrect(): boolean {
    if(!this.includeEndDate) return true;
    else {
      let timeEnd = this.createEventForm.value.timeEnd;
      let dateEnd = this.createEventForm.value.dateEnd;
      if(!timeEnd || !dateEnd){
        return false;
      }
      if(timeEnd.length < 1 || dateEnd.length < 1){
        return false;
      }
      return true;
    }
  }

  createEvent(): void {
    let name = this.createEventForm.value.name;
    let description = this.createEventForm.value.description;
    let timeStart = this.createEventForm.value.timeStart;
    let dateStart = this.createEventForm.value.dateStart;
    let timeEnd = this.createEventForm.value.timeEnd;
    let dateEnd = this.createEventForm.value.dateEnd;
    let location = this.createEventForm.value.location;
    let category = this.createEventForm.value.category as unknown as EventCategory;

    let uploadImageData = undefined;

    if(!name || !description || !timeStart || !dateStart || !location || !category) return;
    if(CreateEventComponent.tooManyChars) return;

    let createEventDto: CreateEventDto = {
      name,
      organizerId: this.tokenStorage.getId(),
      description,
      timeStart,
      dateStart,
      location,
      category
    }
    if(this.includeEndDate) {
      if(!timeEnd || !dateEnd)  return;
      createEventDto = {
        ...createEventDto,
        timeEnd,
        dateEnd
      }
    }

    if(this.selectedImage && this.selectedImage.name) {
      uploadImageData = new FormData();
      uploadImageData.append('imageFile', this.selectedImage, this.selectedImage.name);
      this.store$.dispatch(addEventImage({eventDto: createEventDto, image: uploadImageData}));
    } else {
      this.store$.dispatch(addEvent({createEventDto}));
    }
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
        this.toastr.error("Image is too big");
        this.selectedImage = undefined;
        event.target.value = '';
      }
    }
  }

  setup(editor: Editor) {
    // @ts-ignore
    editor.on('keyup', (event) => {
      let numChars = editor.plugins['wordcount']['body'].getCharacterCount();
      CreateEventComponent.tooManyChars = numChars > 10000;
    });
  }
}
