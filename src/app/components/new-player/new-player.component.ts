import { CommonModule } from '@angular/common';
import { Component, EventEmitter, Input, Output } from '@angular/core';
import { Dungeon } from '../../models/dungeon';
import { Location } from '../../models/location';
import { Player } from '../../models/player';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatIconModule } from '@angular/material/icon';
import { FormControl, FormGroup, FormsModule, ReactiveFormsModule, Validators } from '@angular/forms';
import { RouterOutlet } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';

@Component({
  selector: 'new-player-component',
  templateUrl: './new-player.component.html',
  styleUrl: './new-player.component.scss',
  standalone: true,
  imports:[
    CommonModule,
    MatProgressBarModule,
    MatIconModule,
    CommonModule,
    RouterOutlet, 
    CommonModule,
    MatProgressBarModule,
    MatButtonModule,
    MatIconModule,
    FormsModule, 
    MatFormFieldModule,
    ReactiveFormsModule,
    MatInputModule
  ]
})
export class NewPlayerComponent {

  emailFormControl = new FormControl(null, [Validators.required]);
  userFormControl = new FormControl('', [Validators.required]);

  constructor(
  ){
    
  }

}
