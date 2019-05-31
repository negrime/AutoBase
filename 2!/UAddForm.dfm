object FormInfo: TFormInfo
  Left = 348
  Top = 149
  BorderStyle = bsDialog
  Caption = 'Film Info'
  ClientHeight = 392
  ClientWidth = 395
  Color = clGradientInactiveCaption
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lblName: TLabel
    Left = 8
    Top = 24
    Width = 85
    Height = 13
    Caption = 'Phone number:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblDirector: TLabel
    Left = 16
    Top = 56
    Width = 72
    Height = 19
    Caption = 'Director:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LblActors: TLabel
    Left = 16
    Top = 104
    Width = 58
    Height = 19
    Caption = 'Actors:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LblSummary: TLabel
    Left = 8
    Top = 200
    Width = 82
    Height = 19
    Caption = 'Summary:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object EdName: TEdit
    Left = 104
    Top = 24
    Width = 305
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnChange = ActChangeExecute
    OnKeyPress = EdNameKeyPress
  end
  object EdDirector: TEdit
    Left = 96
    Top = 56
    Width = 289
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnChange = ActChangeExecute
  end
  object MemoActors: TMemo
    Left = 96
    Top = 96
    Width = 289
    Height = 81
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 2
    OnChange = ActChangeExecute
  end
  object MemoSummary: TMemo
    Left = 96
    Top = 200
    Width = 289
    Height = 129
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 3
    OnChange = ActChangeExecute
  end
  object btnOk: TButton
    Left = 200
    Top = 352
    Width = 89
    Height = 25
    Caption = 'OK'
    TabOrder = 4
    OnClick = btnOkClick
  end
  object btnClose: TButton
    Left = 296
    Top = 352
    Width = 89
    Height = 25
    Caption = 'Close'
    TabOrder = 5
    OnClick = btnCloseClick
  end
  object ActionList: TActionList
    Left = 16
    Top = 344
    object ActChange: TAction
      OnExecute = ActChangeExecute
    end
  end
end
