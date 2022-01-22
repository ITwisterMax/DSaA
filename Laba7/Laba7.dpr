program Laba7;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {GraphForm},
  Vcl.Themes,
  Vcl.Styles,
  HelpUnit in 'HelpUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Carbon');
  Application.CreateForm(TGraphForm, GraphForm);
  Application.Run;
end.
