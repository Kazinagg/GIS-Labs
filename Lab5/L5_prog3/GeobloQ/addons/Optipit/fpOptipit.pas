unit fpOptipit;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Math,

  Vcl.Controls,
  Vcl.Graphics,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Outline,
  Vcl.ExtDlgs,
  Vcl.Menus,
  Vcl.ColorGrd,

  Stage.VectorTypes,
  Stage.VectorGeometry,
  Stage.Utils,

  GLS.Scene,
  GLS.VectorLists,
  GLS.SceneViewer,
  GLS.Objects,
  GLS.Cadencer,
  GLS.Coordinates,
  GLS.BaseClasses,
  GLS.Color,
  GLS.Collision,
  GLS.ParticleFX,

  fpAbout,
  Geos.Profuns,
  GLS.FireFX;

type
  TFormOptipit = class(TForm)
    GLSceneViewer: TGLSceneViewer;
    GLScene1: TGLScene;
    GLCamera: TGLCamera;
    GLDummyCube1: TGLDummyCube;
    GLDummyCube2: TGLDummyCube;
    PanelGenerate: TPanel;
    ButtonGenerate: TButton;
    Timer1: TTimer;
    GLCadencer1: TGLCadencer;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit1: TEdit;
    GLDummyCube4: TGLDummyCube;
    ButtonRandom: TButton;
    EditPoints: TEdit;
    Label1: TLabel;
    EditColorPoints: TEdit;
    Label2: TLabel;
    EditIterations: TEdit;
    Label3: TLabel;
    CheckBox1: TCheckBox;
    OpenTextFileDialog1: TOpenTextFileDialog;
    MainMenu1: TMainMenu;
    miFile: TMenuItem;
    miOpenData: TMenuItem;
    Help1: TMenuItem;
    N1: TMenuItem;
    Close1: TMenuItem;
    N2: TMenuItem;
    Exit1: TMenuItem;
    Point: TGLPoints;
    GLPoints: TGLPoints;
    ButtonClear: TButton;
    miAbout: TMenuItem;
    GLSphere: TGLSphere;
    ColorDialog1: TColorDialog;
    ColorBox1: TColorBox;
    Synthesize1: TMenuItem;
    miGenerate: TMenuItem;
    Clear1: TMenuItem;
    GLLightSource1: TGLLightSource;
    PanelFields: TPanel;
    RadioGroupValue: TRadioGroup;
    procedure GLSceneViewerMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure GLSceneViewerMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure ButtonGenerateClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure GLCadencer1Progress(Sender: TObject;
      const deltaTime, newTime: Double);
    procedure FormCreate(Sender: TObject);
    procedure ButtonRandomClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure miOpenDataClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure miGenerateClick(Sender: TObject);
    procedure RadioGroupValueClick(Sender: TObject);
  private
    sl, // lines in file
    tl: // fields in line
    TStringList;
    LineNum: Integer; // Current line;
    IDBlock: Integer; // Identifier of block

    Btype: Integer; // Type of rock in block
    Xs, Ys, Zs: Single; // Size parameters of structure
    A1, A2, A3: Single; // Constants of grid

    Pnum, Niter: Integer;
    ColorPoint: TGLPoints;
    Oldpos, Newpos: TAffineVector;
    PosArray: array of TAffineVector;
    Started: Boolean;
    Dpas: extended;

  public
    DataDir: String;
    TempStream: TMemoryStream;
    Fs: TFileStream;
  end;

var
  FormOptipit: TFormOptipit;
  mx, my: Integer; // Mouse coordinates

implementation //==============================================================

{$R *.dfm}

procedure TFormOptipit.FormCreate(Sender: TObject);
begin
  SetCurrentDir(ExtractFilePath(ParamStr(0)));
  DataDir := GetDataDirFromBin();
  DataDir := DataDir + '\pits';

  // Create a memory stream
  TempStream := TMemoryStream.Create();
  Randomize;
  Started := False;
  PanelGenerate.Visible := False;
  miGenerate.Checked := False;
end;

