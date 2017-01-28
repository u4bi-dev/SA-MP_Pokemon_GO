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

#define d_Reg    	 	 1
#define d_Log    	 	 2
#define poketmon_Bag 	 3
#define player_Bag   	 4
#define slot_bag     	 5
#define car_Bag      	 6
#define slot_car     	 7
#define misson_medi  	 8
#define misson_itemshop  9
#define misson_carshop   10
#define medi_care        11
#define medi_mix         12
#define medi_sell        13
#define medi_qwest		 14
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
  "산악자전거",
  "산체스",
  "NRG 바이크",
  "블리스타 컴팩트",
  "엘리지",
  "뷸렛",
  "매버릭 헤리콥터",
  "샤멜 비행기"
};
new carPrice[8]={6000,22000,46000,25000,430000,470000,110000,160000};

new carMemo[1][200]={
  "가격 : 6000원\n\n효과 : 걸어다니는 것보다 빠르게 다닐 수 있다.\n관동지방 태초마을 30년지기 자전거 장인이 만든 산악형 MTB자전거"
};

new itemMemo[4][200]={
  "가격 : 100원\n\n효과 : 야생 포켓몬에게 사용하여 포켓몬을 포획한다.\n포획률 : 포획률: x 1.0\n포획반경 : 0.0m~0.9m\n야생 포켓몬에게 던져서 잡기 위한 볼 캡슐식으로 되어 있다.",
  "가격 : 600원\n\n효과 : 야생 포켓몬에게 사용하여 포켓몬을 포획한다.\n포획률 : 포획률: x 1.5\n포획반경 : 0.0m~1.9m\n몬스터볼보다도 더욱 포켓몬을 잡기 쉬워진 약간 성능이 좋은 볼",
  "가격 : 1200원\n\n효과 : 야생 포켓몬에게 사용하여 포켓몬을 포획한다.\n포획률 : 포획률: x 2.0\n포획반경 : 0.0m~2.9m\n울트라볼보다도 더욱 포켓몬을 잡기 쉬워진 매우 성능이 좋은 볼",
  "가격 : 판매불가\n\n효과 : 야생 포켓몬에게 사용하여 포켓몬을 포획한다.\n포획률 : 계산식 없이 100퍼센트 포획\n포획반경 : 0.0m~4.9m\n야생 포켓몬을 반드시 잡을 수 있는 최고 성능의 볼"
};

