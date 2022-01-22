program Laba6;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {TreeForm},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Carbon');
  Application.CreateForm(TTreeForm, TreeForm);
  Application.Run;
end.
