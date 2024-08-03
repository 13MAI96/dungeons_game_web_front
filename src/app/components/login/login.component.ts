import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterOutlet } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import {MatProgressBarModule} from '@angular/material/progress-bar';
import {MatCardModule} from '@angular/material/card';
import { MatSnackBar} from '@angular/material/snack-bar';
import { MatFormFieldModule } from '@angular/material/form-field'
import { 
  MatIconModule, 
} from '@angular/material/icon';
import { Player } from '../../models/player';
import { FormControl, FormsModule, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatInputModule } from '@angular/material/input'
import { PlayerService } from '../../services/player.service';
import { MatDialog } from '@angular/material/dialog';
import { LoginErrorDialog } from '../../dialogs/login-error/login-error.dialog';

@Component({
  selector: 'login-component',
  templateUrl: './login.component.html',
  styleUrl: './login.component.scss',
  imports: [
    CommonModule,
    RouterOutlet, 
    CommonModule,
    MatProgressBarModule,
    MatButtonModule,
    MatCardModule,
    MatIconModule,
    FormsModule, 
    MatFormFieldModule,
    ReactiveFormsModule,
    MatInputModule
  ],
  standalone: true
})
export class LoginComponent {

  player!: Player

  userFormControl = new FormControl('', [Validators.required]);
  passFormControl = new FormControl('', [Validators.required]);


  constructor(
    private _snackBar: MatSnackBar,
    private _dialog: MatDialog,
    private playerService: PlayerService,
    private router: Router
  ){ }

  login(){
    if(this.userFormControl.invalid || this.passFormControl.invalid){
      this.userFormControl.markAsTouched()
      this.passFormControl.markAsTouched()
      return
    }
    
    this.player = new Player(this.userFormControl.value ?? '', this.passFormControl.value ?? '')
    this.playerService.login(this.player).subscribe(data => {
      if(data.body) this.router.navigate(['game'])
      else {
        this._dialog.open(LoginErrorDialog, {
          width: '30vw',
          height: '20vh'
        })
        console.log('Error')
      }
    })
  }

//   openSnackBar(data: QuestSnackbarData) {
//     this._snackBar.openFromComponent(QuestSnackbar, {
//       data:data,
//       duration: 3 * 1000,
//       verticalPosition: 'top'
//     });
//   }

}