new ballObjNum[4]={2997,2996,3106,2998};
new itemName[4][20]={
  "포켓볼",
  "그레이트볼",
  "울트라볼",
  "마스터볼"
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
  "피카츄",
  "파이리",
  "꼬부기",
  "탕구리",
  "푸푸린",
  "이브이",
  "구구",
  "고라파덕",
  "토게피",
  "발챙이",
  "이상해씨",
  "모다피",
  "코일",
  "꼬렛",
  "팬텀",
  "메타몽",
  "뿔총",
  "부스터",
  "찌리리공",
  "또도가스",
  "냐옹이",
  "꼬마돌",
  "깨비참",
  "고오스",
  "가디",
  "홍수몬",
  "프테라",
  "프리져",
  "폴리곤",
  "포니타",
  "파오리",
  "투구",
  "크랩",
  "콘팡",
  "콘치",
  "켄타로우스",
  "캥카",
  "캐터피",
  "캐이시",
  "질퍽이",
  "쥬피썬더",
  "쥬레곤",
  "쥬베스",
  "잠만보",
  "잉어킹",
  "왕눈해",
  "에레브",
  "야돈",
  "암나이트",
  "알통몬",
  "아보크",
  "아라리",
  "쏘드라",
  "썬더",
  "신뇽",
  "식스테일",
  "슬리프",
  "스라크",
  "셀러",
  "샤미드",
  "삐삐",
  "쁘사이져",
  "뿔카노",
  "별가사리",
  "미뇽",
  "뮤츠",
  "모래두지",
  "망키",
  "마임맨",
  "마그마",
  "루주라",
  "롱스톤",
  "럭키",
  "라프라스",
  "뚜벅쵸",
  "디그다",
  "두두",
  "덩쿠리",
  "니도란(남)",
  "니도란(여)",
  "내루미"
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
    format(str, sizeof(str),"%s (Y키)",MissonDTO[a][NAME]);
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
  if(mysql_errno(mysql) != 0) print("DB 연결이 안됨.");
  else print("DB 연결됨.");
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
  new memo[400]={"{8D8DFF}공지사항{FFFFFF}\n오브젝트 제작자 한분을 찾습니다. (업무명 : 포켓몬센터 제작)\n좋은 컨텐츠 기획 아이디어 도움을 주실분들을 찾습니다.\n참여도에 따라 차 후 소정의 혜택 지급\n\n참여 카톡 오픈채팅 : https://open.kakao.com/o/gpZ9Qqm\n\n{8D8DFF}명령어 안내{FFFFFF}\n\n/가방(/b) /차(/v) /포켓몬(/p)\n\n"};
  ShowPlayerDialog(playerid,1001,DIALOG_STYLE_MSGBOX,"{8D8DFF}포켓몬 매니저",memo,"확인","");
}

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
    ShowPlayerDialog(playerid, d_Log, DIALOG_STYLE_PASSWORD, "{8D8DFF}계정관리 매니저", "{FFFFFF}비밀번호를 입력해주세요.", "로그인", "나가기");
  }else{
    ShowPlayerDialog(playerid, d_Reg, DIALOG_STYLE_PASSWORD, "{8D8DFF}계정관리 매니저", "{FFFFFF}비밀번호를 입력해주세요.", "회원가입", "나가기");
  }
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]){
  showAudio(playerid, 1);
  switch(dialogid){
      case d_Log:joinDialog(playerid,response,inputtext,0);
      case d_Reg:joinDialog(playerid,response,inputtext,1);
      case poketmon_Bag:{
      if(PoketmonDTO[playerid][0][ID]==0) return SendClientMessage(playerid,col_sys,"		포켓몬이 없습니다.");
      bagDialog(playerid,response,listitem,0);
    }
      case player_Bag:{
      if(ItemDTO[playerid][0][ID]==0) return SendClientMessage(playerid,col_sys,"		아이템이 없습니다.");
      bagDialog(playerid,response,listitem,1);
    }
      case slot_bag:slotEventItem(playerid,response,listitem);
      case car_Bag:{
      if(CarDTO[playerid][0][ID]==0) return SendClientMessage(playerid,col_sys,"		차량이 없습니다.");
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
    ShowPlayerDialog(playerid, misson_medi, DIALOG_STYLE_LIST,str,"{FFFFFF}포켓몬 치료\n포켓몬 합성\n포켓몬 분양\n대화(퀘스트)","확인", "취소");
  }
}

stock itemShopDialog(playerid,response,listitem,type){
  new str[60];
  format(str, sizeof(str),"{8D8DFF}%s",MissonDTO[1][NAME]);
  if(response){
    printf("%d %d",listitem,type);
  }else{
    ShowPlayerDialog(playerid, misson_itemshop, DIALOG_STYLE_LIST,str,"{FFFFFF}아이템 구매\n아이템 판매\n대화(퀘스트)","확인", "취소");
  }
}

stock carShopDialog(playerid,response,listitem,type){
  new str[60];
  format(str, sizeof(str),"{8D8DFF}%s",MissonDTO[2][NAME]);
  if(response){
    printf("%d %d",listitem,type);
  }else{
    ShowPlayerDialog(playerid, misson_carshop, DIALOG_STYLE_LIST,str,"{FFFFFF}차량 구매\n차량 판매\n대화(퀘스트)","확인", "취소");
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
  ShowPlayerDialog(playerid, medi_care, DIALOG_STYLE_LIST, "포켓몬 치료",str,"확인", "취소");
}

stock poketmonMix(playerid,str[]){
  ShowPlayerDialog(playerid, medi_mix, DIALOG_STYLE_LIST, "포켓몬 합성",str,"확인", "취소");
}

stock poketmonSell(playerid,str[]){
  ShowPlayerDialog(playerid, medi_sell, DIALOG_STYLE_LIST, "포켓몬 분양",str,"확인", "취소");
}

stock poketmonQwest(playerid){
  ShowPlayerDialog(playerid, medi_qwest, DIALOG_STYLE_LIST, "포켓몬 퀘스트","경험에 맞는 퀘스트가 없습니다.\n","확인", "취소");
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
  format(sumText, sizeof(sumText), "%s (가격 : %d원)\n%s (가격 : %d원)\n%s (가격 : %d원)\n%s (가격 : %d원)\n",itemName[0],itemPrice[0],itemName[1],itemPrice[1],itemName[2],itemPrice[2],itemName[3],itemPrice[3]);
  ShowPlayerDialog(playerid, item_buy, DIALOG_STYLE_LIST, "아이템 구매",sumText,"확인", "취소");
}

stock itemShopSell(playerid){
  new sumText[624];
  format(sumText, sizeof(sumText), "%s",getBagInfo(playerid));
  ShowPlayerDialog(playerid, item_sell, DIALOG_STYLE_LIST, "아이템 판매",sumText,"확인", "취소");
}

stock itemShopQwest(playerid){
  ShowPlayerDialog(playerid, item_qwest, DIALOG_STYLE_LIST, "아이템 퀘스트","경험에 맞는 퀘스트가 없습니다.\n","확인", "취소");
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
  format(sumText, sizeof(sumText), "%s Model: %d \t(가격 : %d원)\n%s Model: %d (가격 : %d원)\n%s Model: %d (가격 : %d원)\n%s Model: %d (가격 : %d원)\n%s Model: %d (가격 : %d원)\n%s Model: %d (가격 : %d원)\n%s Model: %d (가격 : %d원)\n%s Model: %d (가격 : %d원)\n",
  carName[0],carModelNum[0],carPrice[0],
  carName[1],carModelNum[1],carPrice[1],
  carName[2],carModelNum[2],carPrice[2],
  carName[3],carModelNum[3],carPrice[3],
  carName[4],carModelNum[4],carPrice[4],
  carName[5],carModelNum[5],carPrice[5],
  carName[6],carModelNum[6],carPrice[6],
  carName[7],carModelNum[7],carPrice[7]
  );
  ShowPlayerDialog(playerid, car_buy, DIALOG_STYLE_LIST, "차량 구매",sumText,"확인", "취소");
}

stock carShopSell(playerid){
  new sumText[200];
  format(sumText, sizeof(sumText), "%s",getCarInfo(playerid));
  ShowPlayerDialog(playerid, car_sell, DIALOG_STYLE_LIST, "차량 판매",sumText,"확인", "취소");
}

stock carShopQwest(playerid){
  ShowPlayerDialog(playerid, car_qwest, DIALOG_STYLE_LIST, "차량 퀘스트","경험에 맞는 퀘스트가 없습니다.\n","확인", "취소");
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
  ShowPlayerDialog(playerid, slot_car, DIALOG_STYLE_LIST, str,"사용\n넣기\n정보","확인", "취소");
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
  new memo[300]={"{FFFFFF}차량 정보 : %s(Model : %d)\n\n{8D8DFF}상세설명{FFFFFF}\n\n%s\n\n"};
  new str[300];
  new carNum=CarDTO[playerid][num][MODEL];

  format(str,sizeof(str),memo,
  carName[carNum],
  carModelNum[carNum],
  carMemo[carNum]
  );
  ShowPlayerDialog(playerid,1001,DIALOG_STYLE_MSGBOX,"{8D8DFF}포켓몬 매니저",str,"확인","");
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
  ShowPlayerDialog(playerid, slot_bag, DIALOG_STYLE_LIST, str,"사용\n넣기\n정보","확인", "취소");
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
      if(IngameDTO[playerid][ISBALL] == true) return SendClientMessage(playerid,col_sys,"		이미 몬스터볼을 꺼내셨습니다.");
      openPoketball(playerid,num);
      new str[126];
      format(str, sizeof(str),"		가방에서 %s을(를) 꺼낸다.",itemName[num]);
      SendClientMessage(playerid,col_sys,str);
      }
  }
  return 1;
}

