object MainForm: TMainForm
  Left = 0
  Top = 0
  Align = alCustom
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = #1055#1083#1072#1085' '#1047#1076#1072#1085#1080#1103' | Made by ITwisterMax'
  ClientHeight = 612
  ClientWidth = 812
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object TextX: TLabel
    Left = 64
    Top = 542
    Width = 70
    Height = 46
    Caption = 'X = '
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -40
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object TextY: TLabel
    Left = 330
    Top = 542
    Width = 67
    Height = 46
    Caption = 'Y = '
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -40
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object Generate_: TButton
    Left = 592
    Top = 35
    Width = 195
    Height = 50
    Caption = 'Generate'
    DoubleBuffered = True
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -33
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentDoubleBuffered = False
    ParentFont = False
    TabOrder = 0
    OnClick = Generate_Click
  end
  object Find_: TButton
    Left = 592
    Top = 135
    Width = 195
    Height = 50
    Caption = 'Find '
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -33
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 1
    OnClick = Find_Click
  end
  object Load_: TButton
    Left = 592
    Top = 236
    Width = 195
    Height = 50
    Caption = 'Load '
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -33
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 2
    OnClick = Load_Click
  end
  object Save_: TButton
    Left = 592
    Top = 338
    Width = 195
    Height = 50
    Caption = 'Save'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -33
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 3
    OnClick = Save_Click
  end
  object Draw_: TButton
    Left = 592
    Top = 438
    Width = 195
    Height = 50
    Caption = 'Draw'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -33
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 4
    OnClick = Draw_Click
  end
  object MazeX: TSpinEdit
    Left = 132
    Top = 539
    Width = 121
    Height = 49
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -33
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    MaxValue = 26
    MinValue = 2
    ParentFont = False
    TabOrder = 6
    Value = 26
  end
  object MazeY: TSpinEdit
    Left = 395
    Top = 539
    Width = 121
    Height = 49
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -33
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    MaxValue = 22
    MinValue = 2
    ParentFont = False
    TabOrder = 7
    Value = 22
  end
  object ScrollBox1: TScrollBox
    Left = 32
    Top = 35
    Width = 529
    Height = 453
    Color = clWhite
    ParentColor = False
    TabOrder = 8
    object BackBuffer: TImage
      Left = 3
      Top = 4
      Width = 487
      Height = 438
      Stretch = True
    end
  end
  object Exit_: TButton
    Left = 592
    Top = 538
    Width = 195
    Height = 50
    Caption = 'Exit '
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -33
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 5
    OnClick = Exit_Click
  end
  object HelpVoice2_: TMediaPlayer
    Left = 0
    Top = -16
    Width = 253
    Height = 30
    AutoOpen = True
    FileName = 'Voice2.mp3'
    Visible = False
    TabOrder = 9
  end
end
