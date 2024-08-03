import { Component, Inject } from "@angular/core";
import { MatButtonModule } from "@angular/material/button";
import { MAT_DIALOG_DATA, MatDialogActions, MatDialogClose, MatDialogContent, MatDialogRef, MatDialogTitle } from "@angular/material/dialog";

export class QuestDialogData{
    message: string
    result: boolean

    constructor(msg: string, result: boolean){
        this.message = msg
        this.result = result
    }
}

@Component({
    selector: 'quest-dialog',
    templateUrl: 'quest.dialog.html',
    styleUrl: './quest.dialog.scss',
    standalone: true,
    imports: [MatButtonModule, MatDialogActions, MatDialogClose, MatDialogTitle, MatDialogContent],
  })
  export class QuestDialog {
    constructor(
        public dialogRef: MatDialogRef<QuestDialog>,
        @Inject(MAT_DIALOG_DATA) public data: QuestDialogData
    ) {}
  }