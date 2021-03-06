object GraphForm: TGraphForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1056#1072#1073#1086#1090#1072' '#1089' '#1086#1088#1080#1077#1085#1090#1080#1088#1086#1074#1072#1085#1085#1099#1084' '#1075#1088#1072#1092#1086#1084
  ClientHeight = 697
  ClientWidth = 1005
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object GraphImage: TImage
    Left = 328
    Top = 66
    Width = 664
    Height = 623
  end
  object InfoN: TLabel
    Left = 8
    Top = 8
    Width = 252
    Height = 25
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1101#1083#1077#1084#1077#1085#1090#1086#1074': '
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object InfoV1: TLabel
    Left = 352
    Top = 8
    Width = 217
    Height = 25
    Caption = #1042#1077#1088#1096#1080#1085#1072'-'#1080#1089#1090#1086#1095#1085#1080#1082': '
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object InfoV2: TLabel
    Left = 655
    Top = 8
    Width = 291
    Height = 25
    Caption = #1056#1077#1079#1091#1083#1100#1090#1080#1088#1091#1102#1097#1072#1103' '#1074#1077#1088#1096#1080#1085#1072': '
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object InfoGM: TLabel
    Left = 49
    Top = 58
    Width = 231
    Height = 25
    Caption = #1052#1072#1090#1088#1080#1094#1072' '#1089#1084#1077#1078#1085#1086#1089#1090#1080': '
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object InfoFI: TLabel
    Left = 40
    Top = 388
    Width = 240
    Height = 25
    Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1075#1088#1072#1092#1077': '
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object GraphMatrix: TStringGrid
    Left = 8
    Top = 97
    Width = 305
    Height = 255
    ColCount = 7
    DefaultColWidth = 42
    DefaultRowHeight = 35
    RowCount = 7
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    ParentFont = False
    TabOrder = 0
  end
  object FinalInfo: TListBox
    Left = 8
    Top = 427
    Width = 306
    Height = 200
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ItemHeight = 19
    ParentFont = False
    TabOrder = 1
  end
  object StartWork: TButton
    Left = 8
    Top = 641
    Width = 306
    Height = 48
    Caption = #1055#1086#1089#1090#1088#1086#1080#1090#1100' '#1075#1088#1072#1092
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = StartWorkClick
  end
  object N: TSpinEdit
    Left = 258
    Top = 8
    Width = 47
    Height = 31
    EditorEnabled = False
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    MaxValue = 6
    MinValue = 2
    ParentFont = False
    TabOrder = 3
    Value = 2
    OnChange = NChange
  end
  object V1: TSpinEdit
    Left = 569
    Top = 8
    Width = 47
    Height = 31
    EditorEnabled = False
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    MaxValue = 6
    MinValue = 1
    ParentFont = False
    TabOrder = 4
    Value = 1
  end
  object V2: TSpinEdit
    Left = 945
    Top = 8
    Width = 47
    Height = 31
    EditorEnabled = False
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    MaxValue = 6
    MinValue = 1
    ParentFont = False
    TabOrder = 5
    Value = 1
  end
end
