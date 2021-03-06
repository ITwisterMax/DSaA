unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TMainForm = class(TForm)
    Info: TRichEdit;
    Print: TButton;
    Find: TButton;
    SortA: TButton;
    SortP: TButton;
    Add: TButton;
    AddP: TButton;
    Del: TButton;
    DelP: TButton;
    Edit: TButton;
    EditP: TButton;
    Leave: TButton;
    procedure LeaveClick(Sender: TObject);
    procedure StartWork(Sender: TObject);
    procedure PrintClick(Sender: TObject);
    procedure FindClick(Sender: TObject);
    procedure SortAClick(Sender: TObject);
    procedure SortPClick(Sender: TObject);
    procedure AddClick(Sender: TObject);
    procedure AddPClick(Sender: TObject);
    procedure DelClick(Sender: TObject);
    procedure DelPClick(Sender: TObject);
    procedure EditClick(Sender: TObject);
    procedure EditPClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  //????? ????????? ???-???????
  HTCount = 34;

type
  TPT = ^TTermList;
  PPT = ^TPageList;
  FPT = ^TFindResultList;
  APT = ^TAddressList;
  SPT = ^TSortTermsList;

  THashTable = array [1..HTCount] of TPT;

  //?????? ????????
  TTermList = record
    Word : string;
    SubTerm : THashTable;
    Pages : PPT;
    Next : TPT;
  end;

  //?????? ???????
  TPageList = record
    Page : Integer;
    Next : PPT;
  end;

  //?????? ??????????? ??????
  TFindResultList = record
    Address : APT;
    Result : TPT;
    Next : FPT;
  end;

  //?????? ??? ???????? ??????
  TAddressList = record
    Point : string;
    Next : APT;
  end;

  //?????? ??? ???????? ??????????????? ?????????
  TSortTermsList = record
    Word : string;
    SubTerms : SPT;
    Pages : PPT;
    Next : SPT;
  end;

var
  MainForm : TMainForm;
  Terms : THashTable;
  com : string;
  upterm, p : string;
  frez : TPT;
  findT : FPT;
  AddHT : THashTable;
  page, prev : PPT;
  jLine : Integer;

implementation

{$R *.dfm}

//???-???????
function H(name : string) : Integer;
begin
  name := AnsiUpperCase(name);

  //???????? ? ?? ?
  if ord(name[1]) = 240 then
    name[1] := char(133);

  if (ord(name[1]) < 128) or (ord(name[1]) > 159) then
    result := 1
  else
    result := ord(name[1]) - 191 + 1;
end;

//????????????? ???-???????
procedure Initialize(var HT : THashTable);
var
  i : Integer;

begin
  for i := 1 to HTCount do
  begin
    new(HT[i]);
    HT[i]^.Next := nil;
  end;
end;



//??????? PPT ?? ?????? ????????
function GetPPT(page : Integer) : PPT;
begin
  New(result);
  result^.Page := page;
  result^.Next := nil;
end;

//?????????? ????????
procedure AddPage(var first : PPT; page : PPT);
var
  x : PPT;

begin
  //????? ?????? ??????
  x := first;
  //???? ?????
  while x^.Next  <> nil do
    x := x^.Next;
  x^.Next := page;
end;

//???????? ????????? TPT
function GetTPT(word : string; page : PPT) : TPT;
begin
  New(result);
  //????????? ????????
  result^.Word := Word;
  //????????? ????????
  New(result^.Pages);
  result^.Pages^.Next := page;
  //????????? ??????????
  Initialize(result^.SubTerm);
  result^.Next := nil;
end;

//???????? ????????? SPT
function GetSPT(word : string; page : PPT) : SPT;
begin
  New(result);
  //????????? ????????
  result^.Word := Word;
  //????????? ????????
  New(result^.Pages);
  result^.Pages^.Next := page;
  //????????? ??????????
  New(result^.SubTerms);
  result^.Next := nil;
end;



