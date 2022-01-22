program Escape;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  loginANDpassword in 'loginANDpassword.pas' {LogIn},
  Computer in 'Computer.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Emerald Light Slate');
  Application.CreateForm(TLogIn, LogIn);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
