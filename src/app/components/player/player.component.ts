import { CommonModule } from '@angular/common';
import { Component, EventEmitter, Input, Output } from '@angular/core';
import { Dungeon } from '../../models/dungeon';
import { Location } from '../../models/location';
import { Player } from '../../models/player';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatIconModule } from '@angular/material/icon';

@Component({
  selector: 'player-component',
  templateUrl: './player.component.html',
  styleUrl: './player.component.scss',
  standalone: true,
  imports:[
    CommonModule,
    MatProgressBarModule,
    MatIconModule,
    PlayerComponent
  ]
})
export class PlayerComponent {

  dungeon!: Dungeon;
  rows: Location[][] = []
  currentLocation!: Location | undefined

  @Input() player!: Player
  @Output() location = new EventEmitter<Location>()
  @Output() loseDungeon = new EventEmitter<boolean>()

  constructor(
  ){
    
  }

}
