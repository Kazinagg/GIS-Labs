unit fTerraMorph;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.Math,
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  GLS.Scene,
  GLS.Graph,
  GLS.SceneViewer,
  Stage.VectorGeometry,
  Stage.VectorTypes,
  GLS.Texture,
  GLS.Objects,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  GLS.Cadencer,
  GLSL.LineShaders,
  GLS.WaterPlane,
  Vcl.Imaging.Jpeg,
  GLS.HUDObjects,
  GLS.Material,
  GLS.Color,
  GLS.Coordinates,
  GLS.BaseClasses;

type
  TFormTerramorf = class(TForm)
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    GLCamera1: TGLCamera;
    LightSource: TGLLightSource;
    GLDummyCube1: TGLDummyCube;
    Map: TGLHeightField;
    Timer1: TTimer;
    MaterialLibrary: TGLMaterialLibrary;
    Timer2: TTimer;
    GLCadencer1: TGLCadencer;
    GLHiddenLineShader1: TGLHiddenLineShader;
    Grid: TGLXYZGrid;
    Water: TGLWaterPlane;
    Sprite1: TGLHUDSprite;
    Sprite2: TGLHUDSprite;
    Sprite3: TGLHUDSprite;
    Sprite4: TGLHUDSprite;
    Sprite5: TGLHUDSprite;
    Sprite6: TGLHUDSprite;
    Sprite0: TGLHUDSprite;
    Sprite7: TGLHUDSprite;
    Sprite8: TGLHUDSprite;
    Sprite9: TGLHUDSprite;
    Sprite10: TGLHUDSprite;
    Saver: TSaveDialog;
    Opener: TOpenDialog;
    Cur: TGLHUDSprite;
    procedure GLSceneViewer1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure GLCadencer1Progress(Sender: TObject;
      const deltaTime, newTime: Double);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    procedure Formula(const X, Y: Single; var z: Single;
      var Color: TGLColorVector; var texPoint: TTexPoint);

  public
    { Public declarations }
    mdx, mdy: Integer;
  end;

procedure ClickMenus;
procedure Save;
procedure Load;

var
  FormTerramorf: TFormTerramorf;
  MapInfo: record NumVertex: Integer;
  VertexMap: array [1 .. 1000] of record X, Y: Real;
  Height, Radius: Real;
end;
end;

CursorX, CursorY: Integer;
RotateCamera:
Bool;
DeltaHeight:
Real = 0.1;
DeltaRadius:
Integer = 10;
DRBotton:
Integer = 1;
NewVertex:
Bool;
ClickMap:
Bool;

// ===================================
implementation

// ===================================

{$R *.dfm}

procedure TFormTerramorf.GLSceneViewer1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  v: TAffineVector;
  ix, iy: Real;
  i: Integer;
begin
  ClickMap := True;
  ClickMenus;
  RotateCamera := False;
  NewVertex := True;
  if Button = mbRight then
  begin
    mdy := Y;
    mdx := X;
    RotateCamera := True;
  end
  else if ClickMap then
  begin
    v := GLSceneViewer1.Buffer.PixelRayToWorld(X, Y);
    v := Map.AbsoluteToLocal(v);
    ix := (v.X);
    iy := (v.Y);
    if (ix >= -10) and (ix <= 10) and (iy >= -10) and (iy <= 10) then
    begin
      for i := 1 to MapInfo.NumVertex do
        if (MapInfo.VertexMap[i].X = ix) and (MapInfo.VertexMap[i].Y = iy) then
        begin
          MapInfo.VertexMap[i].Height := MapInfo.VertexMap[i].Height +
            DeltaHeight;
          NewVertex := False;
          Map.OnGetHeight := Formula;
        end;
      if NewVertex then
      begin
        MapInfo.NumVertex := MapInfo.NumVertex + 1;
        MapInfo.VertexMap[MapInfo.NumVertex].X := ix;
        MapInfo.VertexMap[MapInfo.NumVertex].Y := iy;
        MapInfo.VertexMap[MapInfo.NumVertex].Height := DeltaHeight;
        MapInfo.VertexMap[MapInfo.NumVertex].Radius := DeltaRadius;
        Map.OnGetHeight := Formula;
      end;
    end;
  end;
end;

procedure TFormTerramorf.GLSceneViewer1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Shift <> []) and (RotateCamera) then
    GLCamera1.MoveAroundTarget(mdy - Y, mdx - X);
  mdy := Y;
  mdx := X;
  CursorX := X;
  CursorY := Y;
  Cur.Position.X := X;
  Cur.Position.Y := Y;