//????? ??????? ?????? ? ?????? ???-??????? (??? ???????? ?? ?????? ??????)
function LittleFindTerm(term : TPT; parrent : THashTable) : TPT;
var
  x : TPT;

begin
  //?????????? ?????? ???-???????
  x := parrent[H(term^.Word)]^.Next;

  while (x <> nil) and (x^.Word <> term^.Word) do
    x := x^.Next;

  result := x;
end;

//?????????? ? ?????? first ?????? plus, ??????? first ???, ????? ?? ???????? ?? ????? ?????? ??????
procedure AddResultsToList(var first : FPT; var plus : FPT);
var
  x : FPT;

begin
  if first = nil then first := plus
  else
    first^.Next := plus;

  if plus <> nil then
    begin
      x := plus;
      while x^.Next <> nil do
        x := x^.Next;
      first := x;
    end;
end;

//??????????? ?????? ???????
function CopyAddress(x : APT) : APT;
var
  y, z : APT;

begin
  New(y);
  result := y;

  while x <> nil do
  begin
    y^.Point := x^.Point;
    z := y;
    New(y);
    z^.Next := y;
    x := x^.Next;
  end;

  z^.Next := nil;
end;

//????????? ???????? ? ??????
procedure AddAddress(var x, add : APT);
var
  y : APT;

begin
  y := x;

  while y^.Next <> nil do
    y := y.Next;

  y^.Next := add;
end;

//????? ??????? (??????????? ?????)
function FTerm(Address : APT; term : TPT; parrent : THashTable) : FPT;
var
  i : Integer;
  x : TPT;
  rez, t1, t2, t3 : FPT;
  adr, t : APT;
begin
  x := LittleFindTerm(term, parrent);

  New(rez);
  rez^.Next := nil;
  t1 := rez;

  if x <> nil then
  begin
    New(t2);
    t2^.Address := Address;
    t2^.Result := x;
    t2^.Next := nil;
    AddresultsToList(t1, t2);
  end;

  //????????????? ??? ??????? ???? ???????? ??????
  for i := 1 to HTCount do
    begin
      x := parrent[i]^.Next;

      //????????????? ??????
      while x <> nil do
        begin
          //?????????? ? ?????? ??????? ???????
          New(t);
          t^.Point := x^.Word;
          t^.Next := nil;
          adr := CopyAddress(Address);
          AddAddress(adr, t);

          //????????? ????? ?? ??????? ????
          t3:=FTerm(adr, term, x^.SubTerm);
          AddResulTSToList(t1, t3);
          x := x^.Next;
        end; //While
    end;//for

  FTerm := rez^.Next;
end;

//????? ???????? ? ?????? first. ? prev ??????????? ?????????? ??. ??????
function FindPage(first : PPT; page : PPT; var prev : PPT) : PPT;
begin
  prev := first;
  first := first^.Next;

  while (first <> nil) and (first^.Page <> page^.Page) do
  begin
    prev := prev^.Next;
    first := first^.Next;
  end;
  result := first;
end;

function GetParrent(x : FPT) : THashTable;
var
  adr : APT;
  HT : THashTable;

begin
  adr := x^.Address^.Next;
  HT := Terms;

  //????????????? ????? ?????????
  while adr <> nil do
  begin
     //???????? ????? ???-???????
    HT := LittleFindTerm(GetTPT(adr^.Point, nil), HT)^.SubTerm;
    adr := adr^.Next;
  end;

  result := HT;
end;

//????????? ??????? ?? ??????????? ??????
function GetTermFormFind(x : FPT) : TPT;
begin
  if x = nil then exit;
  result := LittleFindTerm(x^.Result, GetParrent(x));
end;

//????? ??????? ?? ???? ?????????
function FindTerm(term : TPT) : FPT;
var
  Adr : APT;

begin
  New(Adr);
  Adr^.Next := nil;

  New(result);
  result^.Next := FTerm(Adr, term, Terms);
end;

//?????????? ??????? ? ???-???????
procedure AddTerm(var HT : ThashTable; Term : TPT);
var
  t : Integer;
  prev : TPT;
  x : TPT;

