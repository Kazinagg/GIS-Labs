//------------------------------------------------------------------------------
// The modeling system Geoblock http://sourceforge.net/projects/geoblock
//---------------------------------------------------------------------------
(* Experimental variograms viewer *)

unit fViewVariogram;

interface

uses
  System.SysUtils, 
  System.Variants, 
  System.Classes,
  Vcl.Graphics, 
  Vcl.Controls, 
  Vcl.Forms, 
  Vcl.ComCtrls, 
  Vcl.Samples.Spin,
  Vcl.Dialogs,
  Vcl.StdCtrls, 
  Vcl.ExtCtrls, 
  Vcl.Grids,
  VclTee.TeeProcs, 
  VclTee.TeEngine, 
  VclTee.Chart, 
  Vcl.DBGrids, 
  VclTee.Series,
  VclTee.DbChart, 
  VclTee.TeeGDIPlus,

  //DB
  Bde.DBTables,
  Data.DB,

  fmBlankDialog,
  usGlobals,
  usVariograms;

type
  TFormViewVariogram = class(TFormBlankDialog)
    GroupBoxVariogram: TGroupBox;
    TreeViewVariogram: TTreeView;
    PageControlViewMode: TPageControl;
    TabSheetTable: TTabSheet;
    TabSheetGraph: TTabSheet;
    DBChart:    TDBChart;
    DBGrid:     TDBGrid;
    Query:      TQuery;
    DataSource: TDataSource;
    Series1:    TLineSeries;
    procedure TreeViewVariogramClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    CurrentID: integer;
    procedure SelectData(vid: integer);
    procedure UpdateTree;
  public
    VariogramFileName: TFileName;
    DisplayMode: integer;
  end;

var
  FormViewVariogram: TFormViewVariogram;

//=================================================================
implementation
//=================================================================

{$R *.dfm}

procedure TFormViewVariogram.FormShow(Sender: TObject);
begin
  UpdateTree;
  case DisplayMode of
    1: PageControlViewMode.ActivePage := TabSheetTable;
    2: PageControlViewMode.ActivePage := TabSheetGraph;
  end;
  with DBChart.Series[0] do
  begin
    DataSource := Query;
    XValues.ValueSource := fldAvgSeparationDistance;
    YValues.ValueSource := fldG;
  end;
end;

procedure TFormViewVariogram.UpdateTree;
var
  TableVar: TTable;
  root, t: TTreeNode;
  p: PInteger;
  i: integer;
begin
  TreeViewVariogram.Items.Clear;
  TableVar := TTable.Create(self);
  TableVar.TableName := VariogramFileName;
  root     := TreeViewVariogram.Items.AddChild(nil, ExtractFileName(VariogramFileName));
  with TableVar, TreeViewVariogram.Items do
  begin
    Open;
    First;
    i := 1;
    while not EOF do
    begin
      New(p);
      p^ := FieldByName(fldID).Value;
      t  := AddChildObject(root, 'Variogram' + ' ' + IntToStr(i), p);
      AddChild(t, 'Type' + ': ' + VariogramNames[FieldByName(fldVarType).AsInteger]);
      AddChild(t, 'Attribute' + ': ' + FieldByName(fldATTRIBUTE).Value);
      if FieldByName(fldDim3d).Value then
        AddChild(t, 'Dimension' + ': 3D')
      else
        AddChild(t, 'Dimension' + ': 2D');
      AddChild(t, 'Azimuth' + ': ' + FloatToStr(FieldByName(fldAzimuthAngle).Value));
      AddChild(t, 'Azimuth tolerance' + ': ' +
        FloatToStr(FieldByName(fldAzimuthTolerance).Value));
      AddChild(t, 'Arimuth bandwidth' + ': ' +
        FloatToStr(FieldByName(fldAzimuthBandwidth).Value));
      AddChild(t, 'Dip' + ': ' + FloatToStr(FieldByName(fldDipAngle).Value));
      AddChild(t, 'Dip tolerance' + ': ' +
        FloatToStr(FieldByName(fldDipTolerance).Value));
      AddChild(t, 'Dip bandwidth' + ': ' +
        FloatToStr(FieldByName(fldDipBandwidth).Value));
      AddChild(t, 'Lags' + ': ' + FloatToStr(FieldByName(fldLagsN).Value));
      AddChild(t, 'Distance' + ': ' + FloatToStr(FieldByName(fldLagDistance).Value));
      AddChild(t, 'Tolerance' + ': ' +
        FloatToStr(FieldByName(fldLagTolerance).Value));
      Next;
      Inc(i);
    end;
    Close;
  end;
  TableVar.Free;
  root.GetFirstChild.Selected := True;
  CurrentID := -1;
  TreeViewVariogramClick(self);
end;

procedure TFormViewVariogram.SelectData(vid: integer);
begin
  Query.Close;
  with Query.SQL do
  begin
    Clear;
    Add('SELECT * FROM "' + VariogramFileName + '_DATA' + '"');
    Add('WHERE ' + fldVarID + '=' + IntToStr(vid));
  end;
  Query.Open;
end;

procedure TFormViewVariogram.TreeViewVariogramClick(Sender: TObject);
var
  id: integer;
begin
  with TreeViewVariogram do
  begin
    if Selected.Level = 1 then
      id := PInteger(Selected.Data)^
    else if Selected.Level = 2 then
      id := PInteger(Selected.Parent.Data)^
    else
      id := CurrentID;
    if id <> CurrentID then
      SelectData(id);
    CurrentID := id;
  end;
end;

end.
