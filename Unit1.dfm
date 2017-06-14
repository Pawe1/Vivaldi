object Form1: TForm1
  Left = 278
  Top = 106
  Width = 352
  Height = 261
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button2: TButton
    Left = 8
    Top = 32
    Width = 89
    Height = 25
    Caption = 'Refresh'
    TabOrder = 0
    OnClick = Button2Click
  end
  object GroupBox1: TGroupBox
    Left = 104
    Top = 8
    Width = 217
    Height = 57
    Caption = 'Window class'
    TabOrder = 1
    object Edit1: TEdit
      Left = 8
      Top = 24
      Width = 201
      Height = 21
      TabOrder = 0
      Text = 'Chrome_WidgetWin_1'
    end
  end
  object GroupBox2: TGroupBox
    Left = 16
    Top = 160
    Width = 153
    Height = 57
    Caption = 'Point'
    TabOrder = 2
    object SpinEdit1: TSpinEdit
      Left = 8
      Top = 24
      Width = 65
      Height = 22
      MaxValue = 9999
      MinValue = 0
      TabOrder = 0
      Value = 10
    end
    object SpinEdit2: TSpinEdit
      Left = 80
      Top = 24
      Width = 65
      Height = 22
      MaxValue = 9999
      MinValue = 0
      TabOrder = 1
      Value = 63
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 72
    Width = 329
    Height = 81
    Caption = 'Window list'
    TabOrder = 3
    object ListBox1: TListBox
      Left = 8
      Top = 16
      Width = 313
      Height = 57
      ItemHeight = 13
      TabOrder = 0
      OnClick = ListBox1Click
    end
  end
  object Timer1: TTimer
    OnTimer = ListBox1Click
  end
end