begin
  //???????? ???-???????;
  t := H(Term^.Word);
  prev := HT[t];
  x := prev^.Next;

  //??????? ????? ??????? ??? ????? ??????
  while (x <> nil) and (AnsiLowerCase(x^.Word) < AnsiLowerCase(Term^.Word)) do
  begin
    x := x^.Next;
    prev := prev^.Next;
  end;

  //?????????
  prev^.Next := Term;
  Term^.Next := x;
end;

//????? ?????? ???????
procedure WritePageList(first : PPT);
var
  x : PPT;
begin
  x := first^.Next;

  while x <> nil do
  begin
    MainForm.Info.Lines[jLine] := MainForm.Info.Lines[jLine] + IntToStr(x^.Page);
    x := x^.Next;

    //??????? ????? ?????? ???? ??????? ???-?? ????
    if x <> nil then
      MainForm.Info.Lines[jLine] := MainForm.Info.Lines[jLine] + ', ';
  end;
end;

procedure WriteHT(table : THashTable; tabs : integer); Forward;

//????? ??????? ? ???????????? ? ???????? ???????. Tabs - ?????? ?? ?????? ????????
procedure WriteTerm(term : TPT; tabs : integer; sub : boolean);
var
  i : Integer;

begin
  //??????????? ????? ????????
  for i := 1 to tabs do
    MainForm.Info.Lines[jLine] := MainForm.Info.Lines[jLine] + '     ';

  MainForm.Info.Lines[jLine] := MainForm.Info.Lines[jLine] + term^.Word + '   ';
  WritePageList(term^.Pages);
  inc(jLine, 2);

  if sub then WriteHT(term^.SubTerm, tabs + 1)
end;

//????? ??????? ??????????? ???-???????
procedure WriteHT;
var
  i : Integer;
  x : TPT;
begin
  for i := 1 to HTCount do
  begin
    //????? ?????? ????????
    x := table[i]^.Next;

    while x <> nil do
    begin
      WriteTerm(x, tabs, true);
      x := x^.Next;
    end;
  end;
end;

//????? ??????????? ??????
procedure WriteFindResult(rez : FPT; sub : boolean);
var
  i, j, tabs : Integer;
  x : FPT;
  y : APT;

begin
  i := 1;
  x := rez^.Next;
  if x = nil then ShowMessage('?????? ?? ??????!')
  else
    begin
      for i := 0 to jLine do
        MainForm.Info.Lines[i] := '';
      jLine := 0;

      MainForm.Info.Lines[jLine] := '????????? ?????? ?? ???????/?????????? :';
      inc(jLine, 2);
      i := 0;

      while x <> nil do
        begin
          inc(i);
          MainForm.Info.Lines[jLine] := IntToStr(i) + ':';
          inc(jLine, 2);

          //????? ??????
          tabs := 0;
          y := x^.Address^.Next;
          while y <> nil do
          begin
            //???????
            for j := 1 to tabs do
              MainForm.Info.Lines[jLine] := MainForm.Info.Lines[jLine] + '     ';
            tabs := tabs + 1;

            MainForm.Info.Lines[jLine] := MainForm.Info.Lines[jLine] + y^.Point;
            inc(jLine, 2);
            y := y^.Next;
          end;

          //????? ???????????
          WriteTerm(x^.Result, tabs, sub);
          x := x^.Next;
        end;
    end;
end;

//????? ?????? ?????? ??????? ? ???????? ???????????? ? ?????? ??????????? ??? ?????????????.
// ? rez ???????????? ????????? ??? ?????????? ??????????
function FindOneTerm(rez : FPT) : FPT;
var
  n, i : Integer;
  frez : FPT;

