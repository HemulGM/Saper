object FormResult: TFormResult
  Left = 339
  Top = 173
  BorderStyle = bsDialog
  Caption = #1048#1075#1088#1072' '#1086#1082#1086#1085#1095#1077#1085#1072
  ClientHeight = 161
  ClientWidth = 321
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ImageWin: TImage
    Left = 0
    Top = 0
    Width = 321
    Height = 100
    Center = True
    Proportional = True
  end
  object Bevel1: TBevel
    Left = 0
    Top = 96
    Width = 321
    Height = 25
    Shape = bsTopLine
  end
  object LabelTime: TLabel
    Left = 8
    Top = 104
    Width = 37
    Height = 13
    Caption = #1042#1088#1077#1084#1103':'
  end
  object LabelCTime: TLabel
    Left = 48
    Top = 104
    Width = 3
    Height = 13
  end
  object ButtonNew: TButton
    Left = 216
    Top = 128
    Width = 97
    Height = 25
    Caption = #1053#1086#1074#1072#1103' '#1080#1075#1088#1072
    ModalResult = 1
    TabOrder = 0
  end
  object ButtonQuit: TButton
    Left = 8
    Top = 128
    Width = 97
    Height = 25
    Caption = #1042#1099#1081#1090#1080' '#1080#1079' '#1080#1075#1088#1099
    ModalResult = 2
    TabOrder = 1
  end
  object ButtonStatistics: TButton
    Left = 112
    Top = 128
    Width = 97
    Height = 25
    Caption = #1057#1090#1072#1090#1080#1089#1090#1080#1082#1072
    TabOrder = 2
    OnClick = ButtonStatisticsClick
  end
  object ListBoxStatistics: TListBox
    Left = 8
    Top = 164
    Width = 305
    Height = 129
    ItemHeight = 13
    TabOrder = 3
  end
end
