import { Component } from '@angular/core';
import { Location } from './models/location';
import { Player } from './models/player';
import { CommonModule } from '@angular/common';
import { RouterOutlet } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { DungeonComponent } from './components/dungeon/dungeon.component';
import {MatProgressBarModule} from '@angular/material/progress-bar';
import {MatCardModule} from '@angular/material/card';
import { MatSnackBar} from '@angular/material/snack-bar';
import { 
  QuestSnackbar, 
  QuestSnackbarData 
} from './snackbar/quest/quest.snackbar';
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
} from '../assets/icons';
import { PlayerComponent } from './components/player/player.component';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss',
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
export class AppComponent {

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

}