begin
  frez := rez;

  //?????? ?? ??????
  if rez^.Next = nil then
    begin
      result := nil;
      exit;
    end
  //?????? ???? ?????????
  else if rez^.Next^.Next = nil then
    frez := rez^.Next
  //??????? ????? ???????????
  else
  begin
    WriteFindResult(frez, false);
    repeat
      n := StrToInt(InputBox('?????????? ???????/??????????', '???? ??????? ????????? ???????, ?????????????? ? ????. ? ????? ???????? ??????? ?????????? ??????? : ', ''));
    until IntToStr(n) <> '';
    //??????? ??? ????? ???????? ????????????? ?????????
    for i := 1 to n do
      frez := frez^.Next;
  end;

  //???????? ??????
  result := frez;
end;

procedure DeleteTerm(var par : THashTable; frez : TPT);
var
  x : TPT;

begin
  //?????????? ?????? ???-???????
  x := par[H(frez^.Word)];

  //?????
  while (x^.Next <> nil) and (x^.Next^.Word <> frez^.Word) do
    x := x^.Next;

  //??????
  x^.Next := x^.Next^.Next;
end;

procedure WriteSPT(x : SPT; tabs : integer);
var
  i : Integer;

begin
  while x <> nil do
  begin
    //??????????? ????? ????????
    for i := 1 to tabs do
      MainForm.Info.Lines[jLine] := MainForm.Info.Lines[jLine] + '     ';

    //????? ???????
    MainForm.Info.Lines[jLine] := MainForm.Info.Lines[jLine] + x^.Word + '   ';
    WritePageList(x^.Pages);
    inc(jLine, 2);

    //????? ???????????
    WriteSPT(x^.SubTerms, tabs+1);

    x := x^.Next;
  end;
end;

//??????????? ????? ?????????? ?? ?????????
function PrSortByPages(HT : THashTable) : SPT;
var
  x : TPT;
  y, prev, sort : SPT;
  i : Integer;

begin
  New(sort);
  sort^.Next := nil;

  //??? ?????? ?????? ???-???????
  for i := 1 to HTCount do
    begin
      x := HT[i]^.Next;

      //??? ??????? ???????? ??????
      while  x <> nil  do
        begin
          y := sort^.Next;
          prev := sort;

          //??????? ????? ???????
          while (y <> nil) and (y^.Pages^.Next^.Page < x^.Pages^.Next^.Page) do
            begin
              prev := prev^.Next;
              y := y^.Next;
            end;

          //???????
          prev^.Next := GetSPT(x^.Word, x^.Pages^.Next);
          prev^.Next^.Next := y;

          //?????????? ??????????
          prev^.Next^.SubTerms := PrSortByPages(x^.SubTerm);

          x := x^.Next;
        end;
    end;

  result := sort^.Next;
end;

//?????????? ?? ???????? ? ????? ??????????
procedure SortByPages;
begin
  WriteSPT(PrSortByPages(Terms), 0);
end;



//????
procedure TMainForm.StartWork(Sender : TObject);
begin
  //?????????????? ???????? ???-??????? ??????????
  Initialize(Terms);

  //????????? ?????????? ???????
  AddTerm(Terms, GetTPT(('?????????'), GetPPT(11)));
  AddPage(Terms[H(('?????????'))]^.Next^.Pages, GetPPT(21));
  AddPage(Terms[H(('?????????'))]^.Next^.Pages, GetPPT(31));

  AddTerm(Terms[H(('?????????'))]^.Next^.SubTerm, GetTPT('??????????', GetPPT(11)));
  AddTerm(Terms[H(('?????????'))]^.Next^.SubTerm, GetTPT('????', GetPPT(21)));
  AddTerm(Terms[H(('?????????'))]^.Next^.SubTerm, GetTPT('??????', GetPPT(31)));
  AddTerm(FindTerm(GetTPT('??????', nil))^.Next^.Result^.SubTerm, GetTPT(('?????'), GetPPT(31)));

  AddTerm(Terms,GetTPT(('??????'), nil));
  AddPage(Terms[H(('??????'))]^.Next^.Pages, GetPPT(55));
  AddPage(Terms[H(('??????'))]^.Next^.Pages, GetPPT(105));
  AddPage(Terms[H(('??????'))]^.Next^.Pages, GetPPT(155));

  AddTerm(Terms[H(('??????'))]^.Next^.SubTerm, GetTPT('?????', GetPPT(155)));
  AddTerm(Terms[H(('??????'))]^.Next^.SubTerm, GetTPT('????', GetPPT(105)));
  AddTerm(Terms[H(('??????'))]^.Next^.SubTerm, GetTPT('??????', GetPPT(55)));
