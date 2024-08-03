import { Component } from '@angular/core';
import { Location } from '../../models/location';
import { Player } from '../../models/player';
import { CommonModule } from '@angular/common';
import { RouterOutlet } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { DungeonComponent } from '../dungeon/dungeon.component';
import {MatProgressBarModule} from '@angular/material/progress-bar';
import {MatCardModule} from '@angular/material/card';
import { MatSnackBar} from '@angular/material/snack-bar';
import { 
  QuestSnackbar, 
  QuestSnackbarData 
} from '../../snackbar/quest/quest.snackbar';
import { DomSanitizer } from '@angular/platform-browser';
import { 
  MatIconModule, 
  MatIconRegistry 
} from '@angular/material/icon';
import { 
  bombExplosionSvgRepo, 
  broadswordSvgRepo, 
  corkedTubeSvgRepo, 
  heartTowerSvgRepo, 
  heartsSvgRepo, 
  lightningBoltSvgRepo, 
  scrollUnfurledSvgRepo, 
  shieldSvgRepo, 
  trophySvgRepo, 
  underhandSvgRepo 
} from '../../../assets/icons';
import { PlayerComponent } from '../player/player.component';

@Component({
  selector: 'game-component',
  templateUrl: './game.component.html',
  styleUrl: './game.component.scss',
  imports: [
    CommonModule,
    RouterOutlet, 
    CommonModule,
    MatProgressBarModule,
    MatButtonModule,
    MatCardModule,
    MatIconModule,
    DungeonComponent,
    PlayerComponent
  ],
  standalone: true
})
export class GameComponent {

  player: Player = new Player('', '')

  isDungeonOpen: boolean = false
  
  currentLocation!: Location | undefined

  constructor(
    private _snackBar: MatSnackBar,
    private iconRegistry: MatIconRegistry, 
    private sanitizer: DomSanitizer
  ){
    this.iconRegistry.addSvgIconLiteral('heartsSvgRepo', this.sanitizer.bypassSecurityTrustHtml(heartsSvgRepo))
    this.iconRegistry.addSvgIconLiteral('shieldSvgRepo', this.sanitizer.bypassSecurityTrustHtml(shieldSvgRepo))
    this.iconRegistry.addSvgIconLiteral('bombExplosionSvgRepo', this.sanitizer.bypassSecurityTrustHtml(bombExplosionSvgRepo))
    this.iconRegistry.addSvgIconLiteral('broadswordSvgRepo', this.sanitizer.bypassSecurityTrustHtml(broadswordSvgRepo))
    this.iconRegistry.addSvgIconLiteral('corkedTubeSvgRepo', this.sanitizer.bypassSecurityTrustHtml(corkedTubeSvgRepo))
    this.iconRegistry.addSvgIconLiteral('heartTowerSvgRepo', this.sanitizer.bypassSecurityTrustHtml(heartTowerSvgRepo))
    this.iconRegistry.addSvgIconLiteral('lightningBoltSvgRepo', this.sanitizer.bypassSecurityTrustHtml(lightningBoltSvgRepo))
    this.iconRegistry.addSvgIconLiteral('scrollUnfurledSvgRepo', this.sanitizer.bypassSecurityTrustHtml(scrollUnfurledSvgRepo))
    this.iconRegistry.addSvgIconLiteral('trophySvgRepo', this.sanitizer.bypassSecurityTrustHtml(trophySvgRepo))
    this.iconRegistry.addSvgIconLiteral('underhandSvgRepo', this.sanitizer.bypassSecurityTrustHtml(underhandSvgRepo))
  }

  public newLocation(location: Location){
    this.currentLocation = location
  }

  public toggleDungeon(){
    if(this.isDungeonOpen && this.currentLocation?.type != 'ENTRANCE') 
      if (!confirm("If you get out in this moment, you will lose reputation.").valueOf()){
        return
      }
    this.player.restoreStatus()
    this.isDungeonOpen = !this.isDungeonOpen
  }

  public restStatus(){
    this.player.restoreWithMana()
  }

  public attackMonster(){
    if(this.currentLocation){
      this.player.consumeEnergy(2)
      let resultado = (Math.random() * 20 + this.player.current_damage) 
      if(resultado == 20){
        this.currentLocation.content.life -= this.player.damage * 2
        this.currentLocation.visited = this.currentLocation.content.life <= 0
      } else if(resultado > this.currentLocation.content.armor){
        this.currentLocation.content.life -= this.player.damage
        this.currentLocation.visited = this.currentLocation.content.life <= 0
        if(this.currentLocation.visited){
          this.player.addExperience(this.currentLocation.content.experience)
          return
        }
        let counterAttack = Math.random()*20 + this.currentLocation.content.damage
        if(counterAttack > this.player.armor){
          this.openSnackBar(new QuestSnackbarData("The monster was hit you.", true))
          this.player.loseLife(this.currentLocation.content.damage)
        }
      } else if(resultado < this.currentLocation.content.damage){
        this.openSnackBar(new QuestSnackbarData("The monster was hit you.", true))
        this.player.loseLife(this.currentLocation.content.damage)
      }
    }
    return
  }

  public collectTreasure(){
    if(this.currentLocation){
      this.player.consumeEnergy(1)
      this.currentLocation.visited = true
      if(Math.random() * 20 > 20 - (this.player.getVision*5)/this.player.level){
        this.player.addExperience(5)
        this.openSnackBar(new QuestSnackbarData("You obtain experience.", false))
      } else {
        this.player.loseLife(2)
        this.openSnackBar(new QuestSnackbarData("You fell into a trap.", true))
      }
    }
  }

  openSnackBar(data: QuestSnackbarData) {
    this._snackBar.openFromComponent(QuestSnackbar, {
      data:data,
      duration: 3 * 1000,
      verticalPosition: 'top'
    });
  }

  public loseDungeon(event: boolean){
    if(event){
      this.isDungeonOpen = false
      this.player.dead()
      this.currentLocation = undefined 
      this.player.restoreStatus()
    }
  }
}
