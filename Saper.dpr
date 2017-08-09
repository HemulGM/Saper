program Saper;

uses
  Forms,
  Main in 'Main.pas' {FormMain},
  Settings in 'Settings.pas' {FormSet},
  UResult in 'UResult.pas' {FormResult},
  About in 'About.pas' {FormHelp};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Сапер';
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormSet, FormSet);
  Application.CreateForm(TFormResult, FormResult);
  Application.CreateForm(TFormHelp, FormHelp);
  Application.Run;
end.