end;

procedure TMainForm.PrintClick(Sender : TObject);
var
  i : Integer;

begin
  //?????????
  for i := 0 to jLine do
    Info.Lines[i] := '';
  jLine := 0;
  WriteHT(Terms, 0)
end;

procedure TMainForm.FindClick(Sender : TObject);
var
  buf : string;

begin
  //???????? ?????
  buf := InputBox('????? ???????/??????????', '??????? ??? ???????/?????????? : ', '');
  if buf = '' then exit;

  if (buf[1] >= '?') and (buf[1] <= '?') then
    buf[1] := chr(ord(buf[1]) - ord('?') + ord('?'))
  else
    if (buf[1] >= '?') and (buf[1] <= '?') then
      buf[1] := chr(ord(buf[1]) - ord('?') + ord('?'))
        else
          if (buf[1] = '?') then buf[1] := '?';

  WriteFindResult(FindTerm(GetTPT(buf, nil)), true);
end;

procedure TMainForm.SortAClick(Sender : TObject);
var
  i : Integer;

begin
  //?????????
  for i := 0 to jLine do
    Info.Lines[i] := '';
  jLine := 0;
  Info.Lines[jLine] := '????????? ?????????? ?? ???????? :';
  inc(jLine, 2);

  WriteHT(Terms, 0)
end;

procedure TMainForm.SortPClick(Sender : TObject);
var
  i : Integer;

begin
  //?????????
  for i := 0 to jLine do
    Info.Lines[i] := '';
  jLine := 0;
  Info.Lines[jLine] := '????????? ?????????? ?? ????????? :';
  inc(jLine, 2);

  SortByPages;
end;

procedure TMainForm.AddClick(Sender: TObject);
begin
  //???????? ?????
  upterm := InputBox('?????????? ???????/??????????', '??????? ????????? ???????????? ??????? : ', '');
  if upterm = '' then upterm := '~';

  if (upterm[1] >= '?') and (upterm[1] <= '?') then
    upterm[1] := chr(ord(upterm[1]) - ord('?') + ord('?'))
  else
    if (upterm[1] >= '?') and (upterm[1] <= '?') then
      upterm[1] := chr(ord(upterm[1]) - ord('?') + ord('?'))
        else
          if (upterm[1] = '?') then upterm[1] := '?';

  //????????? ? ??????
  if upterm = '~' then  AddHT := Terms
  else
    begin
      //????????? ??????
      frez := GetTermFormFind(FindOneTerm(FindTerm(GetTPT(upterm, nil))));
      //????????? ?? ??????
      if frez = nil then
        begin
          ShowMessage('????????? ?? ??????!');
          exit;
        end;

        //???-??????? ??? ??????????
        AddHT := frez^.SubTerm;
    end;

  //??????????
  upterm := InputBox('?????????? ???????/??????????', '??????? ??????????? ?????? : ', '');
  if upterm = '' then exit;

  if (upterm[1] >= '?') and (upterm[1] <= '?') then
    upterm[1] := chr(ord(upterm[1]) - ord('?') + ord('?'))
  else
    if (upterm[1] >= '?') and (upterm[1] <= '?') then
      upterm[1] := chr(ord(upterm[1]) - ord('?') + ord('?'))
        else
          if (upterm[1] = '?') then upterm[1] := '?';

  //?????? ??? ???
  if LittleFindTerm(GetTPT(upterm, nil), AddHT) = nil then
    begin
      //???? ????????
      p := InputBox('?????????? ???????/??????????', '??????? ????? ????????: ', '');
      if p = '' then exit;

      AddTerm(AddHT,GetTPT(upterm, GetPPT(StrToInt(p))));
      ShowMessage('?????? ??????? ????????!');
    end
  else //????? ??? ????
    ShowMessage('????? ?????? ??? ????!');
