//----------------------------------------------------------------------------
// Main form of Geochronology plugin for Geoblock
//----------------------------------------------------------------------------
//
{! The Main form of Geochronology plugin for Geoblock }

unit fGeochronology;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.IniFiles,
  System.Win.Registry,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.DBCtrls,
  Vcl.Grids,
  Vcl.DBGrids,
  Data.DB,
  Data.FMTBcd,
  Data.SqlExpr,
  Bde.DBTables,

  Vcl.ToolWin,
  Vcl.ActnMan,
  Vcl.ActnCtrls,
  Vcl.ActnMenus
  {GR32_Image,};

type
  TfmMainForm = class(TForm)
    GroupBoxTimeScales: TGroupBox;
    GroupBoxHistoryTree: TGroupBox;
    TreeView: TTreeView;
    Splitter1: TSplitter;
    GroupBoxLegend: TGroupBox;
    DBGrid: TDBGrid;
    GroupBoxDescription: TGroupBox;
    DBRichEditDescription: TDBRichEdit;
    DataSourceAge: TDataSource;
    TableAge: TTable;
    DBGridEpoch: TDBGrid;
    DataSourceEpoch: TDataSource;
    TableEpoch: TTable;
    PanelTimeScale: TPanel;
    PanelUniverseScale: TPanel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    TrackBarScale: TTrackBar;
    procedure FormCreate(Sender: TObject);
  private
  public
    RegIni: TRegistryIniFile;
    procedure SetLanguage;
  end;

var
  fmMainForm: TfmMainForm;

//===============================================================
implementation
//===============================================================

uses
  usGlobals,
  usCommon,
  Geos.Profuns;

{$R *.dfm}

procedure TfmMainForm.SetLanguage;
var
  FileName: TFileName;

begin
  RegIni := TRegistryIniFile.Create(GeneralSection);
  AppPath := RegIni.ReadString(GeneralSection,'AppPath', AppPath);


  TreeView.LoadFromFile(FileName);
  TreeView.Items[0].Expand(False);

  RegIni.Free;
end;

procedure TfmMainForm.FormCreate(Sender: TObject);
begin
  SetLanguage;
  TableAge.Open;
  TableEpoch.Open;
end;


end.