// SinCos (Double)
//
procedure RSinCos(const Theta: Double; var Sin, Cos: Double);
// EAX contains address of Sin
// EDX contains address of Cos
// Theta is passed over the stack
asm
  FLD  Theta
  FSINCOS
  FSTP QWORD PTR [EDX]    // cosine
  FSTP QWORD PTR [EAX]    // sine
end;

function Dist(p1, p2: TAffineVector): extended;
begin
  Result := Sqrt(sqr(p1.X - p2.X) + sqr(p1.Y - p2.Y) + sqr(p1.Z - p2.Z));
end;

//-----------------------------------------------------------------------------
procedure TFormOptipit.ButtonGenerateClick(Sender: TObject);
var
  iter, i, i2, adp: Integer;
  sinc, cosc: Double;
  sinc2, cosc2: Double;
  A, B, C, D, pc: extended;
  Color: TAffineVector;
  dst: extended;
  minx, miny, minz, maxx, maxy, maxz, sx, sy, sz: extended;
begin
  Point.Free;
  ColorPoint.Free;
  Point := TGLPoints(GLDummyCube2.AddNewChild(TGLPoints));
  ColorPoint := TGLPoints(GLDummyCube4.AddNewChild(TGLPoints));

  Pnum := StrToInt(EditPoints.Text);
  Niter := StrToInt(EditIterations.Text);
  adp := StrToInt(EditColorPoints.Text);

  SetLength(PosArray, Pnum);

  A := StrToFloat(Edit1.Text);
  B := StrToFloat(Edit2.Text);
  C := StrToFloat(Edit3.Text);
  D := StrToFloat(Edit4.Text);

  ColorPoint.Size := 10.0;
  Point.Size := 1.0;
  Point.NoZWrite := CheckBox1.Checked;

  for i := 0 to Pnum - 1 do
  begin
    PosArray[i].X := (Random(1000000) - 500000) / 100000;
    PosArray[i].Y := (Random(1000000) - 500000) / 100000;
    PosArray[i].Z := (Random(1000000) - 500000) / 100000;
  end;

  for iter := 0 to Niter - 1 do
  begin
    if iter mod 10 = 0 then
    begin
      ButtonGenerate.Caption := IntToStr(iter) + '/' + IntToStr(Niter);
      Application.ProcessMessages;
    end;

    for i := 0 to Pnum - 1 do
    begin
      Oldpos := PosArray[i];

      // posarray[i][0] := sin(A * oldPos[1]) - oldPos[2] * cos(B * oldPos[0]);
      // posarray[i][1] := oldPos[2] * sin(B * oldPos[0]) - cos(C * oldPos[2]);
      // posarray[i][2] := sin(oldPos[0]);

      RSinCos(A * Oldpos.Y, sinc, cosc);
      RSinCos(B * Oldpos.X, sinc2, cosc2);
      PosArray[i].X := sinc - Oldpos.Z * cosc2;
      RSinCos(Oldpos.X, sinc, cosc);
      PosArray[i].Z := sinc;
      RSinCos(C * Oldpos.X, sinc, cosc);
      RSinCos(D * Oldpos.Y, sinc2, cosc2);
      PosArray[i].Y := Oldpos.Z * sinc - cosc2;
    end;
  end;

  minx := 1000;
  miny := 1000;
  minz := 1000;

  maxx := -1000;
  maxy := -1000;
  maxz := -1000;

  for i := 0 to Pnum - 1 do
  begin
    minx := min(PosArray[i].X, minx);
    miny := min(PosArray[i].Y, miny);
    minz := min(PosArray[i].Z, minz);
    maxx := max(PosArray[i].X, maxx);
    maxy := max(PosArray[i].Y, maxy);
    maxz := max(PosArray[i].Z, maxz);
  end;

  sx := -(maxx + minx) / 2;
  sy := -(maxy + miny) / 2;
  sz := -(maxz + minz) / 2;

  for i := 0 to Pnum - 1 do
  begin
    Point.Positions.Add((PosArray[i].X + sx) * 10, (PosArray[i].Y + sy) * 10,
      (PosArray[i].Z + sz) * 10);
  end;

  for i := 0 to adp - 1 do
  begin
    ColorPoint.Colors.AddPoint(Random, Random, Random);
    ColorPoint.Positions.Add((Random(10000) - 5000) / 500,
      (Random(10000) - 5000) / 500, (Random(10000) - 5000) / 500);
  end;

  for i := 0 to Pnum - 1 do
  begin
    Color.X := 0;
    Color.Y := 0;
    Color.Z := 0;

    for i2 := 0 to adp - 1 do
    begin
      dst := Dist(ColorPoint.Positions.Items[i2], Point.Positions.Items[i]);

      if dst > 0 then
        pc := 1 / sqr(dst * 1.3) * 12
      else
        pc := 1;
      {
        color.X := min(colorpoint.Colors.Items[i2].X,color.X + pc * colorpoint.Colors.Items[i2].X);
        color.Y := min(colorpoint.Colors.Items[i2].Y,color.Y + pc * colorpoint.Colors.Items[i2].Y);
        color.Z := min(colorpoint.Colors.Items[i2].Z,color.Z + pc * colorpoint.Colors.Items[i2].Z);
        { }
      Color.X := min(1, Color.X + pc * ColorPoint.Colors.Items[i2].X);
      Color.Y := min(1, Color.Y + pc * ColorPoint.Colors.Items[i2].Y);
      Color.Z := min(1, Color.Z + pc * ColorPoint.Colors.Items[i2].Z);

    end;
    Point.Colors.AddPoint(Color.X, Color.Y, Color.Z);
  end;
  ButtonGenerate.Caption := 'Создать';
end;

//-----------------------------------------------------------------------------
procedure TFormOptipit.ButtonRandomClick(Sender: TObject);
begin
  Randomize;
  Edit1.Text := FloatToStrF((Random(6000000) - 3000000) / 1000000,
    fffixed, 6, 6);
  Edit2.Text := FloatToStrF((Random(6000000) - 3000000) / 1000000,
    fffixed, 6, 6);
  Edit3.Text := FloatToStrF((Random(6000000) - 3000000) / 1000000,
    fffixed, 6, 6);
  Edit4.Text := FloatToStrF((Random(6000000) - 3000000) / 1000000,
    fffixed, 6, 6);
end;

procedure TFormOptipit.ButtonClearClick(Sender: TObject);
begin
  Point.Free;
  ColorPoint.Free;
  GLPoints.Free;
  Point := TGLPoints(GLDummyCube2.AddNewChild(TGLPoints));
  ColorPoint := TGLPoints(GLDummyCube4.AddNewChild(TGLPoints));
  GLPoints := TGLPoints(GLDummyCube2.AddNewChild(TGLPoints));
end;

procedure TFormOptipit.CheckBox1Click(Sender: TObject);
begin
  Point.NoZWrite := CheckBox1.Checked;
end;

//-----------------------------------------------------------------------------
procedure TFormOptipit.miGenerateClick(Sender: TObject);
begin
  miGenerate.Checked := not miGenerate.Checked;
  PanelGenerate.Visible := miGenerate.Checked;
  PanelFields.Visible := not miGenerate.Checked;
end;

procedure TFormOptipit.GLCadencer1Progress(Sender: TObject;
  const deltaTime, newTime: Double);
var
  iter, i: Integer;
  sinc, cosc: Single;
  sinc2, cosc2: Single;
begin
  GLSceneViewer.Invalidate();
end;

//-----------------------------------------------------------------------------
procedure TFormOptipit.GLSceneViewerMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  my := Y;
  mx := X;
end;

//-----------------------------------------------------------------------------
procedure TFormOptipit.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  GLCamera.AdjustDistanceToTarget(Power(1.1, WheelDelta / 120));
end;

//-----------------------------------------------------------------------------
procedure TFormOptipit.GLSceneViewerMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if (SSRight in Shift) or (SSLeft in Shift) then
    GLCamera.MoveAroundTarget(my - Y, mx - X);
  my := Y;
  mx := X;
end;

procedure TFormOptipit.Timer1Timer(Sender: TObject);
begin
  // miFPS.Caption := Format('%.2f FPS', [GLSceneViewer1.FramesPerSecond]);
  // GLSceneViewer1.ResetPerformanceMonitor;
end;

procedure TFormOptipit.FormDestroy(Sender: TObject);
begin
  TempStream.Free;
end;

//--------------------------------------------------------------------------
procedure TFormOptipit.miOpenDataClick(Sender: TObject);
var
  F: TextFile;
  S: String;
  LowLine, HighLine: Integer;

  (*sub*)function ReadPrecedences: Boolean;
  begin
    //
  end;

  (*sub*)function ReadUltimatePit: Boolean;
  begin
    //
  end;

  (*sub*)function ReadConstrainedPit: Boolean;
  begin
    //
  end;

  (*sub*)function ReadProductScheduling: Boolean;
  begin
    //
  end;

  (*sub*)function ReadSolution: Boolean;
  begin
    //
  end;

//-----------------------------------------------------------------------------
// Читает значения блоков из файла и показывает их как точки данных
//-----------------------------------------------------------------------------
(*sub*)function ReadBlocks: Boolean;
  var
    i: Integer;
    NB: Byte;
    X, Y, Z: Integer; // Current coordinates for block centers
    G: Single; // Current grade of block

    Color: TVector3f;
    RealColor: TColor;
    RealGLColor: TGLColor;

  begin
    NB := RadioGroupValue.ItemIndex + 5; // ID(F1), X(F2), Y(F3), Z(F4), etc.
    for i := 0 to sl.Count - 1 do
    begin
      tl.CommaText := sl[i];
      IDBlock := StrToInt(tl[0]); // Id of block
      X := StrToInt(tl[1]);
      Z := StrToInt(tl[2]);
      Y := StrToInt(tl[3]);
      GLPoints.Positions.Add(X * 0.05, Y * 0.05, Z * 0.05);
      GLPoints.Size := 2.0;

      RealColor := Round(StrToFloat(tl[NB]));
      /// ColorToRGB(RealColor);

      Color.X := Random();
      Color.Y := Random();
      Color.Z := Random();
//      GLPoints.Material.BackProperties.Ambient.RandomColor;
//      GLPoints.Material.FrontProperties.Diffuse.RandomColor;
//      GLPoints.Material.BackProperties.Specular.RandomColor;
      GLPoints.Colors.AddPoint(Color);

      // Fill array of GLPoints

      // GLPoints.Material.BackProperties.Diffuse := RealGLColor;    ???
      // GLPoints.Colors.AddPoint(1, 0.5, 0.5); // Temporarily random colors

      /// GLSphere.Assign();
    end;
  end;

begin
  GLPoints.Free;
  GLPoints := TGLPoints(GLDummyCube2.AddNewChild(TGLPoints));

  sl := TStringList.Create;
  tl := TStringList.Create;
  OpenTextFileDialog1.InitialDir := DataDir; // SetCurrentDir(DataDir);
  OpenTextFileDialog1.FilterIndex := 1;
  if OpenTextFileDialog1.Execute() then
  try
    sl.LoadFromFile(OpenTextFileDialog1.FileName);
    case OpenTextFileDialog1.FilterIndex of
      1:
        ReadBlocks;
      2:
        ReadPrecedences;
      3:
        ReadUltimatePit;
      4:
        ReadConstrainedPit;
      5:
        ReadProductScheduling;
      6:
        ReadSolution;
      7:
        ReadBlocks;
    end;
    GLPoints.TurnAngle := 45;

    GLPoints.Position.X := -7.0;
    GLPoints.Position.Y := 0.0;
    GLPoints.Position.Z := 0.0;

    GLPoints.Scale.X := 3.34; // only for marvin
    GLPoints.Scale.Y := 3.34; //
    GLPoints.Scale.Z := 3.34;
  finally
    sl.Free;
    tl.Free;
  end
  else
    Exit;
  // EditColorPoints.Text := IntToStr(Ntypes);
end;

//----------------------------------------------------------------------------
procedure TFormOptipit.RadioGroupValueClick(Sender: TObject);
begin
  // ReadBlocks
end;

//----------------------------------------------------------------------------
procedure TFormOptipit.miAboutClick(Sender: TObject);
begin
  with TFormAbout.Create(Self) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

//----------------------------------------------------------------------------
procedure TFormOptipit.Exit1Click(Sender: TObject);
begin
  Close;
end;

end.