end;

procedure TFormTerramorf.Formula(const X, Y: Single; var z: Single;
  var Color: TGLColorVector; var texPoint: TTexPoint);
var
  ZZ: Single;
  i: Integer;
begin
  ZZ := 0;
  for i := 1 to MapInfo.NumVertex do
  begin
    ZZ := ZZ + MapInfo.VertexMap[i].Height /
      (1 + VectorNorm(X - MapInfo.VertexMap[i].X, Y - MapInfo.VertexMap[i].Y) *
      MapInfo.VertexMap[i].Radius);
  end;
  z := ZZ;
end;

procedure TFormTerramorf.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  GLCamera1.AdjustDistanceToTarget(Power(1.1, WheelDelta / 480));
end;

procedure TFormTerramorf.Timer1Timer(Sender: TObject);
begin
  if CursorY > 766 then
  begin
    GLCamera1.Position.X := GLCamera1.Position.X + 0.1;
    GLDummyCube1.Position.X := GLDummyCube1.Position.X + 0.1;
    GLCamera1.Position.z := GLCamera1.Position.z + 0.1;
    GLDummyCube1.Position.z := GLDummyCube1.Position.z + 0.1;
  end;
  if CursorY < 1 then
  begin
    GLCamera1.Position.X := GLCamera1.Position.X - 0.1;
    GLDummyCube1.Position.X := GLDummyCube1.Position.X - 0.1;
    GLCamera1.Position.z := GLCamera1.Position.z - 0.1;
    GLDummyCube1.Position.z := GLDummyCube1.Position.z - 0.1;
  end;
  if CursorX > 1022 then
  begin
    GLCamera1.Position.X := GLCamera1.Position.X + 0.1;
    GLDummyCube1.Position.X := GLDummyCube1.Position.X + 0.1;
    GLCamera1.Position.z := GLCamera1.Position.z - 0.1;
    GLDummyCube1.Position.z := GLDummyCube1.Position.z - 0.1;
  end;
  if CursorX < 1 then
  begin
    GLCamera1.Position.X := GLCamera1.Position.X - 0.1;
    GLDummyCube1.Position.X := GLDummyCube1.Position.X - 0.1;
    GLCamera1.Position.z := GLCamera1.Position.z + 0.1;
    GLDummyCube1.Position.z := GLDummyCube1.Position.z + 0.1;
  end;
end;

procedure TFormTerramorf.FormCreate(Sender: TObject);
begin
  (* *)
  FormTerramorf.Width := 1024;
  FormTerramorf.Height := 768;
  FormTerramorf.Top := 0;
  FormTerramorf.Left := 0;
  (* *)
  Map.OnGetHeight := Formula;
  Screen.Cursor := crNone;

  GLSceneViewer1MouseMove(Sender, [], 1, 1);
end;

procedure TFormTerramorf.Timer2Timer(Sender: TObject);
begin
  Caption := Format('%.1f FPS', [GLSceneViewer1.FramesPerSecond]);
  // GLSceneViewer1.ResetPerformanceMonitor;
end;

procedure TFormTerramorf.GLCadencer1Progress(Sender: TObject;
  const deltaTime, newTime: Double);
begin
  // GLSceneViewer1.Invalidate;
end;

procedure TFormTerramorf.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Halt;
end;

