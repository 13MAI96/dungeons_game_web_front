export class Player {
    username: string
    _password: string
    // visible stats
    private _life: number = 0
    private _armor: number = 0
    private _mana: number = 0
    private _damage: number = 0
    private _energy: number = 0
    private _reputation: number = 0
    private _level: number = 1
    private _experience_next_level: number = 0
    
    // variable stats
    private strength: number = 1
    private vitality: number = 1
    private accuracy: number = 1
    private agility: number = 1
    private vision: number = 1 //Is used?
    private magic: number = 1
    private experience: number = 0

    private _current_life: number = 0
    private _current_energy: number = 0
    private _current_damage: number = 0
    private _current_mana: number = 0
    private _current_armor: number = 0
    private _current_reputation: number = 0
    private _current_experience: number = 0

    constructor(
        username: string,
        password: string
    ){
        this.username = username
        this._password = password
        this.setVisibleStats()
    }

    setVisibleStats(){
        this._life = this.strength * 2 + this.vitality * 8
        this._armor = this.strength * 2 + this.agility
        this._mana = this.magic * 10 + this.vitality * 2
        this._damage = Math.floor(this.strength + this.accuracy * 0.5 + this.agility * 0.5)
        this._energy = this.agility * 3 + this.vitality * 8
        this._current_life = this._life
        this._current_energy = this._energy
        this._current_damage = this._damage
        this._current_mana = this._mana
        this._current_armor = this._armor
        this._reputation = Math.pow(15, this._level+1)
        this._experience_next_level = Math.pow(10,this._level+1)
    }

    public restoreLife(percentaje: number | null, q: number | null = null){
        if(percentaje) this._current_life += Math.round((this._life*percentaje)/100)
        if(q) this._current_life += q
        if (this._current_life > this._life){
            this._current_life = this._life
        }
    }

    get energy(){
        return this._energy
    }

    get life(){
        return this._life
    }

    get damage(){
        return this._damage
    }

    get mana(){
        return this._mana
    }

    get armor(){
        return this._armor
    }

    get reputation(){
        return this._reputation
    }

    get current_life(){
        return this._current_life
    }

    get current_energy(){
        return this._current_energy
    }

    get current_damage(){
        return this._current_damage
    }

    get current_mana(){
        return this._current_mana
    }

    get current_armor(){
        return this._current_armor
    }

    get current_reputation(){
        return this._current_reputation
    }

    get current_experience(){
        return this._current_experience
    }

    get experience_next_level(){
        return this._experience_next_level
    }

    get getVision(){
        return this.vision
    }

    get level(){
        return this._level
    }

    public consumeEnergy(q: number){
        this._current_energy = this._current_energy - q
    }

    public restoreEnergy(percentaje: number | null, q: number | null = null){
        if(percentaje) this._current_energy += Math.round((this._energy * percentaje)/100)
        if(q) this._current_energy += q
        if (this._current_energy > this._energy){
            this._current_energy = this._energy
        }
    }

    public restoreStatus(){
        this._current_life = this._life
        this._current_energy = this._energy
        this._current_damage = this._damage
        this._current_mana = this._mana
        this._current_armor = this._armor
        // this._current_reputation = this._reputation
        this._current_experience = 0
    }

    public restoreWithMana(){
        if(this._current_mana > 9){
            this.restoreEnergy(20)
            this.restoreLife(20)
            this._current_mana -= 10
        }
    }

    public addExperience(q: number){
        this._current_experience += q
    }

    public loseLife(q: number){
        this._current_life -= q
    }

    public dead(){
        this._current_experience = 0
        this._current_reputation = 0
    }
}
