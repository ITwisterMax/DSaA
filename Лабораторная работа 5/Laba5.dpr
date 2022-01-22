program Laba5;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Windows;

type
  StekElement = ^TStek;

TStek = record
  Elem : Char;
  Next : StekElement;
end;

var
  st : StekElement;
  temp : Char;
  input, output : string;
  i, Rang : Integer;

//���������� � ����� st �������� value
Procedure AddSteck (var st : StekElement; value : Char);
var
  x : StekElement;

begin
  //����������� �������
  new(x);
  x^.Elem := value;
  //���� ������ ���, ��� next ��������� �� ��, ��� �������� ������
  x^.next := st;
  st := x;
end;

//������� �� ����� ������� �������
function GetStek(var st : StekElement) : Char;
begin
  if st <> nil then
  begin
    GetStek := st^.Elem;
    st := st^.next;
  end
  else
    //��� ������� ����� ���������� ������ #0
    GetStek := #0;
end;

//�������� �������� ��������� ������� �
function StekPriority (c : Char) : Integer;
begin
  case c of
    '+', '-' : Result := 2;
    '*', '/' : Result := 4;
    '^' : Result := 5;
    'a'..'z', 'A'..'Z' : Result := 8;
    '(' : Result := 0;
    else
      //��� ������������ ������� ���������� 10
      Result := 10;
  end;
end;

//�������� ������������� ��������� ������� �
function InpPriority (c : Char) : Integer;
begin
  case c of
    '+', '-' : Result := 1;
    '*', '/' : Result := 3;
    '^' : Result := 6;
    'a'..'z', 'A'..'Z' : Result := 7;
    '(' : Result := 9;
    ')' : Result := 0;
    else
      //��� ������������ ������� ���������� 10
      Result := 10;
  end;
end;

//���������� ���� �������
function CharRang (c : Char) : Integer;
begin
  if c in ['a'..'z','A'..'Z'] then
    //��� �������� ���� 1
    Result := 1
  else
    //��� ��������� ���� -1
    Result := -1;
end;

//����������� ������
function PostfixForm (var st : StekElement; var input : string; var Rang : Integer) : string;
var
  i : Integer;
  t : Char;
  output : string;

begin
  //������� ���� ������
  st := nil;
  //�������� ����
  Rang := 0;
  //�������� �������� ������
  output := '';

  i := 1;
  while i <= Length(input) do
    //���� ���� ��� ��������� �������� ������� ������
    if  (st = nil) or (InpPriority(Input[i]) >= StekPriority(st^.Elem)) then
    begin
      if (st <> nil) and (InpPriority(Input[i]) = StekPriority(st^.Elem)) then
        t := GetStek(st);
      if Input[i] <> ')' then
        AddSteck(st,input[i]);
      i := i + 1;
    end

    //���� �� ���� � ��������� �������� ������� ������
    else
    begin
      //�������� �� ����� ������� ������
      t := GetStek(st);
      if t <> '(' then
      begin
        output := output + t;
        Rang := Rang + CharRang(t);
      end;
    end;

  //���������� ��, ��� �������� � �����
  while not (st = nil) do
  begin
    t := GetStek(st);
    if t <> '(' then
      begin
        output := output + t;
        Rang := Rang + CharRang(t);
      end;
  end;

  Result := output;
end;

//����������� ������
function Reverse (var InputString : string) : string;
var
  temp : char;
  i : Integer;

begin
  //������ ������ ������
  for i := 1 to Length(InputString) div 2 do
    begin
      temp := InputString[i];
      InputString[i] := InputString[Length(InputString) - i + 1];
      InputString[Length(InputString) - i + 1] := temp;
    end;

  //����������� ��������� ������
  for i := 1 to Length(InputString) do
    begin
      if InputString[i] = ')' then InputString[i] := '('
        else if InputString[i] = '(' then InputString[i] := ')';
    end;

  Result := InputString;
end;

begin
  Write('��������� �����: ');
  Readln(input);
  Writeln;

  //�������������� ������� ������
  i := 1;
  while i <= Length(input) do
    if input[i] = ' ' then Delete(input, i, 1)
      else inc(i);

  //����������� �����
  output := PostfixForm(st, input, Rang);

  Write('����������� �����: ');
  Writeln(output);
  Write('���� ���������: ');
  Writeln(Rang);
  Writeln;

  //���������� �����
  input := Reverse(input);
  output := PostfixForm(st, input, Rang);
  output := Reverse(output);

  Write('���������� �����: ');
  Writeln(output);
  Write('���� ���������: ');
  Writeln(Rang);

  Readln;
end.
