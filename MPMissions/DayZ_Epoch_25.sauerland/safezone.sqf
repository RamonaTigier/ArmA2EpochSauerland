//Base protection for Players with Eventhandler
//
//requires Trigger with activation BLUEFOR and OPFOR with name Basis_West and Basis_East
//
// you can't fire out of your own Base
//
//Those who hit or kill Enemy in it's Base, will be killed
//
// Parameters: [name of the side trigger for the Base Area]
//
//Center_West:
//if (playerSide == WEST) then {[Basis_West] execVM "safezone.sqf"};
//
//Center_East:
//if (playerSide == EAST) then {[Basis_East] execVM "safezone.sqf"};
 
 
Private ["_Basis","_EH_Fired","_EH_Hit","_EH_Killed"];
 
 
_Basis = _this select 0; //Basisname
 
while {true} do
  {
    //wait until Player is in base, then start Eventhandler
    waitUntil {vehicle player in list _Basis};
    player groupchat "i am in Baseshield!";
    _EH_Fired  = vehicle player addEventHandler ["Fired", { NearestObject [_this select 0,_this select 4] setPos[0,0,0]}];
    _EH_Hit    = vehicle player addEventHandler ["Hit",  {_this select 1 setdammage 0; player setDammage 0; vehicle player setDammage 0}];
    _EH_Killed = vehicle player addEventHandler ["Killed",{_this select 1 setdammage 0}];

_zombies = _Basis nearEntities ["zZombie_Base",150];
_count = count _zombies;
 
for "_i" from 0 to (_count -1) do
{
_zombie = _zombies select _i;
_zombie setpos [-3367.739,-120.84577,-8247.0625];
};
 
    //wait until Player left base, then delete EventHandler
    waitUntil {! (vehicle player in list _Basis)};
    player groupchat "i have left Baseshield!";
    player removeEventHandler ["Fired", _EH_Fired];
    player removeEventHandler ["Hit",  _EH_Hit];
    player removeEventHandler ["Killed",_EH_Killed];
  }