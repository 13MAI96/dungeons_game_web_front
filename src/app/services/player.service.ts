import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, Subscription, of } from 'rxjs';
import { Player } from '../models/player';
import { BodyResponse } from '../models/response'

@Injectable({
  providedIn: 'root'
})
export class PlayerService {

  constructor(
    private _http: HttpClient
  ) { 

  }

//   local_url: string = 'http://192.168.21.45:8000'
  local_url: string = '127.0.0.1:4600'

  login(player: Player): Observable<BodyResponse<Player | null>>{
    // return this._http.get(this.local_url)
    if(player.username == '13mai96') return of(new BodyResponse(player, 200, 'User logued'))
    else return of(new BodyResponse(null, 400, 'User or password incorrect'))
  }
}