procedure ClickMenus;
begin
  if (CursorY > 0) and (CursorY < 50) and (CursorX > 0) and (CursorX < 50) and
    (DeltaHeight > 0) then
  begin
    DeltaHeight := -0.1;
    ClickMap := False;
    FormTerramorf.Sprite1.Position.Y := FormTerramorf.Sprite1.Position.Y + 10;
    FormTerramorf.Sprite2.Position.Y := FormTerramorf.Sprite2.Position.Y - 10;
  end;

  if (CursorY > 0) and (CursorY < 50) and (CursorX > 55) and (CursorX < 105) and
    (DeltaHeight < 0) then
  begin
    DeltaHeight := 0.1;
    ClickMap := False;
    FormTerramorf.Sprite2.Position.Y := FormTerramorf.Sprite2.Position.Y + 10;
    FormTerramorf.Sprite1.Position.Y := FormTerramorf.Sprite1.Position.Y - 10;
  end;

  if (CursorY > 0) and (CursorY < 50) and (CursorX > 165) and (CursorX < 215)
  then
  begin
    ClickMap := False;
    if FormTerramorf.Grid.Visible then
    begin
      FormTerramorf.Grid.Visible := False;
      FormTerramorf.Sprite4.Position.Y := FormTerramorf.Sprite4.Position.Y - 10;
    end
    else
    begin
      FormTerramorf.Grid.Visible := True;
      FormTerramorf.Sprite4.Position.Y := FormTerramorf.Sprite4.Position.Y + 10;
    end;
  end;

  if (CursorY > 0) and (CursorY < 50) and (CursorX > 220) and (CursorX < 270)
  then
  begin
    ClickMap := False;
    if FormTerramorf.GLHiddenLineShader1.Enabled then
    begin
      FormTerramorf.GLHiddenLineShader1.Enabled := False;
      FormTerramorf.Sprite5.Position.Y := FormTerramorf.Sprite5.Position.Y - 10;
    end
    else
    begin
      FormTerramorf.GLHiddenLineShader1.Enabled := True;
      FormTerramorf.Sprite5.Position.Y := FormTerramorf.Sprite5.Position.Y + 10;
    end;
  end;

  if (CursorY > 0) and (CursorY < 50) and (CursorX > 110) and (CursorX < 160)
  then
  begin
    ClickMap := False;
    DRBotton := DRBotton + 1;
    if DRBotton > 4 then
      DRBotton := 1;
    case DRBotton of
      1:
        begin
          DeltaRadius := 10;
          FormTerramorf.Sprite6.Visible := False;
          FormTerramorf.Sprite7.Visible := False;
          FormTerramorf.Sprite8.Visible := False;
        end;
      2:
        begin
          DeltaRadius := 50;
          FormTerramorf.Sprite6.Visible := True;
          FormTerramorf.Sprite7.Visible := False;
          FormTerramorf.Sprite8.Visible := False;
        end;
      3:
        begin
          DeltaRadius := 100;
          FormTerramorf.Sprite6.Visible := True;
          FormTerramorf.Sprite7.Visible := True;
          FormTerramorf.Sprite8.Visible := False;
        end;
      4:
        begin
          DeltaRadius := 1000;
          FormTerramorf.Sprite6.Visible := True;
          FormTerramorf.Sprite7.Visible := True;
          FormTerramorf.Sprite8.Visible := True;
        end;
    end;
  end;

  if (CursorY > 0) and (CursorY < 50) and (CursorX > 275) and (CursorX < 325)
  then
  begin
    ClickMap := False;
    FormTerramorf.Sprite9.Position.Y := FormTerramorf.Sprite9.Position.Y + 10;
    if FormTerramorf.Saver.Execute then
      Save;
    FormTerramorf.Sprite9.Position.Y := FormTerramorf.Sprite9.Position.Y - 10;
  end;
  if (CursorY > 0) and (CursorY < 50) and (CursorX > 330) and (CursorX < 380)
  then
  begin
    ClickMap := False;
    FormTerramorf.Sprite10.Position.Y := FormTerramorf.Sprite10.Position.Y + 10;
    if FormTerramorf.Opener.Execute then
      Load;
    FormTerramorf.Sprite10.Position.Y := FormTerramorf.Sprite10.Position.Y - 10;
  end;
end;

procedure Save;
var
  f: Textfile;
  S: string;
  i: Integer;
begin
  Assignfile(f, FormTerramorf.Saver.FileName + '.txx');
  Rewrite(f);
  Writeln(f, IntToStr(MapInfo.NumVertex));
  for i := 1 to MapInfo.NumVertex do
  begin
    Writeln(f, IntToStr(Round(MapInfo.VertexMap[i].X * 100)));
    Writeln(f, IntToStr(Round(MapInfo.VertexMap[i].Y * 100)));
    Writeln(f, IntToStr(Round(MapInfo.VertexMap[i].Height * 100)));
    Writeln(f, IntToStr(Round(MapInfo.VertexMap[i].Radius * 100)));
  end;
  Closefile(f);
end;

procedure Load;
var
  f: Textfile;
  S: string;
  i: Integer;
begin
  Assignfile(f, FormTerramorf.Opener.FileName);
  Reset(f);
  Readln(f, S);
  MapInfo.NumVertex := StrToInt(S);
  for i := 1 to MapInfo.NumVertex do
  begin
    Readln(f, S);
    MapInfo.VertexMap[i].X := StrToInt(S) / 100;
    Readln(f, S);
    MapInfo.VertexMap[i].Y := StrToInt(S) / 100;
    Readln(f, S);
    MapInfo.VertexMap[i].Height := StrToInt(S) / 100;
    Readln(f, S);
    MapInfo.VertexMap[i].Radius := StrToInt(S) / 100;
  end;
  Closefile(f);
  FormTerramorf.Map.StructureChanged;
end;

end.
