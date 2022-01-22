unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.jpeg,
  Vcl.StdCtrls;

const
  //���������� ���������
  N = 50;
  //������ �����
  Rad = 20;
  //��������� ����� ��������
  Len = 30;
  //���� �����
  PenColor = clBlack;
  //������� �����
  PenWidth = 2;
  //����� �������
  BrushColor1 = clWhite;
  BrushColor2 = clRed;
  BrushColor3 = clGreen;

type
  //��������� �� ��������� ������
  Tree = ^TreeEl;

  TreeEl = record
    //����� � ������ ���
    Left : Tree;
    Right : Tree;
    //��������
    Value : Integer;
    //������ ����
    Thread : Boolean;
    //���������� �����
    X, Y : Integer;
  end;

  //��� �����
  TTreeForm = class(TForm)
    ImageTree: TImage;
    CreateTree: TButton;
    FlashTree: TButton;
    Symmetric: TButton;
    Direct: TButton;
    AddElement: TButton;
    DeleteElement: TButton;
    Back: TButton;
    procedure FormCreate(Sender: TObject);
    procedure CreateTreeClick(Sender: TObject);
    procedure SymmetricClick(Sender: TObject);
    procedure FlashTreeClick(Sender: TObject);
    procedure DirectClick(Sender: TObject);
    procedure AddElementClick(Sender: TObject);
    procedure BackClick(Sender: TObject);
    procedure DeleteElementClick(Sender: TObject);

  private
    { Private declarations }

  public
    //������
    NowTree : Tree;
    //������� ����� ���������
    currN : Integer;
    //�������� ������
    bmp : TBitmap;
  end;

var
  //�����
  TreeForm: TTreeForm;

implementation

{$R *.dfm}

//+------------------+
//| ������ � ������� |
//+------------------+

//���������� ����� ����� ����� �������
procedure PunktLineTo(x0, y0, x, y : Integer; var bmp : TBitmap);
var
  x1, y1, x2, y2, i : Integer;
begin
  //��� �� ������ � �������
  if x > x0 then
    begin
      x1 := x0; y1 := y0;
      x2 := x;  y2 := y;
    end
  else
    begin
      x1 := x;  y1 := y;
      x2 := x0; y2 := y0;
    end;

  //����� �� ��� Ox
  i := x1;
  while i < x2 do
  begin
    bmp.Canvas.MoveTo(i, y1);
    if i + 5 < x2 then
      bmp.Canvas.LineTo(i + 5, y1)
    else
      bmp.Canvas.LineTo(x2, y1);
    i := i + 10;
  end;

  //����� �� ��� Oy
  i := y1;
  if y1 > y2 then
    while i > y2 do
    begin
      bmp.Canvas.MoveTo(x2, i);
      if i - 5 > y2 then
        bmp.Canvas.LineTo(x2, i - 5)
      else
        bmp.Canvas.LineTo(x2, y2);
      i := i - 10;
    end
  else
    while i < y2 do
    begin
      bmp.Canvas.MoveTo(x2, i);
      if i + 5 < y2 then
        bmp.Canvas.LineTo(x2, i + 5)
      else
        bmp.Canvas.LineTo(x2, y2);
      i := i + 10;
    end;
end;

//�������� (������ ������������)
procedure GoFlash(El : Tree; var bmp : TBitmap);
var
  prev, start : Tree;

//���������� �����. ���� ��������  � �����
procedure RFlash(El : Tree; var bmp : TBitmap);
begin
  if El = nil then Exit;

  //����� ���������
  RFlash(El^.Left, bmp);

  //��������
  if (prev^.Right = nil) and (prev <> start) then
  begin
    //����
    prev^.Thread := True;
    //��������� �� �������
    prev^.Right := El;
    PunktLineTo(prev^.X + Rad, prev^.Y, El^.X, El^.Y + Rad, bmp);
  end;
  prev := El;

  //������ ���������
  if not El^.Thread then
    RFlash(El^.Right, bmp);
end;

