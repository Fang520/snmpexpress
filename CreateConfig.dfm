object FormCreateConfig: TFormCreateConfig
  Left = 534
  Top = 217
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Create Deploy Config'
  ClientHeight = 327
  ClientWidth = 290
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 115
    Height = 13
    Caption = 'Network Element Type *'
  end
  object Label2: TLabel
    Left = 24
    Top = 64
    Width = 130
    Height = 13
    Caption = 'Network Element Release *'
  end
  object Label3: TLabel
    Left = 24
    Top = 112
    Width = 53
    Height = 13
    Caption = 'Description'
  end
  object Label4: TLabel
    Left = 24
    Top = 232
    Width = 115
    Height = 13
    Caption = 'Select MIB zip to upload'
  end
  object btnSelect: TSpeedButton
    Left = 248
    Top = 248
    Width = 17
    Height = 17
    Caption = '...'
    OnClick = btnSelectClick
  end
  object edtType: TEdit
    Left = 24
    Top = 32
    Width = 241
    Height = 21
    TabOrder = 0
  end
  object edtRelease: TEdit
    Left = 24
    Top = 80
    Width = 241
    Height = 21
    TabOrder = 1
  end
  object edtDesc: TMemo
    Left = 24
    Top = 128
    Width = 241
    Height = 89
    TabOrder = 2
  end
  object edtPath: TEdit
    Left = 24
    Top = 248
    Width = 217
    Height = 21
    TabOrder = 3
  end
  object btnCreate: TButton
    Left = 192
    Top = 288
    Width = 75
    Height = 25
    Caption = 'Create'
    TabOrder = 4
    OnClick = btnCreateClick
  end
  object OpenDialog1: TOpenDialog
    Filter = 'zip|*.zip'
    Left = 128
    Top = 32
  end
end
