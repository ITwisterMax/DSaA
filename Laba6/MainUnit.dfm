object TreeForm: TTreeForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1056#1072#1073#1086#1090#1072' '#1089' '#1073#1080#1085#1072#1088#1085#1099#1084' '#1076#1077#1088#1077#1074#1086#1084
  ClientHeight = 591
  ClientWidth = 1195
  Color = clWhite
  DoubleBuffered = True
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
  object ImageTree: TImage
    Left = 15
    Top = 7
    Width = 913
    Height = 576
    ParentCustomHint = False
  end
  object CreateTree: TButton
    Left = 934
    Top = 8
    Width = 250
    Height = 50
    ParentCustomHint = False
    Caption = #1057#1086#1079#1076#1072#1090#1100' '#1076#1077#1088#1077#1074#1086
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = CreateTreeClick
  end
  object FlashTree: TButton
    Left = 934
    Top = 96
    Width = 250
    Height = 50
    ParentCustomHint = False
    Caption = #1055#1088#1086#1096#1080#1090#1100' '#1076#1077#1088#1077#1074#1086
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = FlashTreeClick
  end
  object Symmetric: TButton
    Left = 934
    Top = 360
    Width = 250
    Height = 50
    ParentCustomHint = False
    Caption = #1057#1080#1084#1084#1077#1090#1088#1080#1095#1085#1099#1081' '#1086#1073#1093#1086#1076
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = SymmetricClick
  end
  object Direct: TButton
    Left = 934
    Top = 448
    Width = 250
    Height = 50
    ParentCustomHint = False
    Caption = #1055#1088#1103#1084#1086#1081' '#1086#1073#1093#1086#1076
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = DirectClick
  end
  object Back: TButton
    Left = 934
    Top = 534
    Width = 250
    Height = 50
    ParentCustomHint = False
    Caption = #1050#1086#1085#1094#1077#1074#1086#1081' '#1086#1073#1093#1086#1076
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnClick = BackClick
  end
  object AddElement: TButton
    Left = 934
    Top = 184
    Width = 250
    Height = 50
    ParentCustomHint = False
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1101#1083#1077#1084#1077#1085#1090
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = AddElementClick
  end
  object DeleteElement: TButton
    Left = 934
    Top = 272
    Width = 250
    Height = 50
    ParentCustomHint = False
    Caption = #1059#1076#1072#1083#1080#1090#1100' '#1101#1083#1077#1084#1077#1085#1090
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = DeleteElementClick
  end
end
