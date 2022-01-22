unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin,
  Vcl.Grids, Vcl.ExtCtrls, HelpUnit;

const
  //���������� ������� ��������
  Infinity = 100000;
  //������ ���������� ������� �����
  Rad = 20;
  //����� ���������
  ArrowLen = 25;
  //���� �������� ����� ����������� ��������� ������������ �����
  ArrowRot = Pi / 12;
  //���� �����
  PenColor = clBlack;
  //������� �����
  PenWidth = 2;
  //����� �������
  BrushColor1 = clRed;
  BrushColor2 = clGreen;
  BrushColor3 = clGray;

type
  //��� ������� ����� (��� ���������)
  TPoint = record
    Name : Byte;
    X, Y : Integer;
  end;

  //DeykstRes = array of Integer;
  //��� ������� ���������
  Matr = array of array of Integer;

  //��� �����
  TGraphForm = class(TForm)
    GraphImage: TImage;
    GraphMatrix: TStringGrid;
    FinalInfo: TListBox;
    StartWork: TButton;
    InfoN: TLabel;
    InfoV1: TLabel;
    InfoV2: TLabel;
    N: TSpinEdit;
    V1: TSpinEdit;
    V2: TSpinEdit;
    InfoGM: TLabel;
    InfoFI: TLabel;
    function FindWays : TList;
    procedure FormCreate(Sender: TObject);
    procedure StartWorkClick(Sender: TObject);
    procedure NChange(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  //�����
  GraphForm: TGraphForm;
  //������� ���������
  A : Matr;
  //������ �����
  Ways : TList;

implementation

{$R *.dfm}

//+-----------------+
//| ������ � ������ |
//+-----------------+

//��������� �������
procedure DrawPoint(var bmp : TBitmap; Point : TPoint);
begin
  //���������� ����� ��� ���������
  bmp.Canvas.Pen.Width := PenWidth;
  bmp.Canvas.Pen.Color := PenColor;

  //������
  bmp.Canvas.Ellipse(Point.X - Rad, Point.Y - Rad, Point.X + Rad, Point.Y + Rad);
  bmp.Canvas.FloodFill(Point.X, Point.Y, PenColor, fsBorder);

  //��������� ������
  bmp.Canvas.Font.Name := 'Times New Roman';
  bmp.Canvas.Font.Style := [fsBold];
  bmp.Canvas.Font.Size := 10;

  //������
  bmp.Canvas.TextOut(Point.X - 4, Point.Y - 8, IntToStr(Point.Name + 1));
end;

//��������� �����
function Draw(BmpHeight, BmpWidth : Integer; Center : Byte) : TBitmap;
var
  BmpRad : Integer;
  AngleStep : Real;
  i, j : Integer;
  Points : array of TPoint;
  X1, X2, Y1, Y2, X3, Y3 : Integer;
  Phi : Real;

begin
  //���������� ������
  SetLength(Points, High(A) + 1);

  //���������� ����� ��� ���������
  Result := TBitmap.Create;
  Result.Height := BmpHeight;
  Result.Width := BmpWidth;
  Result.Canvas.Pen.Width := PenWidth;
  Result.Canvas.Pen.Color := PenColor;

  //������ (������ �������� � �������� �����������)
  if BmpHeight < BmpWidth then
    BmpRad := (BmpHeight div 2) - Rad - 15
  else
    BmpRad := (BmpWidth div 2) - Rad - 15;
  AngleStep := 2 * Pi / (High(A));

  //���� �������
  j := 0;
  for i := 0 to High(A) do
    begin
      //����� ����� ������ ��������
      if i = Center then Continue;

      //������� ������� � ������
      Points[i].Name := i;
      Points[i].X := BmpRad + 2 * Rad + 25 + Round(BmpRad * Cos(Pi / 10 + j * AngleStep));
      Points[i].Y := BmpRad + Rad + 25 - Round(BmpRad * Sin(Pi / 10 + j * AngleStep));

      //������
      Result.Canvas.Brush.Color := BrushColor1;
      if A[i, i] <> Infinity then
        Result.Canvas.Brush.Color := BrushColor2;
      DrawPoint(Result, Points[i]);
      j := j + 1;
    end;

  //����� �����
  Points[Center].Name := Center;
  Points[Center].X := BmpRad + Rad + 25;
  Points[Center].Y := BmpRad + Rad + 25;

  //���� ���� ���� � ���� ����
  Result.Canvas.Brush.Color := BrushColor1;
  if A[Center, Center] <> Infinity then
    Result.Canvas.Brush.Color := BrushColor2;

  //������
  DrawPoint(Result, Points[Center]);

  //и���
  for i := 0 to High(A) do
    for j := 0 to High(A) do
      if A[i, j] <> Infinity then
        begin
          //�������������� ������� � ����������� �� ������
          if Abs(Points[i].Y - Points[j].Y) < Rad * 2 then
            begin
              Y1 := Points[i].Y;
              Y2 := Points[j].Y;
              //���� �� ������ ���� ������� � ������� ���� ������
              if Points[i].X < Points[j].X then
                begin
                  X1 := Points[i].X + Rad;
                  X2 := Points[j].X - Rad
                end
              else
                begin
                  X1 := Points[i].X - Rad;
                  X2 := Points[j].X + Rad
                end;
            end
          else
            //������� �������� �� ������
            begin
              X1 := Points[i].X;
              X2 := Points[j].X;
              //���� �� ������� ���� �������� � �������� ���� �������
              if Points[i].Y < Points[j].Y then
                begin
                  Y1 := Points[i].Y + Rad;
                  Y2 := Points[j].Y - Rad
                end
              else
                begin
                  Y1 := Points[i].Y - Rad;
                  Y2 := Points[j].Y + Rad
                end;
            end;

          //���� �� ���� � ���� ����
          if i <> j then
            begin
              Result.Canvas.MoveTo(X1, Y1);
              Result.Canvas.LineTo(X2, Y2);

              //��������� ����� � �������� ����������� � ������� � �������������� �������
              Phi := ArcTan(Abs(Y1 - Y2) / Abs(X1 - X2));

              //���������� ��������
              if Y2 - Y1 < 0 then
                Phi := -Phi;
              if X2 - X1 > 0 then
                Phi := Pi - Phi;

              //���� ���������
              X1 := X2 + Round(ArrowLen * Cos(Phi - ArrowRot));
              Y1 := Y2 - Round(ArrowLen * Sin(Phi - ArrowRot));
              Result.Canvas.LineTo(X1, Y1);
              X3 := X2 + Round(ArrowLen * Cos(Phi + ArrowRot));
              Y3 := Y2 - Round(ArrowLen * Sin(Phi + ArrowRot));
              Result.Canvas.MoveTo(X2, Y2);
              Result.Canvas.LineTo(X3, Y3);
              Result.Canvas.LineTo(X1, Y1);

              //���������� ������
              X1 := X2 + Round(ArrowLen * 2 * Cos(Phi));
              Y1 := Y2 - Round(ArrowLen * 2 * Sin(Phi));

              //��������� ������
              Result.Canvas.Font.Name := 'Times New Roman';
              Result.Canvas.Font.Style := [fsBold];
              Result.Canvas.Font.Size := 10;
              Result.Canvas.Brush.Color := BrushColor3;

              //������
              Result.Canvas.TextOut(X1, Y1, IntToStr(A[i, j]));
              Result.Canvas.Brush.Color := BrushColor1;
            end
          else
            //���� � ���� ����
            begin
              //��������� ������
              Result.Canvas.Font.Name := 'Times New Roman';
              Result.Canvas.Font.Style := [fsBold];
              Result.Canvas.Font.Size := 10;
              Result.Canvas.Brush.Color := BrushColor3;

              //������
              Result.Canvas.TextOut(Points[i].X - 2 * Rad, Points[i].Y - Rad div 2, IntToStr(A[i, j]));
              Result.Canvas.Brush.Color := BrushColor1;
            end;
        end;
end;

//����� �����
function GraphCenter(FloidRes : Matr) : Byte;
var
  MaxWay : array of Integer;
  i, j : Integer;

begin
  SetLength(MaxWay, High(A) + 1);

  //����� ����� ������� ����� ��� ������ �������
  for i := 0 to High(A) do
    begin
      MaxWay[i] := FloidRes[0, i];
      for j := 0 to High(A) do
        if MaxWay[i] < FloidRes[j, i] then
          MaxWay[i] := FloidRes[j, i];
    end;

  //���������� �� ���������� �����
  Result := 0;
  for i := 0 to High(A) do
    if MaxWay[i] < MaxWay[Result] then
      Result := i;
end;

//�������� ������
function Floid : Matr;
var
  i, j, k : Integer;

begin
  SetLength(Result, High(A) + 1, High(A) + 1);
  //��������� �������� �� �������
  for i := 0 to High(A) do
    for j := 0 to High(A) do
      Result[i, j] := A[i, j];

  //��� ��������
  for k := 0 to High(A) do
    for i := 0 to High(A) do
      for j := 0 to High(A) do
        if Result[i, k] + Result[k, j] < Result[i, j] then
          Result[i, j] := Result[i, k] + Result[k, j];
end;

//�������� ��������
{function Deykstra(start : Byte; out Way : DeykstRes) : DeykstRes;
var
  Used : Mn;
  i, j, min : integer;

begin
  Used := [];
  //����������� ����������
  SetLength(Result, High(A) + 1);
  SetLength(Way, High(A) + 1);
  for i := 0 to High(Result) do
    begin
      //������ ����
      Result[i] := A[start, i];
      Way[i] := start;
    end;

  //���������� �� ������ �������
  for j := 0 to High(A) do
    begin
      Used := Used + [start];
      //���������� �� ������� ������ ������� �������
      for i := 0 to High(Result) do
        //���� ��� �� ���� � �������
        if not (i in Used) then
          if Result[i] > Result[start] + A[start, i] then
            begin
              Result[i] := Result[start] + A[start, i];
              Way[i] := start;
            end;

      //��������� �������  - ����������� � ��, ������� ��� �� ��������
      min := MaxInt;
      for i := 0 to High(Result) do
        if not (i in Used) and (Result[i] < min) then
          begin
            min := Result[i];
            start := i;
          end;
    end;
end;}

//����� ����� ����� ���������
function TGraphForm.FindWays : TList;
var
  Src, Dest : Integer;
  NullWay : TWay;

//����������� �����
procedure FindRoute(V : Integer; Way : TWay);
var
  i : Integer;
  NewWay : TWay;

begin
  //����� ������ �������
  if V = Dest then
    AddToSortedList(Way, Ways)
  else
    //���� � ��������� �������, ���� ��������
    for i := 0 to High(A[V]) do
      if (A[V, i] <> Infinity) and not (i in Way.Used) then
        begin
          NewWay.Used := Way.Used + [i];
          NewWay.Name := Way.Name + IntToStr(i + 1) + ' ';
          NewWay.Cost := Way.Cost + A[V, i];
          FindRoute(i, NewWay);
        end;
end;

begin
  //���������
  Ways := NewList;
  FinalInfo.Clear;

  //�������-��������
  Src := V1.Value - 1;
  //�������������� �������
  Dest := V2.Value - 1;

  with NullWay do
    begin
      Name := IntToStr(Src + 1) + ' ';
      Cost := 0;
      Used := [Src];
    end;

  //����� ����
  FindRoute(Src, NullWay);

  //���� ���� �� �������
  if (A[V1.Value - 1, V2.Value - 1] = Infinity) and (Ways^.Next = nil) then
    begin
      with NullWay do
        begin
          Name := IntToStr(V1.Value) + ' ' + IntToStr(V2.Value) + ' ';
          Cost := 0;
          Used := [V1.Value - 1] + [V2.Value - 1];
        end;
      AddToSortedList(NullWay, Ways);
    end;

  //���������
  Result := Ways;
end;





//+-----------+
//| ��������� |
//+-----------+

//�������� �����
procedure TGraphForm.FormCreate(Sender: TObject);
var
  i, j : Integer;

begin
  //���������
  GraphImage.Canvas.Brush.Color := clWhite;
  FinalInfo.Clear;

  //�������� � ���������� �������
  N.Value := N.MaxValue;
  GraphMatrix.RowCount := N.Value + 1;
  GraphMatrix.ColCount:= N.Value + 1;

  for i := 1 to GraphMatrix.ColCount - 1 do
    GraphMatrix.Cells[i, 0] := 'V' + IntToStr(i);
  for i := 1 to GraphMatrix.RowCount - 1 do
    GraphMatrix.Cells[0, i] := 'V' + IntToStr(i);

  for i := 1 to GraphMatrix.ColCount - 1 do
    for j := 1 to GraphMatrix.ColCount - 1 do
      GraphMatrix.Cells[j, i] := '1';
end;

//��������� �����������
procedure TGraphForm.NChange(Sender: TObject);
begin
  //������� �������
  GraphMatrix.RowCount := N.Value + 1;
  GraphMatrix.ColCount:= N.Value + 1;

  //������������� �������� V1, V2, N
  V1.MaxValue := N.Value;
  V2.MaxValue := N.Value;
  if V1.Value > N.Value then
    V1.Value := N.Value;
  if V2.Value > N.Value then
    V2.Value := N.Value;

end;

//������ ������
procedure TGraphForm.StartWorkClick(Sender: TObject);
var
  i, j : Integer;
  Rez : Integer;
  Code : Integer;
  x, Ways : TList;
  Center : Byte;

begin
  //������� �������� �������
  SetLength(A, GraphMatrix.RowCount - 1, GraphMatrix.RowCount - 1);

  //���������� �������
  for i := 1 to GraphMatrix.RowCount - 1 do
    for j := 1 to GraphMatrix.ColCount - 1 do
      begin
        //�������� ������������ �����
        Val(GraphMatrix.Cells[j, i], Rez, Code);
        if Code = 0 then
          if Rez = 0 then
            A[i - 1, j - 1] := Infinity
          else
            A[i - 1, j - 1] := Rez
        else
          begin
            ShowMessage('������������ �������� � ������ (' + IntToStr(i) + ',' + IntToStr(j) + ')');
            Exit;
          end;
      end;

  //���� �� ��� � ������ �������
  if V1.Value = V2.Value then
    begin
      FinalInfo.Clear;
      FinalInfo.Items.Add('�� ��� � �������� �������!');
    end
  //�����
  else
    begin
      //����� ���� �����
      Ways := FindWays;

      //����� ���� �����
      x := Ways^.Next;
      i := 1;
      FinalInfo.Items.Add('���� �� ����������� ����:');
      while x <> nil do
        begin
          FinalInfo.Items.Add(IntToStr(i) + ': ' + x^.Way.Name + '(' + IntToStr(x^.Way.Cost) + ')');
          x := x^.Next;
          inc(i);
        end;
      FinalInfo.Items.Add('');

      //����� �������� ����
      x := Ways^.Next;
      FinalInfo.Items.Add('����� �������� ����: ' + x^.Way.Name + '(' + IntToStr(x^.Way.Cost) + ')');

      //����� ������� ����
      x := Ways;
      while x^.Next <> nil do x := x^.Next;
      FinalInfo.Items.Add('����� ������� ����: ' + x^.Way.Name + '(' + IntToStr(x^.Way.Cost) + ')');
    end;

  //����� �����
  Center := GraphCenter(Floid);
  FinalInfo.Items.Add('');
  FinalInfo.Items.Add('����� �����: ' + IntToStr(Center + 1));

  //������ ����
  GraphImage.Picture := TPicture(Draw(GraphImage.Height, GraphImage.Width, Center));
end;

end.