begin
  //��������� �������� ����������� ��������
  prev := El;
  start := El;

  //���� �������� � �����
  RFlash(El, bmp);

  //���� ����, ������� ����� �� ������ �� ���������� ��������
  if (prev^.Right = nil) and (prev <> start) then
    begin
      //����
      prev^.Thread := True;
      //��������� �� �������
      prev^.Right := El;
      PunktLineTo(prev^.X + Rad, prev^.Y, bmp.Width - 20, prev^.Y, bmp);
      PunktLineTo(bmp.Width - 20, prev^.Y, El^.X + Rad, El^.Y, bmp);
    end;
end;

//���������� �������� � ������
procedure Add(El : Integer; var Rez : Tree);
begin
  //���� ����, �� ���������
  if Rez = nil then
    begin
      New(Rez);
      Rez^.Value := El;
      Rez^.Left := nil;
      Rez^.Right := nil;
      Rez^.Thread := False;
    end
  //���� �������� ������ �����, �� ���� �����
  else if El < Rez^.Value then Add(El,Rez^.Left)
  //���� �������� ������ �����, �� ���� ������
  else if El > Rez^.Value then Add(El,Rez^.Right)
end;

//�������� �����
procedure DelThread(var El : Tree);
begin
  if El = nil then Exit;

  //����� ���������
  DelThread(El^.Left);
  if El^.Thread = False then
  //������ ���������
    DelThread(El^.Right);
  if El^.Thread then
  begin
    El^.Thread := False;
    El^.Right := nil;
  end;
end;

//�������� �������� �� ������
procedure DelEl(val : Integer; var Der, PrevEl : Tree);
var
  prev, El, x : Tree;
  function Find(val : Integer; var Der : Tree) : Tree;
  begin
    if Der = nil then
    begin
      Result := Der;
      Exit;
    end;
    if Der^.Value = val then
    //������� ������
      Result := Der
    else
    begin
      prev := Der;
      if Der^.Value < val then
        Result := Find(val, Der^.Right)
      else
        Result := Find(val, Der^.Left)
    end;
  end;
begin
  //���� �������
  prev := PrevEl;
  El := Find(val, Der);
  //������� �� ������
  if El = nil then
  begin
    ShowMessage('������� ������ �� ������...');
    Exit;
  end;
  //������� - ���� ��� ������ ������ ���������
  if (El^.Left = nil) then
  begin
    if prev^.Left = El then
      prev^.Left := El^.Right
    else
      prev^.Right := El^.Right;
    Dispose(El);
  end
  //������� - ������ ����� ���������
  else if (El^.Right = nil) or (El^.Thread) then
  begin
    if prev^.Left = El then
      prev^.Left := El^.Left
    else
      prev^.Right := El^.Left;
    Dispose(El);
  end
  //������� - ��� ���������
  else
  begin
    //����� ������ ������ �������� ������� ���������
    x := El^.Right;
    while x^.Left <> nil do
      x := x^.Left;
    //���������� ��� ��������
    El^.Value := x^.Value;
    //������� ���� �������
    DelEl(x^.Value, El^.Right,El)
  end;
end;

//��������� ������ (Y - ���������� �� ����� �� ������, X1 � X2 - ���������� ����� � ������)
procedure Draw(El : Tree; Y, X1, X2 : Integer; var bmp : TBitmap);
begin
  //������� �������
  bmp.Canvas.Brush.Color := BrushColor1;
  bmp.Canvas.Ellipse((X1 + X2) div 2 - Rad, Y, (X1 + X2) div 2 + Rad, Y + Rad * 2);
  bmp.Canvas.FloodFill((X1 + X2) div 2, Y + Rad, PenColor, fsBorder);
  bmp.Canvas.TextOut((X1 + X2) div 2 - 10, Y + 10, IntToStr(El^.Value));

  El^.X := (X1 + X2) div 2;
  El^.Y := Y + Rad;

  //����� ���������
  if El^.Left <> nil then
    begin
      //�����
      bmp.Canvas.MoveTo((X1 + X2) div 2,Y + Rad * 2);
      bmp.Canvas.LineTo(((X1 + X2) div 2 + X1) div 2, Y + Rad * 2 + Len);
      //���������
      Draw(El^.Left, Y + Rad * 2 + Len, X1,(X1 + X2) div 2, bmp);
    end;

  //������ ���������
  if (El^.Right <> nil) and (not El^.Thread) then
    begin
      //�����
      bmp.Canvas.MoveTo((X1 + X2) div 2, Y + Rad * 2);
      bmp.Canvas.LineTo(((X1 + X2) div 2 + X2) div 2, Y + Rad * 2 + Len);
      //���������
      Draw(El^.Right, Y + Rad * 2 + Len,(X1 + X2) div 2, X2, bmp);
    end;
