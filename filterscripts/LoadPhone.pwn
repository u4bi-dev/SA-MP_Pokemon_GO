
#include<a_samp>
#define USED_PHONE 18

new Text:TextDrawPhone[18];

public OnFilterScriptInit()
{
	TextDrawPhone[0] = TextDrawCreate(507.000183, 195.792556, "ld_pool:ball");
    TextDrawLetterSize(TextDrawPhone[0], 0.000000, 0.000000);
    TextDrawTextSize(TextDrawPhone[0], 16.000000, 16.000000);
    TextDrawAlignment(TextDrawPhone[0], 1);
    TextDrawColor(TextDrawPhone[0], -2139062017);
    TextDrawSetShadow(TextDrawPhone[0], 0);
    TextDrawSetOutline(TextDrawPhone[0], 0);
    TextDrawFont(TextDrawPhone[0], 4);

    TextDrawPhone[1] = TextDrawCreate(506.666839, 404.199951, "ld_pool:ball");
    TextDrawLetterSize(TextDrawPhone[1], 0.000000, 0.000000);
    TextDrawTextSize(TextDrawPhone[1], 16.000000, -16.000000);
    TextDrawAlignment(TextDrawPhone[1], 1);
    TextDrawColor(TextDrawPhone[1], -2139062017);
    TextDrawSetShadow(TextDrawPhone[1], 0);
    TextDrawSetOutline(TextDrawPhone[1], 0);
    TextDrawFont(TextDrawPhone[1], 4);

    TextDrawPhone[2] = TextDrawCreate(578.666870, 404.199951, "ld_pool:ball");
    TextDrawLetterSize(TextDrawPhone[2], 0.000000, 0.000000);
    TextDrawTextSize(TextDrawPhone[2], 16.000000, -16.000000);
    TextDrawAlignment(TextDrawPhone[2], 1);
    TextDrawColor(TextDrawPhone[2], -2139062017);
    TextDrawSetShadow(TextDrawPhone[2], 0);
    TextDrawSetOutline(TextDrawPhone[2], 0);
    TextDrawFont(TextDrawPhone[2], 4);

    TextDrawPhone[3] = TextDrawCreate(578.666870, 195.792541, "ld_pool:ball");
    TextDrawLetterSize(TextDrawPhone[3], 0.000000, 0.000000);
    TextDrawTextSize(TextDrawPhone[3], 16.000000, 16.000000);
    TextDrawAlignment(TextDrawPhone[3], 1);
    TextDrawColor(TextDrawPhone[3], -2139062017);
    TextDrawSetShadow(TextDrawPhone[3], 0);
    TextDrawSetOutline(TextDrawPhone[3], 0);
    TextDrawFont(TextDrawPhone[3], 4);

    TextDrawPhone[4] = TextDrawCreate(507.000061, 202.844375, "LD_SPAC:white");
    TextDrawLetterSize(TextDrawPhone[4], 0.000000, 0.000000);
    TextDrawTextSize(TextDrawPhone[4], 87.666656, 194.962951);
    TextDrawAlignment(TextDrawPhone[4], 1);
    TextDrawColor(TextDrawPhone[4], -2139062017);
    TextDrawSetShadow(TextDrawPhone[4], 0);
    TextDrawSetOutline(TextDrawPhone[4], 0);
    TextDrawFont(TextDrawPhone[4], 4);

    TextDrawPhone[5] = TextDrawCreate(513.666564, 195.548095, "LD_SPAC:white");
    TextDrawLetterSize(TextDrawPhone[5], 0.000000, 0.000000);
    TextDrawTextSize(TextDrawPhone[5], 74.666641, 208.651809);
    TextDrawAlignment(TextDrawPhone[5], 1);
    TextDrawColor(TextDrawPhone[5], -2139062017);
    TextDrawSetShadow(TextDrawPhone[5], 0);
    TextDrawSetOutline(TextDrawPhone[5], 0);
    TextDrawFont(TextDrawPhone[5], 4);

    TextDrawPhone[6] = TextDrawCreate(507.333496, 196.377746, "ld_pool:ball");
    TextDrawLetterSize(TextDrawPhone[6], 0.000000, 0.000000);
    TextDrawTextSize(TextDrawPhone[6], 16.000000, 16.000000);
    TextDrawAlignment(TextDrawPhone[6], 1);
    TextDrawColor(TextDrawPhone[6], 255);
    TextDrawSetShadow(TextDrawPhone[6], 0);
    TextDrawSetOutline(TextDrawPhone[6], 0);
    TextDrawFont(TextDrawPhone[6], 4);

    TextDrawPhone[7] = TextDrawCreate(507.333496, 403.540649, "ld_pool:ball");
    TextDrawLetterSize(TextDrawPhone[7], 0.000000, 0.000000);
    TextDrawTextSize(TextDrawPhone[7], 16.000000, -16.000000);
    TextDrawAlignment(TextDrawPhone[7], 1);
    TextDrawColor(TextDrawPhone[7], 255);
    TextDrawSetShadow(TextDrawPhone[7], 0);
    TextDrawSetOutline(TextDrawPhone[7], 0);
    TextDrawFont(TextDrawPhone[7], 4);

    TextDrawPhone[8] = TextDrawCreate(578.000244, 403.540649, "ld_pool:ball");
    TextDrawLetterSize(TextDrawPhone[8], 0.000000, 0.000000);
    TextDrawTextSize(TextDrawPhone[8], 16.000000, -16.000000);
    TextDrawAlignment(TextDrawPhone[8], 1);
    TextDrawColor(TextDrawPhone[8], 255);
    TextDrawSetShadow(TextDrawPhone[8], 0);
    TextDrawSetOutline(TextDrawPhone[8], 0);
    TextDrawFont(TextDrawPhone[8], 4);

    TextDrawPhone[9] = TextDrawCreate(578.000305, 196.377746, "ld_pool:ball");
    TextDrawLetterSize(TextDrawPhone[9], 0.000000, 0.000000);
    TextDrawTextSize(TextDrawPhone[9], 16.000000, 16.000000);
    TextDrawAlignment(TextDrawPhone[9], 1);
    TextDrawColor(TextDrawPhone[9], 255);
    TextDrawSetShadow(TextDrawPhone[9], 0);
    TextDrawSetOutline(TextDrawPhone[9], 0);
    TextDrawFont(TextDrawPhone[9], 4);

    TextDrawPhone[10] = TextDrawCreate(514.666809, 196.622222, "LD_SPAC:white");
    TextDrawLetterSize(TextDrawPhone[10], 0.000000, 0.000000);
    TextDrawTextSize(TextDrawPhone[10], 72.000022, 206.992568);
    TextDrawAlignment(TextDrawPhone[10], 1);
    TextDrawColor(TextDrawPhone[10], 255);
    TextDrawSetShadow(TextDrawPhone[10], 0);
    TextDrawSetOutline(TextDrawPhone[10], 0);
    TextDrawFont(TextDrawPhone[10], 4);

    TextDrawPhone[11] = TextDrawCreate(507.666656, 204.674133, "LD_SPAC:white");
    TextDrawLetterSize(TextDrawPhone[11], 0.000000, 0.000000);
    TextDrawTextSize(TextDrawPhone[11], 86.333419, 191.229660);
    TextDrawAlignment(TextDrawPhone[11], 1);
    TextDrawColor(TextDrawPhone[11], 255);
    TextDrawSetShadow(TextDrawPhone[11], 0);
    TextDrawSetOutline(TextDrawPhone[11], 0);
    TextDrawFont(TextDrawPhone[11], 4);

    TextDrawPhone[12] = TextDrawCreate(511.333435, 221.925933, "LD_otb:blue");
    TextDrawLetterSize(TextDrawPhone[12], 0.000000, 0.000000);
    TextDrawTextSize(TextDrawPhone[12], 78.666633, 155.140731);
    TextDrawAlignment(TextDrawPhone[12], 1);
    TextDrawColor(TextDrawPhone[12], -1768515841);
    TextDrawSetShadow(TextDrawPhone[12], 0);
    TextDrawSetOutline(TextDrawPhone[12], 0);
    TextDrawFont(TextDrawPhone[12], 4);

    TextDrawPhone[13] = TextDrawCreate(549.666809, 201.599945, "ld_pool:ball");
    TextDrawLetterSize(TextDrawPhone[13], 0.000000, 0.000000);
    TextDrawTextSize(TextDrawPhone[13], 3.333292, 4.148138);
    TextDrawAlignment(TextDrawPhone[13], 1);
    TextDrawColor(TextDrawPhone[13], -2139062142);
    TextDrawSetShadow(TextDrawPhone[13], 0);
    TextDrawSetOutline(TextDrawPhone[13], 0);
    TextDrawFont(TextDrawPhone[13], 4);

    TextDrawPhone[14] = TextDrawCreate(544.999877, 209.896240, "ld_poke:cd1d");
    TextDrawLetterSize(TextDrawPhone[14], 0.000000, 0.000000);
    TextDrawTextSize(TextDrawPhone[14], 12.333331, 2.074084);
    TextDrawAlignment(TextDrawPhone[14], 1);
    TextDrawColor(TextDrawPhone[14], -2139062142);
    TextDrawSetShadow(TextDrawPhone[14], 0);
    TextDrawSetOutline(TextDrawPhone[14], 0);
    TextDrawFont(TextDrawPhone[14], 4);

    TextDrawPhone[15] = TextDrawCreate(541.000366, 210.066589, "ld_pool:ball");
    TextDrawLetterSize(TextDrawPhone[15], 0.000000, 0.000000);
    TextDrawTextSize(TextDrawPhone[15], 1.333292, 1.244433);
    TextDrawAlignment(TextDrawPhone[15], 1);
    TextDrawColor(TextDrawPhone[15], -2139062142);
    TextDrawSetShadow(TextDrawPhone[15], 0);
    TextDrawSetOutline(TextDrawPhone[15], 0);
    TextDrawFont(TextDrawPhone[15], 4);

    TextDrawPhone[16] = TextDrawCreate(543.333618, 380.311004, "ld_pool:ball");
    TextDrawLetterSize(TextDrawPhone[16], 0.000000, 0.000000);
    TextDrawTextSize(TextDrawPhone[16], 16.333269, 18.251844);
    TextDrawAlignment(TextDrawPhone[16], 1);
    TextDrawColor(TextDrawPhone[16], -1061109690);
    TextDrawSetShadow(TextDrawPhone[16], 0);
    TextDrawSetOutline(TextDrawPhone[16], 0);
    TextDrawFont(TextDrawPhone[16], 4);

    TextDrawPhone[17] = TextDrawCreate(511.333496, 221.925994, "ld_plan:tvbase");
    TextDrawLetterSize(TextDrawPhone[17], 0.000000, 0.000000);
    TextDrawTextSize(TextDrawPhone[17], 78.666702, 9.540740);
    TextDrawAlignment(TextDrawPhone[17], 1);
    TextDrawColor(TextDrawPhone[17], -1);
    TextDrawSetShadow(TextDrawPhone[17], 0);
    TextDrawSetOutline(TextDrawPhone[17], 0);
    TextDrawFont(TextDrawPhone[17], 4);
    
	return 1;
}
public OnPlayerConnect(playerid)
{
	for(new i = 0;i<USED_PHONE;i++)
	{
		TextDrawShowForPlayer(playerid,TextDrawPhone[i]);
	}
	return 1;
}

public OnFilterScriptExit()
{
	for(new i = 0;i<USED_PHONE;i++)
	{
		TextDrawDestroy(TextDrawPhone[i]);
	}
	return 1;
}

