object MainForm: TMainForm
  Left = 258
  Top = 231
  Caption = #1069#1082#1089#1082#1072#1074#1072#1094#1080#1103' '#1088#1091#1076#1099' '#1074' '#1082#1072#1088#1100#1077#1088#1077
  ClientHeight = 264
  ClientWidth = 421
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  TextHeight = 13
  object MainPanel: TPanel
    Left = 209
    Top = 0
    Width = 212
    Height = 264
    Align = alRight
    BevelOuter = bvLowered
    TabOrder = 1
    ExplicitLeft = 542
    ExplicitHeight = 510
    object ButtonDigger: TButton
      Left = 62
      Top = 24
      Width = 75
      Height = 25
      Caption = #1069#1082#1089#1082#1072#1074#1072#1090#1086#1088
      TabOrder = 0
      OnClick = ButtonDiggerClick
    end
    object MemoInfo: TMemo
      Left = 6
      Top = 72
      Width = 203
      Height = 137
      Lines.Strings = (
        #1048#1085#1092#1086':'
        'Mouse Move = '#1055#1086#1074#1086#1088#1086#1090
        'Shift + Vertical Move = '#1047#1091#1084
        'Control + Move = '#1055#1072#1085' '#1074' '#1087#1083#1086#1089#1082#1086#1089#1090#1080' XY'
        'Alt + Vertical Move = '#1055#1072#1085' '#1074' '#1087#1083#1086#1089#1082#1086#1089#1090#1080' Z'
        'F + Vertical Move = '#1057#1084#1077#1089#1090#1080#1090#1100' '#1082#1072#1084#1077#1088#1091
        'L + Vertical Move = '#1057#1084#1077#1089#1090#1080#1090#1100' '#1089#1074#1077#1090
        'R = '#1056#1077#1079#1077#1090)
      TabOrder = 1
      OnChange = MemoInfoChange
    end
  end
  object Viewer: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 209
    Height = 264
    Camera = Camera
    Buffer.BackgroundColor = clSilver
    Buffer.ContextOptions = [roDoubleBuffer, roRenderToWindow, roTwoSideLighting]
    Buffer.FaceCulling = False
    FieldOfView = 92.521171569824220000
    PenAsTouch = False
    Align = alClient
    OnMouseDown = ViewerMouseDown
    OnMouseMove = ViewerMouseMove
    OnMouseUp = ViewerMouseUp
    TabOrder = 0
    ExplicitWidth = 542
    ExplicitHeight = 510
  end
  object Scene: TGLScene
    Left = 16
    Top = 16
    object DummyCube: TGLDummyCube
      ShowAxes = True
      CubeSize = 1.000000000000000000
      VisibleAtRunTime = True
      object Camera: TGLCamera
        DepthOfView = 50000.000000000000000000
        FocalLength = 100.000000000000000000
        TargetObject = DummyCube
        Position.Coordinates = {0000204100002041000020410000803F}
        Direction.Coordinates = {000000000000803F0000008000000000}
        Up.Coordinates = {00000000000000000000803F00000000}
        Left = 376
        Top = 240
      end
    end
    object Light1: TGLLightSource
      Ambient.Color = {0000003F0000003F0000003F0000803F}
      ConstAttenuation = 1.000000000000000000
      SpotCutOff = 180.000000000000000000
    end
    object HF: TGLHeightField
      Material.FrontProperties.Diffuse.Color = {00000000000000000000803F0000803F}
      Material.PolygonMode = pmLines
      XSamplingScale.Max = 200.000000000000000000
      XSamplingScale.Step = 1.000000000000000000
      YSamplingScale.Max = 200.000000000000000000
      YSamplingScale.Step = 1.000000000000000000
      OnGetHeight2 = HFGetHeight2
    end
    object PathLines: TGLLines
      LineColor.Color = {BEBC3C3F8A8F0F3F8A8F0F3F0000803F}
      LineWidth = 3.000000000000000000
      NodeColor.Color = {BEBC3C3F8A8F0F3F8A8F0F3F0000803F}
      Nodes = <
        item
          Z = 10.000000000000000000
        end
        item
          X = 40.000000000000000000
          Y = 40.000000000000000000
          Z = 10.000000000000000000
        end
        item
          X = 40.000000000000000000
          Y = 40.000000000000000000
          Z = -8.000000000000000000
        end
        item
          X = 40.000000000000000000
          Y = 160.000000000000000000
          Z = -20.000000000000000000
        end
        item
          X = 80.000000000000000000
          Y = 160.000000000000000000
          Z = -20.000000000000000000
        end
        item
          X = 120.000000000000000000
          Y = 120.000000000000000000
          Z = -4.000000000000000000
        end
        item
          X = 120.000000000000000000
          Y = 120.000000000000000000
          Z = 20.000000000000000000
        end
        item
          Z = 20.000000000000000000
        end>
      Options = [loUseNodeColorForLines]
    end
    object Cutter: TGLDummyCube
      CubeSize = 1.000000000000000000
      object ConeX: TGLCone
        Direction.Coordinates = {000000000000803F2EBD3BB300000000}
        PitchAngle = 90.000000000000000000
        Position.Coordinates = {0000000000000000000020410000803F}
        Up.Coordinates = {000000002EBD3BB3000080BF00000000}
        BottomRadius = 10.000000000000000000
        Height = 20.000000000000000000
      end
      object CutterX: TGLCylinder
        Material.FrontProperties.Diffuse.Color = {0000803F00000000000000000000803F}
        Direction.Coordinates = {00000000000080BF0000000000000000}
        Position.Coordinates = {00000000000000000000A0400000803F}
        Up.Coordinates = {00000000000000000000803F00000000}
        BottomRadius = 5.000000000000000000
        Height = 10.000000000000000000
        TopRadius = 10.000000000000000000
      end
      object Cylinder: TGLCylinder
        Material.FrontProperties.Diffuse.Color = {0000803F00000000000000000000803F}
        Direction.Coordinates = {00000000000080BF0000000000000000}
        Position.Coordinates = {00000000000000000000A0410000803F}
        Up.Coordinates = {00000000000000000000803F00000000}
        Visible = False
        BottomRadius = 10.000000000000000000
        Height = 20.000000000000000000
        TopRadius = 10.000000000000000000
      end
    end
  end
  object GLCadencer: TGLCadencer
    Left = 96
    Top = 16
  end
end
