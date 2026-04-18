unit fAtomicRotation;
(*
  As the data is 'global' this changes it...
  The stage[1].rot_x,y,z is processed by the Cadencer
  rotating the Dummycubes (they are holding the Spheres)
*)

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,

  Stage.VectorTypes,
  GLS.Objects,
  GLS.Coordinates,
  Vcl.ComCtrls,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Buttons;

type
  TFormAtomicRotation = class(TForm)
    AtomicLevelsRg: TRadioGroup;
    TrackBarX: TTrackBar;
    TrackBarY: TTrackBar;
    TrackBarZ: TTrackBar;
    ColorDialog1: TColorDialog;
    SpeedButton1: TSpeedButton;
    LevelLineCB: TCheckBox;
    procedure AtomicLevelsRgClick(Sender: TObject);
    procedure TrackBarXChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure LevelLineCBClick(Sender: TObject);
    { procedure AllLinesCBClick(Sender: TObject); }
  private

  public

  end;

var
  FormAtomicRotation: TFormAtomicRotation;
  LinesBusy: Boolean;

implementation

uses
  fAtoms;

{$R *.DFM}

procedure TFormAtomicRotation.FormCreate(Sender: TObject);
begin
  TrackBarX.Position := Round(Stages[1].rot_x * 100);
  TrackBarY.Position := Round(Stages[1].rot_y * 100);
  TrackBarZ.Position := Round(Stages[1].rot_z * 100);
  LinesBusy := False;
end;

procedure TFormAtomicRotation.AtomicLevelsRgClick(Sender: TObject);
begin
  If AtomicLevelsRg.ItemIndex = 7 then
  begin
    TrackBarX.Position := Round(FormAtoms.WhiteLight.Position.X);
    TrackBarY.Position := Round(FormAtoms.WhiteLight.Position.Y);
    TrackBarZ.Position := Round(FormAtoms.WhiteLight.Position.Z);
  end
  else
  begin
    TrackBarX.Position := Round(Stages[AtomicLevelsRg.ItemIndex + 1]
      .rot_x * 100);
    TrackBarY.Position := Round(Stages[AtomicLevelsRg.ItemIndex + 1]
      .rot_y * 100);
    TrackBarZ.Position := Round(Stages[AtomicLevelsRg.ItemIndex + 1]
      .rot_z * 100);
    If LevelLine then
      LevelLineLevel := AtomicLevelsRg.ItemIndex + 1;
  end;
end;

procedure TFormAtomicRotation.TrackBarXChange(Sender: TObject);
begin
  If AtomicLevelsRg.ItemIndex = 7 then
  begin
    FormAtoms.WhiteLight.Position.SetPoint(TrackBarX.Position,
      TrackBarY.Position, TrackBarZ.Position);
    { (TGLCoordinates)
      (AAtomForm.WhiteLight.Position.X):=TrackBarX.Position;
      (AAtomForm.WhiteLight.Position.Y):=TrackBarY.Position;
      (AAtomForm.WhiteLight.Position.Z):=TrackBarZ.Position; }
  end
  else
  begin
    Stages[AtomicLevelsRg.ItemIndex + 1].rot_x := TrackBarX.Position / 100;
    Stages[AtomicLevelsRg.ItemIndex + 1].rot_y := TrackBarY.Position / 100;
    Stages[AtomicLevelsRg.ItemIndex + 1].rot_z := TrackBarZ.Position / 100;
  end;
end;

procedure TFormAtomicRotation.SpeedButton1Click(Sender: TObject);
begin
  If (AtomicLevelsRg.ItemIndex < 7) then // do not paint light
    if ColorDialog1.Execute then
      // CastColor(Leveled:Integer;NewColor:TColor);
      FormAtoms.CastColor((AtomicLevelsRg.ItemIndex + 1), ColorDialog1.Color);
end;

procedure TFormAtomicRotation.LevelLineCBClick(Sender: TObject);
// var i:Integer;
begin
  If (not LinesBusy) then
  begin
    LinesBusy := True;
    If (AtomicLevelsRg.ItemIndex < 7) then
    begin
      LevelLineLevel := AtomicLevelsRg.ItemIndex + 1;
      LevelLine := (not LevelLine);
      LevelLineCB.Checked := LevelLine;
      MaxLines := 36;
    end;
    If (LevelLine = False) then
    begin
      LevelLineLevel := 0;
      MaxLines := 36;
      FormAtoms.DoLevelLineLevel;
      // method to clear lines... changed to move to inside,
      // this broke program whenever lines were turned on again
      // another way would be to make a 1st point again, as in create.
      (*
      for i:=0 to AAtomForm.Lines1.Nodes.Count-1 do
        AAtomForm.Lines1.Nodes[0].Free;
        Lines1.AddNode(0, 0, 0);
      *)
    end;
    LinesBusy := False;
  end;
end;

// Пытаемся соединить линиями все уровни...
// для этого надо 7 line objects
// put off till turned into an Atom class
// для каждого уровня нарисовать линию заданного цвета...

(*
procedure TAtomicRotationForm.AllLinesCBClick(Sender: TObject);
begin
  If (AtomicLevelsRg.ItemIndex< 7) then
  If (LevelLine) then
  begin
  LevelLineLevel:= 9;
  MaxLines:=156;
  end;
end;
*)

end.
