import { Location } from "./location"

export class Dungeon {
    _id: string | null = null
    number_of_columns: number
    number_of_rows: number
    locations: Location[]
    q_locations: number

    constructor(number_of_columns: number, number_of_rows: number, locations: Location[], q_locations: number, _id = null){
        this.locations = locations
        this.number_of_columns = number_of_columns
        this.number_of_rows = number_of_rows
        this.q_locations = q_locations
    }
}
