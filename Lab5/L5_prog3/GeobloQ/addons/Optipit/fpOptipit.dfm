object FormOptipit: TFormOptipit
  Left = 0
  Top = 0
  Caption = 'Optipit - '#1086#1087#1090#1080#1084#1080#1079#1072#1094#1080#1103' '#1092#1086#1088#1084#1099' '#1082#1072#1088#1100#1077#1088#1072
  ClientHeight = 672
  ClientWidth = 976
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseWheel = FormMouseWheel
  TextHeight = 13
  object GLSceneViewer: TGLSceneViewer
    Left = 185
    Top = 0
    Width = 791
    Height = 554
    Camera = GLCamera
    Buffer.BackgroundColor = clBlack
    FieldOfView = 159.535964965820300000
    PenAsTouch = False
    Align = alClient
    OnMouseDown = GLSceneViewerMouseDown
    OnMouseMove = GLSceneViewerMouseMove
    TabOrder = 0
  end
  object PanelGenerate: TPanel
    Left = 0
    Top = 554
    Width = 976
    Height = 118
    Align = alBottom
    TabOrder = 1
    Visible = False
    object Label1: TLabel
      Left = 176
      Top = 14
      Width = 40
      Height = 13
      Caption = #1041#1083#1086#1082#1086#1074':'
    end
    object Label2: TLabel
      Left = 176
      Top = 41
      Width = 61
      Height = 13
      Caption = 'Color Points:'
    end
    object Label3: TLabel
      Left = 176
      Top = 65
      Width = 46
      Height = 13
      Caption = 'Iteration:'
    end
    object ButtonGenerate: TButton
      Left = 383
      Top = 6
      Width = 57
      Height = 25
      Caption = #1043#1077#1085#1077#1088#1072#1090#1086#1088
      TabOrder = 0
      OnClick = ButtonGenerateClick
    end
    object Edit2: TEdit
      Left = 8
      Top = 33
      Width = 121
      Height = 21
      TabOrder = 1
      Text = '2.791139'
    end
    object Edit3: TEdit
      Left = 8
      Top = 60
      Width = 121
      Height = 21
      TabOrder = 2
      Text = '1.85185185'
    end
    object Edit4: TEdit
      Left = 8
      Top = 87
      Width = 121
      Height = 21
      TabOrder = 3
      Text = '1.5'
    end
    object Edit1: TEdit
      Left = 8
      Top = 6
      Width = 121
      Height = 21
      TabOrder = 4
      Text = '-0.9629629'
    end
    object ButtonRandom: TButton
      Left = 176
      Top = 84
      Width = 58
      Height = 25
      Caption = 'Random'
      TabOrder = 5
      OnClick = ButtonRandomClick
    end
    object EditPoints: TEdit
      Left = 256
      Top = 6
      Width = 97
      Height = 21
      TabOrder = 6
      Text = '100000'
    end
    object EditColorPoints: TEdit
      Left = 256
      Top = 38
      Width = 97
      Height = 21
      TabOrder = 7
      Text = '9'
    end
    object EditIterations: TEdit
      Left = 256
      Top = 65
      Width = 97
      Height = 21
      TabOrder = 8
      Text = '100'
    end
    object CheckBox1: TCheckBox
      Left = 256
      Top = 92
      Width = 97
      Height = 17
      Caption = 'NoZWrite'
      TabOrder = 9
      OnClick = CheckBox1Click
    end
    object ButtonClear: TButton
      Left = 470
      Top = 6
      Width = 58
      Height = 25
      Caption = #1057#1073#1088#1086#1089
      TabOrder = 10
      OnClick = ButtonClearClick
    end
    object ColorBox1: TColorBox
      Left = 383
      Top = 37
      Width = 145
      Height = 22
      TabOrder = 11
    end
  end
  object PanelFields: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 554
    Align = alLeft
    TabOrder = 2
    object RadioGroupValue: TRadioGroup
      Left = 8
      Top = 32
      Width = 171
      Height = 161
      Caption = 'Value'
      ItemIndex = 0
      Items.Strings = (
        'Field 5'
        'Field 6'
        'Field 7'
        'Field 8'
        'Field 9'
        'Field 10')
      TabOrder = 0
      OnClick = RadioGroupValueClick
    end
  end
  object GLScene1: TGLScene
    Left = 240
    Top = 16
    object GLCamera: TGLCamera
      DepthOfView = 1800.000000000000000000
      FocalLength = 50.000000000000000000
      NearPlaneBias = 0.200000002980232200
      TargetObject = GLDummyCube2
      CameraStyle = csInfinitePerspective
      Position.Coordinates = {0000204100002041000000000000803F}
    end
    object GLLightSource1: TGLLightSource
      ConstAttenuation = 1.000000000000000000
      Position.Coordinates = {0000A04000000000000000000000803F}
      SpotCutOff = 180.000000000000000000
    end
    object GLDummyCube1: TGLDummyCube
      Direction.Coordinates = {F304353F00000000F304353F00000000}
      ShowAxes = True
      TurnAngle = 45.000000000000000000
      CubeSize = 10.000000000000000000
      VisibleAtRunTime = True
      object GLPoints: TGLPoints
        NoZWrite = False
        Static = False
      end
      object GLSphere: TGLSphere
        Visible = False
        Radius = 0.500000000000000000
        BehavioursData = {
          0458434F4C02010201060D54474C42436F6C6C6973696F6E0202020012000000
          000200120000000002000200}
        EffectsData = {
          0458434F4C02010202061254474C536F75726365504658456666656374020202
          001200000000020002001200000000050000000000000080FF3F020602000802
          0008020008050000000000000000000005000000000000000000000500000000
          00CDCCCCFB3F02000200090500000000000000000000080200060A54474C4246
          6972654658020102001200000000020002001200000000}
      end
    end
    object GLDummyCube2: TGLDummyCube
      CubeSize = 1.000000000000000000
      VisibleAtRunTime = True
      object Point: TGLPoints
        NoZWrite = False
        Static = False
      end
    end
    object GLDummyCube4: TGLDummyCube
      CubeSize = 1.000000000000000000
      VisibleAtRunTime = True
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 930
    Top = 30
  end
  object GLCadencer1: TGLCadencer
    Scene = GLScene1
    OnProgress = GLCadencer1Progress
    Left = 406
    Top = 16
  end
  object OpenTextFileDialog1: TOpenTextFileDialog
    Filter = 
      'Block model (*.blocks)|*.blocks|Precedence file (*.prec)|*.prec|' +
      'Ultimit pit (*.upit)|*.upit|Constrained pit (*.cpit)|*.cpit|Mine' +
      ' scheduling (*.pcpsp) |*.pcpsp|Solution file (*.sol)|*.sol|All (' +
      '*.*)|*.*'
    Encodings.Strings = (
      'ASCII'
      'ANSI'
      'Unicode'
      'Big Endian Unicode'
      'UTF-8'
      'UTF-7')
    Left = 638
    Top = 18
  end
  object MainMenu1: TMainMenu
    Left = 394
    Top = 130
    object miFile: TMenuItem
      Caption = 'File'
      object miOpenData: TMenuItem
        Caption = 'Open...'
        OnClick = miOpenDataClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Close1: TMenuItem
        Caption = 'Close'
        OnClick = ButtonClearClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object Synthesize1: TMenuItem
      Caption = 'Structure'
      object miGenerate: TMenuItem
        Caption = 'Generate'
        OnClick = miGenerateClick
      end
      object Clear1: TMenuItem
        Caption = 'Clean'
        OnClick = ButtonClearClick
      end
    end
    object Help1: TMenuItem
      Caption = '?'
      object miAbout: TMenuItem
        Caption = 'About...'
        OnClick = miAboutClick
      end
    end
  end
  object ColorDialog1: TColorDialog
    Left = 240
    Top = 96
  end
end
