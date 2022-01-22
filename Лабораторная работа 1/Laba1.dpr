program laba1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

const
  N_MIN = 1;
  N_MAX = 64;

type
  TPMan = ^TRMan;
  //Информация о игроке
  TRInfoMan = record
    Number : integer;
  end;
  //Элемент списка
  TRMan = record
    info : TRInfoMan;
    adr  : TPMan;
  end;

  //Массив для сохранения порядка удаления игроков
  TOrderArray = array [0..N_MAX] of integer;

var
  ListMan : TPMan;
  N, K, i : integer;
  OrderDelete : TOrderArray;

//Создание списка
procedure CreateList(var ListMan : TPMan);
begin
  New(ListMan);
  ListMan^.adr := nil;
  ListMan^.info.Number := 0;
end;

//Ввод данных
procedure InputData(var K : integer);
begin
  repeat
    write('Введите номер удаляемых игроков K: ');
    readln(K);
    if (K < 0) or (K > 64) then writeln('Ошибка! Повторите ввод..');
  until (K > 0) and (K < 65);
end;

//Наполнение списка ребятами
procedure AddToList(var ListMan : TPMan; const N : integer);
var
  i : integer;
  CurrListMan : TPMan;

begin
  CurrListMan := ListMan;
  for i := 1 to N do
    begin
      New(CurrListMan^.adr);
      CurrListMan := CurrListMan^.adr;
      CurrListMan^.info.Number := i;
      CurrListMan^.adr := ListMan^.adr;
      inc(ListMan^.info.Number);
    end;
end;

//Поиск последнего элемента в списке
function FindListEnd(ListMan : TPMan) : TPMan;
var
  CurrListMan : TPMan;

begin
  CurrListMan := ListMan^.adr;
  while CurrListMan^.adr <> ListMan^.adr do
    CurrListMan := CurrListMan^.adr;
  Result := CurrListMan;
end;

//Удаление элемента из списка
procedure DeleteListManItem(var ListMan, ListManItem : TPMan);
var
  CurrListMan : TPMan;

begin
  if ListMan = ListManItem then
    ListManItem := FindListEnd(ListMan);

  CurrListMan := ListManItem^.adr;
  if CurrListMan = ListMan^.adr then
    ListMan^.adr := CurrListMan^.adr;
  ListManItem^.adr := CurrListMan^.adr;
  Dispose(CurrListMan);
end;

//Удаление каждого k-ого игрока из списка
procedure DeleteFromListAll(var ListMan : TPMan; const K : integer; var OrderDelete : TOrderArray);
var
  CurrListMan : TPMan;
  i, CurrLen, CurrI : integer;

begin
  CurrLen := ListMan^.info.Number;
  CurrListMan := ListMan;
  CurrI := 1;
  while CurrLen > 1 do
    begin
      for i := 1 to K - 1 do
        CurrListMan := CurrListMan^.adr;
      OrderDelete[CurrI] := CurrListMan^.adr.info.Number;
      inc(CurrI);
      inc(OrderDelete[0]);
      DeleteListManItem(ListMan, CurrListMan);
      dec(ListMan^.info.Number);
      dec(CurrLen);
    end;
end;

//Очистка списка перед новым наполнением
procedure CleanList(var ListMan : TPMan);
begin
  Dispose(ListMan^.adr);
  ListMan^.adr := nil;
  ListMan^.info.Number := 0;
end;

begin
  CreateList(ListMan);
  InputData(K);

  writeln('Будет удален каждый ', K, '-й игрок из круга');
  writeln;
  writeln('-------------------------------------------------------------------');
  writeln('| N | Оставшийся игрок   |        Порядок удаления игроков         ');
  writeln('-------------------------------------------------------------------');
  for N := N_MIN to N_MAX do
    begin
      //Заполнение массива порядка нулями
      Fillchar(OrderDelete, N_MAX, 0);
      //Наполнение списка
      AddToList(ListMan, N);
      //Удаление каждого k-ого игрока
      DeleteFromListAll(ListMan, K, OrderDelete);
      //Вывод оставшегося игрока
      write('|', N:3, '|', ListMan^.adr.info.Number:20, '| ');
      //Вывод порядка удаления игроков
      for i := 1 to OrderDelete[0] do
        begin
          if i = OrderDelete[0] then write(OrderDelete[i])
                                else write(OrderDelete[i], ', ');
          if (i mod 10 = 0) and (i <> OrderDelete[0]) then
            begin
              writeln;
              write('|   |                    | ');
            end;
        end;
      writeln;
      writeln('|---|--------------------|-----------------------------------------');
      //Очистка списка
      CleanList(ListMan);
    end;
  readln;
end.
