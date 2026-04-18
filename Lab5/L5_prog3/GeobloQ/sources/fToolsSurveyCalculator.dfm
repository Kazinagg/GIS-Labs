inherited FormToolsSurveyCalculator: TFormToolsSurveyCalculator
  Left = 310
  Top = 198
  Caption = 'Survey Calculator'
  ClientHeight = 428
  ClientWidth = 672
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 688
  ExplicitHeight = 467
  TextHeight = 16
  inherited PanelTop: TPanel
    Width = 672
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 664
  end
  inherited PanelMiddle: TPanel
    Width = 672
    Height = 370
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 664
    ExplicitHeight = 345
    inherited PageControl: TPageControl
      Width = 662
      Height = 360
      ActivePage = TabSheetLossesAndDilutions
      ExplicitWidth = 654
      ExplicitHeight = 335
      object TabSheetStrippingFactor: TTabSheet
        Caption = 'Stripping Factor'
        object StaticTextStrippingFactor: TStaticText
          Left = 0
          Top = 0
          Width = 168
          Height = 30
          Align = alTop
          Alignment = taCenter
          BorderStyle = sbsSunken
          Caption = 'Stripping Factor'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -23
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
      object TabSheetLossesAndDilutions: TTabSheet
        Caption = 'Losses and Dilutions'
        ImageIndex = 1
        object Image1: TImage
          Left = 9
          Top = 49
          Width = 263
          Height = 224
        end
        object Label2: TLabel
          Left = 296
          Top = 64
          Width = 41
          Height = 16
          Caption = 'Label1'
        end
        object Label1: TLabel
          Left = 296
          Top = 112
          Width = 41
          Height = 16
          Caption = 'Label1'
        end
        object LabelDilution: TLabel
          Left = 296
          Top = 192
          Width = 44
          Height = 16
          Caption = 'Dilution'
        end
        object Label3: TLabel
          Left = 296
          Top = 232
          Width = 44
          Height = 16
          Caption = 'Losses'
        end
        object StaticTextLossesAndDilutions: TStaticText
          Left = 0
          Top = 0
          Width = 654
          Height = 30
          Align = alTop
          Alignment = taCenter
          BorderStyle = sbsSunken
          Caption = 'Losses and Dilutions'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -23
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          ExplicitWidth = 646
        end
        object GBEditValue1: TGBEditValue
          Left = 376
          Top = 189
          Width = 121
          Height = 24
          TabOrder = 1
          Text = '0'
          Parent = TabSheetLossesAndDilutions
          EnabledConvert = True
          AsInteger = 0
          ValueType = vtDouble
          Error = False
          Precision = 0
        end
        object GBEditValue2: TGBEditValue
          Left = 376
          Top = 229
          Width = 121
          Height = 24
          TabOrder = 2
          Text = '0'
          Parent = TabSheetLossesAndDilutions
          EnabledConvert = True
          AsInteger = 0
          ValueType = vtDouble
          Error = False
          Precision = 0
        end
      end
    end
  end
  inherited PanelBottom: TPanel
    Top = 381
    Width = 672
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 356
    ExplicitWidth = 664
    inherited ButtonOK: TButton
      Align = alCustom
      ExplicitLeft = 174
    end
    inherited ButtonCancel: TButton
      Align = alCustom
      ExplicitLeft = 294
    end
    inherited ButtonHelp: TButton
      Align = alCustom
      ExplicitLeft = 416
    end
  end
end
