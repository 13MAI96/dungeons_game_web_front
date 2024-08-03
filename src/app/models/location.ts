export class Location {
    _id: string | null
    column: number
    row: number
    type: string | null
    content: any // EXIT = 7
    visited: boolean = false
    visible: boolean = false
    canVisit: boolean = false
    show: boolean = false
    
    constructor(column: number, row: number, type: string, _id: string | null = null){
        this.column = column
        this.row = row
        this.type = type
        this._id = _id
    }
}
