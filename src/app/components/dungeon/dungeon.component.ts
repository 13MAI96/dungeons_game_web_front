import { CommonModule } from '@angular/common';
import { Component, EventEmitter, Input, Output } from '@angular/core';
import { Dungeon } from '../../models/dungeon';
import { Location } from '../../models/location';
import { DungeonsDataService } from '../../services/dungeons-data.service';
import { Player } from '../../models/player';
import { MatSnackBar } from '@angular/material/snack-bar';
import { QuestSnackbar, QuestSnackbarData } from '../../snackbar/quest/quest.snackbar';

@Component({
  selector: 'app-dungeon',
  templateUrl: './dungeon.component.html',
  styleUrl: './dungeon.component.scss',
  standalone: true,
  imports:[
    CommonModule
  ]
})
export class DungeonComponent {

  dungeon!: Dungeon;
  rows: Location[][] = []
  currentLocation!: Location | undefined

  @Input() player!: Player
  @Output() location = new EventEmitter<Location>()
  @Output() loseDungeon = new EventEmitter<boolean>()

  constructor(
    private data_service: DungeonsDataService,
    private _snackBar: MatSnackBar
  ){
    this.data_service.getDungeon().subscribe(
      (data: Dungeon) => {
        this.dungeon = data
        console.log(data.q_locations)
        for (let rindex = 1; rindex <= data.number_of_rows; rindex++) {
          let temp: Location[] = []
          this.currentLocation = data.locations.find(x => x.type == 'ENTRANCE')
          this.location.emit(this.currentLocation)
          if(this.currentLocation){
            for (let cindex = 1; cindex <= data.number_of_columns; cindex++) {
              let loc = data.locations.find(el => el.column == cindex && el.row == rindex)
              if(loc){
                if (loc?.type == 'ENTRANCE'){
                  loc.visible = true
                  loc.visited = true
                }
                if(this.currentLocation.column-1 <= loc.column && this.currentLocation.column+1 >= loc.column){
                  if(this.currentLocation.row-1 <= loc.row && this.currentLocation.row+1 >= loc.row){
                    loc.visible = true
                  }
                }
                this.isReachableOrVisible(loc)
                loc ? temp.push(loc) : null
              }
            }
            this.rows.push(temp)
          }
        }
      }
    )
  }

  private isReachableOrVisible(location: Location){
    if(this.currentLocation){
      if(this.currentLocation.column == location.column){
        if(this.currentLocation.row-1 <= location.row && this.currentLocation.row+1 >= location.row){
          location.show = true
          location.canVisit = true
          location.visible = true
          return
        }
      }
      if(this.currentLocation.row == location.row){
        if(this.currentLocation.column-1 <= location.column && this.currentLocation.column+1 >= location.column){
          location.show = true
          location.canVisit = true
          location.visible = true
          return
        }
      }
      location.canVisit = false
    }
  }

  public isVisited(location: Location): string {
    let result = `column 
      ${location.visited && location.type != 'ENTRANCE' ? 'visited' : ''} 
      ${location?.type?.toLowerCase()} 
      ${location.canVisit ? 'canVisit' : ''} 
      ${location.show ? '' : 'cantShow'}
      ${location == this.currentLocation ? 'current' : ''}`
    return result
  }

  public visitLocation(location: Location){
    if(this.currentLocation?.type == 'MONSTER' && !this.currentLocation.visited){
      if(Math.random()*20 < 15){
        // this.player.loseLife(5)
        this._snackBar.openFromComponent(QuestSnackbar, {
          data: new QuestSnackbarData('You were hit while running away.', true),
          duration: 5 * 1000,
          verticalPosition: 'top'
        })
        if(this.player.current_life <= 0){
          this.loseDungeon.emit(true)
          return
        }
      }
    }
    if(location.canVisit && location.type != 'BLOCK' && this.player.current_energy > 0){
      this.currentLocation = location
      this.location.emit(this.currentLocation)
      // this.player.consumeEnergy(1)
      if(location.type == 'SANCTUARY'){
        this.player.restoreEnergy(50)
        this.player.restoreLife(50)
      }
      this.rows.forEach( row => {
        row.forEach(loc => {
          this.isReachableOrVisible(loc)
        })
      })
    } else if(this.player.current_energy <= 0){
      console.log("You need to rest.")
    }
  }

  public getImg(location: Location){
    return location.type == 'MONSTER' ? 
        'assets/broadsword-svgrepo-com.svg' : 
        location.type == 'QUEST' ? 
        'assets/scroll-unfurled-svgrepo-com.svg' : 
        location.type == 'SANCTUARY' ? 
        'assets/heart-tower-svgrepo-com.svg' : ''
  }


  scrollToElement(): void {
    const element = document.getElementById('target-element');
    if (element) {
      const rect = element.getBoundingClientRect();
      window.scrollTo({
        top: rect.top + window.scrollY,
        behavior: 'smooth'
      });
    }
  }
}
