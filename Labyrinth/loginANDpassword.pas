unit loginANDpassword;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Vcl.MPlayer;

type
  TLogIn = class(TForm)
    Exit_: TButton;
    Photo_: TImage;
    Password_: TEdit;
    Login_: TEdit;
    HelpVoice1_: TMediaPlayer;
    procedure Exit_Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Password_Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LogIn: TLogIn;

implementation

{$R *.dfm}

uses Computer;

procedure TLogIn.FormShow(Sender: TObject);
begin
  //?????????? ?????
  Password_.SetFocus;
  //?????? ???????
  HelpVoice1_.Play;
end;

procedure TLogIn.Password_Change(Sender: TObject);
begin
  //???????? ??????
  if Password_.Text = '7788' then
    begin
      //????????? ???????
      HelpVoice1_.Close;
      //???????? ??????????
      Computer.MainForm.ShowModal;
      //????????? ?????? ??????
      Password_.Text := '';
    end;
end;

procedure TLogIn.Exit_Click(Sender: TObject);
begin
  //???????? ?????
  LogIn.Close;
end;

end.