stock putItem(playerid,num){
  switch(num){
      case 0..3:
      {
      if(IngameDTO[playerid][ITEAMNUM] != num) return SendClientMessage(playerid,col_sys,"		몬스터볼을 꺼내지 않았습니다.");
      if(IngameDTO[playerid][ISBALL] == false) return SendClientMessage(playerid,col_sys,"		몬스터볼을 꺼내지 않았습니다.");
      SendClientMessage(playerid,col_sys,"		몬스터볼을 가방에 넣는다.");
      closePoketBall(playerid);
    }
  }
  return 1;
}

stock infoItem(playerid,num){
  selectItemInfo(playerid,num);
}

stock selectItemInfo(playerid,num){
  new memo[300]={"{FFFFFF}아이템 정보 : %s\n\n{8D8DFF}상세설명{FFFFFF}\n\n%s\n\n"};
  new str[300];
  format(str,sizeof(str),memo,
  itemName[num],
  itemMemo[num]
  );
  ShowPlayerDialog(playerid,1001,DIALOG_STYLE_MSGBOX,"{8D8DFF}포켓몬 매니저",str,"확인","");
}

stock selectPoketMon(playerid,num){
  new memo[300]={"{FFFFFF}별명 : %s\n포켓몬명 : %s\nCP점수 : %d\n\n{8D8DFF}배틀기록{FFFFFF}\n승리 : %d\t패배 : %d\n\n{8D8DFF}상태정보{FFFFFF}\n건강도 : %d\n목마름 : %d\n포만감 : %d\n피곤함 : %d\n청결도 : %d\n즐거움 : %d\n\n\n{8D8DFF}포켓몬은 인포웹에서 훈련시킬 수 있습니다.\n{FFFFFF}sundayplay.kr"};
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
  ShowPlayerDialog(playerid,1001,DIALOG_STYLE_MSGBOX,"{8D8DFF}포켓몬 매니저",str,"확인","");
}

