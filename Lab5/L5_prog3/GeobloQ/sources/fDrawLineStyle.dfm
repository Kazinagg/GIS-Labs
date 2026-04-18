inherited FormDrawLineStyle: TFormDrawLineStyle
  Left = 351
  Top = 215
  HelpContext = 615
  Caption = 'Line Style'
  ClientHeight = 224
  ClientWidth = 424
  StyleElements = [seFont, seClient, seBorder]
  OnCreate = FormCreate
  ExplicitWidth = 440
  ExplicitHeight = 263
  TextHeight = 16
  inherited PanelTop: TPanel
    Width = 424
    Height = 1
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 424
    ExplicitHeight = 1
  end
  inherited PanelMiddle: TPanel
    Top = 1
    Width = 424
    Height = 175
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 1
    ExplicitWidth = 424
    ExplicitHeight = 175
    object GroupBoxOptions: TGroupBox
      Left = 1
      Top = 1
      Width = 422
      Height = 173
      Align = alClient
      Caption = 'Options'
      TabOrder = 0
      object LabelColor: TLabel
        Left = 18
        Top = 116
        Width = 32
        Height = 16
        Caption = 'Color'
      end
      object LabelLineType: TLabel
        Left = 18
        Top = 30
        Width = 32
        Height = 16
        Caption = 'Type'
      end
      object LabelLineWidth: TLabel
        Left = 18
        Top = 70
        Width = 34
        Height = 16
        Caption = 'Width'
      end
      object ComboBoxLineType: TComboBox
        Left = 80
        Top = 28
        Width = 161
        Height = 22
        Style = csOwnerDrawFixed
        TabOrder = 0
        OnChange = ComboBoxLineTypeChange
        OnDrawItem = ComboBoxLineTypeDrawItem
        Items.Strings = (
          'Solid'
          'Dash'
          'Dot'
          'DashDot'
          'DashDotDot'
          'Clear'
          'InsideFrame')
      end
      object PanelColor: TPanel
        Left = 72
        Top = 111
        Width = 169
        Height = 25
        BevelOuter = bvLowered
        BorderWidth = 1
        BorderStyle = bsSingle
        TabOrder = 1
        TabStop = True
        OnEnter = PanelColorEnter
        OnExit = PanelColorExit
        object ImageColor: TImage
          Left = 2
          Top = 2
          Width = 161
          Height = 17
          Align = alClient
          OnClick = ImageColorClick
        end
        object SpeedButtonColor: TSpeedButton
          Left = 148
          Top = 0
          Width = 16
          Height = 20
          Glyph.Data = {
            96000000424D9600000000000000760000002800000008000000080000000100
            0400000000002000000000000000000000001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
            7777777777777770077777000077700000077777777777777777}
          OnClick = ImageColorClick
        end
      end
      object GroupBoxExample: TGroupBox
        Left = 256
        Top = 56
        Width = 145
        Height = 81
        Caption = 'Example'
        TabOrder = 2
        object ImageExample: TImage
          Left = 2
          Top = 18
          Width = 141
          Height = 61
          Align = alClient
        end
      end
      object SpinEditWidth: TSpinEdit
        Left = 160
        Top = 64
        Width = 81
        Height = 26
        MaxValue = 0
        MinValue = 0
        TabOrder = 3
        Value = 0
        OnChange = SpinEditWidthChange
        OnExit = SpinEditWidthExit
        OnKeyPress = SpinEditWidthKeyPress
      end
    end
  end
  inherited PanelBottom: TPanel
    Top = 176
    Width = 424
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 176
    ExplicitWidth = 424
    inherited ButtonOK: TButton
      Left = 86
      Top = 6
      ExplicitLeft = 86
      ExplicitTop = 6
    end
    inherited ButtonCancel: TButton
      Left = 198
      Top = 6
      ExplicitLeft = 198
      ExplicitTop = 6
    end
    inherited ButtonHelp: TButton
      Left = 313
      Top = 6
      ExplicitLeft = 313
      ExplicitTop = 6
    end
  end
end
