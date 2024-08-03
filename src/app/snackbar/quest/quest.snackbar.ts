import { Component, Inject, inject } from "@angular/core";
import { MatButtonModule } from "@angular/material/button";
import { MAT_SNACK_BAR_DATA, MatSnackBarAction, MatSnackBarActions, MatSnackBarLabel, MatSnackBarRef } from "@angular/material/snack-bar";


export class QuestSnackbarData{
    message: string
    isTrap: boolean

    constructor(msg: string, isTrap: boolean){
        this.message = msg
        this.isTrap = isTrap
    }
}


@Component({
    selector: 'quest.snackbar',
    templateUrl: 'quest.snackbar.html',
    styleUrl: './quest.snackbar.scss',
    standalone: true,
    imports: [MatButtonModule, MatSnackBarLabel, MatSnackBarActions, MatSnackBarAction],
  })
  export class QuestSnackbar {

    constructor(
        @Inject(MAT_SNACK_BAR_DATA) public data: QuestSnackbarData
    ){

    }
    snackBarRef = inject(MatSnackBarRef);
  }