stock joinDialog(playerid,response,inputtext[],type){
    if(!response) return Kick(playerid);
  switch(type){
    case 0:{
      if(!strcmp(inputtext, UserDTO[playerid][PASS])){
        LoadDB(playerid);
        IngameDTO[playerid][LOGIN]=true;

        }else ShowPlayerDialog(playerid, d_Log, DIALOG_STYLE_PASSWORD, "{8D8DFF}계정관리 매니저", "{FFFFFF}비밀번호가 틀립니다.", "로그인", "나가기");
    }
    case 1:{
          if(strlen(inputtext) > 24) return ShowPlayerDialog(playerid, d_Reg, DIALOG_STYLE_PASSWORD, "{8D8DFF}계정관리 매니저", "{FFFFFF}24자 이하의 비밀번호를 입력해주세요.", "회원가입", "나가기");
        if(strlen(inputtext) < 6) return ShowPlayerDialog(playerid, d_Reg, DIALOG_STYLE_PASSWORD, "{8D8DFF}계정관리 매니저", "{FFFFFF}6자 이상의 비밀번호를 입력해주세요.", "회원가입", "나가기");
        InsertLogAdapter(playerid,inputtext);
      IngameDTO[playerid][LOGIN]=true;
    }
  }
  return 1;
}
stock LoadDB(playerid){
  print("\n유저로그 불러옴");
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
  SendClientMessage(playerid,col_sys,"		당신의 인포웹 접근권한 핀코드는 23552입니다.");
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

    print("\n유저로그 생성");
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
    SendClientMessage(playerid,col_sys,"		당신의 인포웹 접근권한 핀코드는 23552입니다.");
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

/*HACK : 초기화*/
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
  SendClientMessage(playerid,col_sys, "		저장되었습니다.");
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
   new msg[32];
   format(msg,sizeof(msg), "정상탑승 : %s", (WarpDTO[playerid][CHECK]) ? ("맞음") : ("아님"));
   SendClientMessage(playerid, -1, msg);

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
        if(isShotBall==true) return SendClientMessage(playerid,col_sys,"		누군가 포켓몬을 포획중입니다.");
        isShotBall=true;
        IngameDTO[playerid][SHOTB]=true;
        showPoketmonPickup(playerid);
        showPoketmonIcon(playerid);
      }
      ClearAnimations(playerid);
      ApplyAnimation(playerid,"BASEBALL","Bat_IDLE",4.1,0,1,1,1,1);
      SendClientMessage(playerid,col_sys,"		포켓몬을 향해 조준합니다.");
    }
    if(RELEASED(KEY_HANDBRAKE)){
      shotBall(playerid);
      SetTimerEx("shotBallManager", 2000, false, "ii", playerid,distance);
      ApplyAnimation(playerid,"BASEBALL","Bat_M",4.1,0,1,1,1,1);
      openPoketball(playerid, 0);
      SendClientMessage(playerid,col_sys,"		몬스터볼을 던집니다.");
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
    case 0: ShowPlayerDialog(playerid, misson_medi, DIALOG_STYLE_LIST,str,"{FFFFFF}포켓몬 치료\n포켓몬 합성\n포켓몬 분양\n대화(퀘스트)","확인", "취소");
    case 1: ShowPlayerDialog(playerid, misson_itemshop, DIALOG_STYLE_LIST,str,"{FFFFFF}아이템 구매\n아이템 판매\n대화(퀘스트)","확인", "취소");
    case 2: ShowPlayerDialog(playerid, misson_carshop, DIALOG_STYLE_LIST,str,"{FFFFFF}차량 구매\n차량 판매\n대화(퀘스트)","확인", "취소");
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
  if(distance > ballDistance) return SendClientMessage(playerid,col_sys,"		주변에 포켓몬이 없습니다.");
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
  new memo[200]={"{FFFFFF}숙련도\t+100\t\t포켓볼 +1\n\n%s 획득\t\tEXP +100\n뉴 포켓몬\t\tEXP +500\n\n합계\t\t\tEXP +600"};
  new str[252];
  format(str,sizeof(str),memo,poketMonName[poketmonType]);
  ShowPlayerDialog(playerid,1001,DIALOG_STYLE_MSGBOX,"{8D8DFF}포켓몬 매니저",str,"확인","");
  UserDTO[playerid][EXP]++;
  SetPlayerScore(playerid, GetPlayerScore(playerid) + 1);
  isShotBall=false;
  IngameDTO[playerid][SHOTB]=false;

    poketmonInit(playerid,(CountDTO[playerid][TICKMON]+1),poketmonType,poketmonCP,0,0,100,100,100,100,100,100);
}

