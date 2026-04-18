object Form3: TForm3
  Left = 0
  Top = 0
  Margins.Left = 5
  Margins.Top = 5
  Margins.Right = 5
  Margins.Bottom = 5
  Caption = 'Minliber - '#1088#1072#1089#1082#1088#1099#1090#1080#1077' '#1084#1080#1085#1077#1088#1072#1083#1086#1074
  ClientHeight = 776
  ClientWidth = 1096
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -21
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu1
  Position = poScreenCenter
  PixelsPerInch = 168
  TextHeight = 30
  object GLSceneViewer1: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 1096
    Height = 776
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Camera = Camera
    FieldOfView = 165.313980102539100000
    PenAsTouch = False
    Align = alClient
    TabOrder = 0
  end
  object MainMenu1: TMainMenu
    Left = 458
    Top = 102
  end
  object GLScene1: TGLScene
    Left = 266
    Top = 98
    object Camera: TGLCamera
      DepthOfView = 100.000000000000000000
      FocalLength = 50.000000000000000000
    end
    object Light: TGLLightSource
      ConstAttenuation = 1.000000000000000000
      SpotCutOff = 180.000000000000000000
    end
    object dcRock: TGLDummyCube
      CubeSize = 1.000000000000000000
    end
  end
  object GLMaterialLibrary1: TGLMaterialLibrary
    Left = 462
    Top = 224
  end
  object GLCadencer1: TGLCadencer
    Left = 280
    Top = 224
  end
end
