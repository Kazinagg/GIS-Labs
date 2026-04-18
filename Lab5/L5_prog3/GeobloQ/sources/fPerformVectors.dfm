inherited FormPerformVectors: TFormPerformVectors
  Tag = 1
  Left = 403
  Top = 228
  HelpContext = 498
  Caption = 'Features of Vectors'
  ClientHeight = 165
  ClientWidth = 389
  ExplicitWidth = 413
  ExplicitHeight = 229
  TextHeight = 16
  inherited PanelTop: TPanel
    Width = 389
    Height = 1
    ExplicitWidth = 389
    ExplicitHeight = 1
  end
  inherited PanelMiddle: TPanel
    Top = 1
    Width = 389
    Height = 116
    ExplicitTop = 1
    ExplicitWidth = 389
    ExplicitHeight = 116
    object LabelShowEvery: TLabel
      Left = 80
      Top = 72
      Width = 83
      Height = 16
      Caption = 'Display every'
    end
    object LabelLengthFactor: TLabel
      Left = 80
      Top = 32
      Width = 76
      Height = 16
      Caption = 'Length factor'
    end
    object SpinEditDisplayEvery: TSpinEdit
      Left = 232
      Top = 64
      Width = 49
      Height = 26
      MaxValue = 10
      MinValue = 1
      TabOrder = 0
      Value = 1
    end
    object SpinEditLengthFactor: TSpinEdit
      Left = 232
      Top = 24
      Width = 49
      Height = 26
      MaxValue = 10
      MinValue = 1
      TabOrder = 1
      Value = 1
    end
  end
  inherited PanelBottom: TPanel
    Top = 117
    Width = 389
    ExplicitTop = 117
    ExplicitWidth = 389
    inherited ButtonOK: TButton
      Left = 19
      ExplicitLeft = 19
    end
    inherited ButtonCancel: TButton
      Left = 140
      ExplicitLeft = 140
    end
    inherited ButtonHelp: TButton
      Left = 262
      ExplicitLeft = 262
    end
  end
end
