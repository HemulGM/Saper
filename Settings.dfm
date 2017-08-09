object FormSet: TFormSet
  Left = 241
  Top = 178
  BorderStyle = bsDialog
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 249
  ClientWidth = 297
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LabelGraphics: TLabel
    Left = 8
    Top = 120
    Width = 128
    Height = 13
    Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1086#1092#1086#1088#1084#1083#1077#1085#1080#1077':'
  end
  object RadioGroupDif: TRadioGroup
    Left = 8
    Top = 8
    Width = 281
    Height = 105
    Caption = #1057#1083#1086#1078#1085#1086#1089#1090#1100
    Items.Strings = (
      #1051#1077#1075#1082#1086
      #1053#1086#1088#1084#1072#1083#1100#1085#1086
      #1057#1083#1086#1078#1085#1086
      'Hardcore')
    TabOrder = 0
  end
  object ButtonApply: TButton
    Left = 88
    Top = 216
    Width = 97
    Height = 25
    Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
    TabOrder = 1
    OnClick = ButtonApplyClick
  end
  object ButtonClose: TButton
    Left = 192
    Top = 216
    Width = 99
    Height = 25
    Caption = #1047#1072#1088#1082#1099#1090#1100
    TabOrder = 2
    OnClick = ButtonCloseClick
  end
  object ListBoxGraphics: TListBox
    Left = 8
    Top = 136
    Width = 281
    Height = 73
    ItemHeight = 13
    TabOrder = 3
    OnDblClick = ListBoxGraphicsDblClick
  end
end
