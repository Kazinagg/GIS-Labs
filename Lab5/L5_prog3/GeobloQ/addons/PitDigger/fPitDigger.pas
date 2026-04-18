unit fPitDigger;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  System.Math,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.Menus,
  Vcl.StdCtrls,

  GLS.Scene,
  GLS.PersistentClasses,
  GLS.VectorFileObjects,
  GLS.Objects,
  GLS.GeomObjects,
  GLS.Texture,
  Stage.VectorGeometry,
  GLS.Skydome,
  GLS.Graph,
  GLS.Mesh,
  GLS.Cadencer,
  Stage.VectorTypes,
  GLS.HUDObjects,
  GLS.AVIRecorder,
  GLS.SceneViewer,
  GLS.Color,
  GLS.Coordinates,
  GLS.BaseClasses;

const
  CamDistDef = 200; // Расстояниеот камеры до объекта по умолчанию
  CamDistMax = 500; // Значения MinMax при зуме
  CamDistMin = 1;
  CamFocalMax = 20000;
  // MinMax values allowed when changing camera focus. По умолчанию 100
  CamFocalMin = 20;

  // Cursor ID's
  ZoomCursor = 5;
  MoveXYCursor = 6;
  MoveZCursor = 7;
  RotateCursor = 8;
  FocusCursor = 9;
  LightCursor = 10;

type

  TViewerState = (vsRotate, vsZoom, vsPanXY, vsPanZ, vsFocus, vsLight);

  TMainForm = class(TForm)
    Scene: TGLScene;
    Viewer: TGLSceneViewer;
    DummyCube: TGLDummyCube;
    Camera: TGLCamera;
    Light1: TGLLightSource;
    MainPanel: TPanel;
    HF: TGLHeightField;
    PathLines: TGLLines;
    ButtonDigger: TButton;
    CutterX: TGLCylinder;
    Cutter: TGLDummyCube;
    Cylinder: TGLCylinder;
    MemoInfo: TMemo;
    GLCadencer: TGLCadencer;
    ConeX: TGLCone;
    procedure ViewerMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ViewerMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure ViewerMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure HFGetHeight(const X, Y: Single; var z: Single;
      var Color: TVector4f; var texPoint: TTexPoint);
    procedure ButtonDiggerClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MemoInfoChange(Sender: TObject);
    procedure HFGetHeight2(Sender: TObject; const x, y: Single; var z: Single;
      var Color: TGLColorVector; var TexPoint: TTexPoint);
  Private
    Stock: Array [0 .. 200, 0 .. 200] Of Single;
    Tool: Array [-10 .. 10, -10 .. 10] Of Single;
    // This tells what we should do when the user drags the mouse, based on the
    // keys that are down
    ViewerState: TViewerState;
    // Ratio of camera target distance to focal length. When changing focal length
    // keep the ratio constant so that the target object seems to stay at the same place
    // to the viewer
    CameraAspect: Double;
    // These track down the mouse events in the viewer
    MouseDown: Boolean;
    MouseX, MouseY: Integer;
    // The light follows the camera, we have to call this whenever the camera position changes
    procedure ReAdjustLightPosition;
    // Resets the camera such that it's CamDistDef distance away from the target in the direction [X,Y,Z]
    // Magnitude of [X,Y,Z] is irrelevant
    procedure ResetCamera(X, Y, z: Double);
    // This proc handles changing the cursor as well as switching the ViewerState. Called from the form's
    // keydown and keyup events
    procedure SetGLCursor(var Key: Word; Down: Boolean);
    procedure UpdateHF(V: TGLVector);
  public
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

// ==============================================================================
//  Check if a control (including all its parents) are visible
//
function IsControlShowing(C: TControl): Boolean;
begin
  Result := False;
  try
    while not(C is TForm) do
      if not C.Visible then
        Exit
      else
        C := C.Parent;
  except
    On Exception do;
  end;
  Result := True;
end;

(*
 ==============================================================================
 Returns true if a given screen coordinate (ie Mouse.CursorPos) is over a given
 component (which must be showing)
*)
function PointOver(T: TPoint; C: TControl): Boolean;
var
  T1, T2: TPoint;
