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
  //Открыть файл для чтения
  AssignFile(f, 'Сlassified.txt');
  Reset(f);

  //Определяем и записываем размеры лабиринта
  ReadLn(f, Width, Height);
  SetLength(TheMaze, Width + 1, Height + 1);

  //Идем по лабиринту
  for y := 0 to Height do
    for x := 0 to Width do
      if (y = Height) or (x = Width) then
        begin
          //Если локация - служебная, то обе стены существуют
          TheMaze[x, y].left_wall := true;
          TheMaze[x, y].up_wall := true;
	      end
      else
        begin
          //Чтение данных из файла и приведение к типу Boolean
          ReadLn(f, uw, lw);
          TheMaze[x, y].left_wall := Boolean(lw);
          TheMaze[x, y].up_wall := Boolean(uw);
        end;

  //Закрыть файл
  CloseFile(f);
end;

procedure SaveMaze(TheMaze : Maze; Name : string);
var
  f : TextFile;
  Height, Width	: Integer;
  x, y	: Integer;

begin
  //Открыть файл для записи
	AssignFile(f, 'Сlassified.txt');
  Rewrite(f);

  //Определяем и записываем размеры лабиринта
	Height := High(TheMaze[0]);
	Width := High(TheMaze);
	WriteLn(f, Width, ' ', Height);

  //Запись данных о локациях
  for	y := 0 to Height - 1 do
    for	x := 0 to Width - 1 do
	    WriteLn(f, Integer(TheMaze[x, y].up_wall), ' ',
	Integer(TheMaze[x, y].left_wall));

  //Закрыть файл
  CloseFile(f);
end;

function WaveTracingSolve(TheMaze : Maze; xs, ys, xf, yf : Integer) : Boolean;

var
  //Метки локаций
  Mark : array of array of Integer;
  x, y, xc, yc : Integer;
  N, i : Integer;
  Height, Width : Integer;

const
  //Смещения
  dx : array[1..4] of Integer = (1, 0, -1, 0);
  dy : array[1..4] of Integer = (0, -1, 0, 1);

function CanGo(x, y, dx, dy : Integer) : Boolean;
begin
  //Проверка на стену
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
  //Начинаем с 1
  N := 1;

  repeat
    //Полагаем, что решений нет
    NoSolution := true;
    for x := 0 to Width - 1 do
      for y := 0 to Height - 1 do
        //Ишем локацию N
        if Mark[x, y] = N then
    //Проверяем соседние
    for i := 1 to 4 do
      if CanGo(x, y, dx[i], dy[i]) and (Mark[x + dx[i], y + dy[i]] = 0) then
        begin
          //Локация доступна и помечена 0
          NoSolution := false;
          //Предполагаем, что шанс есть и помечаем как N + 1
          Mark[x + dx[i], y + dy[i]] := N + 1;
          if (x + dx[i] = xf) and (y + dy[i] = yf) then
            begin
              //Если дошли, то конец
              Solve := true;
              Exit;
            end;
        end;

    //Увеличиваем N
    N := N + 1;
  until NoSolution;

  //Решение не найдено
  Solve := false;
end;

begin
  result := false;
  Width := High(TheMaze);
  Height := High(TheMaze[0]);
  //Выделение памяти для меток
  SetLength(Mark, Width, Height);

  //Заполняем метки нулями
  for x := 0 to Width - 1 do
    for y := 0 to Height - 1 do
      Mark[x, y] := 0;

  //Стартовая локация
  Mark[xs, ys] := 1;
  //Если решение найдено
  if Solve then
    begin
      result := true;
      x := xf;
      y := yf;
      MainForm.BackBuffer.Canvas.brush.Color := clred;
      for N := Mark[xf, yf] downto 1 do
        begin
          //Рисуем окружность
          xc := CellSize * (2 * x + 1) div 2;
          yc := CellSize * (2 * y + 1) div 2;
          MainForm.BackBuffer.Canvas.Ellipse(xc - 5, yc - 5, xc + 5, yc + 5);

          for i := 1 to 4 do
            if CanGo(x, y, dx[i], dy[i]) and (Mark[x + dx[i], y + dy[i]] = N - 1) then
              begin
                //Ищем следующую локацию
                x := x + dx[i];
                y := y + dy[i];
                Break;
              end;
        end;
      MainForm.BackBuffer.Canvas.brush.Color := clwhite;
    end
  else ShowMessage('Выход не обнаружен!');
end;

procedure ShowMaze(TheMaze : Maze);

var
  x, y : Integer;
  Height, Width : Integer;

begin
  //Определяем размеры лабиринта
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
      //Чистим буфер
      FillRect(Rect(0, 0, MainForm.BackBuffer.Width, MainForm.BackBuffer.Height));
      for x := 0 to Width - 1 do
        for y := 0 to Height - 1 do
          begin
            //Если есть верхняя стена, то рисуем ее
            if TheMaze[x, y].up_wall then
              begin
                MoveTo(x * CellSize, y * CellSize);
                LineTo((x + 1) * CellSize, y * CellSize);
              end;
            //Если есть левая стена, то рисуем ее
            if (x <> 0) or ((x = 0) and (y <> 0))  then
              if TheMaze[x, y].left_wall then
                begin
                  MoveTo(x * CellSize, y * CellSize);
                  LineTo(x * CellSize, (y + 1) * CellSize);
                end;
          end;

      //Рисуем стену снизу
      MoveTo(0, Height * CellSize);
      //Рисуем стену справа
      LineTo(Width * CellSize, (Height) * CellSize);
      MoveTo(Width * CellSize,  (Height - 1) * CellSize);
      LineTo(Width * CellSize, 0);
    end;
