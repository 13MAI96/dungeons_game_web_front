import { Routes } from '@angular/router';
import { LoginComponent } from './components/login/login.component';
import { GameComponent } from './components/game/game.component';
import { NewPlayerComponent } from './components/new-player/new-player.component';

export const routes: Routes = [
    { path: '', redirectTo: 'login', pathMatch: 'full'},
    { path: 'login', component: LoginComponent },
    { path: 'game', component: GameComponent},
    { path: 'new-player', component: NewPlayerComponent}
];
