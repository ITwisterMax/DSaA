unit Computer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Samples.Spin, Vcl.MPlayer;

type
  TMainForm = class(TForm)
    Generate_: TButton;
    Find_: TButton;
    Load_: TButton;
    Save_: TButton;
    Draw_: TButton;
    MazeX: TSpinEdit;
    MazeY: TSpinEdit;
    TextX: TLabel;
    TextY: TLabel;
    ScrollBox1: TScrollBox;
    BackBuffer: TImage;
    Exit_: TButton;
    HelpVoice2_: TMediaPlayer;
    procedure Generate_Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Find_Click(Sender: TObject);
    procedure Save_Click(Sender: TObject);
    procedure Load_Click(Sender: TObject);
    procedure Draw_Click(Sender: TObject);
    procedure Exit_Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
  Location = record
    left_wall, up_wall : Boolean;
  end;

  Maze = array of array of Location;

var
  MainForm : TMainForm;
  Laberint : Maze;
  CellSize : Byte = 24;

implementation

{$R *.dfm}

procedure LoadMaze(var TheMaze : Maze; Name : string);
var
  f : TextFile;
  Height, Width : Integer;
  x,y : Integer;
  lw,uw : Integer;

begin
  //������� ���� ��� ������
  AssignFile(f, '�lassified.txt');
  Reset(f);

  //���������� � ���������� ������� ���������
  ReadLn(f, Width, Height);
  SetLength(TheMaze, Width + 1, Height + 1);

  //���� �� ���������
  for y := 0 to Height do
    for x := 0 to Width do
      if (y = Height) or (x = Width) then
        begin
          //���� ������� - ���������, �� ��� ����� ����������
          TheMaze[x, y].left_wall := true;
          TheMaze[x, y].up_wall := true;
	      end
      else
        begin
          //������ ������ �� ����� � ���������� � ���� Boolean
          ReadLn(f, uw, lw);
          TheMaze[x, y].left_wall := Boolean(lw);
          TheMaze[x, y].up_wall := Boolean(uw);
        end;

  //������� ����
  CloseFile(f);
end;

procedure SaveMaze(TheMaze : Maze; Name : string);
var
  f : TextFile;
  Height, Width	: Integer;
  x, y	: Integer;

begin
  //������� ���� ��� ������
	AssignFile(f, '�lassified.txt');
  Rewrite(f);

  //���������� � ���������� ������� ���������
	Height := High(TheMaze[0]);
	Width := High(TheMaze);
	WriteLn(f, Width, ' ', Height);

  //������ ������ � ��������
  for	y := 0 to Height - 1 do
    for	x := 0 to Width - 1 do
	    WriteLn(f, Integer(TheMaze[x, y].up_wall), ' ',
	Integer(TheMaze[x, y].left_wall));

  //������� ����
  CloseFile(f);
end;

function WaveTracingSolve(TheMaze : Maze; xs, ys, xf, yf : Integer) : Boolean;

var
  //����� �������
  Mark : array of array of Integer;
  x, y, xc, yc : Integer;
  N, i : Integer;
  Height, Width : Integer;

const
  //��������
  dx : array[1..4] of Integer = (1, 0, -1, 0);
  dy : array[1..4] of Integer = (0, -1, 0, 1);

function CanGo(x, y, dx, dy : Integer) : Boolean;
begin
  //�������� �� �����
  if dx = -1 then CanGo := not TheMaze[x, y].left_wall
  else
    if dx = 1 then CanGo := not TheMaze[x + 1, y].left_wall
    else
      if dy = -1 then CanGo := not TheMaze[x, y].up_wall
      else CanGo := not TheMaze[x, y + 1].up_wall;
end;

function Solve : Boolean;
var
  i, N, x, y : Integer;
  NoSolution : Boolean;

begin
  //�������� � 1
  N := 1;

  repeat
    //��������, ��� ������� ���
    NoSolution := true;
    for x := 0 to Width - 1 do
      for y := 0 to Height - 1 do
        //���� ������� N
        if Mark[x, y] = N then
    //��������� ��������
    for i := 1 to 4 do
      if CanGo(x, y, dx[i], dy[i]) and (Mark[x + dx[i], y + dy[i]] = 0) then
        begin
          //������� �������� � �������� 0
          NoSolution := false;
          //������������, ��� ���� ���� � �������� ��� N + 1
          Mark[x + dx[i], y + dy[i]] := N + 1;
          if (x + dx[i] = xf) and (y + dy[i] = yf) then
            begin
              //���� �����, �� �����
              Solve := true;
              Exit;
            end;
        end;

    //����������� N
    N := N + 1;
  until NoSolution;

  //������� �� �������
  Solve := false;