end;

procedure TMainForm.AddPClick(Sender: TObject);
begin
  upterm := InputBox('?????????? ????????', '??????? ?????? : ', '');
  if upterm = '' then exit;

  if (upterm[1] >= '?') and (upterm[1] <= '?') then
    upterm[1] := chr(ord(upterm[1]) - ord('?') + ord('?'))
  else
    if (upterm[1] >= '?') and (upterm[1] <= '?') then
      upterm[1] := chr(ord(upterm[1]) - ord('?') + ord('?'))
        else
          if (upterm[1] = '?') then upterm[1] := '?';

  frez := GetTermFormFind(FindOneTerm(FindTerm(GetTPT(upterm, nil))));

  if frez = nil then
    ShowMessage('?????? ?? ??????!')
  else
    begin
      upterm := InputBox('?????????? ????????', '??????? ????? ????????: ', '');
      if upterm = '' then exit;

      AddPage(frez^.Pages,GetPPT(StrToInt(upterm)));
      ShowMessage('???????? ??????? ?????????!');
    end;
end;

procedure TMainForm.DelClick(Sender: TObject);
begin
  //???????? ?????
  upterm := InputBox('???????? ???????/??????????', '??????? ??? ???????/?????????? : ', '');
  if upterm = '' then exit;

  if (upterm[1] >= '?') and (upterm[1] <= '?') then
    upterm[1] := chr(ord(upterm[1]) - ord('?') + ord('?'))
  else
    if (upterm[1] >= '?') and (upterm[1] <= '?') then
      upterm[1] := chr(ord(upterm[1]) - ord('?') + ord('?'))
        else
          if (upterm[1] = '?') then upterm[1] := '?';

  //?????????? ? ??????? ?????? ? ????????? ?????? ??? ????????? ????????
  findT := FindOneTerm(FindTerm(GetTPT(upterm, nil)));
  frez := GetTermFormFind(findT);

  if frez = nil then
    ShowMessage('?????? ?? ??????!')
  else
  begin
    AddHT := GetParrent(findT);
    DeleteTerm(AddHT, frez);
    ShowMessage('?????? ?????? ???????!');
  end;
end;

procedure TMainForm.DelPClick(Sender: TObject);
begin
  //???????? ?????
  upterm := InputBox('???????? ????????', '??????? ??? ???????/?????????? : ', '');
  if upterm = '' then exit;

  if (upterm[1] >= '?') and (upterm[1] <= '?') then
    upterm[1] := chr(ord(upterm[1]) - ord('?') + ord('?'))
  else
    if (upterm[1] >= '?') and (upterm[1] <= '?') then
      upterm[1] := chr(ord(upterm[1]) - ord('?') + ord('?'))
        else
          if (upterm[1] = '?') then upterm[1] := '?';

  frez := GetTermFormFind(FindOneTerm(FindTerm(GetTPT(upterm, nil))));

  if frez = nil then
    ShowMessage('?????? ?? ??????!')
  //??????? ????????? ???????? ??????
  else if frez^.Pages^.Next^.Next = nil then
    ShowMessage('?????????? ??????? ???????????? ????????!')
  else
  begin
    upterm := InputBox('???????? ????????', '??????? ????? ???????? : ', '');
    if upterm = '' then exit;

    //?????? ?????? ????????
    page := FindPage(frez^.Pages,GetPPT(StrToInt(upterm)),prev);

    if page=nil then
      ShowMessage('???????? ?? ???????!')
    else
    begin
      prev^.Next := page^.Next;
      ShowMessage('???????? ??????? ???????!');
    end;
  end;
end;