end;

//������������ �����
function GoSymmetric(El : Tree; var bmp : TBitmap) : String;
begin
  //����� ������
  if El = nil then
    begin
      Sleep(500);
      Result := '0 ';
      Exit;
    end;

  //����������� ������
  if bmp.Canvas.Pixels[El^.X + 10, El^.Y - 10] <> BrushColor3 then
    begin
      bmp.Canvas.Brush.Color := BrushColor2;
      bmp.Canvas.FloodFill(El^.X + 10, El^.Y - 10, PenColor, fsBorder);
      bmp.Canvas.TextOut(El^.X - 10, El^.Y - Rad + 10, IntToStr(El^.Value));
      TreeForm.ImageTree.Picture := TPicture(bmp);
      Application.ProcessMessages;
      Sleep(500);

      bmp.Canvas.Brush.Color := BrushColor1;
      bmp.Canvas.FloodFill(El^.X + 10, El^.Y - 10, PenColor, fsBorder);
      bmp.Canvas.TextOut(El^.X - 10, El^.Y - Rad + 10, IntToStr(El^.Value));
      TreeForm.ImageTree.Picture := TPicture(bmp);
      Application.ProcessMessages;
    end
  else
    begin
      bmp.Canvas.Brush.Color := BrushColor2;
      bmp.Canvas.FloodFill(El^.X + 10, El^.Y - 10, PenColor, fsBorder);
      bmp.Canvas.TextOut(El^.X - 10, El^.Y - Rad + 10, IntToStr(El^.Value));
      TreeForm.ImageTree.Picture := TPicture(bmp);
      Application.ProcessMessages;
      Sleep(500);

      bmp.Canvas.Brush.Color := BrushColor3;
      bmp.Canvas.FloodFill(El^.X + 10, El^.Y - 10, PenColor, fsBorder);
      bmp.Canvas.TextOut(El^.X - 10, El^.Y - Rad + 10, IntToStr(El^.Value));
      TreeForm.ImageTree.Picture := TPicture(bmp);
      Application.ProcessMessages;
    end;
  Result := IntToStr(El^.Value) + ' ';

  //����� ���������
  Result := Result + GoSymmetric(El^.Left, bmp);

  //������������ �������
  bmp.Canvas.Brush.Color := BrushColor3;
  bmp.Canvas.FloodFill(El^.X + 10, El^.Y - 10, PenColor, fsBorder);
  bmp.Canvas.TextOut(El^.X - 10, El^.Y - Rad + 10, IntToStr(El^.Value));
  TreeForm.ImageTree.Picture := TPicture(bmp);
  Application.ProcessMessages;
  Sleep(500);
  Result:=Result + '(' + IntToStr(El^.Value) + ')' + ' ';

  //������ ���������
  Result := Result + GoSymmetric(El^.Right,bmp);

  //����������� ������
  if bmp.Canvas.Pixels[El^.X + 10, El^.Y - 10] <> BrushColor3 then
    begin
      bmp.Canvas.Brush.Color := BrushColor2;
      bmp.Canvas.FloodFill(El^.X + 10, El^.Y - 10, PenColor, fsBorder);
      bmp.Canvas.TextOut(El^.X - 10, El^.Y - Rad + 10, IntToStr(El^.Value));
      TreeForm.ImageTree.Picture := TPicture(bmp);
      Application.ProcessMessages;
      Sleep(500);

      bmp.Canvas.Brush.Color := BrushColor1;
      bmp.Canvas.FloodFill(El^.X + 10, El^.Y - 10, PenColor, fsBorder);
      bmp.Canvas.TextOut(El^.X - 10, El^.Y - Rad + 10, IntToStr(El^.Value));
      TreeForm.ImageTree.Picture := TPicture(bmp);
      Application.ProcessMessages;
    end
  else
    begin
      bmp.Canvas.Brush.Color := BrushColor2;
      bmp.Canvas.FloodFill(El^.X + 10, El^.Y - 10, PenColor, fsBorder);
      bmp.Canvas.TextOut(El^.X - 10, El^.Y - Rad + 10, IntToStr(El^.Value));
      TreeForm.ImageTree.Picture := TPicture(bmp);
      Application.ProcessMessages;
      Sleep(500);

      bmp.Canvas.Brush.Color := BrushColor3;
      bmp.Canvas.FloodFill(El^.X + 10, El^.Y - 10, PenColor, fsBorder);
      bmp.Canvas.TextOut(El^.X - 10, El^.Y - Rad + 10, IntToStr(El^.Value));
      TreeForm.ImageTree.Picture := TPicture(bmp);
      Application.ProcessMessages;
    end;
  Result := Result + IntToStr(El^.Value) + ' ';
