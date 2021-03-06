program laba2;

{$APPTYPE CONSOLE}

{$R *.res}
 uses
  System.SysUtils;

type
  element = record
    phone_number : string[7];
    name : string[20];
 end;


  pspisok = ^tspisok;
  tspisok = record
    adrprev,adrnext : pspisok;
    inf : element;
 end;

  pnewspisok = ^tnewspisok;
  tnewspisok = record
    adrnext : pnewspisok;
    inf : element;
  end;

var
  headspisok, currentspisok : pspisok;
  spisfile : file of element;
  headnew : pnewspisok;

//????? ??????? ? ???????
procedure output(var Headspisok : pspisok);
var
  tempspis : Pspisok;

begin
  //????? ?????? ?????????
  tempspis := HeadSpisok;
  if tempspis^.adrnext = headspisok then
    writeln('?????? ????')
  else
    begin
      writeln('?????? ????????? ? ?? ??????? : ');
      writeln('-------------------------------------');
      writeln('|    ??? ????????    |   ???????    |');
      writeln('|                    |              |');
      writeln('-------------------------------------');

      tempspis := tempspis^.adrnext;
      while tempspis <> headspisok do
        begin
          with tempspis^.inf do
            write( '|', name : 20, '|', phone_Number : 14, '|');
          writeln;
          writeln('-------------------------------------');
          tempspis := tempspis^.adrnext;
        end;
      writeln;

      writeln('?????? ????????? ? ?? ??????? : ');
      writeln('-------------------------------------');
      writeln('|    ??? ????????    |   ???????    |');
      writeln('|                    |              |');
      writeln('-------------------------------------');

      tempspis := tempspis^.adrprev;
      while tempspis <> headspisok do
        begin
          with tempspis^.inf do
            write( '|', name : 20, '|', phone_Number : 14, '|');
          writeln;
          writeln('-------------------------------------');
          tempspis := tempspis^.adrprev;
        end;
      writeln;
    end;
end;

procedure readingfile(var Headspisok : pspisok);
var
  i : integer;
  tempspis : Pspisok;
begin
  //????????? ???? ??? ??????
  if FileExists('List') = false then
    begin
      assign(spisFile,
        'List');
      Rewrite(spisFile);
      CloseFile(spisFile);
    end;
  assign(spisFile, 'List');
  reset(spisFile);
  tempspis := Headspisok;

  i := 0;
  //???? ?? ????? ?????, ?????? ????????? ??????
  while (not eof(spisFile)) do
    begin
      Seek(spisFile, i);
      new(tempspis^.adrnext);
      tempspis^.adrnext^.adrprev := tempspis;
      tempspis := tempspis^.adrnext;
      read(spisFile, tempspis^.inf);
      Inc(i);
    end;
  headspisok^.adrprev := tempspis;
  tempspis^.adrnext := headspisok;
  CloseFile(spisFile);
  writeln('?????? ??????? ????????.');
  writeln;
end;

procedure savefile(var headspisok : pspisok);
var
  tempspis : pspisok;
begin
  assign(spisFile, 'List');
  Rewrite(spisFile);
  tempspis := Headspisok;
  if tempspis<>tempspis^.adrnext then
    repeat
      tempspis := tempspis^.adrnext;
      write(spisFile, tempspis^.inf);
    until tempspis^.adrnext = headspisok;

  CloseFile(spisFile);
end;

//?????????? ?????? ? ??????
procedure addData(var Headspisok : Pspisok);
var
  tempspis: Pspisok;
begin
  tempspis := Headspisok;
  //???? ? ????? ??????
  while tempspis^.adrnext <> headspisok do
    tempspis := tempspis^.adrnext;
  //???????? ?????? ? ????? ??????
  new(tempspis^.adrnext);
  tempspis^.adrnext^.adrprev := tempspis;
  tempspis := tempspis^.adrnext;
  tempspis^.adrnext := headspisok;
  headspisok^.adrprev := tempspis;

  with tempspis^.inf do
    begin
      writeln('?????????? ?????? ?? ???????? : ');
      write('????? : ');
      readln(phone_number);
      write('???????? : ');
      readln(name);
    end;
end;

procedure addnew(tempnew : pnewspisok; tempspis : pspisok);
begin
  //???? ? ????? ??????
  while tempnew^.adrnext <> nil do
    tempnew := tempnew^.adrnext;
  //???????? ?????? ? ????? ??????
  new(tempnew^.adrnext);
  tempnew := tempnew^.adrnext;
  tempnew^.adrnext := nil;
  tempnew^.inf:=tempspis^.inf;
end;

procedure sort(headnew : pnewspisok);
var
  previous, temp : Pnewspisok;
  temp1 : element;

begin
  previous := Headnew;
  while previous^.adrnext <> nil do
    begin
      previous := previous^.adrnext;
      temp := previous;
      while temp^.adrnext <> nil do
        begin
          temp := temp^.adrnext;
          if  previous^.inf.name > temp^.inf.name then
            begin
              temp1 := previous^.inf;
              previous^.inf := temp^.inf;
              temp^.inf := temp1;
            end;
        end;
    end;
end;

procedure output_1();
var
  tempnew : pnewspisok;
begin
  tempnew := headnew;
  writeln('?????????? ???????????????? ?????? : ');
  writeln('-------------------------------------');
  writeln('|    ??? ????????    |    ???????   |');
  writeln('|                    |              |');
  writeln('-------------------------------------');
  while tempnew^.adrnext <> nil do
    begin
      with tempnew^.adrnext^.inf do
        write( '|', name : 20 , '|', phone_Number : 14, '|');
      writeln;
      writeln('-------------------------------------');
      tempnew := tempnew^.adrnext;
    end;
 writeln;
end;

procedure spec_proc(var headspisok : pspisok);
var
  tempspis : pspisok;
  tempnew : pnewspisok;

begin
  new(headnew);
  tempnew := headnew;
  tempnew^.adrnext := nil;
  tempspis := headspisok^.adrprev;
  while tempspis <> headspisok do
    begin
      if length(tempspis^.inf.phone_number) = 7 then
        addnew(tempnew,tempspis);
      tempspis := tempspis^.adrprev;
    end;
  sort(headnew);
  output_1;
end;



procedure mainmenu;
var
  button: integer;

begin
  writeln('??????? ???? : ');
  writeln('-------------------------------------');
  writeln('1.???????? ??????                   |');
  writeln('2.?????????? ?????? ? ??????        |');
  writeln('3.???????? ????????????????? ?????? |');
  writeln('4.?????                             |');
  writeln('-------------------------------------');

  write('??????? ????? ???? : ');
  readln(button);
  case button of
     1: output(Headspisok);
     2: addData(Headspisok);
     3: spec_proc(Headspisok);
     4: exit;
  end;
   if button <> 4 then
    mainmenu;
end;


begin
  //???????? ?????? ??? ?????? ??????
  new(Headspisok);
  Currentspisok := Headspisok;
  CurrentSpisok^.adrnext := headspisok;
  CurrentSpisok^.adrprev := headspisok;
  readingfile(Headspisok);
  mainmenu;
  savefile(HeadSpisok);
end.
