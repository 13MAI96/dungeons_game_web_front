import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, Subscription } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class DungeonsDataService {

  constructor(
    private _http: HttpClient
  ) { 

  }

  // local_url: string = 'http://192.168.21.45:8000'
  local_url: string = 'http://127.0.0.1:4600/'

  getDungeon(): Observable<any>{
    return this._http.get(this.local_url)
  }

  
}