end;

//������ �����
function GoDirect(El : Tree; var bmp : TBitmap) : String;
begin
  //����� ������
  if El = nil then
    begin
      Sleep(500);
      Result := '0 ';
      Exit;
    end;

  //������������ �������
  bmp.Canvas.Brush.Color := BrushColor3;
  bmp.Canvas.FloodFill(El^.X + 10, El^.Y - 10, PenColor, fsBorder);
  bmp.Canvas.TextOut(El^.X - 10, El^.Y - Rad + 10, IntToStr(El^.Value));
  TreeForm.ImageTree.Picture := TPicture(bmp);
  Application.ProcessMessages;
  Sleep(500);
  Result := Result + '(' + IntToStr(El^.Value) + ')' + ' ';

  //����� ���������
  Result := Result + GoDirect(El^.Left, bmp);

  //����������� ������
  if bmp.Canvas.Pixels[El^.X + 10, El^.Y - 10] <> BrushColor3 then
    begin
      bmp.Canvas.Brush.Color := BrushColor2;
      bmp.Canvas.FloodFill(El^.X + 10, El^.Y - 10, PenColor, fsBorder);
      bmp.Canvas.TextOut(El^.X - 10, El^.Y - Rad + 10, IntToStr(El^.Value));
      TreeForm.ImageTree.Picture := TPicture(bmp);
      Application.ProcessMessages;
      Sleep(500);

      bmp.Canvas.Brush.Color := BrushColor1;
      bmp.Canvas.FloodFill(El^.X + 10, El^.Y - 10, PenColor, fsBorder);
      bmp.Canvas.TextOut(El^.X - 10, El^.Y - Rad + 10, IntToStr(El^.Value));
      TreeForm.ImageTree.Picture := TPicture(bmp);
      Application.ProcessMessages;
    end
  else
    begin
      bmp.Canvas.Brush.Color := BrushColor2;
      bmp.Canvas.FloodFill(El^.X + 10, El^.Y - 10, PenColor, fsBorder);
      bmp.Canvas.TextOut(El^.X - 10, El^.Y - Rad + 10, IntToStr(El^.Value));
      TreeForm.ImageTree.Picture := TPicture(bmp);
      Application.ProcessMessages;
      Sleep(500);

      bmp.Canvas.Brush.Color := BrushColor3;
      bmp.Canvas.FloodFill(El^.X + 10, El^.Y - 10, PenColor, fsBorder);
      bmp.Canvas.TextOut(El^.X - 10, El^.Y - Rad + 10, IntToStr(El^.Value));
      TreeForm.ImageTree.Picture := TPicture(bmp);
      Application.ProcessMessages;
    end;
  Result := Result + IntToStr(El^.Value) + ' ';

  //������ ���������
  Result := Result + GoDirect(El^.Right, bmp);

  //����������� ������
  if bmp.Canvas.Pixels[El^.X + 10, El^.Y - 10] <> BrushColor3 then
    begin
      bmp.Canvas.Brush.Color := BrushColor2;
      bmp.Canvas.FloodFill(El^.X + 10, El^.Y - 10, PenColor, fsBorder);
      bmp.Canvas.TextOut(El^.X - 10, El^.Y - Rad + 10, IntToStr(El^.Value));
      TreeForm.ImageTree.Picture := TPicture(bmp);
      Application.ProcessMessages;
      Sleep(500);

      bmp.Canvas.Brush.Color := BrushColor1;
      bmp.Canvas.FloodFill(El^.X + 10, El^.Y - 10, PenColor, fsBorder);
      bmp.Canvas.TextOut(El^.X - 10, El^.Y - Rad + 10, IntToStr(El^.Value));
      TreeForm.ImageTree.Picture := TPicture(bmp);
      Application.ProcessMessages;
    end
  else
    begin
      bmp.Canvas.Brush.Color := BrushColor2;
      bmp.Canvas.FloodFill(El^.X + 10, El^.Y - 10, PenColor, fsBorder);
      bmp.Canvas.TextOut(El^.X - 10, El^.Y - Rad + 10, IntToStr(El^.Value));
      TreeForm.ImageTree.Picture := TPicture(bmp);
      Application.ProcessMessages;
      Sleep(500);

      bmp.Canvas.Brush.Color := BrushColor3;
      bmp.Canvas.FloodFill(El^.X + 10, El^.Y - 10, PenColor, fsBorder);
      bmp.Canvas.TextOut(El^.X - 10, El^.Y - Rad + 10, IntToStr(El^.Value));
      TreeForm.ImageTree.Picture := TPicture(bmp);
      Application.ProcessMessages;
    end;
  Result := Result + IntToStr(El^.Value) + ' ';
