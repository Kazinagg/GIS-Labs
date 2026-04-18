inherited FormDisplayGrid2DOptions: TFormDisplayGrid2DOptions
  Left = 447
  Top = 140
  HelpContext = 470
  Caption = 'Grid 2D Options'
  ClientHeight = 468
  ClientWidth = 390
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 406
  ExplicitHeight = 507
  TextHeight = 16
  inherited PanelTop: TPanel
    Width = 390
    Height = 185
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 390
    ExplicitHeight = 185
    inherited GroupBoxAttribute: TGroupBox
      Width = 388
      Height = 143
      ExplicitWidth = 388
      ExplicitHeight = 143
      inherited LabelNumeric: TLabel
        StyleElements = [seFont, seClient, seBorder]
      end
      inherited ListBoxNumericAttributes: TListBox
        StyleElements = [seFont, seClient, seBorder]
      end
      inherited ListBoxTextAttributes: TListBox
        TabOrder = 3
        StyleElements = [seFont, seClient, seBorder]
      end
      object CheckBoxByVertices: TCheckBox
        Left = 216
        Top = 119
        Width = 137
        Height = 17
        Caption = 'By centers'
        Checked = True
        State = cbChecked
        TabOrder = 1
        OnClick = CheckBoxByVerticesClick
      end
      object CheckBoxAsHeight: TCheckBox
        Left = 37
        Top = 119
        Width = 137
        Height = 17
        Caption = 'As height'
        Checked = True
        State = cbChecked
        TabOrder = 4
        OnClick = CheckBoxAsHeightClick
      end
    end
    inherited GroupBoxModel: TGroupBox
      Width = 388
      ExplicitWidth = 388
    end
  end
  inherited PanelMiddle: TPanel
    Top = 278
    Width = 390
    Height = 142
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 278
    ExplicitWidth = 390
    ExplicitHeight = 142
    inherited RadioGroupSize: TRadioGroup
      Width = 388
      Visible = False
      ExplicitWidth = 388
    end
    inherited SpinEditFactor: TSpinEdit
      Left = 126
      Top = 27
      StyleElements = [seFont, seClient, seBorder]
      Value = 5
      ExplicitLeft = 126
      ExplicitTop = 27
    end
    object GroupBoxFeature: TGroupBox
      Left = 1
      Top = 73
      Width = 388
      Height = 68
      Align = alClient
      Caption = 'Show'
      TabOrder = 2
      object ButtonIsolines: TButton
        Left = 47
        Top = 24
        Width = 137
        Height = 25
        HelpContext = 495
        Caption = 'Isolines...'
        TabOrder = 0
      end
      object CheckBoxIsolines: TCheckBox
        Left = 24
        Top = 32
        Width = 17
        Height = 17
        TabOrder = 1
        OnClick = CheckBoxIsolinesClick
      end
      object ButtonVectors: TButton
        Left = 232
        Top = 24
        Width = 137
        Height = 25
        HelpContext = 498
        Caption = 'Vectors 2D...'
        TabOrder = 2
      end
      object CheckBoxVectors: TCheckBox
        Left = 208
        Top = 32
        Width = 17
        Height = 17
        Hint = 'Features of vectors'
        HelpContext = 400
        Caption = '&Vector...'
        TabOrder = 3
        OnClick = CheckBoxVectorsClick
      end
    end
  end
  inherited PanelBottom: TPanel
    Top = 420
    Width = 390
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 420
    ExplicitWidth = 390
    inherited ButtonOK: TButton
      Left = 41
      ExplicitLeft = 41
    end
    inherited ButtonCancel: TButton
      Left = 162
      ExplicitLeft = 162
    end
    inherited ButtonHelp: TButton
      Left = 276
      ExplicitLeft = 276
    end
  end
  inherited RadioGroupDetails: TRadioGroup
    Top = 185
    Width = 390
    Height = 93
    ItemIndex = 2
    ExplicitTop = 185
    ExplicitWidth = 390
    ExplicitHeight = 93
  end
  inherited CheckBoxAsCylinder: TCheckBox
    Top = 248
    ExplicitTop = 248
  end
  inherited CheckBoxAsSphere: TCheckBox
    Top = 248
    Visible = False
    ExplicitTop = 248
  end
end
