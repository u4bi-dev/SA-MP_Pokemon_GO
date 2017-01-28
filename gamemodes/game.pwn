#include <a_samp>
#include <a_mysql>
#include <foreach>
#include <physics>
#include <audio>

/*
CREATE TABLE BOARD_TABLE(
ID INT PRIMARY KEY AUTO_INCREMENT,
TITLE VARCHAR(255) NOT NULL,
description text NULL,
created datetime NOT NULL
*/
/*
CREATE TABLE DMSERVER_TABLE(
ID INT PRIMARY KEY AUTO_INCREMENT,
NAME VARCHAR(24) NOT NULL,
PASS VARCHAR(24) NOT NULL,
USERIP VARCHAR(16) NOT NULL,
ADMIN INT(1) NOT NULL,
TEAM INT(2) NOT NULL,
MONEY INT(10) NOT NULL,
LEVEL INT(3) NOT NULL,
EXP INT(3) NOT NULL,
KILLS INT(5) NOT NULL,
DEATHS INT(5) NOT NULL,
SKIN INT(5) NOT NULL,
WEP1 INT(2) NOT NULL,
AMMO1 INT(4) NOT NULL,
INTERIOR INT(2) NOT NULL,
WORLD INT(1) NOT NULL,
POS_X DECIMAL (10,5) NOT NULL,
POS_Y DECIMAL (10,5) NOT NULL,
POS_Z DECIMAL (10,5) NOT NULL,
ANGLE DECIMAL (10,5) NOT NULL,
HP DECIMAL (3,0) NOT NULL,
AM DECIMAL (3,0) NOT NULL
) ENGINE=INNODB;

*/

/*
CREATE TABLE POKETMON_TABLE(
ID INT PRIMARY KEY AUTO_INCREMENT,
NAME VARCHAR(24) NOT NULL,
TYPE INT(3) NOT NULL,
MONNAME VARCHAR(24) NOT NULL,
CP INT(4) NOT NULL,
HEALTH INT(3) NOT NULL,
THIRST INT(3) NOT NULL,
HUNGER INT(3) NOT NULL,
TIRED INT(3) NOT NULL,
CLEAN INT(3) NOT NULL,
FUNNY INT(3) NOT NULL
) ENGINE=INNODB;

 */

main(){}

#define d_Reg            1
#define d_Log            2
#define poketmon_Bag     3
#define player_Bag       4
#define slot_bag         5
#define car_Bag          6
#define slot_car         7
#define misson_medi      8
#define misson_itemshop  9
#define misson_carshop   10
#define medi_care        11
#define medi_mix         12
#define medi_sell        13
#define medi_qwest		   14
#define item_buy         15
#define item_sell        16
#define item_qwest       17
#define car_buy          18
#define car_sell         19
#define car_qwest        20


  static mysql;
        new sql[][]={
        "INSERT INTO `DMSERVER_TABLE` (`NAME`, `PASS`,`USERIP`,`ADMIN`,`TEAM`,`MONEY`,`LEVEL`,`EXP`,`KILLS`,`DEATHS`,`SKIN`,`WEP1`,`AMMO1`,`INTERIOR`,`WORLD`,`POS_X`,`POS_Y`,`POS_Z`,`ANGLE`,`HP`,`AM`)",
        "VALUES ('%e', '%s', '%s','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d',','%d','%d','%f','%f','%f','%f','%f','%f')"
        };

        new sql2[][]={
        "UPDATE `DMSERVER_TABLE` SET `ADMIN`=%d,`TEAM`=%d,`MONEY`=%d,`LEVEL`=%d,`EXP`=%d,`KILLS`=%d,`DEATHS`=%d,`SKIN`=%d,",
        "`WEP1`=%d,`AMMO1`=%d,`INTERIOR`=%d,`WORLD`=%d,`POS_X`=%f,`POS_Y`=%f,`POS_Z`=%f,`ANGLE`=%f,`HP`=%f,`AM`=%f WHERE `ID`=%d"
        };

enum USER{
  ID, NAME[MAX_PLAYER_NAME], PASS[24], USERIP[16],
  ADMIN,
  TEAM, MONEY,LEVEL, EXP,
  KILLS, DEATHS, SKIN,
  WEP1, AMMO1,
  INTERIOR, WORLD,
  Float:POS_X, Float:POS_Y, Float:POS_Z,
  Float:ANGLE,
  Float:HP, Float:AM
}
new UserDTO[MAX_PLAYERS][USER];

enum POKETMON{
  ID, NAME[MAX_PLAYER_NAME], TYPE,MONNAME[24],
  CP, WIN, LOSE, HEALTH, THIRST, HUNGER, TIRED, CLEAN, FUNNY
}
new PoketmonDTO[MAX_PLAYERS][10][POKETMON];

enum CAR{
  ID, MODEL
}
new CarDTO[MAX_PLAYERS][4][CAR];

enum ITEM{
  ID, TYPE,AMOUNT
}
new ItemDTO[MAX_PLAYERS][10][ITEM];

enum MISSON{
  NAME[24], Float:POS_Y, Float:POS_X, Float:POS_Z
}
new MissonDTO[3][MISSON];

enum GAME{
  bool:LOGIN,
  bool:ISBALL,
  bool:SHOTB,
  bool:ISCAR1,
  bool:ISCAR2,
  bool:ISCAR3,
  bool:ISCAR4,
  Text:DISTANCE,
  ITEAMNUM,
  BALLOBJ,
  BALLOBJNUM,
  CARNUM1,
  CARNUM2,
  CARNUM3,
  CARNUM4,
  FORWARD
}
new IngameDTO[MAX_PLAYERS][GAME];

enum COUNT{
  TICKMON,
  TICKITEM,
  TICKCAR,
  TICKMISSON
}
new CountDTO[MAX_PLAYERS][COUNT];

#define col_sys  0xAFAFAF99

#define USED_PHONES 2
#define USED_BALL 400
#define USED_POKETMON 81
#define USED_ZONE 932

