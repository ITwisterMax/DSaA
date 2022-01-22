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
  //Установить фокус
  Password_.SetFocus;
  //Запуск озвучки
  HelpVoice1_.Play;
end;

procedure TLogIn.Password_Change(Sender: TObject);
begin
  //Проверка пароля
  if Password_.Text = '7788' then
    begin
      //Остановка озвучки
      HelpVoice1_.Close;
      //Передача управления
      Computer.MainForm.ShowModal;
      //Обнуление строки пароля
      Password_.Text := '';
    end;
end;

procedure TLogIn.Exit_Click(Sender: TObject);
begin
  //Закрытие формы
  LogIn.Close;
end;

end.
