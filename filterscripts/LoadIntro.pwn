#include<a_samp>
#define USED_DRAWS 400
enum textdraw
{
	Text:id,
	used
}
new Text:introBG[3];
new bool:isOn[MAX_PLAYERS];
public OnFilterScriptInit()
{
	introBG[0] = TextDrawCreate(-20.000000,2.000000,"|");
	TextDrawUseBox(introBG[0],1);
	TextDrawBoxColor(introBG[0],0xFFFFFFFF);
	TextDrawTextSize(introBG[0],660.000000,22.000000);
	TextDrawAlignment(introBG[0],0);
	TextDrawBackgroundColor(introBG[0],0xFFFFFFFF);
	TextDrawFont(introBG[0],3);
	TextDrawLetterSize(introBG[0],1.000000,52.200000);
	TextDrawColor(introBG[0],0xFFFFFFFF);
	TextDrawSetOutline(introBG[0],1);
	TextDrawSetProportional(introBG[0],1);
	TextDrawSetShadow(introBG[0],1);

    introBG[1] = TextDrawCreate(258.000000, 109.000000, "FOKEMON");
    TextDrawBackgroundColor(introBG[1], 0x2964B0FF);
    TextDrawFont(introBG[1], 1);
    TextDrawLetterSize(introBG[1], 0.699999, 4.599997);
    TextDrawColor(introBG[1], 0xFECB0EFF);
    TextDrawSetOutline(introBG[1], 2);
    TextDrawSetProportional(introBG[1], 1);

    introBG[2] = TextDrawCreate(298.000000, 139.000000, "GO");
    TextDrawBackgroundColor(introBG[2], 0x000824FF);
    TextDrawFont(introBG[2], 1);
    TextDrawLetterSize(introBG[2], 0.699999, 4.599997);
    TextDrawColor(introBG[2], 0x0C4CA3FF);
    TextDrawSetOutline(introBG[2], 1);
    TextDrawSetProportional(introBG[2], 1);
    
	return 1;
}
public OnPlayerConnect(playerid)
{
	showIntroImg(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	isOn[playerid]=false;
	return 1;
}
public OnPlayerSpawn(playerid)
{
	if(isOn[playerid]==false){
		hideIntroImg(playerid);
		isOn[playerid]=true;
	}
    return 1;
}

stock showIntroImg(playerid){
	TextDrawShowForPlayer(playerid, introBG[0]);
	TextDrawShowForPlayer(playerid, introBG[1]);
	TextDrawShowForPlayer(playerid, introBG[2]);
}
stock hideIntroImg(playerid){
 	TextDrawHideForPlayer(playerid, introBG[0]);
 	TextDrawHideForPlayer(playerid, introBG[1]);
 	TextDrawHideForPlayer(playerid, introBG[2]);
}

public OnFilterScriptExit()
{
	TextDrawDestroy(introBG[0]);
	TextDrawDestroy(introBG[1]);
	TextDrawDestroy(introBG[2]);
	return 1;
}