procedure TMainForm.EditClick(Sender: TObject);
begin
  //???????? ?????
  upterm := InputBox('????????? ???????/??????????', '??????? ??? ???????/?????????? : ', '');
  if upterm = '' then exit;

  if (upterm[1] >= '?') and (upterm[1] <= '?') then
    upterm[1] := chr(ord(upterm[1]) - ord('?') + ord('?'))
  else
    if (upterm[1] >= '?') and (upterm[1] <= '?') then
      upterm[1] := chr(ord(upterm[1]) - ord('?') + ord('?'))
        else
          if (upterm[1] = '?') then upterm[1] := '?';

  findT := FindOneTerm(FindTerm(GetTPT(upterm, nil)));
  frez := GetTermFormFind(findT);

  if frez = nil then
    ShowMessage('?????? ?? ??????!')
  else
  begin
    //???????? ?????
    upterm := InputBox('????????? ???????/??????????', '??????? ????? ??? ???????/?????????? : ', '');
    if upterm = '' then exit;

    if (upterm[1] >= '?') and (upterm[1] <= '?') then
      upterm[1] := chr(ord(upterm[1]) - ord('?') + ord('?'))
    else
      if (upterm[1] >= '?') and (upterm[1] <= '?') then
        upterm[1] := chr(ord(upterm[1]) - ord('?') + ord('?'))
          else
            if (upterm[1] = '?') then upterm[1] := '?';

    //?????? ???????? ???????? - ?????? ?????????? ??????????. ??????? ??????
    // ??????? ??????????????? ?????? ?????? ? ??????? ????? ??????
    AddHT := GetParrent(findT);
    DeleteTerm(AddHT, frez);
    frez^.Word := upterm;
    AddTerm(AddHT, frez);

    ShowMessage('?????? ??????? ???????!');
  end;
end;

procedure TMainForm.EditPClick(Sender: TObject);
begin
  //???????? ?????
    upterm := InputBox('????????? ????????', '??????? ??? ???????/?????????? : ', '');
    if upterm = '' then exit;

    if (upterm[1] >= '?') and (upterm[1] <= '?') then
      upterm[1] := chr(ord(upterm[1]) - ord('?') + ord('?'))
    else
      if (upterm[1] >= '?') and (upterm[1] <= '?') then
        upterm[1] := chr(ord(upterm[1]) - ord('?') + ord('?'))
          else
            if (upterm[1] = '?') then upterm[1] := '?';

  frez := GetTermFormFind(FindOneTerm(FindTerm(GetTPT(upterm, nil))));

  if frez = nil then
    ShowMessage('?????? ?? ??????!')
  else
  begin
    //???????? ?????
    upterm := InputBox('????????? ???????/??????????', '??????? ?????? ????? ???????? : ', '');
    if upterm = '' then exit;

    if (upterm[1] >= '?') and (upterm[1] <= '?') then
      upterm[1] := chr(ord(upterm[1]) - ord('?') + ord('?'))
    else
      if (upterm[1] >= '?') and (upterm[1] <= '?') then
        upterm[1] := chr(ord(upterm[1]) - ord('?') + ord('?'))
          else
            if (upterm[1] = '?') then upterm[1] := '?';

    //?????? ?????? ????????
    page := FindPage(frez^.Pages,GetPPT(StrToInt(upterm)),prev);

    if page = nil then
      ShowMessage('???????? ?? ???????!')
    else
      begin
        //???????? ?????
        upterm := InputBox('????????? ???????/??????????', '??????? ????? ????? ???????? : ', '');
        if upterm = '' then exit;

        if (upterm[1] >= '?') and (upterm[1] <= '?') then
          upterm[1] := chr(ord(upterm[1]) - ord('?') + ord('?'))
        else
          if (upterm[1] >= '?') and (upterm[1] <= '?') then
            upterm[1] := chr(ord(upterm[1]) - ord('?') + ord('?'))
              else
                if (upterm[1] = '?') then upterm[1] := '?';

        page^.Page:=StrToInt(upterm);
        ShowMessage('???????? ??????? ????????!');
      end;
  end;
end;

procedure TMainForm.LeaveClick(Sender : TObject);
begin
  MainForm.Close;
end;

end.