end;

begin
  result := false;
  Width := High(TheMaze);
  Height := High(TheMaze[0]);
  //��������� ������ ��� �����
  SetLength(Mark, Width, Height);

  //��������� ����� ������
  for x := 0 to Width - 1 do
    for y := 0 to Height - 1 do
      Mark[x, y] := 0;

  //��������� �������
  Mark[xs, ys] := 1;
  //���� ������� �������
  if Solve then
    begin
      result := true;
      x := xf;
      y := yf;
      MainForm.BackBuffer.Canvas.brush.Color := clred;
      for N := Mark[xf, yf] downto 1 do
        begin
          //������ ����������
          xc := CellSize * (2 * x + 1) div 2;
          yc := CellSize * (2 * y + 1) div 2;
          MainForm.BackBuffer.Canvas.Ellipse(xc - 5, yc - 5, xc + 5, yc + 5);

          for i := 1 to 4 do
            if CanGo(x, y, dx[i], dy[i]) and (Mark[x + dx[i], y + dy[i]] = N - 1) then
              begin
                //���� ��������� �������
                x := x + dx[i];
                y := y + dy[i];
                Break;
              end;
        end;
      MainForm.BackBuffer.Canvas.brush.Color := clwhite;
    end
  else ShowMessage('����� �� ���������!');
end;

procedure ShowMaze(TheMaze : Maze);

var
  x, y : Integer;
  Height, Width : Integer;

begin
  //���������� ������� ���������
  Width := High(TheMaze);
  Height := High(TheMaze[0]);

  MainForm.MazeX.text := IntToStr(Width);
  MainForm.MazeY.text := IntToStr(Height);

  MainForm.BackBuffer.Width := (StrToInt(MainForm.MazeX.text) + 1) * CellSize;
  MainForm.BackBuffer.Height := (StrToInt(MainForm.MazeY.text) + 1) * CellSize;

  MainForm.BackBuffer.Picture.Bitmap.Width := MainForm.BackBuffer.Width;
  MainForm.BackBuffer.Picture.Bitmap.Height := MainForm.BackBuffer.Height;

  with MainForm.BackBuffer.Canvas do
    begin
      //������ �����
      FillRect(Rect(0, 0, MainForm.BackBuffer.Width, MainForm.BackBuffer.Height));
      for x := 0 to Width - 1 do
        for y := 0 to Height - 1 do
          begin
            //���� ���� ������� �����, �� ������ ��
            if TheMaze[x, y].up_wall then
              begin
                MoveTo(x * CellSize, y * CellSize);
                LineTo((x + 1) * CellSize, y * CellSize);
              end;
            //���� ���� ����� �����, �� ������ ��
            if (x <> 0) or ((x = 0) and (y <> 0))  then
              if TheMaze[x, y].left_wall then
                begin
                  MoveTo(x * CellSize, y * CellSize);
                  LineTo(x * CellSize, (y + 1) * CellSize);
                end;
          end;

      //������ ����� �����
      MoveTo(0, Height * CellSize);
      //������ ����� ������
      LineTo(Width * CellSize, (Height) * CellSize);
      MoveTo(Width * CellSize,  (Height - 1) * CellSize);
      LineTo(Width * CellSize, 0);
    end;
end;

function PrimGenerateMaze(Width, Height : Integer) : Maze;

type
  //��� "������� �������"
  AttrType = (Inside, Outside, Border);

var
  //��������
  TheMaze : Maze;
  x, y, i : Integer;
  xc, yc : Integer;
  xloc, yloc : Integer;
  //����� ���������
  Attribute : array of array of AttrType;
  IsEnd : Boolean;
  counter : Integer;

const
  //��������
  dx : array[1..4] of Integer = (1, 0, -1, 0);
  dy : array[1..4] of Integer = (0, -1, 0, 1);

label
  //�����
  ExitFor1,
  ExitFor2,
  ExitFor3;

//���������� ����� ����� ���������
procedure BreakWall(x, y, dx, dy : Integer);
  begin
      if dx = -1 then TheMaze[x, y].left_wall := false
      else
        if dx = 1 then TheMaze[x + 1, y].left_wall := false
        else
          if dy = -1 then TheMaze[x, y].up_wall := false
          else TheMaze[x, y + 1].up_wall := false;
  end;