begin
  T1.X := 0;
  T1.Y := 0;
  T2.X := C.Width;
  T2.Y := C.Height;
  T1 := C.ClientToScreen(T1);
  T2 := C.ClientToScreen(T2);
  Result := IsControlShowing(C) And (T.X >= T1.X) And (T.X <= T2.X) And
    (T.Y >= T1.Y) And (T.Y <= T2.Y);
end;

// ==============================================================================
//  The light follows the camera but at some distance away. We don't want the light
//  too close to the target object when we zoom in.
//
procedure TMainForm.ReAdjustLightPosition;
begin
  Light1.Position.X := Camera.Position.X * 20;
  Light1.Position.Y := Camera.Position.Y * 20;
  Light1.Position.z := Camera.Position.z * 20;
end;


//  ==============================================================================
//  Remember mouse position when it was clicked down
//
procedure TMainForm.ViewerMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MouseDown := True;
  MouseX := X;
  MouseY := Y;
end;

//==============================================================================
//  Main routine
//
procedure TMainForm.ViewerMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  dx, dy: Integer;
  V: TGLVector;
  d: Double;
begin
  if not MouseDown then
    Exit;

  // How much the mouse has moved since last time
  dx := MouseX - X;
  dy := MouseY - Y;

  case ViewerState Of
    vsRotate:
      begin
        // Rotate the camera around the target
        Camera.MoveAroundTarget(dy, dx);
        ReAdjustLightPosition;
      end;
    vsZoom:
      begin
        // 0.01 is an arbitrary scale factor
        // Notice we first check if the mouse movement will result in an allowable
        // camera target distance and if not, we clamp the value before assigning
        // it to camera.
        d := (1 - dy * 0.01) * Camera.DistanceToTarget;
        If d > CamDistMax then
          d := CamDistMax;
        If d < CamDistMin then
          d := CamDistMin;
        Camera.AdjustDistanceToTarget(d / Camera.DistanceToTarget);
        // We also update the CameraAspect so that next time the focal length
        // changes, this new ratio is used
        CameraAspect := Camera.DistanceToTarget / Camera.FocalLength;
        // Again, lights follow the camera
        ReAdjustLightPosition;
      end;
    vsPanXY:
      begin
        // Convert the delta movement to GLScene translation, correcting for the camera
        // target distance and the focal length
        V := Camera.ScreenDeltaToVectorXY(dx, -dy,
          0.12 * Camera.DistanceToTarget / Camera.FocalLength);
        // Camera is actually a child of the dummycube (the target object). This separates
        // translation from rotation, the former applied to the dummycube (and thus indirectly to the
        // camera as well), the latter to the camera only. This way, instead of panning the scene,
        // we translate the dummycube+camera. Such motion has side effects too. For example, the proper
        // place to attach a skydome would be as a child of the dummycube.
        DummyCube.Position.Translate(V);
        ReAdjustLightPosition;
        Camera.TransformationChanged;
      end;
    vsPanZ:
      begin
        // Same deal as above except that the motion is limited to one axis
        V.X := 0;
        V.Y := 0;
        V.z := -dy * 0.12 * Camera.DistanceToTarget / Camera.FocalLength;
        DummyCube.Position.Translate(V);
        ReAdjustLightPosition;
        Camera.TransformationChanged;
      end;
    vsFocus:
      begin
        // We first figure out what the new focal length would be
        d := (1 - dy * 0.01) * Camera.FocalLength;
        // then clamp it down based on the constraints. Checking against CamDistMax/CameraAspect ..etc
        // at this stage makes sure we don't end up with an illegal DistanceToTarget for the camera
        // since to keep the target in the same virtual location, camera-target distance adjustment has
        // to immediately follow a focus adjustment
        If d > CamFocalMax then
          d := CamFocalMax;
        If d > CamDistMax / CameraAspect then
          d := CamDistMax / CameraAspect;
        If d < CamFocalMin then
          d := CamFocalMin;
        If d < CamDistMin / CameraAspect then
          d := CamDistMin / CameraAspect;
        Camera.FocalLength := d;
        Camera.AdjustDistanceToTarget(Camera.FocalLength * CameraAspect /
          Camera.DistanceToTarget);
      end;
    vsLight:
      begin
        // Simply alter the light intensity. Notice this time the change is additive
        d := Light1.Diffuse.Red;
        d := d + dy * 0.001;
        If d > 1 then
          d := 1
        else if d < 0 then
          d := 0;
        Light1.Diffuse.Red := d;
        Light1.Diffuse.Green := d;
        Light1.Diffuse.Blue := d;
      End
  end;

  // Reset the mouse position
  MouseX := X;
  MouseY := Y;

