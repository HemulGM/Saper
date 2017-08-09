unit UResult;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, pngimage, ExtCtrls;

type
  TFormResult = class(TForm)
    ImageWin: TImage;
    ButtonNew: TButton;
    ButtonQuit: TButton;
    Bevel1: TBevel;
    LabelTime: TLabel;
    LabelCTime: TLabel;
    ButtonStatistics: TButton;
    ListBoxStatistics: TListBox;
    procedure FormShow(Sender: TObject);
    procedure ButtonStatisticsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormResult: TFormResult;
  Stat:Boolean;

implementation

{$R *.dfm}
 uses Main;

procedure TFormResult.FormShow(Sender: TObject);
begin
 case Game.GameState of
  gsGame:Application.Terminate;
  gsWin: ImageWin.Picture.Graphic:=Bitmaps.Win;
  gsLose: ImageWin.Picture.Graphic:=Bitmaps.Lose;
 end;
 LabelCTime.Caption:=IntToStr(Game.Time)+' сек.';
 ListBoxStatistics.Clear;
 ListBoxStatistics.Items.Add('Ваш счет: '+IntToStr(Statistics.Bonus));
 ListBoxStatistics.Items.Add('Время игры: '+IntToStr(Statistics.LastTime)+' сек.');
 ListBoxStatistics.Items.Add('Кол-во ходов: '+IntToStr(Statistics.Clicks));
 ListBoxStatistics.Items.Add('');
 ListBoxStatistics.Items.Add('Общая статистика');
 ListBoxStatistics.Items.Add('Минимальное время: '+IntToStr(Statistics.MinTime)+' сек.');
 ListBoxStatistics.Items.Add('Максимальное время: '+IntToStr(Statistics.MaxTime)+' сек.');
 ListBoxStatistics.Items.Add('Побед: '+IntToStr(Statistics.Win));
 ListBoxStatistics.Items.Add('Неудач: '+IntToStr(Statistics.Lose));
 ListBoxStatistics.Items.Add('Неудач, не считая неудачных начал: '+IntToStr(Statistics.Lose-Statistics.FirstBoom));
 ListBoxStatistics.Items.Add('Неудачное начало: '+IntToStr(Statistics.FirstBoom));
 ListBoxStatistics.Items.Add('Минимальное кол-во ходов: '+IntToStr(Statistics.MinClicks));
 ListBoxStatistics.Items.Add('Максимальное кол-во очков: '+IntToStr(Statistics.MaxBonus));
end;

procedure TFormResult.ButtonStatisticsClick(Sender: TObject);
begin
 if Stat then ClientHeight:=160 else ClientHeight:=300;
 Stat:=not Stat;
end;

procedure TFormResult.FormCreate(Sender: TObject);
begin
 Stat:=False;
end;

end.
