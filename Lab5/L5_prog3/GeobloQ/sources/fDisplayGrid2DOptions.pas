//-----------------------------------------------------------------------------
// The modeling system Geoblock http://sourceforge.net/projects/geoblock
 //-----------------------------------------------------------------------------
 {! The dialog to display options for 2d grid models }

unit fDisplayGrid2DOptions;

interface

uses
  System.SysUtils, 
  System.Classes,
  Vcl.Graphics, 
  Vcl.Controls, 
  Vcl.Forms, 
  Vcl.Dialogs,
  Vcl.StdCtrls, 
  Vcl.CheckLst, 
  Vcl.ExtCtrls, 
  Vcl.Buttons, 
  Vcl.Samples.Spin,

  usModels,
  fOptionDialog;

type
  TFormDisplayGrid2DOptions = class(TfmOptionDialog)
    CheckBoxByVertices: TCheckBox;
    GroupBoxFeature:    TGroupBox;
    ButtonIsolines: TButton;
    CheckBoxIsolines: TCheckBox;
    ButtonVectors:      TButton;
    CheckBoxVectors:    TCheckBox;
    CheckBoxAsHeight:   TCheckBox;
    procedure CheckBoxAsHeightClick(Sender: TObject);
    procedure CheckBoxIsolinesClick(Sender: TObject);
    procedure CheckBoxVectorsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBoxByVerticesClick(Sender: TObject);
  private
    procedure AssignFromGrid2D(Source: TGBGrid2D);
    procedure AssignToGrid2D(Dest: TGBGrid2D);
  public
    procedure Assign(Source: TPersistent); override;
    procedure AssignTo(Dest: TPersistent); override;
  end;

var
  FormDisplayGrid2DOptions: TFormDisplayGrid2DOptions;

implementation

uses
  fMapWindow;

{$R *.DFM}

{ TfmDisplayGrid2DOptions }

procedure TFormDisplayGrid2DOptions.FormCreate(Sender: TObject);
begin
  inherited;
  ButtonIsolines.Enabled := CheckBoxIsolines.Checked;
  ButtonVectors.Enabled  := CheckBoxVectors.Checked;
end;

procedure TFormDisplayGrid2DOptions.Assign(Source: TPersistent);
begin
  if Source is TGBGrid2D then
    AssignFromGrid2D(TGBGrid2D(Source))
  else
    inherited;
end;

procedure TFormDisplayGrid2DOptions.AssignTo(Dest: TPersistent);
begin
  if Dest is TGBGrid2D then
    AssignToGrid2D(TGBGrid2D(Dest))
  else
    inherited;
end;

procedure TFormDisplayGrid2DOptions.AssignFromGrid2D(Source: TGBGrid2D);
begin
  AssignFromModel(Source);
  CheckBoxByVertices.Checked := Source.ShowByCenters;
  CheckBoxAsHeight.Checked   := Source.ShowAsHeight;
  CheckBoxIsolines.Checked   := Source.ShowIsolines;
  CheckBoxVectors.Checked    := Source.ShowVectors;
end;

procedure TFormDisplayGrid2DOptions.AssignToGrid2D(Dest: TGBGrid2D);
begin
  Dest.ShowByCenters := CheckBoxByVertices.Checked;
  Dest.ShowAsHeight   := CheckBoxAsHeight.Checked;
  Dest.ShowIsolines   := CheckBoxIsolines.Checked;
  Dest.ShowVectors    := CheckBoxVectors.Checked;
  AssignToModel(Dest);
end;

procedure TFormDisplayGrid2DOptions.CheckBoxIsolinesClick(Sender: TObject);
begin
  ButtonIsolines.Enabled := CheckBoxIsolines.Checked;
end;

procedure TFormDisplayGrid2DOptions.CheckBoxVectorsClick(Sender: TObject);
begin
  ButtonVectors.Enabled := CheckBoxVectors.Checked;
end;


procedure TFormDisplayGrid2DOptions.CheckBoxAsHeightClick(Sender: TObject);
begin
  AssignTo(frmMapWindow.Model);
  frmMapWindow.Repaint;
end;

procedure TFormDisplayGrid2DOptions.CheckBoxByVerticesClick(Sender: TObject);
begin
  AssignTo(frmMapWindow.Model);
  frmMapWindow.Repaint;
end;

end.
