inherited fmDisplayMesh3DOptions: TfmDisplayMesh3DOptions
  Left = 537
  Top = 155
  HelpContext = 492
  Caption = 'Mesh 3D Options'
  ClientHeight = 445
  StyleElements = [seFont, seClient, seBorder]
  ExplicitHeight = 484
  TextHeight = 16
  inherited PanelTop: TPanel
    StyleElements = [seFont, seClient, seBorder]
    inherited GroupBoxAttribute: TGroupBox
      inherited LabelNumeric: TLabel
        StyleElements = [seFont, seClient, seBorder]
      end
      inherited ListBoxNumericAttributes: TListBox
        StyleElements = [seFont, seClient, seBorder]
      end
      inherited ListBoxTextAttributes: TListBox
        StyleElements = [seFont, seClient, seBorder]
      end
    end
  end
  inherited PanelMiddle: TPanel
    Height = 144
    StyleElements = [seFont, seClient, seBorder]
    ExplicitHeight = 144
    inherited SpinEditFactor: TSpinEdit
      StyleElements = [seFont, seClient, seBorder]
    end
    object GroupBoxFeature: TGroupBox
      Left = 1
      Top = 73
      Width = 383
      Height = 70
      Align = alClient
      Caption = 'Show'
      TabOrder = 2
      object CheckBoxIsosurface: TCheckBox
        Left = 24
        Top = 32
        Width = 17
        Height = 17
        TabOrder = 0
        OnClick = CheckBoxIsosurfaceClick
      end
      object ButtonIsosurface: TButton
        Left = 48
        Top = 24
        Width = 137
        Height = 25
        HelpContext = 496
        Caption = 'Isosurfaces...'
        TabOrder = 3
        OnClick = ButtonIsosurfaceClick
      end
      object CheckBoxVectors: TCheckBox
        Left = 208
        Top = 32
        Width = 17
        Height = 17
        Hint = 'Features of vectors'
        HelpContext = 400
        Caption = '&Vector...'
        Enabled = False
        TabOrder = 2
        OnClick = CheckBoxVectorsClick
      end
      object ButtonVectors: TButton
        Left = 232
        Top = 24
        Width = 137
        Height = 25
        HelpContext = 498
        Caption = 'Vectors 3D...'
        TabOrder = 1
      end
    end
  end
  inherited PanelBottom: TPanel
    Top = 397
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 397
  end
end