public OnPlayerCommandText(playerid, cmdtext[]){
  showAudio(playerid, 1);
  if (strcmp("/체인지", cmdtext, true, 10) == 0){
    changePoketball();
    SendClientMessageToAll(col_sys, "몬스터 체인지");
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

    if (strcmp("/포켓몬", cmdtext, true, 10) == 0 || strcmp("/p", cmdtext, true, 10) == 0){
    new sumText[624];
    format(sumText, sizeof(sumText), "%s",getPoketMonInfo(playerid));
    ShowPlayerDialog(playerid, poketmon_Bag, DIALOG_STYLE_LIST, "{8D8DFF}포켓몬 매니저",sumText,"확인", "취소");
    return 1;
  }
  if (strcmp("/가방", cmdtext, true, 10) == 0 || strcmp("/b", cmdtext, true, 10) == 0){

    new sumText[624];
    format(sumText, sizeof(sumText), "%s",getBagInfo(playerid));
    ShowPlayerDialog(playerid, player_Bag, DIALOG_STYLE_LIST, "{8D8DFF}가방",sumText,"확인", "취소");
    return 1;
  }

    if (strcmp("/차", cmdtext, true, 10) == 0 || strcmp("/v", cmdtext, true, 10) == 0){
    new sumText[200];
    format(sumText, sizeof(sumText), "%s",getCarInfo(playerid));
    ShowPlayerDialog(playerid, car_Bag, DIALOG_STYLE_LIST, "{8D8DFF}차고 매니저",sumText,"확인", "취소");
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
        format(Line[i], 60, "별명: %s\t 포켓몬: %s CP: %d",poketMonNameHan[PoketmonDTO[playerid][i][TYPE]],PoketmonDTO[playerid][i][MONNAME],PoketmonDTO[playerid][i][CP]);
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
        format(Line2[i], 60, "%s (수량: %d)",itemName[ItemDTO[playerid][i][TYPE]],ItemDTO[playerid][i][AMOUNT]);
    }
  }
  format(sumText, sizeof(sumText), "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s",Line2[0],Line2[1],Line2[2],Line2[3],Line2[4],Line2[5],Line2[6],Line2[7],Line2[8],Line2[9]);
  return sumText;
}

stock rideCar(playerid,num,model){
  if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,col_sys,"		이미 차량에 탑승중입니다.");
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
  missonInit("포켓몬 센터",1910.2273,-1714.3197,13.3307);
  missonInit("아이템 상점",1909.9907,-1707.3611,13.3251);
  missonInit("차량 판매점",1909.9747,-1700.0070,13.3236);
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
