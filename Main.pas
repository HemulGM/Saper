unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, XPMan, ExtCtrls, pngextra, pngimage;

type
  TFormMain = class(TForm)
    ButtonClose: TPNGButton;
    LabelFCount: TLabel;
    ButtonHide: TPNGButton;
    LabelTime: TLabel;
    ImageTime: TImage;
    ImageBombLeft: TImage;
    ButtonNew: TPNGButton;
    ButtonAbout: TPNGButton;
    ButtonOption: TPNGButton;
    DrawGridPoly: TDrawGrid;
    XPManifest: TXPManifest;
    TimerTime: TTimer;
    ImageBG: TImage;
    ButtonHelp: TPNGButton;
    procedure DrawGridPolyDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure DrawGridPolyMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DrawGridPolyMouseWheelDown(Sender: TObject;
      Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure DrawGridPolyMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure ButtonCloseClick(Sender: TObject);
    procedure ImageBGMouseEnter(Sender: TObject);
    procedure ImageBGMouseLeave(Sender: TObject);
    procedure ButtonHideClick(Sender: TObject);
    procedure TimerTimeTimer(Sender: TObject);
    procedure ButtonNewClick(Sender: TObject);
    procedure ButtonAboutClick(Sender: TObject);
    procedure ButtonOptionClick(Sender: TObject);
    procedure ButtonCloseMouseEnter(Sender: TObject);
    procedure ButtonCloseMouseExit(Sender: TObject);
    procedure ButtonHelpClick(Sender: TObject);
  private
   procedure WMNCHitTest(var M: TWMNCHitTest); message wm_NCHitTest;
  end;
  TSArray = array[0..50, 0..50] of Byte;                                        //Шаблон массива - поля
  TBitmaps = class                                                              //Текстуры
   public
    Bomb:TBitmap;                                                               //Бомба
    Flag:TBitmap;                                                               //Флаг
    Quest:TBitmap;                                                              //Вопрос
    Close:TBitmap;                                                              //Закрытая клетка
    Empty:TBitmap;                                                              //Пустая клетка
    BMP:TBitmap;
    BackGround:TBitmap;                                                         //Фон
    Win:TPNGObject;                                                             //Победа
    Lose:TPNGObject;                                                            //Проигрыш
    constructor Create;
  end;
  TGameState = (gsWin, gsGame, gsLose);                                         //Статус игры (Победа, Игра идет, Проигрыш)
  TGameDificulty = (gdEasy, gdNormal, gdHard, gdExpert);                        //Сложность (Легко, Нормально, Сложно, Yardcore)
  TGame = class
   public
    GameState:TGameState;
    Time:Cardinal;
    GameDif:TGameDificulty;
    HelpEnable:Boolean;
    procedure New;                                                              //Новая игра
    procedure Win;                                                              //Победа
    procedure Lose;                                                             //Проигрыш
    procedure GetHelp;
    procedure Close;
    constructor Create;
   private
    GSize:Byte;                                                                 //Размер поля
    BombCount:Byte;                                                             //Кол-во бомб
    procedure ClearPoly;                                                        //Очистка поля
    procedure SetSize(Value:Byte);                                              //Размер сетки
    procedure DoClick(C, R:Byte);                                               //Клик по сетке
    procedure OpenAll(C, R:Byte);                                               //Открыть все соседние пустые клетки
    function SetForOpen(C, R:Byte):Byte;                                        //Назначить цифру пустой клетке
    function CheckForWin:Boolean;                                               //Проверка на выигрыш
    procedure FillBomb;                                                         //Заполнить показочный массив бомбами (проигрышь)
   published
    property Size:Byte read GSize write SetSize;                                //Установка размера поля
  end;
  TStatistics = record
   Win:Integer;
   Lose:Integer;
   FirstBoom:Integer;
   MinTime:Integer;
   MaxTime:Integer;
   LastTime:Integer;
   Clicks:Integer;
   MinClicks:Integer;
   Bonus:Integer;
   MaxBonus:Integer;
  end;
  TSaveStat = class
   procedure SaveTo(FileName:string);
   procedure LoadFrom(FileName:string);
  end;

const
  //Значения ячеек
  ctEmpty = 0;                                                                  //Пусто
  ctBomb = 44;                                                                  //Мина
  ctFlag = 15;                                                                  //Флаг
  ctQuest = 32;                                                                 //Воскл.знак
  ctClose = 128;                                                                //Закрыта
  ctOpen = 182;                                                                 //Открыта


var
  FormMain: TFormMain;
  SArray:TSArray;   //Значения
  HArray:TSArray;   //Отображение
  Bitmaps:TBitmaps; //Текстуры
  FCount:Word;      //Кол-во оставшихся закрытых ячеек
  Game:TGame;       //Игра
  Need:Boolean;     //Перетаскивание возможно
  Path:String;      //Рабочий каталог
  Statistics:TStatistics;
  SaveStat:TSaveStat;

function LoadSkinFromDll(DllName:string):Boolean;  


implementation

{$R *.dfm}
 uses UResult, About, Settings;

procedure TGame.Close;
begin
 SaveStat.SaveTo(Path+'stat.dat');
 Application.Terminate;
end;

procedure TSaveStat.SaveTo(FileName:string);
var SaveFile:file of Integer;
begin
 AssignFile(SaveFile, FileName);
 Rewrite(SaveFile);
 write(SaveFile, Statistics.Win);
 write(SaveFile, Statistics.Lose);
 write(SaveFile, Statistics.FirstBoom);
 write(SaveFile, Statistics.MinTime);
 write(SaveFile, Statistics.MaxTime);
 write(SaveFile, Statistics.LastTime);
 write(SaveFile, Statistics.MinClicks);
 write(SaveFile, Statistics.MaxBonus);
 CloseFile(SaveFile);
end;

procedure TSaveStat.LoadFrom(FileName:string);
var SaveFile:file of Integer;
begin
 AssignFile(SaveFile, FileName);
 if FileExists(FileName) then Reset(SaveFile) else
  begin
   Statistics.Win:=0;
   Statistics.Lose:=0;
   Statistics.FirstBoom:=0;
   Statistics.MinTime:=900;
   Statistics.MaxTime:=0;
   Statistics.MinClicks:=50;
   Statistics.MaxBonus:=100;
   Statistics.LastTime:=0;
   Exit;
  end;
 Read(SaveFile, Statistics.Win);
 Read(SaveFile, Statistics.Lose);
 Read(SaveFile, Statistics.FirstBoom);
 Read(SaveFile, Statistics.MinTime);
 Read(SaveFile, Statistics.MaxTime);
 Read(SaveFile, Statistics.LastTime);
 Read(SaveFile, Statistics.MinClicks);
 Read(SaveFile, Statistics.MaxBonus);
 CloseFile(SaveFile);
end;

function LoadSkinFromDll(DllName:string):Boolean;
var DLL:Cardinal;
 S: array [0..255] of Char;
 Clr:string;
 Color:TColor;
 PNG:TPNGObject;
begin
 Dll:=LoadLibrary(PChar(Dllname));
 if DLL=0 then
  begin
   Result:=False;
   Exit;
  end;
 LoadString(DLL, 60000, S, 255);
 Clr:=StrPas(S);
 try
  Color:=StringToColor(Clr);
 except
  Color:=clWhite;
 end;
 FormMain.LabelFCount.Font.Color:=Color;
 FormMain.LabelTime.Font.Color:=Color;
 with Bitmaps do
  try
   Bomb.LoadFromResourceName(DLL, 'bomb');
   Close.LoadFromResourceName(DLL, 'close');
   Flag.LoadFromResourceName(DLL, 'Flag');
   Quest.LoadFromResourceName(DLL, 'quest');
   Empty.LoadFromResourceName(DLL, 'Empty');
   BackGround.LoadFromResourceName(DLL, 'bg');
   Win.LoadFromResourceName(DLL, 'win');
   Lose.LoadFromResourceName(DLL, 'lose');
   with FormMain do
    begin
     ImageBG.Picture.Bitmap:=Bitmaps.BackGround;
     ButtonClose.ImageNormal.LoadFromResourceName(DLL, 'close');
     ButtonHide.ImageNormal.LoadFromResourceName(DLL, 'hide');
     ButtonNew.ImageNormal.LoadFromResourceName(DLL, 'new');
     ButtonHelp.ImageNormal.LoadFromResourceName(DLL, 'help');
     ButtonAbout.ImageNormal.LoadFromResourceName(DLL, 'about');
     ButtonOption.ImageNormal.LoadFromResourceName(DLL, 'set');
     PNG:=TPNGObject.Create;
     PNG.LoadFromResourceName(DLL, 'time');
     ImageTime.Picture.Graphic:=PNG;
     PNG.LoadFromResourceName(DLL, 'bomb');
     ImageBombLeft.Picture.Graphic:=PNG;
     PNG.Free;
     DrawGridPoly.Repaint;
    end;
   FreeLibrary(DLL);
  except
   begin
    MessageBox(FormMain.Handle, 'Отсутствуют необходимые текстуры!'+#13+#10+'Программа будет закрыта.', '', MB_ICONSTOP or MB_OK);
    FreeLibrary(Dll);
    Application.Terminate;
   end;
  end;
 Result:=True;
end;

procedure TGame.Win;
var LT:Integer;
begin
 FormMain.TimerTime.Enabled:=False;
 GameState:=gsWin;
 Inc(Statistics.Win);
 Statistics.LastTime:=Game.Time;
 if Statistics.MinTime>Statistics.LastTime then Statistics.MinTime:=Statistics.LastTime;
 if Statistics.MaxTime<Statistics.LastTime then Statistics.MaxTime:=Statistics.LastTime;
 if Statistics.Clicks<Statistics.MinClicks then Statistics.MinClicks:=Statistics.Clicks;
 if Game.HelpEnable then Inc(Statistics.Bonus, 15) else Dec(Statistics.Bonus, 5);
 LT:=100-Statistics.LastTime;
 if LT<0 then LT:=0;
 Inc(Statistics.Bonus, LT);

 if Statistics.Bonus>Statistics.MaxBonus then Statistics.MaxBonus:=Statistics.Bonus;

 with FormMain do
  begin
   DrawGridPoly.Repaint;
   case FormResult.ShowModal of
    mrOk:  New;
    mrCancel: Game.Close;
   end;
  end;
end;

procedure TGame.Lose;
begin
 FormMain.TimerTime.Enabled:=False;
 Inc(Statistics.Lose);
 Statistics.LastTime:=Game.Time;
 if Statistics.Clicks=1 then Inc(Statistics.FirstBoom);
 if Game.HelpEnable then Inc(Statistics.Bonus, 15) else Dec(Statistics.Bonus, 5);
 GameState:=gsLose;
 with FormMain do
  begin
   DrawGridPoly.Repaint;
   case FormResult.ShowModal of
    mrOk: New;
    mrCancel: Game.Close;
   end;
  end;
end;

procedure TFormMain.WMNCHitTest (var M:TWMNCHitTest);
begin
 inherited;
 if (M.Result = htClient) and Need then M.Result := htCaption;
end;

procedure TGame.SetSize(Value:Byte);                                            //Установка размера поля
begin
 FormMain.DrawGridPoly.ColCount:=Value;
 FormMain.DrawGridPoly.RowCount:=Value;
 FormMain.DrawGridPoly.Width:=(FormMain.DrawGridPoly.DefaultColWidth*Value)+Value-1;
 FormMain.DrawGridPoly.Height:=(FormMain.DrawGridPoly.DefaultRowHeight*Value)+Value-1;
 GSize:=Value;
 case GameDif of
  gdEasy:BombCount:=Value div 2;
  gdNormal:BombCount:=Value;
  gdHard:BombCount:=Value*2;
  gdExpert:BombCount:=Value*3;
 end;
 ClearPoly;
 New;
end;

constructor TGame.Create;
begin
 GameDif:=gdNormal;
 inherited;
end;

constructor TBitmaps.Create;
begin
 Bomb:=TBitmap.Create;
 Flag:=TBitmap.Create;
 Close:=TBitmap.Create;
 Quest:=TBitmap.Create;
 Empty:=TBitmap.Create;
 BackGround:=TBitmap.Create;
 Win:=TPNGObject.Create;
 Lose:=TPNGObject.Create;
 BMP:=TBitmap.Create;
 BMP.Width:=24;
 BMP.Height:=24;
 inherited;
end;

procedure TGame.ClearPoly;                                                      //Очистить оба массива, или очистка поля
var i,j:Byte;
begin
 for i:=0 to GSize-1 do
  for j:=0 to GSize-1 do
   begin
    HArray[i,j]:=ctClose;
    SArray[i,j]:=ctEmpty;
   end;
end;

procedure TGame.FillBomb;                                                       //Заполнить показочный массив минами
var i,j:Byte;
begin
 for i:=0 to GSize-1 do
  for j:=0 to GSize-1 do
   if SArray[i,j]=ctBomb then HArray[i,j]:=ctBomb;
end;

function TGame.SetForOpen(C, R:Byte):Byte;
begin
 Result:=0;
 if SArray[C-1, R-1]=ctBomb then Inc(Result);
 if SArray[C-0, R-1]=ctBomb then Inc(Result);
 if SArray[C+1, R-1]=ctBomb then Inc(Result);
 if SArray[C-1, R+0]=ctBomb then Inc(Result);
 if SArray[C+1, R+0]=ctBomb then Inc(Result);
 if SArray[C-1, R+1]=ctBomb then Inc(Result);
 if SArray[C-0, R+1]=ctBomb then Inc(Result);
 if SArray[C+1, R+1]=ctBomb then Inc(Result);
end;

procedure TGame.OpenAll(C, R:Byte);
begin
 if HArray[C-1, R-1]=ctClose then DoClick(C-1, R-1);
 if HArray[C, R-1]=ctClose then DoClick(C, R-1);
 if HArray[C+1, R-1]=ctClose then DoClick(C+1, R-1);
 if HArray[C-1, R]=ctClose then DoClick(C-1, R);
 if HArray[C+1, R]=ctClose then DoClick(C+1, R);
 if HArray[C-1, R+1]=ctClose then DoClick(C-1, R+1);
 if HArray[C, R+1]=ctClose then  DoClick(C, R+1);
 if HArray[C+1, R+1]=ctClose then DoClick(C+1, R+1);
end;

function TGame.CheckForWin:Boolean;
var i,j, Count, F:Byte;
begin
 Count:=0;
 F:=0;
 for i:=0 to Game.Size-1 do
  for j:=0 to Game.Size-1 do
   begin
    if (HArray[i,j]=ctClose) or (HArray[i,j]=ctFlag) then Inc(Count);
    if HArray[i,j]=ctFlag then Inc(F);
   end;
 Result:=Count=BombCount;
 FCount:=F;
end;

procedure TGame.DoClick(C, R:Byte);

begin
 if SArray[C, R]=ctBomb then                                                    //Если выбранная клетка - бомба, то конец игры и показ всех бомб
  begin
   FillBomb;
   FormMain.DrawGridPoly.Repaint;
   Lose;
   Exit;
  end;

 HArray[C, R]:=SetForOpen(C, R);                                                //Установить значение от 0 до 8 в зависимости от кол-ва мин
 if HArray[C, R]=ctEmpty then OpenAll(C, R);                                    //Если значение 0, то открыть все находящиеся рядом, пустые клетки
 FormMain.DrawGridPoly.Repaint;
end;

procedure TFormMain.DrawGridPolyDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var Cell:Byte;
begin
 Cell:=HArray[ACol, ARow];
 case Cell of
  ctClose:Bitmaps.BMP.Canvas.Draw(0, 0, Bitmaps.Close);
  ctBomb :Bitmaps.BMP.Canvas.Draw(0, 0, Bitmaps.Bomb);
  ctOpen :Exit;
  ctFlag :Bitmaps.BMP.Canvas.Draw(0, 0, Bitmaps.Flag);
  ctQuest:Bitmaps.BMP.Canvas.Draw(0, 0, Bitmaps.Quest);
  ctEmpty:Bitmaps.BMP.Canvas.Draw(0, 0, Bitmaps.Empty);
 else
  Bitmaps.BMP.Canvas.Brush.Style:=bsClear;
  Bitmaps.BMP.Canvas.Font.Name:='Segoe UI';
  Bitmaps.BMP.Canvas.Font.Size:=13;
  Bitmaps.BMP.Canvas.Font.Style:=[fsBold];
  Bitmaps.BMP.Canvas.Draw(0, 0, Bitmaps.Empty);
  Bitmaps.BMP.Canvas.TextOut(6, 0, IntToStr(Cell));
 end;
 DrawGridPoly.Canvas.Draw(Rect.Left, Rect.Top, Bitmaps.BMP);
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
 Need:=True;
 Game:=TGame.Create;
 Bitmaps:=TBitmaps.Create;
 SaveStat:=TSaveStat.Create;

 Game.Size:=10;
 LoadSkinFromDll(Path+'Graphics\default.dll');
 SaveStat.LoadFrom(Path+'stat.dat');
end;

procedure TGame.New;
var i:Byte;
   C, R:Byte;
begin
 Time:=0;
 HelpEnable:=True;
 Statistics.Clicks:=0;
 Statistics.Bonus:=0;
 Randomize;
 ClearPoly;
 case GameDif of
  gdEasy:BombCount:=GSize div 2;
  gdNormal:BombCount:=GSize;
  gdHard:BombCount:=GSize*2;
  gdExpert:BombCount:=GSize*3;
 end;
 for i:=1 to BombCount do
  begin
   repeat
    C:=Random(GSize-1);
    R:=Random(GSize-1);
   until SArray[C, R] = ctEmpty;
   SArray[C, R]:=ctBomb;
  end;
 FormMain.LabelFCount.Caption:=IntToStr(Game.BombCount-FCount);
 FormMain.DrawGridPoly.Repaint;
 GameState:=gsGame;
 FormMain.TimerTime.Enabled:=True;
end;

procedure TFormMain.DrawGridPolyMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var C, R:Integer;
  Win:Boolean;
begin
 DrawGridPoly.MouseToCell(X, Y, C, R);
 if (Button=mbLeft) and not (HArray[C, R]=ctFlag) then
  begin
   Inc(Statistics.Clicks);
   Game.DoClick(C, R);
   Win:=Game.CheckForWin;
   LabelFCount.Caption:=IntToStr(Game.BombCount-FCount);
   if Win then
    begin
     Game.DoClick(C, R);
     Game.Win;
     Exit;
    end;
  end;
 if Button=mbRight then
  begin
   case HArray[C, R] of
    ctClose:
     begin
      if SArray[C, R]=ctBomb then Inc(Statistics.Bonus, 10)
      else Dec(Statistics.Bonus, 10);
      HArray[C, R]:=ctFlag;
     end;
    ctFlag:
     begin
      Dec(Statistics.Bonus, 10);
      HArray[C, R]:=ctQuest;
     end;
    ctQuest:HArray[C, R]:=ctClose;
   end;
   Game.CheckForWin;
   LabelFCount.Caption:=IntToStr(Game.BombCount-FCount);
   DrawGridPoly.Repaint;
  end;
end;

procedure TFormMain.DrawGridPolyMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
 Handled:=True;
end;

procedure TFormMain.DrawGridPolyMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
 Handled:=True;
end;

procedure TFormMain.ButtonCloseClick(Sender: TObject);
begin
 Application.Terminate;
end;

procedure TFormMain.ImageBGMouseEnter(Sender: TObject);
begin
 Need:=True;
end;

procedure TFormMain.ImageBGMouseLeave(Sender: TObject);
begin
 Need:=False;
end;

procedure TFormMain.ButtonHideClick(Sender: TObject);
begin
 Application.Minimize;
end;

procedure TFormMain.TimerTimeTimer(Sender: TObject);
begin
 Inc(Game.Time);
 LabelTime.Caption:=IntToStr(Game.Time);
end;

procedure TFormMain.ButtonNewClick(Sender: TObject);
begin
 if MessageBox(Handle, 'Вы уверены, что хотите начать новую игру?', '', MB_ICONWARNING or MB_YESNOCANCEL)=ID_YES
 then Game.New;
end;

procedure TFormMain.ButtonAboutClick(Sender: TObject);
begin
 FormHelp.ShowModal;
end;

procedure TFormMain.ButtonOptionClick(Sender: TObject);
begin
 FormSet.ShowModal;
end;

procedure TFormMain.ButtonCloseMouseEnter(Sender: TObject);
begin
 Need:=False;
end;

procedure TFormMain.ButtonCloseMouseExit(Sender: TObject);
begin
 Need:=True;
end;

procedure TGame.GetHelp;
var C,R:Byte;
 Count:Integer;
begin
 Count:=0;
 if Not HelpEnable then
  begin
   MessageBox(FormMain.Handle, 'Помощь использована!', 'Сообщение', MB_ICONWARNING or MB_OK);
   Exit;
  end;
 repeat
  C:=Random(GSize);
  R:=Random(GSize);
  Inc(Count);
  if Count=1000000 then
   begin
    MessageBox(FormMain.Handle, 'Неудача!', 'Сообщение', MB_ICONWARNING or MB_OK);
    Exit;
   end;
 until (SArray[C, R]=ctEmpty) and (HArray[C, R]=ctClose);
 DoClick(C, R);
 HelpEnable:=False;
end;

procedure TFormMain.ButtonHelpClick(Sender: TObject);
begin
 Game.GetHelp;
end;

initialization
   Path:=ExtractFilePath(ParamStr(0));

end.
