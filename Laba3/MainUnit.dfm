object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = #1052#1077#1085#1102' '#1089#1083#1086#1074#1072#1088#1103
  ClientHeight = 695
  ClientWidth = 650
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -18
  Font.Name = 'Times New Roman'
  Font.Style = [fsBold, fsItalic]
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = StartWork
  PixelsPerInch = 120
  TextHeight = 21
  object Info: TRichEdit
    Left = 8
    Top = 8
    Width = 350
    Height = 681
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    Lines.Strings = (
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      '')
    MaxLength = 100
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    Zoom = 100
  end
  object Print: TButton
    Left = 367
    Top = 8
    Width = 268
    Height = 41
    Caption = #1042#1099#1074#1077#1089#1090#1080' '#1089#1086#1076#1077#1088#1078#1080#1084#1086#1077' '#1089#1083#1086#1074#1072#1088#1103
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 1
    OnClick = PrintClick
  end
  object Find: TButton
    Left = 367
    Top = 72
    Width = 268
    Height = 41
    Caption = #1053#1072#1081#1090#1080' '#1090#1077#1088#1084#1080#1085'/'#1087#1086#1076#1090#1077#1088#1084#1080#1085
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 2
    OnClick = FindClick
  end
  object SortA: TButton
    Left = 367
    Top = 136
    Width = 268
    Height = 41
    Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1087#1086' '#1072#1083#1092#1072#1074#1080#1090#1091
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 3
    OnClick = SortAClick
  end
  object SortP: TButton
    Left = 367
    Top = 200
    Width = 268
    Height = 41
    Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1087#1086' '#1089#1090#1088#1072#1085#1080#1094#1072#1084
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 4
    OnClick = SortPClick
  end
  object Add: TButton
    Left = 367
    Top = 264
    Width = 268
    Height = 41
    Caption = ' '#1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1077#1088#1084#1080#1085'/'#1087#1086#1076#1090#1077#1088#1084#1080#1085
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 5
    OnClick = AddClick
  end
  object AddP: TButton
    Left = 367
    Top = 328
    Width = 268
    Height = 41
    Caption = ' '#1044#1086#1073#1072#1074#1080#1090#1100' '#1085#1086#1084#1077#1088' '#1089#1090#1088#1072#1085#1080#1094#1099
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 6
    OnClick = AddPClick
  end
  object Del: TButton
    Left = 367
    Top = 392
    Width = 268
    Height = 41
    Caption = #1059#1076#1072#1083#1080#1090#1100' '#1090#1077#1088#1084#1080#1085'/'#1087#1086#1076#1090#1077#1088#1084#1080#1085
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 7
    OnClick = DelClick
  end
  object DelP: TButton
    Left = 367
    Top = 456
    Width = 268
    Height = 41
    Caption = #1059#1076#1072#1083#1080#1090#1100' '#1085#1086#1084#1077#1088' '#1089#1090#1088#1072#1085#1080#1094#1099
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 8
    OnClick = DelPClick
  end
  object Edit: TButton
    Left = 367
    Top = 520
    Width = 268
    Height = 41
    Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1090#1077#1088#1084#1080#1085'/'#1087#1086#1076#1090#1077#1088#1084#1080#1085
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 9
    OnClick = EditClick
  end
  object EditP: TButton
    Left = 367
    Top = 584
    Width = 268
    Height = 41
    Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1085#1086#1084#1077#1088' '#1089#1090#1088#1072#1085#1080#1094#1099
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 10
    OnClick = EditPClick
  end
  object Leave: TButton
    Left = 367
    Top = 648
    Width = 268
    Height = 41
    Caption = #1042#1099#1081#1090#1080' '#1080#1079' '#1084#1077#1085#1102' '#1089#1083#1086#1074#1072#1088#1103
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 11
    OnClick = LeaveClick
  end
end
