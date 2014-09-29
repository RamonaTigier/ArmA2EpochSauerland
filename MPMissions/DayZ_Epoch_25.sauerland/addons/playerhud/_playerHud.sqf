disableSerialization;

// player setVariable["AsReMixhud", true];//Variable Show/Hide HUD Support for control player hud

AsReMixhud_Control = true; // player getVariable["AsReMixhud",true];


while {true} do
{
    1000 cutRsc ["AsReMixhud","PLAIN"];
    _wpui = uiNameSpace getVariable "AsReMixhud";
    _vitals = _wpui displayCtrl 4900;
	
	_thePlayer = player;
	
	AsReMixhud_zombieKills 	= _thePlayer getVariable["zombieKills",0];
	AsReMixhud_headshots 	= _thePlayer getVariable["headShots",0];
	AsReMixhud_killsH 		= _thePlayer getVariable["humanKills",0];
    Zupa_bank 				=  _thePlayer getVariable["bank",0];
	AsReMixhud_killsB 		= _thePlayer getVariable["banditKills",0];
	AsReMixhud_humanity 	= _thePlayer getVariable["humanity",0];
	AsReMixhud_zombies 		= "";
	AsReMixhud_zombiesAlive = "";
	AsReMixhud_blood		=  round(r_player_blood);
	AsReMixhud_pid			= "";
	AsReMixhud_puid			= "";
    AsReMixhud_hmnicon 		= "";
	AsReMixhud_fps 			= (round diag_fps); //	<t size='0.8' align='right'>%13 FPS</t><br/>	
	AsReMixhud_svrname		= "Ladi&TiggA";
	
	// MagicTigger %16 - %?? start
	MT_HUD_pic = (gettext (configFile >> 'CfgVehicles' >> (typeof vehicle player) >> 'picture'));
        if (player == vehicle player) then
        {
			_pic = (gettext (configFile >> 'cfgWeapons' >> (currentWeapon player) >> 'picture'));
        }
			else
        {
			_pic = (gettext (configFile >> 'CfgVehicles' >> (typeof vehicle player) >> 'picture'));
        };
	MT_HUD_name = name _character;
	MT_HUD_temp = round(_thePlayer getVariable ["temperature",100]); // round(dayz_temperatur);
	MT_HUD_zombies = count entities "zZombie_Base";
    MT_HUD_zombiesA =     {alive _x} count entities "zZombie_Base";
	MT_HUD_dayZ		= (dayz_Survived);
	_nearestCity = nearestLocations [getPos player, ["NameCityCapital","NameCity","NameVillage","NameLocal"],750];
        MT_HUD_nextC = "Wildniss";
        if (count _nearestCity > 0) then {MT_HUD_nextC = text (_nearestCity select 0)};
	_walked = _thePlayer getVariable["distanceWalked",0]; // distanceWalked??
		MT_HUD_walked = round(_walked/3280,8399);
	// MagicTigger end
	
	_stime = 0;
	if(serverTime > 36000)then{_stime = time;}else{_stime = serverTime;};
	_hours = (_stime/60/60);
	_hours = toArray (str _hours);
	_hours resize 1;
	_hours = toString _hours;
	_hours = compile _hours;
	_hours = call  _hours;
	_minutes = floor(_stime/60);
	_minutes2 = ((_minutes - (_hours*60)) min 60) max 0;if (_minutes2 < 10) then {_minutes2 = format ['0%1',_minutes2];};
    

	if(AsReMixhud_humanity >= 5000) then { AsReMixhud_hmnicon = "<img size='0.8' image='addons\playerhud\icons\As_hmhero.paa'/>"; };
	if((AsReMixhud_humanity >= 200) && (AsReMixhud_humanity <= 4999)) then { AsReMixhud_hmnicon = "<img size='0.8' image='addons\playerhud\icons\As_hmcivil.paa'/>"; };
	if(AsReMixhud_humanity <= 199) then { AsReMixhud_hmnicon = "<img size='0.8' image='addons\playerhud\icons\As_hmbandit.paa'/>"; };
	
	_vitals ctrlSetStructuredText parseText format ["
		<t size='0.8' align='right'>Epoch 1.0.5.1</t><br/>
		<t size='0.9'> %2 %5 </t><img size='0.8' align='right' image='addons\playerhud\icons\As_humanity.paa'/>  <br/> 
		<t size='0.9'> %3 </t><img size='0.8' align='right' image='addons\playerhud\icons\As_headshot.paa'/>   <br/>
		<t size='0.9'> %20/%19 </t><img size='0.8' align='right' image='addons\playerhud\icons\As_zombie.paa'/>   <br/>
		<t size='0.9'> %4 </t><img size='0.8' align='right' image='addons\playerhud\icons\As_zkill.paa'/>  <br/>
		<t size='0.9'> %9 </t><img size='0.8' align='right' image='addons\playerhud\icons\As_killb.paa'/>  <br/>
		<t size='0.9'> %10 </t><img size='0.8' align='right' image='addons\playerhud\icons\As_killh.paa'/>  <br/> 
		<t size='0.9'> %21 </t><img size='0.8' align='right' image='addons\playerhud\icons\dollars.paa'/>  <br/> 
		<t size='0.8' align='right'>Nächster Ort: %22</t><br/>
		<t size='0.8' align='right'>Temperatur: %18</t><br/>
		<t size='0.8' align='right'>%11h %12min Server uptime</t><br/>
		<t size='0.8' align='right'>Überlebt seit: %21</t><br/>
		<img size='3' image='%17'/><br/>",
	AsReMixhud_blood,   		// 1
	AsReMixhud_humanity,		// 2
	AsReMixhud_headshots,		// 3
	AsReMixhud_zombiekills,		// 4
	AsReMixhud_hmnicon,			// 5
	name player,				// 6
	AsReMixhud_zombiesAlive,	// 7
	AsReMixhud_zombies,			// 8
	AsReMixhud_killsB,			// 9
	AsReMixhud_killsH,			//10
	_hours,						//11
	_minutes2,					//12
	AsReMixhud_fps,				//13
	Zupa_bank,					//14 <t size='0.9'> %14 </t><img size='0.8' align='right' image='addons\playerhud\icons\equip_safe_CA.paa'/>   <br/>
	AsReMixhud_svrname,			//15
	MT_HUD_name,				//16
	MT_HUD_pic,					//17
	MT_HUD_temp,				//18
	MT_HUD_zombies, 			//19
	MT_HUD_zombiesA,			//20
	MT_HUD_dayZ,				//21
	MT_HUD_nextC				//22
	];
	_vitals ctrlCommit 0;
        
    sleep 2;
};