begin
  //��������� ������ ��� ���������
  SetLength(Attribute, Width, Height);
  //�������� ������ ���������
  SetLength(TheMaze, Width + 1, Height + 1);

  //���������� ��� �������� - Outside
  for x := 0 to Width - 1 do
    for y := 0 to Height - 1 do
      Attribute[x, y] := Outside;

  //���������� ��� ����� ����������
  for y := 0 to Height do
    for x := 0 to Width do
      begin
        TheMaze[x, y].left_wall := true;
        TheMaze[x, y].up_wall := true;
      end;

  Randomize;
  //����� ��������� �������
  x := Random(Width);
  y := Random(Height);
  //����������� ������� - Inside
  Attribute[x, y] := Inside;

  //���� ������� ����������� ������� - Border
  for i := 1 to 4 do
    begin
      xc := x + dx[i];
      yc := y + dy[i];
      if (xc >= 0) and (yc >= 0) and (xc < Width) and (yc < Height) then
        Attribute[xc, yc] := Border;
    end;

  //������� ����
  repeat
    IsEnd := true;
    counter := 0;
    //������������ ���������� ��������� - Border
    for x := 0 to Width - 1 do
      for y := 0 to Height - 1 do
        if Attribute[x, y] = Border then counter := counter + 1;

    //�������� �� ��� ���������
    counter := Random(counter) + 1;
    for x := 0 to Width - 1 do
      for y := 0 to Height - 1 do
        if Attribute[x, y] = Border then
          begin
            counter := counter - 1;
            if counter = 0 then
              begin
                xloc := x;
                yloc := y;
                goto ExitFor1;
              end;
          end;

    ExitFor1:
    //��������� ������� - Inside
    Attribute[xloc, yloc] := Inside;
    counter := 0;
    for i := 1 to 4 do
      begin
        xc := xloc + dx[i];
        yc := yloc + dy[i];
        if (xc >= 0) and (yc >= 0) and (xc < Width) and (yc < Height) then
          begin
            //������������ ���������� ��������� - Inside
            if Attribute[xc, yc] = Inside then counter := counter + 1;
            //������ �������� � Inside �� Border
            if Attribute[xc, yc] = Outside then
              Attribute[xc, yc] := Border;
          end;
      end;

      //������� ��������� Inside-�������
      counter := Random(counter) + 1;
      for i := 1 to 4 do
        begin
          xc := xloc + dx[i];
          yc := yloc + dy[i];
          if (xc >= 0) and (yc >= 0) and (xc < Width)
          and (yc < Height) and (Attribute[xc, yc] = Inside)then
            begin
              counter := counter - 1;
              if counter = 0 then
                begin
                  //���������� ����� ����� ���������
                  BreakWall(xloc, yloc, dx[i], dy[i]);
                  goto ExitFor2;
                end;
            end;
        end;

    ExitFor2:
    //�������� �� ������� �������� - Border
    for x := 0 to Width - 1 do
      for y := 0 to Height - 1 do
        if Attribute[x, y] = Border then
          begin
            IsEnd := false;
            goto ExitFor3;
          end;

    ExitFor3:

    //���������� ������� ���������
    ShowMaze(TheMaze);
    Application.ProcessMessages;

  until IsEnd;

  PrimGenerateMaze := TheMaze;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  //��������� ������
  ScrollBox1.SetFocus;
  //��������� �������� ���������
  MazeX.Text := '26';
  MazeY.Text := '22';
  //�������� ���������
  Laberint := PrimGenerateMaze(StrToInt(MazeX.text), StrToInt(MazeY.text));
  //����������� ���������
  ShowMaze(Laberint);
  //������ �������
  HelpVoice2_.Open;
  HelpVoice2_.Play;
end;

procedure TMainForm.Generate_Click(Sender: TObject);
begin
  //�������� ���������
  Laberint := PrimGenerateMaze(StrToInt(MazeX.text), StrToInt(MazeY.text));
  //����������� ���������
  ShowMaze(Laberint);
end;

procedure TMainForm.Find_Click(Sender: TObject);
begin
  //����� ����
  WaveTracingSolve(Laberint, 0, 0, StrToInt(MazeX.text) - 1, StrToInt(MazeY.text) - 1);
end;

procedure TMainForm.Load_Click(Sender: TObject);
begin
  //�������� �� �����
  LoadMaze(Laberint, '�lassified.txt');
end;

procedure TMainForm.Save_Click(Sender: TObject);
begin
  //���������� � ����
  SaveMaze(Laberint, '�lassified.txt');
end;

procedure TMainForm.Draw_Click(Sender: TObject);
begin
  //����������� ���������
  ShowMaze(Laberint);
end;

procedure TMainForm.Exit_Click(Sender: TObject);
begin
  //��������� �������
  HelpVoice2_.Close;
  //�������� �����
  MainForm.Close;
end;

end.