end;

function PrimGenerateMaze(Width, Height : Integer) : Maze;

type
  //Тип "атрибут локации"
  AttrType = (Inside, Outside, Border);

var
  //Лабиринт
  TheMaze : Maze;
  x, y, i : Integer;
  xc, yc : Integer;
  xloc, yloc : Integer;
  //Карта атрибутов
  Attribute : array of array of AttrType;
  IsEnd : Boolean;
  counter : Integer;

const
  //Смещения
  dx : array[1..4] of Integer = (1, 0, -1, 0);
  dy : array[1..4] of Integer = (0, -1, 0, 1);

label
  //Метки
  ExitFor1,
  ExitFor2,
  ExitFor3;

//Разрушение стены между локациями
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
  //Выделение памяти для атрибутов
  SetLength(Attribute, Width, Height);
  //Измерить размер лабиринта
  SetLength(TheMaze, Width + 1, Height + 1);

  //Изначально все атрибуты - Outside
  for x := 0 to Width - 1 do
    for y := 0 to Height - 1 do
      Attribute[x, y] := Outside;

  //Изначально все стены существуют
  for y := 0 to Height do
    for x := 0 to Width do
      begin
        TheMaze[x, y].left_wall := true;
        TheMaze[x, y].up_wall := true;
      end;

  Randomize;
  //Выбор начальной локации
  x := Random(Width);
  y := Random(Height);
  //Присваиваем атрибут - Inside
  Attribute[x, y] := Inside;

  //Всем соседям присваиваем атрибут - Border
  for i := 1 to 4 do
    begin
      xc := x + dx[i];
      yc := y + dy[i];
      if (xc >= 0) and (yc >= 0) and (xc < Width) and (yc < Height) then
        Attribute[xc, yc] := Border;
    end;

  //Главный цикл
  repeat
    IsEnd := true;
    counter := 0;
    //Подсчитываем количество атрибутов - Border
    for x := 0 to Width - 1 do
      for y := 0 to Height - 1 do
        if Attribute[x, y] = Border then counter := counter + 1;

    //Выбираем из них рандомный
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
    //Присвоить атрибут - Inside
    Attribute[xloc, yloc] := Inside;
    counter := 0;
    for i := 1 to 4 do
      begin
        xc := xloc + dx[i];
        yc := yloc + dy[i];
        if (xc >= 0) and (yc >= 0) and (xc < Width) and (yc < Height) then
          begin
            //Подсчитываем количество атрибутов - Inside
            if Attribute[xc, yc] = Inside then counter := counter + 1;
            //Замена атрибута с Inside на Border
            if Attribute[xc, yc] = Outside then
              Attribute[xc, yc] := Border;
          end;
      end;

      //Выбрать случайную Inside-локацию
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
                  //Разрушение стены между локациями
                  BreakWall(xloc, yloc, dx[i], dy[i]);
                  goto ExitFor2;
                end;
            end;
        end;

    ExitFor2:
    //Проверка на наличие атрибута - Border
    for x := 0 to Width - 1 do
      for y := 0 to Height - 1 do
        if Attribute[x, y] = Border then
          begin
            IsEnd := false;
            goto ExitFor3;
          end;

    ExitFor3:

    //Отобразить процесс генерации
    ShowMaze(TheMaze);
    Application.ProcessMessages;

  until IsEnd;

  PrimGenerateMaze := TheMaze;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  //Установка фокуса
  ScrollBox1.SetFocus;
  //Установка размеров лабиринта
  MazeX.Text := '26';
  MazeY.Text := '22';
  //Создание лабиринта
  Laberint := PrimGenerateMaze(StrToInt(MazeX.text), StrToInt(MazeY.text));
  //Отображение лабиринта
  ShowMaze(Laberint);
  //Запуск озвучки
  HelpVoice2_.Open;
  HelpVoice2_.Play;
end;

procedure TMainForm.Generate_Click(Sender: TObject);
begin
  //Создание лабиринта
  Laberint := PrimGenerateMaze(StrToInt(MazeX.text), StrToInt(MazeY.text));
  //Отображение лабиринта
  ShowMaze(Laberint);
end;

procedure TMainForm.Find_Click(Sender: TObject);
begin
  //Поиск пути
  WaveTracingSolve(Laberint, 0, 0, StrToInt(MazeX.text) - 1, StrToInt(MazeY.text) - 1);
end;

procedure TMainForm.Load_Click(Sender: TObject);
begin
  //Загрузка из файла
  LoadMaze(Laberint, 'Сlassified.txt');
end;

procedure TMainForm.Save_Click(Sender: TObject);
begin
  //Сохранение в файл
  SaveMaze(Laberint, 'Сlassified.txt');
end;

procedure TMainForm.Draw_Click(Sender: TObject);
begin
  //Отображение лабиринта
  ShowMaze(Laberint);
end;

procedure TMainForm.Exit_Click(Sender: TObject);
begin
  //Остановка озвучки
  HelpVoice2_.Close;
  //Закрытие формы
  MainForm.Close;
end;

end.
