unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VclTee.TeeGDIPlus, Vcl.StdCtrls,
  Vcl.ExtCtrls, VCLTee.TeEngine, VCLTee.TeeProcs, VCLTee.Chart, Vcl.Imaging.jpeg,
  Vcl.Imaging.pngimage, VCLTee.Series, MyUnit;

type
  TMainForm = class(TForm)
    Chart1: TChart;
    Chart2: TChart;
    BackGround: TImage;
    Analyze_: TButton;
    Exit_: TButton;
    Series1: TLineSeries;
    Series2: TLineSeries;
    Series3: TLineSeries;
    Series4: TLineSeries;
    Series5: TLineSeries;
    Series6: TLineSeries;
    Series7: TLineSeries;
    Series8: TLineSeries;
    Series9: TLineSeries;
    Series10: TLineSeries;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure Exit_Click(Sender: TObject);
    procedure Analyze_Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.Analyze_Click(Sender : TObject);
var
  i, j, KPD, stand : Integer;

begin
  for i := 0 to 4 do
    for j := 1 to 5 do
    begin
      stand := 0;
      Initialize(j, i + 1);
      KPD := AllTakts(stand);
      chart1.SeriesList[i].AddXY(j, TimeNeed / KPD / j * 100);
      chart2.SeriesList[i].AddXY(j, stand);
    end;
end;

procedure TMainForm.Exit_Click(Sender : TObject);
begin
  MainForm.Close;
end;

end.