end;

//�������� �����
function GoBack(El : Tree; var bmp : TBitmap) : String;
begin
  //����� ������
  if El = nil then
  begin
    Sleep(500);
    Result := '0 ';
    Exit;
  end;

  //����������� ������
  if bmp.Canvas.Pixels[El^.X + 10, El^.Y - 10] <> BrushColor3 then
    begin
      bmp.Canvas.Brush.Color := BrushColor2;
      bmp.Canvas.FloodFill(El^.X + 10, El^.Y - 10, PenColor, fsBorder);
      bmp.Canvas.TextOut(El^.X - 10, El^.Y - Rad + 10, IntToStr(El^.Value));
      TreeForm.ImageTree.Picture := TPicture(bmp);
      Application.ProcessMessages;
      Sleep(500);

      bmp.Canvas.Brush.Color := BrushColor1;
      bmp.Canvas.FloodFill(El^.X + 10, El^.Y - 10, PenColor, fsBorder);
      bmp.Canvas.TextOut(El^.X - 10, El^.Y - Rad + 10, IntToStr(El^.Value));
      TreeForm.ImageTree.Picture := TPicture(bmp);
      Application.ProcessMessages;
    end
  else
    begin
      bmp.Canvas.Brush.Color := BrushColor2;
      bmp.Canvas.FloodFill(El^.X + 10, El^.Y - 10, PenColor, fsBorder);
      bmp.Canvas.TextOut(El^.X - 10, El^.Y - Rad + 10, IntToStr(El^.Value));
      TreeForm.ImageTree.Picture := TPicture(bmp);
      Application.ProcessMessages;
      Sleep(500);

      bmp.Canvas.Brush.Color := BrushColor3;
      bmp.Canvas.FloodFill(El^.X + 10, El^.Y - 10, PenColor, fsBorder);
      bmp.Canvas.TextOut(El^.X - 10, El^.Y - Rad + 10, IntToStr(El^.Value));
      TreeForm.ImageTree.Picture := TPicture(bmp);
      Application.ProcessMessages;
    end;
  Result := IntToStr(El^.Value) + ' ';

  //����� ���������
  Result := Result + GoBack(El^.Left, bmp);

  //����������� ������
  if bmp.Canvas.Pixels[El^.X + 10, El^.Y - 10] <> BrushColor3 then
    begin
      bmp.Canvas.Brush.Color := BrushColor2;
      bmp.Canvas.FloodFill(El^.X + 10, El^.Y - 10, PenColor, fsBorder);
      bmp.Canvas.TextOut(El^.X - 10, El^.Y - Rad + 10, IntToStr(El^.Value));
      TreeForm.ImageTree.Picture := TPicture(bmp);
      Application.ProcessMessages;
      Sleep(500);

      bmp.Canvas.Brush.Color := BrushColor1;
      bmp.Canvas.FloodFill(El^.X + 10, El^.Y - 10, PenColor, fsBorder);
      bmp.Canvas.TextOut(El^.X - 10, El^.Y - Rad + 10, IntToStr(El^.Value));
      TreeForm.ImageTree.Picture := TPicture(bmp);
      Application.ProcessMessages;
    end
  else
    begin
      bmp.Canvas.Brush.Color := BrushColor2;
      bmp.Canvas.FloodFill(El^.X + 10, El^.Y - 10, PenColor, fsBorder);
      bmp.Canvas.TextOut(El^.X - 10, El^.Y - Rad + 10, IntToStr(El^.Value));
      TreeForm.ImageTree.Picture := TPicture(bmp);
      Application.ProcessMessages;
      Sleep(500);

      bmp.Canvas.Brush.Color := BrushColor3;
      bmp.Canvas.FloodFill(El^.X + 10, El^.Y - 10, PenColor, fsBorder);
      bmp.Canvas.TextOut(El^.X - 10, El^.Y - Rad + 10, IntToStr(El^.Value));
      TreeForm.ImageTree.Picture := TPicture(bmp);
      Application.ProcessMessages;
    end;
  Result := Result + IntToStr(El^.Value) + ' ';

  //������ ���������
  Result := Result + GoBack(El^.Right, bmp);

  //������������ �������
  bmp.Canvas.Brush.Color := BrushColor3;
  bmp.Canvas.FloodFill(El^.X + 10, El^.Y - 10, PenColor, fsBorder);
  bmp.Canvas.TextOut(El^.X - 10, El^.Y - Rad + 10, IntToStr(El^.Value));
  TreeForm.ImageTree.Picture := TPicture(bmp);
  Application.ProcessMessages;
  Sleep(500);
  Result:=Result + '(' + IntToStr(El^.Value) + ')' + ' ';
