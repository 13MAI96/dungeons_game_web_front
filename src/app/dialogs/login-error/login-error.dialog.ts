import { Component, Inject } from "@angular/core";
import { MatButtonModule } from "@angular/material/button";
import { MAT_DIALOG_DATA, MatDialogActions, MatDialogClose, MatDialogContent, MatDialogRef, MatDialogTitle } from "@angular/material/dialog";
import { Router } from "@angular/router";

export class QuestDialogData{
    message: string
    result: boolean

    constructor(msg: string, result: boolean){
        this.message = msg
        this.result = result
    }
}

@Component({
    selector: 'login-error-dialog',
    templateUrl: 'login-error.dialog.html',
    styleUrl: './login-error.dialog.scss',
    standalone: true,
    imports: [MatButtonModule, MatDialogActions, MatDialogClose, MatDialogTitle, MatDialogContent],
  })
export class LoginErrorDialog {
    constructor(
        // public dialogRef: MatDialogRef<QuestDialog>,
        @Inject(MAT_DIALOG_DATA) public data: QuestDialogData,
        private router: Router
    ) {}

    public createPlayer(){
        console.log('Create player')
        this.router.navigate(['new-player']);
    }
}