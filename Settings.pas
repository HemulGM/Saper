unit Settings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFormSet = class(TForm)
    RadioGroupDif: TRadioGroup;
    ButtonApply: TButton;
    ButtonClose: TButton;
    ListBoxGraphics: TListBox;
    LabelGraphics: TLabel;
    procedure ButtonApplyClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
    procedure ListBoxGraphicsDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSet: TFormSet;
  LastDif:Byte;
  MF:array[0..50] of String;

implementation

{$R *.dfm}
 uses Main;

procedure FillDll;
var FS:TSearchRec;
   Count:Byte;
begin
 Count:=0;
 FormSet.ListBoxGraphics.Clear;
 if FindFirst(Path+'Graphics\*.dll', faAnyFile, FS) = 0 then
  begin
   FormSet.ListBoxGraphics.Items.Add(FS.Name);
   MF[Count]:=Path+'Graphics\'+FS.Name;
   while FindNext(FS) = 0 do
    begin
     Inc(Count);
     if Count=50 then Break;
     FormSet.ListBoxGraphics.Items.Add(FS.Name);
     MF[Count]:=Path+'Graphics\'+FS.Name;
    end;
   FindClose(FS);
  end;
end;

procedure TFormSet.ButtonApplyClick(Sender: TObject);
begin
 if LastDif<>RadioGroupDif.ItemIndex then
  begin
   if MessageBox(Handle, 'Начать новую игру?', '', MB_ICONWARNING or MB_YESNO)=ID_YES
   then
    begin
     Game.GameDif:=TGameDificulty(RadioGroupDif.ItemIndex);
     Game.New;
     Close;
    end
   else Exit;
  end;
end;

procedure TFormSet.FormShow(Sender: TObject);
begin
 RadioGroupDif.ItemIndex:=Ord(Game.GameDif);
 LastDif:=RadioGroupDif.ItemIndex;
 FillDll;
end;

procedure TFormSet.ButtonCloseClick(Sender: TObject);
begin
 Close;
end;

procedure TFormSet.ListBoxGraphicsDblClick(Sender: TObject);
begin
 LoadSkinFromDll(MF[ListBoxGraphics.ItemIndex]);
end;

end.
