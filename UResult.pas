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
 LabelCTime.Caption:=IntToStr(Game.Time)+' ���.';
 ListBoxStatistics.Clear;
 ListBoxStatistics.Items.Add('��� ����: '+IntToStr(Statistics.Bonus));
 ListBoxStatistics.Items.Add('����� ����: '+IntToStr(Statistics.LastTime)+' ���.');
 ListBoxStatistics.Items.Add('���-�� �����: '+IntToStr(Statistics.Clicks));
 ListBoxStatistics.Items.Add('');
 ListBoxStatistics.Items.Add('����� ����������');
 ListBoxStatistics.Items.Add('����������� �����: '+IntToStr(Statistics.MinTime)+' ���.');
 ListBoxStatistics.Items.Add('������������ �����: '+IntToStr(Statistics.MaxTime)+' ���.');
 ListBoxStatistics.Items.Add('�����: '+IntToStr(Statistics.Win));
 ListBoxStatistics.Items.Add('������: '+IntToStr(Statistics.Lose));
 ListBoxStatistics.Items.Add('������, �� ������ ��������� �����: '+IntToStr(Statistics.Lose-Statistics.FirstBoom));
 ListBoxStatistics.Items.Add('��������� ������: '+IntToStr(Statistics.FirstBoom));
 ListBoxStatistics.Items.Add('����������� ���-�� �����: '+IntToStr(Statistics.MinClicks));
 ListBoxStatistics.Items.Add('������������ ���-�� �����: '+IntToStr(Statistics.MaxBonus));
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
