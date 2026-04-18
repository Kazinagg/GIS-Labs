inherited fmDisplayHolesOptions: TfmDisplayHolesOptions
  Tag = 0
  Left = 480
  Top = 157
  HelpContext = 410
  Caption = 'Options of Dholes'
  ClientHeight = 496
  ClientWidth = 378
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 394
  ExplicitHeight = 535
  TextHeight = 16
  inherited PanelTop: TPanel
    Width = 378
    Height = 201
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 378
    ExplicitHeight = 201
    inherited GroupBoxAttribute: TGroupBox
      Width = 376
      Height = 159
      ExplicitWidth = 376
      ExplicitHeight = 159
      inherited LabelNumeric: TLabel
        StyleElements = [seFont, seClient, seBorder]
      end
      inherited ListBoxNumericAttributes: TListBox
        StyleElements = [seFont, seClient, seBorder]
      end
      inherited ListBoxTextAttributes: TListBox
        StyleElements = [seFont, seClient, seBorder]
      end
      object CheckBoxDrawTextOnChange: TCheckBox
        Left = 200
        Top = 125
        Width = 137
        Height = 26
        Caption = 'Draw on change'
        TabOrder = 3
        OnClick = CheckBoxDrawTextOnChangeClick
      end
    end
    inherited GroupBoxModel: TGroupBox
      Width = 376
      ExplicitWidth = 376
    end
  end
  inherited PanelMiddle: TPanel
    Top = 285
    Width = 378
    Height = 163
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 285
    ExplicitWidth = 378
    ExplicitHeight = 163
    inherited RadioGroupSize: TRadioGroup
      Width = 376
      Height = 80
      ExplicitWidth = 376
      ExplicitHeight = 80
    end
    inherited SpinEditFactor: TSpinEdit
      StyleElements = [seFont, seClient, seBorder]
    end
  end
  inherited PanelBottom: TPanel
    Top = 448
    Width = 378
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 448
    ExplicitWidth = 378
    inherited ButtonOK: TButton
      Left = 37
      ExplicitLeft = 37
    end
    inherited ButtonCancel: TButton
      Left = 158
      ExplicitLeft = 158
    end
    inherited ButtonHelp: TButton
      Left = 272
      ExplicitLeft = 272
    end
  end
  inherited RadioGroupDetails: TRadioGroup
    Top = 201
    Width = 378
    Items.Strings = (
      'Point'
      'Line')
    ExplicitTop = 201
    ExplicitWidth = 378
  end
  inherited CheckBoxAsCylinder: TCheckBox
    Left = 131
    Top = 264
    Visible = True
    ExplicitLeft = 131
    ExplicitTop = 264
  end
  inherited CheckBoxAsSphere: TCheckBox
    Top = 264
    ExplicitTop = 264
  end
end
