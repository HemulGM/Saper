unit About;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, pngimage, ExtCtrls;

type
  TFormHelp = class(TForm)
    ImageSaper: TImage;
    LabelAbout: TLabel;
    ScrollBoxHelp: TScrollBox;
    LabelP: TLabel;
    LabelP1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormHelp: TFormHelp;

implementation

{$R *.dfm}

end.