end;

//==============================================================================
procedure TMainForm.ViewerMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MouseDown := False;
end;

//==============================================================================
//  Position the camera in it's default location..etc
//
procedure TMainForm.ResetCamera(X, Y, z: Double);
var
  d: Double;
begin
  d := CamDistDef / Sqrt(Sqr(X) + Sqr(Y) + Sqr(z));
  DummyCube.Position.X := 0;
  DummyCube.Position.Y := 0;
  DummyCube.Position.z := 0;
  Camera.Position.X := X * d;
  Camera.Position.Y := Y * d;
  Camera.Position.z := z * d;
  Camera.FocalLength := 100;
  ReAdjustLightPosition;
  Camera.TransformationChanged;
  CameraAspect := Camera.DistanceToTarget / Camera.FocalLength;
end;

{ ==============================================================================
  This proc is called from the form KeyDown events (Form.KeyPreview is set to true)
  and based on the key that went down/up.
}
procedure TMainForm.SetGLCursor(var Key: Word; Down: Boolean);
var
  K: Integer;
  B: Boolean;
begin
  B := PointOver(Mouse.CursorPos, Viewer);

  ViewerState := vsRotate;
  K := RotateCursor;

  if Down then
  begin
    case Key Of
      VK_SHIFT:
        begin
          ViewerState := vsZoom;
          K := ZoomCursor;
        end;
      VK_CONTROL:
        begin
          ViewerState := vsPanXY;
          K := MoveXYCursor;
        end;
      VK_MENU:
        begin
          ViewerState := vsPanZ;
          K := MoveZCursor;
        end;
      Ord('F'), Ord('f'):
        begin
          ViewerState := vsFocus;
          K := FocusCursor;
        end;
      Ord('L'), Ord('l'):
        begin
          ViewerState := vsLight;
          K := LightCursor;
        end;
      Ord('R'), Ord('r'):
        If B then
          ResetCamera(1, 1, 1);
    end;
  end;

  If Viewer.Cursor <> K then
  begin
    Viewer.Cursor := K;
    // This next line is necessary to update the cursor immediately in the case
    // where a key switched state while a mouse button was being held down. To see
    // the problem, comment out the next line, then LEFT CLICK AND HOLD, then PRESS SHIFT :
    // the mouse cursor will not update.
    If B then
      SetCursor(Screen.Cursors[K]);
  end;
  // Since the ALT key has a special significance (brings up menu), we disable it
  // if pressed over the GLSceneViewer. Again, to see the problem, you can comment
  // out the next line and try pressing ALT: the cursor will reset to the default
  // one, depending on the timing
  if (Key = VK_MENU) and B then
    Key := 0;

end;

//==============================================================================
procedure TMainForm.FormCreate(Sender: TObject);
var
  K: Word;
  i, j: Integer;
  R: Single;
