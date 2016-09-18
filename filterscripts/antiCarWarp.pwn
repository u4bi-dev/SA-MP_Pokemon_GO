#include <foreach>
#define ENUM_WARP 3
enum WARP{
   bool:CHECK,
   bool:INCAR,
   CARID
}
new WarpDTO[MAX_PLAYERS][WARP];


/*=========================================================================*/

public OnGameModeInit(){
	server_init();
	
	return 1;
}

stock server_init(){
	SetTimer("WarpThread", 50, true);
}

forward WarpThread();
public WarpThread(){
    foreach (new i : Player){
        warpManager(i);
	}
}

stock warpManager(playerid){
	if(!WarpDTO[playerid][INCAR]) return false;
	
	new carid = GetPlayerVehicleID(playerid);
	if(WarpDTO[playerid][CARID] != carid && carid != 0)SendClientMessage(playerid, -1, "핵임");
	return 1;
}

/*=========================================================================
TODO : 모드내 차량 탑승 코드 부분에 inCar(playerid,vehicleid) 선언해야함

   예를 들어 /강타 같은 경우

   /강타 [유저번호] [차번호] [차시트]{
      inCar(유저번호, 차번호);
      PutPlayerInVehicle(유저번호, 차번호, 0);
      기존코드 블라블라;
   }

   /차소환(/v){
      new 차번호 = CreateVehicle(123123,123,123,123);
      inCar(유저번호, 차번호);
      PutPlayerInVehicle(유저번호, 차번호, 0);
      기존코드 블라블라;
   }
    PutPlayerInVehicleEX 만들어도 좋음
*/

/* SEE : 차량 탑승키를 눌렀을 시*/
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger){
	inCar(playerid,vehicleid);
	return 1;
}

/* 유저상태*/
public OnPlayerStateChange(playerid, newstate, oldstate){
    switch(newstate){
        case PLAYER_STATE_ONFOOT:warpInit(playerid);
        case PLAYER_STATE_DRIVER..PLAYER_STATE_PASSENGER:checkWarp(playerid);
    }
   return 1;
}


/*=========================================================================*/

/* 탑승부선언*/
stock inCar(playerid,vehicleid){
   WarpDTO[playerid][CARID]=vehicleid;
   WarpDTO[playerid][CHECK]=true;
}

/* 체킹*/
stock checkWarp(playerid){
   new msg[32];
   format(msg,sizeof(msg), "정상탑승 : %s", (WarpDTO[playerid][CHECK]) ? ("맞음") : ("아님"));
   SendClientMessage(playerid, -1, msg);

   WarpDTO[playerid][INCAR]=true;
   
   if(!WarpDTO[playerid][CHECK]){
      new carid = GetPlayerVehicleID(playerid);
      if(WarpDTO[playerid][CARID] != carid && carid != 0)SendClientMessage(playerid, -1, "핵임");
   }
}

/* 초기화*/
stock warpInit(playerid){
   new temp[WARP];
   for(new i=0; i < ENUM_WARP; i++)WarpDTO[playerid] = temp;
}