end;





//+-----------+
//| ��������� |
//+-----------+

//�������� �����
procedure TTreeForm.FormCreate(Sender: TObject);
begin
  //������ ��� ��������
  ImageTree.Canvas.Brush.Color := BrushColor1;

  //��������� ������
  FlashTree.Enabled := False;
  AddElement.Enabled := False;
  DeleteElement.Enabled := False;
  Symmetric.Enabled := False;
  Direct.Enabled := False;
  Back.Enabled := False;
end;

//�������� ������
procedure TTreeForm.CreateTreeClick(Sender: TObject);
var
  i, j : Integer;
  InputString, buf : String;
  Elements : array [1..N] of Integer;

begin
  //�������� ��������� ��������� � �� ������ � ������
  InputString := InputBox('�������� ������', '������� �������� ������ ����� ������:', '');
  InputString := Trim(InputString);
  if InputString = '' then Exit;

  i := 1;
  j := 1;
  while (i <= Length(InputString)) do
    begin
      buf := '';

      while (InputString[i] <> ' ') and (i <= Length(InputString)) do
        begin
          if (InputString[i] in ['0'..'9']) then
            begin
              buf := buf + InputString[i];
              inc(i);
            end
          else
            begin
              ShowMessage('�������� ������ ������� �������...');
              Exit;
            end;
        end;
      while (InputString[i] = ' ') do inc(i);

      Elements[j] := StrToInt(buf);
      inc(j);
    end;
  currN := j - 1;

  //������ ������
  NowTree := nil;
  for i := 1 to currN do
    Add(Elements[i], NowTree);

  //������ ������
  bmp := TBitmap.Create;
  with bmp do
    begin
      //��������� ������
      Canvas.Font.Name := 'Times New Roman';
      Canvas.Font.Style := [fsBold];
      Canvas.Font.Size := 10;

      //��������� ���������
      Canvas.Pen.Color := PenColor;
      Canvas.Pen.Width := PenWidth;
      Canvas.Brush.Color := BrushColor1;

      //������ � ������ ��������
      Width := ImageTree.Width;
      Height := ImageTree.Height;
    end;
  //��������� ���������
  Draw(NowTree, Len, 0, ImageTree.Width, bmp);

  //���������� ������
  ImageTree.Picture := TPicture(bmp);

  //��������� ������
  FlashTree.Enabled := True;
  AddElement.Enabled := True;
  DeleteElement.Enabled := True;
  Symmetric.Enabled := True;
  Direct.Enabled := True;
  Back.Enabled := True;
end;

//�������� ������
procedure TTreeForm.FlashTreeClick(Sender: TObject);
begin
  //��������� ������
  AddElement.Enabled := False;
  Symmetric.Enabled := False;
  Direct.Enabled := False;
  Back.Enabled := False;

  //��������
  GoFlash(NowTree, bmp);
  if (NowTree^.Left = nil) and (NowTree^.Right = nil) then ShowMessage('� ������ ����� ���� �������...');

  //����������� ��������
  ImageTree.Picture := TPicture(bmp);