begin
  // Load cursors
  Screen.Cursors[ZoomCursor] := LoadCursor(HInstance, 'ZoomCursor');
  Screen.Cursors[MoveXYCursor] := LoadCursor(HInstance, 'PanXYCursor');
  Screen.Cursors[MoveZCursor] := LoadCursor(HInstance, 'PanZCursor');
  Screen.Cursors[RotateCursor] := LoadCursor(HInstance, 'RotateCursor');
  Screen.Cursors[FocusCursor] := LoadCursor(HInstance, 'FocusCursor');
  Screen.Cursors[LightCursor] := LoadCursor(HInstance, 'LightCursor');
  // Reset the camera
  ResetCamera(1, 1, 1);
  // Set the cursors and the ViewerState
  K := 0;
  SetGLCursor(K, False);
  // Stock
  for i := 0 To 200 Do
    for j := 0 To 200 Do
      Stock[i, j] := 0;
  // Tool (angled)
  for i := -10 To 10 Do
    for j := -10 To 10 Do
    begin
      R := Sqrt(Sqr(i) + Sqr(j));
      If R > 10 then
        Tool[i, j] := 1E10
      else if R > 5 then
        Tool[i, j] := R - 5
      Else
        Tool[i, j] := 0;
    end;

end;

//==============================================================================
procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  SetGLCursor(Key, True);
end;

//==============================================================================
procedure TMainForm.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  SetGLCursor(Key, False);
end;

//---------------------------------------------------------------------------
// Глубина канавы
//---------------------------------------------------------------------------
procedure TMainForm.HFGetHeight(const X, Y: Single; var z: Single;
  var Color: TVector4f; var texPoint: TTexPoint);
begin
  z := Stock[Round(X), Round(Y)];
  if z < -0.001 then
    Color := clrGold
  else
    Color := clrRed;
end;

procedure TMainForm.HFGetHeight2(Sender: TObject; const x, y: Single;
  var z: Single; var Color: TGLColorVector; var TexPoint: TTexPoint);
begin
  z := Stock[Round(X), Round(Y)];
  if z < -0.001 then
    Color := clrGold
  else
    Color := clrRed;
end;

procedure TMainForm.MemoInfoChange(Sender: TObject);
begin

end;

//==============================================================================
procedure TMainForm.UpdateHF(V: TGLVector);
var
  i, j: Integer;
  i1, i2, j1, j2: Integer;
  X, Y: Integer;
begin
  X := Round(V.X);
  Y := Round(V.Y);

  i1 := Max(X - 10, 0) - X;
  i2 := Min(X + 10, 200) - X;
  j1 := Max(Y - 10, 0) - Y;
  j2 := Min(Y + 10, 200) - Y;

  for i := i1 To i2 Do
    for j := j1 To j2 Do
      If Stock[X + i, Y + j] > Tool[i, j] + V.z then
        Stock[X + i, Y + j] := Tool[i, j] + V.z;
end;

// ==============================================================================
procedure TMainForm.ButtonDiggerClick(Sender: TObject);
const
  Resolution: Single = 1;
var
  i, j: Integer;
  N: Integer;
  d, T: Single;
  V: TGLVector;
  K: Integer;
begin
  for i := 0 To 200 Do
    for j := 0 To 200 Do
      Stock[i, j] := 0;
  HF.StructureChanged;
  Application.ProcessMessages;

  K := 0;

  for i := 0 To PathLines.Nodes.Count - 2 Do
  begin
    d := VectorDistance(PathLines.Nodes.Items[i].AsVector,
      PathLines.Nodes.Items[i + 1].AsVector);
    N := Ceil(d / Resolution); // subdivs
    d := 1 / N; // deltaT
    T := 0;
    for j := 0 to N do
    begin
      V := VectorLerp(PathLines.Nodes.Items[i].AsVector,
        PathLines.Nodes.Items[i + 1].AsVector, T);
      UpdateHF(V);
      T := T + d;

      inc(K);
      if K > 20 then
      begin
        Cutter.Position.AsVector := V;
        HF.StructureChanged;
        Application.ProcessMessages;
        K := 0;
      end;

    end;
  end;
  HF.StructureChanged;
  Application.ProcessMessages;
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  V: TGLVector;
begin
  V := Camera.ScreenDeltaToVectorXY(0, -600, 0.12 * Camera.DistanceToTarget /
    Camera.FocalLength);
  DummyCube.Position.Translate(V);
  Camera.MoveAroundTarget(0, 20);
  ReAdjustLightPosition;
  Camera.TransformationChanged;
end;

end.