#define PRESSED(%0) \
  (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define RELEASED(%0) \
  (((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

new missonTick=0;
new Text:TD_iPhone[2];
new poketmonType;
new poketmonCP;
new ballPickup;
new Float:ballPos[2];
new zonePoketmon[932];
new bool:isShotBall=false;

#define ENUM_WARP 3
enum WARP{
   bool:CHECK,
   bool:INCAR,
   CARID
}
new WarpDTO[MAX_PLAYERS][WARP];

enum td_ball
{
  Text:id,
  used
}
new TextDrawBall[USED_BALL][td_ball];

new carModelNum[8]={510,468,522,496,562,541,487,519};
new carName[8][20]={
	"»ê¾ÇÀÚÀü°Å",
	"»êÃ¼½º",
	"NRG ¹ÙÀÌÅ©",
	"ºí¸®½ºÅ¸ ÄÄÆÑÆ®",
	"¿¤¸®Áö",
	"ºæ·¿",
	"¸Å¹ö¸¯ Çì¸®ÄßÅÍ",
	"»ş¸á ºñÇà±â"
};
new carPrice[8]={6000,22000,46000,25000,430000,470000,110000,160000};

new carMemo[1][200]={
	"°¡°İ : 6000¿ø\n\nÈ¿°ú : °É¾î´Ù´Ï´Â °Íº¸´Ù ºü¸£°Ô ´Ù´Ò ¼ö ÀÖ´Ù.\n°üµ¿Áö¹æ ÅÂÃÊ¸¶À» 30³âÁö±â ÀÚÀü°Å ÀåÀÎÀÌ ¸¸µç »ê¾ÇÇü MTBÀÚÀü°Å"
};

new itemMemo[4][200]={
	"°¡°İ : 100¿ø\n\nÈ¿°ú : ¾ß»ı Æ÷ÄÏ¸ó¿¡°Ô »ç¿ëÇÏ¿© Æ÷ÄÏ¸óÀ» Æ÷È¹ÇÑ´Ù.\nÆ÷È¹·ü : Æ÷È¹·ü: x 1.0\nÆ÷È¹¹İ°æ : 0.0m~0.9m\n¾ß»ı Æ÷ÄÏ¸ó¿¡°Ô ´øÁ®¼­ Àâ±â À§ÇÑ º¼ Ä¸½¶½ÄÀ¸·Î µÇ¾î ÀÖ´Ù.",
	"°¡°İ : 600¿ø\n\nÈ¿°ú : ¾ß»ı Æ÷ÄÏ¸ó¿¡°Ô »ç¿ëÇÏ¿© Æ÷ÄÏ¸óÀ» Æ÷È¹ÇÑ´Ù.\nÆ÷È¹·ü : Æ÷È¹·ü: x 1.5\nÆ÷È¹¹İ°æ : 0.0m~1.9m\n¸ó½ºÅÍº¼º¸´Ùµµ ´õ¿í Æ÷ÄÏ¸óÀ» Àâ±â ½¬¿öÁø ¾à°£ ¼º´ÉÀÌ ÁÁÀº º¼",
	"°¡°İ : 1200¿ø\n\nÈ¿°ú : ¾ß»ı Æ÷ÄÏ¸ó¿¡°Ô »ç¿ëÇÏ¿© Æ÷ÄÏ¸óÀ» Æ÷È¹ÇÑ´Ù.\nÆ÷È¹·ü : Æ÷È¹·ü: x 2.0\nÆ÷È¹¹İ°æ : 0.0m~2.9m\n¿ïÆ®¶óº¼º¸´Ùµµ ´õ¿í Æ÷ÄÏ¸óÀ» Àâ±â ½¬¿öÁø ¸Å¿ì ¼º´ÉÀÌ ÁÁÀº º¼",
	"°¡°İ : ÆÇ¸ÅºÒ°¡\n\nÈ¿°ú : ¾ß»ı Æ÷ÄÏ¸ó¿¡°Ô »ç¿ëÇÏ¿© Æ÷ÄÏ¸óÀ» Æ÷È¹ÇÑ´Ù.\nÆ÷È¹·ü : °è»ê½Ä ¾øÀÌ 100ÆÛ¼¾Æ® Æ÷È¹\nÆ÷È¹¹İ°æ : 0.0m~4.9m\n¾ß»ı Æ÷ÄÏ¸óÀ» ¹İµå½Ã ÀâÀ» ¼ö ÀÖ´Â ÃÖ°í ¼º´ÉÀÇ º¼"
};

new ballObjNum[4]={2997,2996,3106,2998};
new itemName[4][20]={
	"Æ÷ÄÏº¼",
	"±×·¹ÀÌÆ®º¼",
	"¿ïÆ®¶óº¼",
	"¸¶½ºÅÍº¼"
};

new itemPrice[4]={
  100,
  600,
  1200,
  99999
};

new poketMonName[81][20]={
  "Picachu",
  "Paili",
  "Kkobugi",
  "Tangguri",
  "Pupurin",
  "Eevee",
  "Gugu",
  "Gorapaduck",
  "Togepi",
  "Balchaeng",
  "Isanghaessi",
  "Modapi",
  "Koil",
  "Kkolet",
  "Phantom",
  "Metamong",
  "Ppulchong",
  "Booster",
  "Jjililigong",
  "Ttodogas",
  "Nyanyaong",
  "Kkomadol",
  "kkaebicham",
  "Gooseu",
  "Gadi",
  "Hongsumon",
  "Peutela",
  "Peulijeo",
  "Polligon",
  "Ponita",
  "Paoli",
  "Tugu",
  "Keulaeb",
  "Konpang",
  "Konchi",
  "Kentaloseu",
  "Kaengka",
  "Kaeteopi",
  "Keisi",
  "Jilpeog-i",
  "Jyupisseondeo",
  "Jyulegon",
  "Jubes",
  "Jammanbo",
  "Ingeoking",
  "Wangnunhae",
  "Elebeu",
  "Yadon",
  "Amnaiteu",
  "Altongmon",
  "Abokeu",
  "Alali",
  "Ssodeula",
  "Sseondeo",
  "Sinnyong",
  "Sigseuteil",
  "Seullipeu",
  "Seulakeu",
  "Selleo",
  "Syamideu",
  "Ppippi",
  "Ppeusaijyeo",
  "Ppulkano",
  "Byeolgasali",
  "Minyong",
  "Myucheu",
  "Molaeduji",
  "Mangki",
  "Maimmaen",
  "Mageuma",
  "Lujula",
  "Longseuton",
  "Leogki",
  "Lapeulaseu",
  "Ttubeogcho",
  "Digeuda",
  "Dudu",
  "Deongkuli",
  "NidolanMan",
  "NidolanWoman",
  "Naelumi"
};

new poketMonNameHan[81][20]={
	"ÇÇÄ«Ãò",
	"ÆÄÀÌ¸®",
	"²¿ºÎ±â",
	"ÅÁ±¸¸®",
	"ÇªÇª¸°",
	"ÀÌºêÀÌ",
	"±¸±¸",
	"°í¶óÆÄ´ö",
	"Åä°ÔÇÇ",
	"¹ßÃ¬ÀÌ",
	"ÀÌ»óÇØ¾¾",
	"¸ğ´ÙÇÇ",
	"ÄÚÀÏ",
	"²¿·¿",
	"ÆÒÅÒ",
	"¸ŞÅ¸¸ù",
	"»ÔÃÑ",
	"ºÎ½ºÅÍ",
	"Âî¸®¸®°ø",
	"¶Çµµ°¡½º",
	"³Ä¿ËÀÌ",
	"²¿¸¶µ¹",
	"±úºñÂü",
	"°í¿À½º",
	"°¡µğ",
	"È«¼ö¸ó",
	"ÇÁÅ×¶ó",
	"ÇÁ¸®Á®",
	"Æú¸®°ï",
	"Æ÷´ÏÅ¸",
	"ÆÄ¿À¸®",
	"Åõ±¸",
	"Å©·¦",
	"ÄÜÆÎ",
	"ÄÜÄ¡",
	"ÄËÅ¸·Î¿ì½º",
	"Ä»Ä«",
	"Ä³ÅÍÇÇ",
	"Ä³ÀÌ½Ã",
	"ÁúÆÜÀÌ",
	"ÁêÇÇ½ã´õ",
	"Áê·¹°ï",
	"Áêº£½º",
	"Àá¸¸º¸",
	"À×¾îÅ·",
	"¿Õ´«ÇØ",
	"¿¡·¹ºê",
	"¾ßµ·",
	"¾Ï³ªÀÌÆ®",
	"¾ËÅë¸ó",
	"¾Æº¸Å©",
	"¾Æ¶ó¸®",
	"½îµå¶ó",
	"½ã´õ",
	"½Å´¨",
	"½Ä½ºÅ×ÀÏ",
	"½½¸®ÇÁ",
	"½º¶óÅ©",
	"¼¿·¯",
	"»ş¹Ìµå",
	"»ß»ß",
	"»Ú»çÀÌÁ®",
	"»ÔÄ«³ë",
	"º°°¡»ç¸®",
	"¹Ì´¨",
	"¹ÂÃ÷",
	"¸ğ·¡µÎÁö",
	"¸ÁÅ°",
	"¸¶ÀÓ¸Ç",
	"¸¶±×¸¶",
	"·çÁÖ¶ó",
	"·Õ½ºÅæ",
	"·°Å°",
	"¶óÇÁ¶ó½º",
	"¶Ñ¹÷Ãİ",
	"µğ±×´Ù",
	"µÎµÎ",
	"µ¢Äí¸®",
	"´Ïµµ¶õ(³²)",
	"´Ïµµ¶õ(¿©)",
	"³»·ç¹Ì"
};

public OnGameModeInit(){

  mode_init();
  server_init();
  object_init();
  gangZone_init();
  textDraw_init();

  textLabel_init();
  mysql_init();
  thread_init();
  return 1;
}

stock server_init(){
  randomPoketmonType();
  randomPoketmonCP();
  loadMisson();
  fixBallPos();
}

stock thread_init(){
  SetTimer("ServerThread", 500, true);
  SetTimer("WarpThread", 50, true);
}
stock mode_init(){
  Audio_SetPack("default_pack", true);

  EnableStuntBonusForAll(0);
  DisableInteriorEnterExits();
  ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);

  SetGameModeText("Blank Script");
  AddPlayerClass(289,1925.0215,-1684.2222,13.5469,255.7507,0,0,0,0,0,0);

}

stock object_init(){
  CreateObject(1504, 1909.60229, -1713.55371, 12.30253,   0.00000, 0.00000, 269.91336);
  CreateObject(1505, 1909.58008, -1708.08728, 12.14866,   0.00000, 0.00000, 89.91272);
  CreateObject(1507, 1909.53870, -1699.33984, 12.30817,   0.00000, 0.00000, 269.92120);
}

stock gangZone_init(){
  new pos[4] = { -3000, 2800, -2800, 3000 };
  new fix = 200;
  new tick = 0;
  for(new i = 0; i < USED_ZONE; i++){
    tick++;
    if(tick == 31){
      tick = 1;
      pos[0] = -3000;
      pos[1] = pos[1] - fix;
      pos[2] = -2800;
      pos[3] = pos[3] - fix;
    }
    zonePoketmon[i] = GangZoneCreate(pos[0], pos[1], pos[2], pos[3]);
    pos[0] = fix + pos[0];
    pos[2] = fix + pos[2];
  }
}

stock textDraw_init(){
  for(new b = 0;b<GetMaxPlayers();b++){loadDistanceImg(b);}
  loadPhoneImg();
  loadModeImg();
  fixPoketMonName();
}

stock textLabel_init(){
  for(new a = 0;a<3;a++){
    new str[40];
    format(str, sizeof(str),"%s (Yí‚¤)",MissonDTO[a][NAME]);
    Create3DTextLabel(str, 0x8D8DFFFF, MissonDTO[a][POS_X], MissonDTO[a][POS_Y], MissonDTO[a][POS_Z], 7.0, 0, 0);
  }
}

stock mysql_init(){
  #define sql_host	"localhost"
  #define sql_user	"root"
  #define sql_db		"u4bi"
  #define sql_pass 	"root940617"
  mysql = mysql_connect(sql_host, sql_user, sql_db, sql_pass);
  mysql_set_charset("euckr");
  if(mysql_errno(mysql) != 0) print("DB ¿¬°áÀÌ ¾ÈµÊ.");
  else print("DB ¿¬°áµÊ.");
}

public OnGameModeExit(){
  mysql_close();
  return 1;
}

public OnPlayerText(playerid, text[]){
  if(IngameDTO[playerid][LOGIN]==true){
    new str[200];
    format(str,sizeof(str),"%s : %s",UserDTO[playerid][NAME], text);
    SendClientMessageToAll(0xE6E6E6E6, str);
    SetPlayerChatBubble(playerid, str, 0xE6E6E6E6, 10.0, 1000);
  }

  return 0;
}

public OnPlayerRequestSpawn(playerid)
{
    if(IngameDTO[playerid][LOGIN]==false){
        return 0;
    }
    return 1;
}

public OnPlayerConnect(playerid){
  IngameDTO[playerid][LOGIN]=false;
  IngameDTO[playerid][ISBALL]=false;
  SetPlayerColor(playerid, 0xE6E6E6E6);
  onIntro(playerid);
  return 1;
}

stock onIntro(playerid){
  zoneInit(playerid);
  showDistanceImg(playerid);
  showPhoneImg(playerid);
  showBallImg(playerid);
  SetTimerEx("introTimer", 5000, false, "i", playerid);
}

forward introTimer(playerid);
public introTimer(playerid){
  for(new i = 0; i < 20; i++) SendClientMessage(playerid, -1, "");
  testInit(playerid);
  startConnect(playerid);
  return 1;
}

stock startConnect(playerid){
  GetPlayerName(playerid, UserDTO[playerid][NAME], 24);
  joinController(playerid);
}

stock helpInfo(playerid){
	new memo[400]={"{8D8DFF}°øÁö»çÇ×{FFFFFF}\n¿ÀºêÁ§Æ® Á¦ÀÛÀÚ ÇÑºĞÀ» Ã£½À´Ï´Ù. (¾÷¹«¸í : Æ÷ÄÏ¸ó¼¾ÅÍ Á¦ÀÛ)\nÁÁÀº ÄÁÅÙÃ÷ ±âÈ¹ ¾ÆÀÌµğ¾î µµ¿òÀ» ÁÖ½ÇºĞµéÀ» Ã£½À´Ï´Ù.\nÂü¿©µµ¿¡ µû¶ó Â÷ ÈÄ ¼ÒÁ¤ÀÇ ÇıÅÃ Áö±Ş\n\nÂü¿© Ä«Åå ¿ÀÇÂÃ¤ÆÃ : https://open.kakao.com/o/gpZ9Qqm\n\n{8D8DFF}¸í·É¾î ¾È³»{FFFFFF}\n\n/°¡¹æ(/b) /Â÷(/v) /Æ÷ÄÏ¸ó(/p)\n\n"};
	ShowPlayerDialog(playerid,1001,DIALOG_STYLE_MSGBOX,"{8D8DFF}Æ÷ÄÏ¸ó ¸Å´ÏÀú",memo,"È®ÀÎ","");}

stock joinController(playerid){
  new query[200];
  GetPlayerName(playerid, UserDTO[playerid][NAME], 24);
  GetPlayerIp(playerid, UserDTO[playerid][USERIP], 16);
  mysql_format(mysql, query, sizeof(query), "SELECT ID,PASS FROM `DMSERVER_TABLE` WHERE `NAME` = '%e' LIMIT 1", UserDTO[playerid][NAME]);
  mysql_query(mysql, query, true);

  new rows, fields;
  cache_get_data(rows, fields, mysql);
  if(rows){
    UserDTO[playerid][ID] = cache_get_field_content_int(0, "ID");
    cache_get_field_content(0, "PASS", UserDTO[playerid][PASS], mysql, 24);
    ShowPlayerDialog(playerid, d_Log, DIALOG_STYLE_PASSWORD, "{8D8DFF}ê³„ì •ê´€ë¦¬ ë§¤ë‹ˆì €", "{FFFFFF}ë¹„ë°€ë²ˆí˜¸ë¥¼ ì…ë ¥í•´ì£¼ì„¸ìš”.", "ë¡œê·¸ì¸", "ë‚˜ê°€ê¸°");
  }else{
    ShowPlayerDialog(playerid, d_Reg, DIALOG_STYLE_PASSWORD, "{8D8DFF}ê³„ì •ê´€ë¦¬ ë§¤ë‹ˆì €", "{FFFFFF}ë¹„ë°€ë²ˆí˜¸ë¥¼ ì…ë ¥í•´ì£¼ì„¸ìš”.", "íšŒì›ê°€ì…", "ë‚˜ê°€ê¸°");
  }
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]){
  showAudio(playerid, 1);
  switch(dialogid){
      case d_Log:joinDialog(playerid,response,inputtext,0);
      case d_Reg:joinDialog(playerid,response,inputtext,1);
      case poketmon_Bag:{
      if(PoketmonDTO[playerid][0][ID]==0) return SendClientMessage(playerid,col_sys,"		í¬ì¼“ëª¬ì´ ì—†ìŠµë‹ˆë‹¤.");
      bagDialog(playerid,response,listitem,0);
    }
      case player_Bag:{
      if(ItemDTO[playerid][0][ID]==0) return SendClientMessage(playerid,col_sys,"		ì•„ì´í…œì´ ì—†ìŠµë‹ˆë‹¤.");
      bagDialog(playerid,response,listitem,1);
    }
      case slot_bag:slotEventItem(playerid,response,listitem);
      case car_Bag:{
      if(CarDTO[playerid][0][ID]==0) return SendClientMessage(playerid,col_sys,"		ì°¨ëŸ‰ì´ ì—†ìŠµë‹ˆë‹¤.");
      carDialog(playerid,response,listitem);
    }
      case slot_car:slotEventCar(playerid,response,listitem);
      case misson_medi:		missonDialog(playerid,response,listitem,0);
      case misson_itemshop:	missonDialog(playerid,response,listitem,1);
      case misson_carshop:	missonDialog(playerid,response,listitem,2);
    case medi_care:		mediDialog(playerid,response,listitem,0);
    case medi_mix:      mediDialog(playerid,response,listitem,1);
    case medi_sell:     mediDialog(playerid,response,listitem,2);
    case medi_qwest:    mediDialog(playerid,response,listitem,3);
    case item_buy:      itemShopDialog(playerid,response,listitem,0);
    case item_sell:     itemShopDialog(playerid,response,listitem,1);
    case item_qwest:    itemShopDialog(playerid,response,listitem,2);
    case car_buy:       carShopDialog(playerid,response,listitem,0);
    case car_sell:      carShopDialog(playerid,response,listitem,1);
    case car_qwest:     carShopDialog(playerid,response,listitem,2);
    }
  return 1;
}

stock mediDialog(playerid,response,listitem,type){
  new str[60];
  format(str, sizeof(str),"{8D8DFF}%s",MissonDTO[0][NAME]);
  if(response){
    printf("%d %d",listitem,type);
  }else{
    ShowPlayerDialog(playerid, misson_medi, DIALOG_STYLE_LIST,str,"{FFFFFF}í¬ì¼“ëª¬ ì¹˜ë£Œ\ní¬ì¼“ëª¬ í•©ì„±\ní¬ì¼“ëª¬ ë¶„ì–‘\nëŒ€í™”(í€˜ìŠ¤íŠ¸)","í™•ì¸", "ì·¨ì†Œ");
  }
}

stock itemShopDialog(playerid,response,listitem,type){
  new str[60];
  format(str, sizeof(str),"{8D8DFF}%s",MissonDTO[1][NAME]);
  if(response){
    printf("%d %d",listitem,type);
  }else{
    ShowPlayerDialog(playerid, misson_itemshop, DIALOG_STYLE_LIST,str,"{FFFFFF}ì•„ì´í…œ êµ¬ë§¤\nì•„ì´í…œ íŒë§¤\nëŒ€í™”(í€˜ìŠ¤íŠ¸)","í™•ì¸", "ì·¨ì†Œ");
  }
}

stock carShopDialog(playerid,response,listitem,type){
  new str[60];
  format(str, sizeof(str),"{8D8DFF}%s",MissonDTO[2][NAME]);
  if(response){
    printf("%d %d",listitem,type);
  }else{
    ShowPlayerDialog(playerid, misson_carshop, DIALOG_STYLE_LIST,str,"{FFFFFF}ì°¨ëŸ‰ êµ¬ë§¤\nì°¨ëŸ‰ íŒë§¤\nëŒ€í™”(í€˜ìŠ¤íŠ¸)","í™•ì¸", "ì·¨ì†Œ");
  }
}

stock missonDialog(playerid,response,listitem,type){
  if(response){
      switch(type){
        case 0: selectMadi(playerid,listitem);
        case 1: selectItemShop(playerid,listitem);
        case 2: selectCarShop(playerid,listitem);
      }
  }
}

stock selectMadi(playerid,listitem){
  new sumText[624];
  format(sumText, sizeof(sumText), "%s",getPoketMonInfo(playerid));
  switch(listitem){
      case 0:poketmonCare(playerid,sumText);
      case 1:poketmonMix(playerid,sumText);
      case 2:poketmonSell(playerid,sumText);
      case 3:poketmonQwest(playerid);
  }
}

stock poketmonCare(playerid,str[]){
	ShowPlayerDialog(playerid, medi_care, DIALOG_STYLE_LIST, "Æ÷ÄÏ¸ó Ä¡·á",str,"È®ÀÎ", "Ãë¼Ò");
}

stock poketmonMix(playerid,str[]){
	ShowPlayerDialog(playerid, medi_mix, DIALOG_STYLE_LIST, "Æ÷ÄÏ¸ó ÇÕ¼º",str,"È®ÀÎ", "Ãë¼Ò");
}

stock poketmonSell(playerid,str[]){
	ShowPlayerDialog(playerid, medi_sell, DIALOG_STYLE_LIST, "Æ÷ÄÏ¸ó ºĞ¾ç",str,"È®ÀÎ", "Ãë¼Ò");
}

stock poketmonQwest(playerid){
	ShowPlayerDialog(playerid, medi_qwest, DIALOG_STYLE_LIST, "Æ÷ÄÏ¸ó Äù½ºÆ®","°æÇè¿¡ ¸Â´Â Äù½ºÆ®°¡ ¾ø½À´Ï´Ù.\n","È®ÀÎ", "Ãë¼Ò");
}

stock selectItemShop(playerid,listitem){
  switch(listitem){
      case 0:itemShopBuy(playerid);
      case 1:itemShopSell(playerid);
      case 2:itemShopQwest(playerid);
  }
}

stock itemShopBuy(playerid){
  new sumText[624];
	format(sumText, sizeof(sumText), "%s (°¡°İ : %d¿ø)\n%s (°¡°İ : %d¿ø)\n%s (°¡°İ : %d¿ø)\n%s (°¡°İ : %d¿ø)\n",itemName[0],itemPrice[0],itemName[1],itemPrice[1],itemName[2],itemPrice[2],itemName[3],itemPrice[3]);
	ShowPlayerDialog(playerid, item_buy, DIALOG_STYLE_LIST, "¾ÆÀÌÅÛ ±¸¸Å",sumText,"È®ÀÎ", "Ãë¼Ò");
}

stock itemShopSell(playerid){
  new sumText[624];
  format(sumText, sizeof(sumText), "%s",getBagInfo(playerid));
	ShowPlayerDialog(playerid, item_sell, DIALOG_STYLE_LIST, "¾ÆÀÌÅÛ ÆÇ¸Å",sumText,"È®ÀÎ", "Ãë¼Ò");
}

stock itemShopQwest(playerid){
	ShowPlayerDialog(playerid, item_qwest, DIALOG_STYLE_LIST, "¾ÆÀÌÅÛ Äù½ºÆ®","°æÇè¿¡ ¸Â´Â Äù½ºÆ®°¡ ¾ø½À´Ï´Ù.\n","È®ÀÎ", "Ãë¼Ò");
}

stock selectCarShop(playerid,listitem){
  switch(listitem){
      case 0:carShopBuy(playerid);
      case 1:carShopSell(playerid);
      case 2:carShopQwest(playerid);
  }
}

stock carShopBuy(playerid){
  new sumText[624];
	format(sumText, sizeof(sumText), "%s Model: %d \t(°¡°İ : %d¿ø)\n%s Model: %d (°¡°İ : %d¿ø)\n%s Model: %d (°¡°İ : %d¿ø)\n%s Model: %d (°¡°İ : %d¿ø)\n%s Model: %d (°¡°İ : %d¿ø)\n%s Model: %d (°¡°İ : %d¿ø)\n%s Model: %d (°¡°İ : %d¿ø)\n%s Model: %d (°¡°İ : %d¿ø)\n",
  carName[0],carModelNum[0],carPrice[0],
  carName[1],carModelNum[1],carPrice[1],
  carName[2],carModelNum[2],carPrice[2],
  carName[3],carModelNum[3],carPrice[3],
  carName[4],carModelNum[4],carPrice[4],
  carName[5],carModelNum[5],carPrice[5],
  carName[6],carModelNum[6],carPrice[6],
  carName[7],carModelNum[7],carPrice[7]
  );
	ShowPlayerDialog(playerid, car_buy, DIALOG_STYLE_LIST, "Â÷·® ±¸¸Å",sumText,"È®ÀÎ", "Ãë¼Ò");
}

stock carShopSell(playerid){
  new sumText[200];
  format(sumText, sizeof(sumText), "%s",getCarInfo(playerid));
	ShowPlayerDialog(playerid, car_sell, DIALOG_STYLE_LIST, "Â÷·® ÆÇ¸Å",sumText,"È®ÀÎ", "Ãë¼Ò");
}

stock carShopQwest(playerid){
	ShowPlayerDialog(playerid, car_qwest, DIALOG_STYLE_LIST, "Â÷·® Äù½ºÆ®","°æÇè¿¡ ¸Â´Â Äù½ºÆ®°¡ ¾ø½À´Ï´Ù.\n","È®ÀÎ", "Ãë¼Ò");
}


stock carDialog(playerid,response,listitem){
  if(response){
    selectCar(playerid,listitem);
  }
}

stock selectCar(playerid,num){
    new str[60];
    IngameDTO[playerid][FORWARD]=num;
    new carNum=CarDTO[playerid][num][MODEL];
    format(str, sizeof(str),"{8D8DFF}%s (Model: %d)",carName[carNum],carModelNum[carNum]);
    ShowPlayerDialog(playerid, slot_car, DIALOG_STYLE_LIST, str,"»ç¿ë\n³Ö±â\nÁ¤º¸","È®ÀÎ", "Ãë¼Ò");
}

stock slotEventCar(playerid,response,listitem){
  if(response){
      switch(listitem){
          case 0:takeCar(playerid,IngameDTO[playerid][FORWARD]);
          case 1:putCar(playerid,IngameDTO[playerid][FORWARD]);
          case 2:infoCar(playerid,IngameDTO[playerid][FORWARD]);
      }
  }
}

stock takeCar(playerid,num){

  new carNum=CarDTO[playerid][num][MODEL];
  rideCar(playerid,num,carModelNum[carNum]);
}

stock putCar(playerid,num){
  switch(num){
    case 0: DestroyVehicle(IngameDTO[playerid][CARNUM1]),IngameDTO[playerid][ISCAR1]=false;
    case 1: DestroyVehicle(IngameDTO[playerid][CARNUM2]),IngameDTO[playerid][ISCAR2]=false;
    case 2: DestroyVehicle(IngameDTO[playerid][CARNUM3]),IngameDTO[playerid][ISCAR3]=false;
    case 3: DestroyVehicle(IngameDTO[playerid][CARNUM4]),IngameDTO[playerid][ISCAR4]=false;
  }
}

stock infoCar(playerid,num){
  selectCarInfo(playerid,num);
}

stock selectCarInfo(playerid,num){
	new memo[300]={"{FFFFFF}Â÷·® Á¤º¸ : %s(Model : %d)\n\n{8D8DFF}»ó¼¼¼³¸í{FFFFFF}\n\n%s\n\n"};
  new str[300];
  new carNum=CarDTO[playerid][num][MODEL];

  format(str,sizeof(str),memo,
  carName[carNum],
  carModelNum[carNum],
  carMemo[carNum]
  );
  ShowPlayerDialog(playerid,1001,DIALOG_STYLE_MSGBOX,"{8D8DFF}Æ÷ÄÏ¸ó ¸Å´ÏÀú",str,"È®ÀÎ","");
}

stock bagDialog(playerid,response,listitem,type){
  if(response){
    switch(type){
      case 0:{
          selectPoketMon(playerid,listitem);
      }
      case 1:{
          selectInventory(playerid,listitem);
      }
    }
  }
  return 1;
}

stock selectInventory(playerid,num){
  new str[60];
  IngameDTO[playerid][FORWARD]=ItemDTO[playerid][num][TYPE];
  IngameDTO[playerid][ITEAMNUM]=IngameDTO[playerid][FORWARD];
  format(str, sizeof(str),"{8D8DFF}%s",itemName[IngameDTO[playerid][FORWARD]]);
  ShowPlayerDialog(playerid, slot_bag, DIALOG_STYLE_LIST, str,"»ç¿ë\n³Ö±â\nÁ¤º¸","È®ÀÎ", "Ãë¼Ò");
}

stock slotEventItem(playerid,response,listitem){
  if(response){
      switch(listitem){
          case 0:takeItem(playerid,IngameDTO[playerid][FORWARD]);
          case 1:putItem(playerid,IngameDTO[playerid][FORWARD]);
          case 2:infoItem(playerid,IngameDTO[playerid][FORWARD]);
      }
  }
}

stock takeItem(playerid,num){
  switch(num){
      case 0..3:
      {
      if(IngameDTO[playerid][ISBALL] == true) return SendClientMessage(playerid,col_sys,"		ì´ë¯¸ ëª¬ìŠ¤í„°ë³¼ì„ êº¼ë‚´ì…¨ìŠµë‹ˆë‹¤.");
      openPoketball(playerid,num);
      new str[126];
      format(str, sizeof(str),"		°¡¹æ¿¡¼­ %sÀ»(¸¦) ²¨³½´Ù.",itemName[num]);
      SendClientMessage(playerid,col_sys,str);
      }
  }
  return 1;
}

stock putItem(playerid,num){
  switch(num){
      case 0..3:
      {
      if(IngameDTO[playerid][ITEAMNUM] != num) return SendClientMessage(playerid,col_sys,"		ëª¬ìŠ¤í„°ë³¼ì„ êº¼ë‚´ì§€ ì•Šì•˜ìŠµë‹ˆë‹¤.");
      if(IngameDTO[playerid][ISBALL] == false) return SendClientMessage(playerid,col_sys,"		ëª¬ìŠ¤í„°ë³¼ì„ êº¼ë‚´ì§€ ì•Šì•˜ìŠµë‹ˆë‹¤.");
      SendClientMessage(playerid,col_sys,"		¸ó½ºÅÍº¼À» °¡¹æ¿¡ ³Ö´Â´Ù.");
      closePoketBall(playerid);
    }
  }
  return 1;
}

stock infoItem(playerid,num){
  selectItemInfo(playerid,num);
}

stock selectItemInfo(playerid,num){
  new memo[300]={"{FFFFFF}¾ÆÀÌÅÛ Á¤º¸ : %s\n\n{8D8DFF}»ó¼¼¼³¸í{FFFFFF}\n\n%s\n\n"};
  new str[300];
  format(str,sizeof(str),memo,
  itemName[num],
  itemMemo[num]
  );
  ShowPlayerDialog(playerid,1001,DIALOG_STYLE_MSGBOX,"{8D8DFF}Æ÷ÄÏ¸ó ¸Å´ÏÀú",str,"È®ÀÎ","");
}

stock selectPoketMon(playerid,num){
  new memo[300]={"{FFFFFF}º°¸í : %s\nÆ÷ÄÏ¸ó¸í : %s\nCPÁ¡¼ö : %d\n\n{8D8DFF}¹èÆ²±â·Ï{FFFFFF}\n½Â¸® : %d\tÆĞ¹è : %d\n\n{8D8DFF}»óÅÂÁ¤º¸{FFFFFF}\n°Ç°­µµ : %d\n¸ñ¸¶¸§ : %d\nÆ÷¸¸°¨ : %d\nÇÇ°ïÇÔ : %d\nÃ»°áµµ : %d\nÁñ°Å¿ò : %d\n\n\n{8D8DFF}Æ÷ÄÏ¸óÀº ÀÎÆ÷À¥¿¡¼­ ÈÆ·Ã½ÃÅ³ ¼ö ÀÖ½À´Ï´Ù."};
  new str[300];
  format(str,sizeof(str),memo,
  PoketmonDTO[playerid][num][MONNAME],
  poketMonNameHan[PoketmonDTO[playerid][num][TYPE]],
  PoketmonDTO[playerid][num][CP],
  PoketmonDTO[playerid][num][WIN],
  PoketmonDTO[playerid][num][LOSE],
  PoketmonDTO[playerid][num][HEALTH],
  PoketmonDTO[playerid][num][THIRST],
  PoketmonDTO[playerid][num][HUNGER],
  PoketmonDTO[playerid][num][TIRED],
  PoketmonDTO[playerid][num][CLEAN],
  PoketmonDTO[playerid][num][FUNNY]
  );
  ShowPlayerDialog(playerid,1001,DIALOG_STYLE_MSGBOX,"{8D8DFF}Æ÷ÄÏ¸ó ¸Å´ÏÀú",str,"È®ÀÎ","");
}

stock joinDialog(playerid,response,inputtext[],type){
    if(!response) return Kick(playerid);
  switch(type){
    case 0:{
      if(!strcmp(inputtext, UserDTO[playerid][PASS])){
        LoadDB(playerid);
        IngameDTO[playerid][LOGIN]=true;

        }else ShowPlayerDialog(playerid, d_Log, DIALOG_STYLE_PASSWORD, "{8D8DFF}ê³„ì •ê´€ë¦¬ ë§¤ë‹ˆì €", "{FFFFFF}ë¹„ë°€ë²ˆí˜¸ê°€ í‹€ë¦½ë‹ˆë‹¤.", "ë¡œê·¸ì¸", "ë‚˜ê°€ê¸°");
    }
    case 1:{
          if(strlen(inputtext) > 24) return ShowPlayerDialog(playerid, d_Reg, DIALOG_STYLE_PASSWORD, "{8D8DFF}ê³„ì •ê´€ë¦¬ ë§¤ë‹ˆì €", "{FFFFFF}24ì ì´í•˜ì˜ ë¹„ë°€ë²ˆí˜¸ë¥¼ ì…ë ¥í•´ì£¼ì„¸ìš”.", "íšŒì›ê°€ì…", "ë‚˜ê°€ê¸°");
        if(strlen(inputtext) < 6) return ShowPlayerDialog(playerid, d_Reg, DIALOG_STYLE_PASSWORD, "{8D8DFF}ê³„ì •ê´€ë¦¬ ë§¤ë‹ˆì €", "{FFFFFF}6ì ì´ìƒì˜ ë¹„ë°€ë²ˆí˜¸ë¥¼ ì…ë ¥í•´ì£¼ì„¸ìš”.", "íšŒì›ê°€ì…", "ë‚˜ê°€ê¸°");
        InsertLogAdapter(playerid,inputtext);
      IngameDTO[playerid][LOGIN]=true;
    }
  }
  return 1;
}
stock LoadDB(playerid){
  print("\nÀ¯Àú·Î±× ºÒ·¯¿È");
  new query[200];
  mysql_format(mysql, query, sizeof(query), "SELECT * FROM `DMSERVER_TABLE` WHERE `ID` = %d LIMIT 1",UserDTO[playerid][ID]);
  mysql_query(mysql, query, true);
  new rows, fields;
  cache_get_data(rows, fields);
  for(new i=4; i < fields; i++){
    switch(i){
      case 4: UserDTO[playerid][ADMIN] = cache_get_row_int(0, i);
      case 5: UserDTO[playerid][TEAM] = cache_get_row_int(0, i);
      case 6: UserDTO[playerid][MONEY] = cache_get_row_int(0, i);
      case 7: UserDTO[playerid][LEVEL] = cache_get_row_int(0, i);
      case 8: UserDTO[playerid][EXP] = cache_get_row_int(0, i);
      case 9: UserDTO[playerid][KILLS] = cache_get_row_int(0, i);
      case 10: UserDTO[playerid][DEATHS] = cache_get_row_int(0, i);
      case 11: UserDTO[playerid][SKIN] = cache_get_row_int(0, i);
      case 12: UserDTO[playerid][WEP1] = cache_get_row_int(0, i);
      case 13: UserDTO[playerid][AMMO1] = cache_get_row_int(0, i);
      case 14: UserDTO[playerid][INTERIOR] = cache_get_row_int(0, i);
      case 15: UserDTO[playerid][WORLD] = cache_get_row_int(0, i);
      case 16: UserDTO[playerid][POS_X] = cache_get_row_float(0, i);
      case 17: UserDTO[playerid][POS_Y] = cache_get_row_float(0, i);
      case 18: UserDTO[playerid][POS_Z] = cache_get_row_float(0, i);
      case 19: UserDTO[playerid][ANGLE] = cache_get_row_float(0, i);
      case 20: UserDTO[playerid][HP] = cache_get_row_float(0, i);
      case 21: UserDTO[playerid][AM] = cache_get_row_float(0, i);
    }
  }
  SetSpawnInfo(playerid, UserDTO[playerid][TEAM], UserDTO[playerid][SKIN], UserDTO[playerid][POS_X], UserDTO[playerid][POS_Y], UserDTO[playerid][POS_Z], UserDTO[playerid][ANGLE], 0, 0, 0, 0, 0, 0);
  SpawnPlayer(playerid);
  SendClientMessage(playerid,col_sys,"		´ç½ÅÀÇ ÀÎÆ÷À¥ Á¢±Ù±ÇÇÑ ÇÉÄÚµå´Â 23552ÀÔ´Ï´Ù.");
}

stock InsertLogAdapter(playerid,inputtext[]){
  format(UserDTO[playerid][PASS], 16, "%s", inputtext);
    UserDTO[playerid][ADMIN]=0; 		UserDTO[playerid][TEAM]=0;
    UserDTO[playerid][MONEY]=0; 		UserDTO[playerid][LEVEL]=1;
    UserDTO[playerid][EXP]=0; 			UserDTO[playerid][KILLS]=0;
    UserDTO[playerid][DEATHS]=0; 		UserDTO[playerid][SKIN]=289;
    UserDTO[playerid][HP]=100; 			UserDTO[playerid][AM]=100;
  UserDTO[playerid][WEP1]=24; 		UserDTO[playerid][AMMO1]=300;
    UserDTO[playerid][INTERIOR]=0; 		UserDTO[playerid][WORLD]=0;
  UserDTO[playerid][POS_X]=1913.1345; UserDTO[playerid][POS_Y]=-1710.5565;
    UserDTO[playerid][POS_Z]=13.4003; 	UserDTO[playerid][ANGLE]=89.3591;
    InsertDB(playerid);
}

  stock InsertDB(playerid){

    print("\nÀ¯Àú·Î±× »ı¼º");
    new query[400];
    new sqlSum[400];
    format(sqlSum, sizeof(sqlSum), "%s%s", sql[0],sql[1]);

    mysql_format(mysql, query, sizeof(query), sqlSum,
    UserDTO[playerid][NAME],UserDTO[playerid][PASS],UserDTO[playerid][USERIP],
    UserDTO[playerid][ADMIN],
    UserDTO[playerid][TEAM],UserDTO[playerid][MONEY],UserDTO[playerid][LEVEL],UserDTO[playerid][EXP],
    UserDTO[playerid][KILLS],UserDTO[playerid][DEATHS],UserDTO[playerid][SKIN],
    UserDTO[playerid][WEP1],UserDTO[playerid][AMMO1],
    UserDTO[playerid][INTERIOR],UserDTO[playerid][WORLD],
    UserDTO[playerid][POS_X],UserDTO[playerid][POS_Y],UserDTO[playerid][POS_Z],UserDTO[playerid][ANGLE],
    UserDTO[playerid][HP],UserDTO[playerid][AM]);
    mysql_query(mysql, query, true);
    UserDTO[playerid][ID] = cache_insert_id();
    SetSpawnInfo(playerid, UserDTO[playerid][TEAM], UserDTO[playerid][SKIN], UserDTO[playerid][POS_X], UserDTO[playerid][POS_Y], UserDTO[playerid][POS_Z], UserDTO[playerid][ANGLE], 0, 0, 0, 0, 0, 0);
    SpawnPlayer(playerid);
    SendClientMessage(playerid,col_sys,"		´ç½ÅÀÇ ÀÎÆ÷À¥ Á¢±Ù±ÇÇÑ ÇÉÄÚµå´Â 23552ÀÔ´Ï´Ù.");
  }

stock SpawnInit(playerid){
  helpInfo(playerid);
  ResetPlayerMoney(playerid);
  SetPlayerScore(playerid, UserDTO[playerid][LEVEL]);
  GivePlayerMoney(playerid, UserDTO[playerid][MONEY]);
  SetPlayerSkin(playerid, UserDTO[playerid][SKIN]);
  SetPlayerVirtualWorld(playerid, UserDTO[playerid][WORLD]);
  SetPlayerInterior(playerid, UserDTO[playerid][INTERIOR]);
  SetPlayerHealth(playerid, UserDTO[playerid][HP]);
  SetPlayerArmour(playerid, UserDTO[playerid][AM]);
  SetPlayerTeam(playerid, UserDTO[playerid][TEAM]);
  GivePlayerWeapon(playerid, UserDTO[playerid][WEP1], UserDTO[playerid][AMMO1]);
  SetPlayerPos(playerid, UserDTO[playerid][POS_X], UserDTO[playerid][POS_Y], UserDTO[playerid][POS_Z]);
  SetPlayerFacingAngle(playerid, UserDTO[playerid][ANGLE]);
}

stock testInit(playerid){
    poketmonInit(playerid,1,0,230,0,0,100,100,100,100,100,100);
  itemInit(playerid, 1, 0, 99);
  itemInit(playerid, 2, 3, 1);
  carInit(playerid, 1, 0);
  carInit(playerid, 2, 2);
  carInit(playerid, 3, 4);
  carInit(playerid, 4, 6);

}

stock poketmonInit(playerid,poketmonid,type,cp,win,lose,health,thirst,hunger,tired,clean,funny){
  new num = CountDTO[playerid][TICKMON]++;

  PoketmonDTO[playerid][num][ID]=poketmonid;
  PoketmonDTO[playerid][num][TYPE]=type;
  format(PoketmonDTO[playerid][num][MONNAME], 24,"%s",poketMonNameHan[PoketmonDTO[playerid][num][TYPE]]);
  PoketmonDTO[playerid][num][CP]=cp;
  PoketmonDTO[playerid][num][WIN]=win;
  PoketmonDTO[playerid][num][LOSE]=lose;
  PoketmonDTO[playerid][num][HEALTH]=health;
  PoketmonDTO[playerid][num][THIRST]=thirst;
  PoketmonDTO[playerid][num][HUNGER]=hunger;
  PoketmonDTO[playerid][num][TIRED]=tired;
  PoketmonDTO[playerid][num][CLEAN]=clean;
  PoketmonDTO[playerid][num][FUNNY]=funny;
}

stock itemInit(playerid, itemid, type, amount){
  new num = CountDTO[playerid][TICKITEM]++;

  ItemDTO[playerid][num][ID]=itemid;
  ItemDTO[playerid][num][TYPE]=type;
  ItemDTO[playerid][num][AMOUNT]=amount;
}

stock carInit(playerid, carid, model){
  new num = CountDTO[playerid][TICKCAR]++;

  CarDTO[playerid][num][ID]=carid;
  CarDTO[playerid][num][MODEL]=model;
}

public OnPlayerDeath(playerid, killerid, reason){
  UserDTO[playerid][DEATHS]++;		UserDTO[playerid][MONEY]-=1000;
  UserDTO[playerid][WEP1]=24;	UserDTO[playerid][AMMO1]=600;
  UserDTO[playerid][INTERIOR]=0; 		UserDTO[playerid][WORLD]=0;
  UserDTO[playerid][HP]=100; 			UserDTO[playerid][AM]=100;
  UserDTO[playerid][POS_X]=1913.1345; UserDTO[playerid][POS_Y]=-1710.5565;
    UserDTO[playerid][POS_Z]=13.4003; 	UserDTO[playerid][ANGLE]=89.3591;
  warpInit(playerid);
  return 1;
}

public OnPlayerSpawn(playerid){
  SpawnInit(playerid);
  return 1;
}
public OnPlayerDisconnect(playerid, reason){
  if(IngameDTO[playerid][LOGIN]==true){
    if(reason == 1){
      PutLogDB(playerid);
    }
    if(IngameDTO[playerid][SHOTB]==true){
      isShotBall=false;
      IngameDTO[playerid][SHOTB]=false;
    }
    closePoketBall(playerid);
    putCar(playerid,0);
    putCar(playerid,1);
    putCar(playerid,2);
    UserLogInit(playerid);
    warpInit(playerid);
  }
  return 1;
}

/*HACK : µ¥ÀÌÅÍ ÃÊ±âÈ­ ÃßÈÄ ¿ÉÆ¼¸¶ÀÌÂ¡ ÀÛ¾÷À» À§ÇÑ ÄÚµå¸®ÆåÇØ¾ßÇÔ*/
stock UserLogInit(playerid){
  new temp1[USER];
  new temp2[CAR];
  new temp3[COUNT];
  new temp4[POKETMON];
  new temp5[ITEM];

  for(new i=0; i < 19; i++){
    UserDTO[playerid] = temp1;
    if(i <3){
      CountDTO[playerid] = temp3;
    }
    if(i <4){
      CarDTO[playerid][i] = temp2;
    }
    if(i <10){
      PoketmonDTO[playerid][i] = temp4;
      ItemDTO[playerid][i] = temp5;
    }
  }
}

stock PutLogDB(playerid){
  GetPlayerPos(playerid,UserDTO[playerid][POS_X],UserDTO[playerid][POS_Y],UserDTO[playerid][POS_Z]);
  GetPlayerFacingAngle(playerid, UserDTO[playerid][ANGLE]);
  UserDTO[playerid][WORLD] = GetPlayerVirtualWorld(playerid);
  UserDTO[playerid][INTERIOR] = GetPlayerInterior(playerid);

  new query[400];
  new sqlSum[400];
  format(sqlSum, sizeof(sqlSum), "%s%s", sql2[0],sql2[1]);

  mysql_format(mysql, query, sizeof(query), sqlSum,
  UserDTO[playerid][ADMIN],		UserDTO[playerid][TEAM],
  UserDTO[playerid][MONEY],		UserDTO[playerid][LEVEL],
  UserDTO[playerid][EXP],			UserDTO[playerid][KILLS],
  UserDTO[playerid][DEATHS],		UserDTO[playerid][SKIN],
  UserDTO[playerid][WEP1],		UserDTO[playerid][AMMO1],
  UserDTO[playerid][INTERIOR],	UserDTO[playerid][WORLD],
  UserDTO[playerid][POS_X],		UserDTO[playerid][POS_Y],
  UserDTO[playerid][POS_Z],		UserDTO[playerid][ANGLE],
  UserDTO[playerid][HP],			UserDTO[playerid][AM],

  UserDTO[playerid][ID]
  );
  mysql_query(mysql, query, true);
  SendClientMessage(playerid,col_sys, "		ÀúÀåµÇ¾ú½À´Ï´Ù.");
  return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger){
   inCar(playerid,vehicleid);
   return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate){
    switch(newstate){
        case PLAYER_STATE_ONFOOT:warpInit(playerid);
        case PLAYER_STATE_DRIVER..PLAYER_STATE_PASSENGER:checkWarp(playerid);
    }
    return 1;
}

stock inCar(playerid,vehicleid){
   WarpDTO[playerid][CARID]=vehicleid;
   WarpDTO[playerid][CHECK]=true;
}

stock checkWarp(playerid){
   WarpDTO[playerid][INCAR]=true;
   
   if(!WarpDTO[playerid][CHECK]){
      new carid = GetPlayerVehicleID(playerid);
      if(WarpDTO[playerid][CARID] != carid && carid != 0)Ban(playerid);
   }
}

stock warpInit(playerid){
   new temp[WARP];
   for(new i=0; i < ENUM_WARP; i++)WarpDTO[playerid] = temp;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys){

    if(IngameDTO[playerid][ISBALL]){
    SetPlayerArmedWeapon(playerid,0);
  }

  if (PRESSED(KEY_YES)){
    showAudio(playerid, 1);
      showEventRange(playerid);
  }
  new Float:distance = getPoketmonDistence(playerid);
  if(IngameDTO[playerid][ISBALL] && !IsPlayerInAnyVehicle(playerid)){
    if(PRESSED(KEY_HANDBRAKE)){
      if(distance < 1){
        if(isShotBall==true) return SendClientMessage(playerid,col_sys,"		´©±º°¡ Æ÷ÄÏ¸óÀ» Æ÷È¹ÁßÀÔ´Ï´Ù.");
        isShotBall=true;
        IngameDTO[playerid][SHOTB]=true;
        showPoketmonPickup(playerid);
        showPoketmonIcon(playerid);
      }
      ClearAnimations(playerid);
      ApplyAnimation(playerid,"BASEBALL","Bat_IDLE",4.1,0,1,1,1,1);
      SendClientMessage(playerid,col_sys,"		Æ÷ÄÏ¸óÀ» ÇâÇØ Á¶ÁØÇÕ´Ï´Ù.");
    }
    if(RELEASED(KEY_HANDBRAKE)){
      shotBall(playerid);
      SetTimerEx("shotBallManager", 2000, false, "ii", playerid,distance);
      ApplyAnimation(playerid,"BASEBALL","Bat_M",4.1,0,1,1,1,1);
      openPoketball(playerid, 0);
      SendClientMessage(playerid,col_sys,"		¸ó½ºÅÍº¼À» ´øÁı´Ï´Ù.");
      new num=IngameDTO[playerid][ITEAMNUM];
      ItemDTO[playerid][num][AMOUNT]--;
      if(ItemDTO[playerid][num][AMOUNT] == 0){
        ItemDTO[playerid][num][ID]=0;
        ItemDTO[playerid][num][TYPE]=0;
      }
    }
  }
  return 1;
}

stock showEventRange(playerid){
  new Float:x,Float:y,Float:z;

  for(new i=0; i < sizeof(MissonDTO); i++){
      x=MissonDTO[i][POS_X];
      y=MissonDTO[i][POS_Y];
      z=MissonDTO[i][POS_Z];
    if(IsPlayerInRangeOfPoint(playerid,3.0,x,y,z)){
      eventMisson(playerid, i);
    }
  }
}

stock eventMisson(playerid, type){
  new str[60];
  format(str, sizeof(str),"{8D8DFF}%s",MissonDTO[type][NAME]);
  switch(type){
    case 0: ShowPlayerDialog(playerid, misson_medi, DIALOG_STYLE_LIST,str,"{FFFFFF}Æ÷ÄÏ¸ó Ä¡·á\nÆ÷ÄÏ¸ó ÇÕ¼º\nÆ÷ÄÏ¸ó ºĞ¾ç\n´ëÈ­(Äù½ºÆ®)","È®ÀÎ", "Ãë¼Ò");
    case 1: ShowPlayerDialog(playerid, misson_itemshop, DIALOG_STYLE_LIST,str,"{FFFFFF}¾ÆÀÌÅÛ ±¸¸Å\n¾ÆÀÌÅÛ ÆÇ¸Å\n´ëÈ­(Äù½ºÆ®)","È®ÀÎ", "Ãë¼Ò");
    case 2: ShowPlayerDialog(playerid, misson_carshop, DIALOG_STYLE_LIST,str,"{FFFFFF}Â÷·® ±¸¸Å\nÂ÷·® ÆÇ¸Å\n´ëÈ­(Äù½ºÆ®)","È®ÀÎ", "Ãë¼Ò");
  }
}

stock shotBall(playerid){
      new Float:x,Float:y,Float:z;
    GetPlayerCameraDistance(playerid,x,y,z,1.0);

    new Float:x2,Float:y2, Float:Pos[4];
      GetPlayerPos(playerid,Pos[0],Pos[1],Pos[2]);
      GetPlayerFacingAngle(playerid,Pos[3]);
      x2 = 2 * floatsin(-Pos[3], degrees);
      y2 = 2 * floatcos(-Pos[3], degrees);

    new objNum =IngameDTO[playerid][BALLOBJNUM];
    IngameDTO[playerid][BALLOBJ] = CreateObject(objNum, x, y, Pos[2]-0.7, 0, 0, 0);
    PHY_InitObject(IngameDTO[playerid][BALLOBJ], objNum, 1.0);
    PHY_SetObjectVelocity(IngameDTO[playerid][BALLOBJ], x2,y2, 5.5);
    PHY_RollObject(IngameDTO[playerid][BALLOBJ]);
    PHY_SetObjectFriction(IngameDTO[playerid][BALLOBJ], 0.25);
    PHY_SetObjectAirResistance(IngameDTO[playerid][BALLOBJ], 0.1);
    PHY_SetObjectGravity(IngameDTO[playerid][BALLOBJ], 7.1);
    PHY_SetObjectZBound(IngameDTO[playerid][BALLOBJ], _, _, 0.5);
}

forward shotBallManager(playerid,Float:distance);
public shotBallManager(playerid,Float:distance){
  new ballNum=IngameDTO[playerid][BALLOBJ];
  DestroyObject(IngameDTO[playerid][BALLOBJ]);
  deletePoketmonPickup();
  deletePoketmonIcon(playerid);
  closePoketBall(playerid);
  switch(ballNum){
      case 0:
      {
        checkBall(playerid, distance, 1);
        }
      case 1:
      {
        checkBall(playerid, distance, 2);
        }
    case 2:
      {
        checkBall(playerid, distance, 3);
        }
        case 3:
      {
        checkBall(playerid, distance, 5);
        }
  }
  return 1;
}

stock checkBall(playerid, Float:distance,Float:ballDistance){
  if(distance > ballDistance) return SendClientMessage(playerid,col_sys,"		ì£¼ë³€ì— í¬ì¼“ëª¬ì´ ì—†ìŠµë‹ˆë‹¤.");
  new str[50];
  format(str,sizeof(str),"%s is caught!",UserDTO[playerid][NAME]);
  foreach (new i : Player){
    GameTextForPlayer(i, str, 2000, 0);
  }
  shotBallInfo(playerid);
  changePoketball();
  return 1;
}

stock shotBallInfo(playerid){
  new memo[200]={"{FFFFFF}¼÷·Ãµµ\t+100\t\tÆ÷ÄÏº¼ +1\n\n%s È¹µæ\t\tEXP +100\n´º Æ÷ÄÏ¸ó\t\tEXP +500\n\nÇÕ°è\t\t\tEXP +600"};
  new str[252];
  format(str,sizeof(str),memo,poketMonName[poketmonType]);
  ShowPlayerDialog(playerid,1001,DIALOG_STYLE_MSGBOX,"{8D8DFF}Æ÷ÄÏ¸ó ¸Å´ÏÀú",str,"È®ÀÎ","");
  UserDTO[playerid][EXP]++;
  SetPlayerScore(playerid, GetPlayerScore(playerid) + 1);
  isShotBall=false;
  IngameDTO[playerid][SHOTB]=false;

    poketmonInit(playerid,(CountDTO[playerid][TICKMON]+1),poketmonType,poketmonCP,0,0,100,100,100,100,100,100);
}

public OnPlayerCommandText(playerid, cmdtext[]){
  showAudio(playerid, 1);
	if (strcmp("/Ã¼ÀÎÁö", cmdtext, true, 10) == 0){
		changePoketball();
		SendClientMessageToAll(col_sys, "¸ó½ºÅÍ Ã¼ÀÎÁö");
		return 1;
	}

    if (strcmp("/kill", cmdtext, true, 10) == 0){
        SetPlayerHealth(playerid, 0);
        return 1;
    }
  if (strcmp("/help", cmdtext, true, 10) == 0){
      helpInfo(playerid);
        return 1;
    }
    if (strcmp("/sav", cmdtext, true, 10) == 0){
    PutLogDB(playerid);
        return 1;
    }

	if (strcmp("/°¡¹æ", cmdtext, true, 10) == 0 || strcmp("/b", cmdtext, true, 10) == 0){

		new sumText[624];
		format(sumText, sizeof(sumText), "%s",getBagInfo(playerid));
		ShowPlayerDialog(playerid, player_Bag, DIALOG_STYLE_LIST, "{8D8DFF}°¡¹æ",sumText,"È®ÀÎ", "Ãë¼Ò");
		return 1;
	}

  	if (strcmp("/Â÷", cmdtext, true, 10) == 0 || strcmp("/v", cmdtext, true, 10) == 0){
		new sumText[200];
		format(sumText, sizeof(sumText), "%s",getCarInfo(playerid));
		ShowPlayerDialog(playerid, car_Bag, DIALOG_STYLE_LIST, "{8D8DFF}Â÷°í ¸Å´ÏÀú",sumText,"È®ÀÎ", "Ãë¼Ò");
        return 1;
    }

  return 0;
}

stock getPoketMonInfo(playerid){
  new Line[10][60];
  new sumText[624];

  for(new i=0; i<10; i++){
    if(PoketmonDTO[playerid][i][ID]==0){
      format(Line[i], 60, "");
    }else{
      format(Line[i], 60, "º°¸í: %s\t Æ÷ÄÏ¸ó: %s CP: %d",poketMonNameHan[PoketmonDTO[playerid][i][TYPE]],PoketmonDTO[playerid][i][MONNAME],PoketmonDTO[playerid][i][CP]);
    }
  }
  format(sumText, sizeof(sumText), "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s",Line[0],Line[1],Line[2],Line[3],Line[4],Line[5],Line[6],Line[7],Line[8],Line[9]);
  return sumText;
}

stock getCarInfo(playerid){
  new Line3[4][40];
  new sumText[200];

  for(new i=0; i<4; i++){
    if(CarDTO[playerid][i][ID]==0){
      format(Line3[i], 60, "");
    }else{
      new carNum=CarDTO[playerid][i][MODEL];
        format(Line3[i], 60, "%s (Model : %d)",carName[carNum],carModelNum[carNum]);
    }
  }
  format(sumText, sizeof(sumText), "%s\n%s\n%s\n%s",Line3[0],Line3[1],Line3[2],Line3[3]);
  return sumText;
}
stock getBagInfo(playerid){
  new Line2[10][60];
  new sumText[624];

  for(new i=0; i<10; i++){
    if(ItemDTO[playerid][i][ID]==0){
      format(Line2[i], 60, "");
    }else{
        format(Line2[i], 60, "%s (¼ö·®: %d)",itemName[ItemDTO[playerid][i][TYPE]],ItemDTO[playerid][i][AMOUNT]);
    }
  }
  format(sumText, sizeof(sumText), "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s",Line2[0],Line2[1],Line2[2],Line2[3],Line2[4],Line2[5],Line2[6],Line2[7],Line2[8],Line2[9]);
  return sumText;
}

stock rideCar(playerid,num,model){
  if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,col_sys,"		ì´ë¯¸ ì°¨ëŸ‰ì— íƒ‘ìŠ¹ì¤‘ì…ë‹ˆë‹¤.");
  new Float:pos[4];
  GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
  GetPlayerFacingAngle(playerid, pos[3]);
  switch(num){
    case 0:{
      if(IngameDTO[playerid][ISCAR1]==true){
              putCar(playerid,num);
      }
      IngameDTO[playerid][CARNUM1] = CreateVehicle(model, pos[0], pos[1], pos[2], pos[3], 0, 0, 0);
      inCar(playerid, IngameDTO[playerid][CARNUM1]);
      PutPlayerInVehicle(playerid, IngameDTO[playerid][CARNUM1], 0);
      IngameDTO[playerid][ISCAR1]=true;
    }
    case 1:{
      if(IngameDTO[playerid][ISCAR2]==true){
              putCar(playerid,num);
      }
      IngameDTO[playerid][CARNUM2] = CreateVehicle(model, pos[0], pos[1], pos[2], pos[3], 0, 0, 0);
      inCar(playerid, IngameDTO[playerid][CARNUM2]);
      PutPlayerInVehicle(playerid, IngameDTO[playerid][CARNUM2], 0);
      IngameDTO[playerid][ISCAR2]=true;
    }
    case 2:{
      if(IngameDTO[playerid][ISCAR3]==true){
              putCar(playerid,num);
      }
      IngameDTO[playerid][CARNUM3] = CreateVehicle(model, pos[0], pos[1], pos[2], pos[3], 0, 0, 0);
      inCar(playerid, IngameDTO[playerid][CARNUM3]);
      PutPlayerInVehicle(playerid, IngameDTO[playerid][CARNUM3], 0);
      IngameDTO[playerid][ISCAR3]=true;
    }
    case 3:{
      if(IngameDTO[playerid][ISCAR4]==true){
              putCar(playerid,num);
      }
      IngameDTO[playerid][CARNUM4] = CreateVehicle(model, pos[0], pos[1], pos[2], pos[3], 0, 0, 0);
      inCar(playerid, IngameDTO[playerid][CARNUM4]);
      PutPlayerInVehicle(playerid, IngameDTO[playerid][CARNUM4], 0);
      IngameDTO[playerid][ISCAR4]=true;
    }
  }
  return 1;
}

stock openPoketball(playerid, type){
    IngameDTO[playerid][BALLOBJNUM]=ballObjNum[type];
  SetPlayerAttachedObject( playerid, 0, ballObjNum[type], 6, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000,   0.000000, 1.050000, 1.050000, 1.050000 );
  IngameDTO[playerid][ISBALL]=true;
}

stock closePoketBall(playerid){
  RemovePlayerAttachedObject(playerid, 0);
  IngameDTO[playerid][ISBALL]=false;
  IngameDTO[playerid][ITEAMNUM]=0;
  IngameDTO[playerid][BALLOBJNUM]=0;
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
   if(WarpDTO[playerid][CARID] != carid && carid != 0)Ban(playerid);
   return 1;
}

forward ServerThread();
public ServerThread(){
    foreach (new i : Player){
        distanceManager(i);
  }
}

forward distanceManager(playerid);
public distanceManager(playerid){
  new str[30];
  format(str,sizeof(str),"distance: %.1f",getPoketmonDistence(playerid));
  TextDrawSetString(IngameDTO[playerid][DISTANCE],str);
}

forward Float:getPoketmonDistence(playerid);
stock Float:getPoketmonDistence(playerid){
  new Float:distance = GetDistance(playerid,ballPos[0],ballPos[1]);
  return distance;
}

stock changePoketball(){
  new szCmd[64];
  format(szCmd, sizeof(szCmd), "unloadfs %s", poketMonName[poketmonType]);
  SendRconCommand(szCmd);
  randomPoketmonType();
  randomPoketmonCP();
    fixBallPos();
    fixPoketMonName();
  changePoketMonImg();
}

stock randomPoketmonType(){
  poketmonType = random(USED_POKETMON);
}

stock randomPoketmonCP(){
  poketmonCP = randMin(130, 210);
}


stock fixPoketMonName(){
  new str[60];
  format(str,sizeof(str),"%s CP : %d",poketMonName[poketmonType],poketmonCP);
  TextDrawSetString(TD_iPhone[1],str);
}

stock changePoketMonImg(){
  loadModeImg();
}

stock fixBallPos(){
  ballPos[0] = randMin(-3000,3000);
  ballPos[1] = randMin(-3000,3000);
}

stock randMin(min, max){
  return random(max - min) + min;
}

stock deletePoketmonPickup(){
  DestroyPickup(ballPickup);
}

stock showPoketmonPickup(playerid){
  new Float:x,Float:y,Float:z;
  GetPlayerCameraDistance(playerid,x,y,z,1.0);
  ballPickup = CreatePickup(1598, 1, x, y, z, -1);
}

stock showPoketmonIcon(playerid){
  new Float:x,Float:y,Float:z;
  GetPlayerCameraDistance(playerid,x,y,z,2.0);
  SetPlayerMapIcon(playerid, 0, x, y, z, 36, 0, MAPICON_LOCAL_CHECKPOINT);
}

stock deletePoketmonIcon(playerid){
  RemovePlayerMapIcon(playerid, 0);
}

stock showDistanceImg(playerid){
  TextDrawShowForPlayer(playerid, IngameDTO[playerid][DISTANCE]);
}

stock deleteDistanceImg(playerid){
  TextDrawDestroy(IngameDTO[playerid][DISTANCE]);
}

stock loadDistanceImg(playerid){
    IngameDTO[playerid][DISTANCE] = TextDrawCreate(550.6666, 331.9259, "distance: 1340m");
    TextDrawLetterSize(IngameDTO[playerid][DISTANCE], 0.2843, 1.3657);
    TextDrawAlignment(IngameDTO[playerid][DISTANCE], 2);
    TextDrawColor(IngameDTO[playerid][DISTANCE], -1);
    TextDrawSetShadow(IngameDTO[playerid][DISTANCE], 0);
    TextDrawSetOutline(IngameDTO[playerid][DISTANCE], 0);
    TextDrawBackgroundColor(IngameDTO[playerid][DISTANCE], 51);
    TextDrawFont(IngameDTO[playerid][DISTANCE], 1);
    TextDrawSetProportional(IngameDTO[playerid][DISTANCE], 1);
}

stock showPhoneImg(playerid){
  for(new b = 0;b<USED_PHONES;b++){
    TextDrawShowForPlayer(playerid, TD_iPhone[b]);
  }
}
stock loadPhoneImg(){

    TD_iPhone[0] = TextDrawCreate(550.666687, 221.925918, "WEB PIN CODE : 23552");
    TextDrawLetterSize(TD_iPhone[0], 0.194333, 0.865778);
    TextDrawAlignment(TD_iPhone[0], 2);
    TextDrawColor(TD_iPhone[0], -1);
    TextDrawSetShadow(TD_iPhone[0], 0);
    TextDrawSetOutline(TD_iPhone[0], 0);
    TextDrawBackgroundColor(TD_iPhone[0], 51);
    TextDrawFont(TD_iPhone[0], 1);
    TextDrawSetProportional(TD_iPhone[0], 1);

    TD_iPhone[1] = TextDrawCreate(550.6666, 251.9259, "Picachu CP : 216");
    TextDrawLetterSize(TD_iPhone[1], 0.2343, 0.8657);
    TextDrawAlignment(TD_iPhone[1], 2);
    TextDrawColor(TD_iPhone[1], -1);
    TextDrawSetShadow(TD_iPhone[1], 0);
    TextDrawSetOutline(TD_iPhone[1], 0);
    TextDrawBackgroundColor(TD_iPhone[1], 51);
    TextDrawFont(TD_iPhone[1], 1);
    TextDrawSetProportional(TD_iPhone[1], 1);
}

stock loadModeImg(){
  new szCmd[64];
  format(szCmd, sizeof(szCmd), "loadfs %s", poketMonName[poketmonType]);
  SendRconCommand(szCmd);
}

stock showBallImg(playerid){
  for(new b = 0;b<USED_BALL;b++){
    if(TextDrawBall[b][used] == 1){TextDrawShowForPlayer(playerid,TextDrawBall[b][id]);}
  }
}

stock loadMisson(){
  missonInit("Æ÷ÄÏ¸ó ¼¾ÅÍ",1910.2273,-1714.3197,13.3307);
  missonInit("¾ÆÀÌÅÛ »óÁ¡",1909.9907,-1707.3611,13.3251);
  missonInit("Â÷·® ÆÇ¸ÅÁ¡",1909.9747,-1700.0070,13.3236);
}

stock missonInit(name[24],Float:pos_x,Float:pos_y,Float:pos_z){
  new num = missonTick++;
  format(MissonDTO[num][NAME], 24,"%s",name);
  MissonDTO[num][POS_X]=pos_x;
  MissonDTO[num][POS_Y]=pos_y;
  MissonDTO[num][POS_Z]=pos_z;

}

GetPlayerCameraDistance(playerid,&Float:x,&Float:y,&Float:z,Float:distance){
  new
    Float:fPX, Float:fPY, Float:fPZ,
    Float:fVX, Float:fVY, Float:fVZ;

  const Float:fScale = 5.0;

  GetPlayerCameraPos(playerid, fPX, fPY, fPZ);
  GetPlayerCameraFrontVector(playerid, fVX, fVY, fVZ);

  x = fPX + floatmul(fVX, fScale) * distance;
  y = fPY + floatmul(fVY, fScale) * distance;
  z = fPZ + floatmul(fVZ, fScale) * distance;
}

stock zoneInit(playerid){
  new zoneCol[2] = { 0xFFFFFF99, 0xAFAFAF99};
  new flag = 0;
  new flag2 = 0;
  new tick = 0;
  for(new i = 0; i < USED_ZONE; i++){
    tick++;
    if(tick == 31){
      tick = 1;
      flag2 = !flag2;
    }
    flag = !flag;
    if(flag == 1){
      if(flag2 == 1){
        GangZoneShowForPlayer(playerid, zonePoketmon[i], zoneCol[0]);
      }else{
        GangZoneShowForPlayer(playerid, zonePoketmon[i], zoneCol[1]);
      }
    }
    else if(!flag2){
      GangZoneShowForPlayer(playerid, zonePoketmon[i], zoneCol[0]);
    }else{
      GangZoneShowForPlayer(playerid, zonePoketmon[i], zoneCol[1]);
    }
  }
  return 0;
}

stock showAudio(playerid, type){
    if(Audio_IsClientConnected(playerid)){
    Audio_Play(playerid, type,false,false,false);
  }
}
forward Float:GetDistance(playerid,Float:x2,Float:y2);
stock Float:GetDistance(playerid,Float:x2,Float:y2){
  new Float:pos[3];
    GetPlayerPos(playerid,pos[0],pos[1],pos[2]);
  return floatsqroot(floatpower(floatabs(floatsub(x2,pos[0])),2)+floatpower(floatabs(floatsub(y2,pos[1])),2));
}