end;

//���������� ��������
procedure TTreeForm.AddElementClick(Sender: TObject);
var
  i : Integer;
  InputString : String;

begin
  //�������� ���������� ��������
  InputString := InputBox('���������� ��������', '������� ������� ������:', '');
  InputString := Trim(InputString);
  if InputString = '' then Exit;

  i := 1;
  while (i <= Length(InputString)) do
    begin
      if not (InputString[i] in ['0'..'9']) then
        begin
          ShowMessage('������� ������ ������ �������...');
          Exit;
        end
      else inc(i);
    end;

  //���������� ��������
  Add(StrToInt(InputString), NowTree);

  //���������� ����
  Draw(NowTree, Len, 0, ImageTree.Width, bmp);
  ImageTree.Picture := TPicture(bmp);
end;

//�������� ��������
procedure TTreeForm.DeleteElementClick(Sender: TObject);
var
  i : Integer;
  InputString : String;
  x : Tree;

begin
  //�������� ���������� ��������
  InputString := InputBox('�������� ��������', '������� ������� ������:', '');
  InputString := Trim(InputString);
  if InputString = '' then Exit;

  i := 1;
  while (i <= Length(InputString)) do
    begin
      if not (InputString[i] in ['0'..'9']) then
        begin
          ShowMessage('������� ������ ������ �������...');
          Exit;
        end
      else inc(i);
    end;

  if NowTree^.Value = StrToInt(InputString) then
    if (NowTree^.Left = nil) and ((NowTree^.Right = nil) or (NowTree^.Thread = True)) then
      begin
        //�������� ������
        NowTree := nil;

        //���������� ����
        bmp.Canvas.Brush.Color := BrushColor1;
        bmp.Canvas.FillRect(Rect(0, 0, bmp.Width, bmp.Height));
        ImageTree.Picture := TPicture(bmp);

        //��������� ������
        FlashTree.Enabled := False;
        AddElement.Enabled := False;
        DeleteElement.Enabled := False;
        Symmetric.Enabled := False;
        Direct.Enabled := False;
        Back.Enabled := False;

        ShowMessage('������ ��������� �������...');
        Exit;
      end;

  //��������� �������� �������
  New(x);
  x^.Left := NowTree;
  x^.Right := x;
  x^.Value := -1;
  NowTree := x;

  //�������� �����
  DelThread(NowTree^.Left);
  //�������� ��������
  DelEl(StrToInt(InputString), NowTree^.Left, NowTree);
  NowTree := x^.Left;

  //���������� ����
  bmp.Canvas.Brush.Color := BrushColor1;
  bmp.Canvas.FillRect(Rect(0, 0, bmp.Width, bmp.Height));
  Draw(NowTree, Len, 0, ImageTree.Width, bmp);
  //�� ������������� ��������
  if not Symmetric.Enabled then GoFlash(NowTree, bmp);

  ImageTree.Picture := TPicture(bmp);
  if (NowTree^.Left = nil) and (NowTree^.Right = nil) then ShowMessage('� ������ ����� ���� �������...');
end;

//������������ �����
procedure TTreeForm.SymmetricClick(Sender: TObject);
begin
  //��������� ������
  ShowMessage(GoSymmetric(NowTree, bmp));

  //���������� ����
  Draw(NowTree, Len, 0, ImageTree.Width, bmp);
  ImageTree.Picture := TPicture(bmp);
end;

//������ �����
procedure TTreeForm.DirectClick(Sender: TObject);
begin
  //��������� ������
  ShowMessage(GoDirect(NowTree, bmp));

  //���������� ����
  Draw(NowTree, Len, 0, ImageTree.Width, bmp);
  ImageTree.Picture := TPicture(bmp);
end;

//�������� �����
procedure TTreeForm.BackClick(Sender: TObject);
begin
  //��������� ������
  ShowMessage(GoBack(NowTree, bmp));

  //���������� ����
  Draw(NowTree, Len, 0, ImageTree.Width, bmp);
  ImageTree.Picture := TPicture(bmp);
end;

end.
