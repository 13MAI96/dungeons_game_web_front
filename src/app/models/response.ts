export class BodyResponse<T>{
    body: T
    code: number
    message: string

    constructor(body: T, code: number, message: string){
        this.body = body
        this.code = code
        this.message = message
    }
}