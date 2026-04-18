 //----------------------------------------------------------------------------
 // The unit of Geoblock, http://sourceforge.net/projects/geoblock
 // The contents of this file are subject to the Mozilla Public License
 // Version 2.0 (the "License"); you may not use this file except in compliance
 // with the License. You may obtain a copy of the License at http://www.mozilla.org/MPL/

 // Software distributed under the License is distributed on an "AS IS" basis,
 // WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
 // the specific language governing rights and limitations under the License.
 // The initial developer of the original code is Getos Ltd., Copyright (c) 1997.
 // Portions created by contributors are documented in a history log
 // and Copyright (c) of these contributors. All Rights Reserved.
 //---------------------------------------------------------------------------
 {! The Main form with menus, panels and toolbars }

unit fmGeoblock;

interface

uses
  Winapi.Windows, 
  System.IniFiles,
  System.SysUtils, 
  System.Classes, 
  System.Actions,
  System.Win.Registry,
  Vcl.Forms, 
  Vcl.Controls, 
  Vcl.StdCtrls,
  Vcl.Dialogs, 
  Vcl.Buttons,
  Vcl.ComCtrls, 
  Vcl.ExtCtrls, 
  Vcl.ToolWin, 
  Vcl.ActnList, 
  Vcl.ActnCtrls,
  Vcl.Samples.Spin, 
  Vcl.StdActns, 
  Vcl.BandActn, 
  Vcl.ActnMan, 
  Vcl.ActnMenus,
  Vcl.XPStyleActnCtrls, 
  Vcl.StdStyleActnCtrls,
  Vcl.ImgList,
  Vcl.CustomizeDlg,
  Vcl.ActnColorMaps,
  Vcl.Graphics, 
  Vcl.HtmlHelpViewer,

  fmFirstForm,
  dbase,
  dDialogs;

/// The Main form
type
  TFormGeoblock = class(TFormFirst)
    StatusBar:    TStatusBar;
    ControlBarTop: TControlBar;
    ControlBarBottom: TControlBar;
    ControlBarRight: TControlBar;
    PanelModelPalette: TPanel;
    PageControlModels: TPageControl;
    TabSheetHoles: TTabSheet;
    TabSheetPoints2D: TTabSheet;
    TabSheetPoints3D: TTabSheet;
    TabSheetPolygons: TTabSheet;
    TabSheetTins: TTabSheet;
    TabSheetSolids: TTabSheet;
    TabSheetGrids2D: TTabSheet;
    ToolBarGrids2D: TToolBar;
    TabSheetGrids3D: TTabSheet;
    TabSheetMeshes2D: TTabSheet;
    TabSheetMeshes3D: TTabSheet;
    ToolButton2:  TToolButton;
    TabSheetDrawings: TTabSheet;
    ToolBarGrids3D: TToolBar;
    StaticTextGrid3DRow: TStaticText;
    SpinEditGrid3DRow: TSpinEdit;
    StaticTextGrid3DColumn: TStaticText;
    SpinEditGrid3DColumn: TSpinEdit;
    StaticTextGrid3DLayer: TStaticText;
    SpinEditGrid3DLayer: TSpinEdit;
    StaticTextGrid2DRow: TStaticText;
    StaticTextGrid2DColumn: TStaticText;
    SpinEditGrid2DColumn: TSpinEdit;
    ActionManager: TActionManager;
    EditCopy:     TEditCopy;
    EditPaste:    TEditPaste;
    EditSelectAll: TEditSelectAll;
    EditUndo:     TEditUndo;
    EditDelete:   TEditDelete;
    WindowClose:  TWindowClose;
    WindowCascade: TWindowCascade;
    WindowTileHorizontal: TWindowTileHorizontal;
    WindowTileVertical: TWindowTileVertical;
    WindowMinimizeAll: TWindowMinimizeAll;
    WindowArrange: TWindowArrange;
    StyleText:    TAction;
    StyleSymbol:  TAction;
    StyleLine:    TAction;
    StyleFill:    TAction;
    CalculatorGeology: TAction;
    CalculatorGeometry: TAction;
    ActionToolBarStandard: TActionToolBar;
    ActionToolBarEdit: TActionToolBar;
    ActionToolBarMap: TActionToolBar;
    ActionToolBarView: TActionToolBar;
    ActionToolBarAnalyse: TActionToolBar;
    EditCut:      TEditCut;
    ToolsStandardStyle: TAction;
    ToolsXPStyle: TAction;
    ToolsCustomize: TCustomizeActionBars;
    HelpGlossary: TAction;
    HelpContents: TAction;
    HelpAbout:    TAction;
    ObserveTop:   TAction;
    ObserveBottom: TAction;
    ObserveBack:  TAction;
    ObserveLeft:  TAction;
    ObserveRight: TAction;
    ObserveFront: TAction;
    Observe3D:    TAction;
    ObserveRotate: TAction;
    ObservePerspective: TAction;
    ActionToolBarObserve: TActionToolBar;
    WindowRedraw: TAction;
    ToolsConfiguration: TAction;
    ToolsUnitsConverter: TAction;
    CalculatorMining: TAction;
    CalculatorSurvey: TAction;
    acAnalyseProblemBook: TAction;
    acAnalyseVolumeCalculation: TAction;
    acAnalyseReserveCalculation: TAction;
    acAnalyseBaseStatistics: TAction;
    acAnalyseFactorAnalysis: TAction;
    acAnalyseVariograms: TAction;
    CompositingSampleContacts: TAction;
    CompositingCenters: TAction;
    CompositingOreIntervals: TAction;
    CompositingOreSorting: TAction;
    CompositingInsideHorizons: TAction;
    CompositingLinearReserves: TAction;
    FileOpenProject: TAction;
    FileOpenModel: TAction;
    FileOpenReport: TAction;
    FileOpenImage: TAction;
    FileOpenText: TAction;
    FileSave:     TAction;
    FileSaveAs:   TAction;
    FileSaveProjectAs: TAction;
    FileClose:    TAction;
    FileCloseAll: TAction;
    FileImport:   TAction;
    FileExport:   TAction;
    MethodConversion: TAction;
    FilePrint:    TAction;
    FilePrintPreview: TAction;
    FileExit: TFileExit;
    EditFind:     TAction;
    DrawText:     TAction;
    DrawSymbol:   TAction;
    DrawPolyline: TAction;
    DrawPolygon:  TAction;
    DrawEllipse:  TAction;
    DrawRectangle: TAction;
    DrawSolid:    TAction;
    DrawReshape:  TAction;
    DrawAddNode:  TAction;
    DrawDepth:    TAction;
    MapOptions:   TAction;
    MapLegend:    TAction;
    MapMaterial:  TAction;
    MapLighting:  TAction;
    MapBackColor: TAction;
    ViewProjectManager: TAction;
    ViewScale:    TAction;
    aZoomInOut: TAction;
    ViewSelect:   TAction;
    ViewScroll:   TAction;
    ViewPan:      TAction;
    ViewPlaneXY:  TAction;
    ViewPlaneXZ:  TAction;
    ViewPlaneYZ:  TAction;
    ViewVolumeXYZ: TAction;
    ViewStatusline: TAction;
    aZoomToProject: TAction;
    aZoomToComplete: TAction;
    aZoomToModel: TAction;
    aZoomToRectangle: TAction;
    DrillholesOptions: TAction;
    DrillholesSelectDrillhole: TAction;
    DrillholesSelectContact: TAction;
    DrillholesSelectSegment: TAction;
    DrillholesCreateDrillhole: TAction;
    DrillholesCreateSegment: TAction;
    Points2DOptions: TAction;
    Points2DSelectPoint: TAction;
    Points2DCreatePoint: TAction;
    Points3DOptions: TAction;
    Points3DSelectPoint: TAction;
    Points3DCreatePoint: TAction;
    PolygonsOptions: TAction;
    PolygonsSelectPolygon: TAction;
    PolygonsSelectVertex: TAction;
    PolygonsCreatePolygon: TAction;
    PolygonsSelectType: TAction;
    PolygonsLinkToSolid: TAction;
    TinOptions:   TAction;
    TinVertex:    TAction;
    TinSelectEdge: TAction;
    TinSelectTriangle: TAction;
    TinCreateVertex: TAction;
    TinCreateTriangle: TAction;
    TinSwapDiagonals: TAction;
    SolidOptions: TAction;
    SolidCreate:  TAction;
    SolidSelect:  TAction;
    Grid2DOptions: TAction;
    Grid2DSelectCell: TAction;
    Grid2DSelectRow: TAction;
    Grid2DSelectCol: TAction;
    Grid2DCreateCell: TAction;
    Grid3DOptions: TAction;
    Grid3DSelectCell: TAction;
    Grid3DSelectRow: TAction;
    Grid3DSelectCol: TAction;
    Grid3DSelectLay: TAction;
    Grid3DCreateCell: TAction;
    Mesh2DOptions: TAction;
    Mesh2DSelectNode: TAction;
    Mesh2DSelectCell: TAction;
    Mesh2DCreateCell: TAction;
    Mesh3DOptions: TAction;
    Mesh3DSelectNode: TAction;
    Mesh3DSelectCell: TAction;
    Mesh3DCreateNode: TAction;
    Mesh3DCreateCell: TAction;
    ShowSection:  TAction;
    ShowContours: TAction;
    ShowIsosurface: TAction;
    ShowVectors:  TAction;
    ShowFilm:     TAction;
    MethodGridGeneration: TAction;
    MethodTriangulation: TAction;
    MethodInterpolation: TAction;
    MethodBlockEvaluation: TAction;
    MethodPitOptimization: TAction;
    MethodSetOperations: TAction;
    ActionToolBarPoints2D: TActionToolBar;
    ActionToolBarDrillholes: TActionToolBar;
    ActionToolBarPoints3D: TActionToolBar;
    ActionToolBarPolygons: TActionToolBar;
    SpinEditGrid2DRow: TSpinEdit;
    ActionToolBarGrid2D: TActionToolBar;
    ActionToolBarGrid3D: TActionToolBar;
    ActionToolBarTin: TActionToolBar;
    ActionToolBarSolids: TActionToolBar;
    ActionToolBarMesh2D: TActionToolBar;
    ActionToolBarMesh3D: TActionToolBar;
    ActionToolBarDrawing: TActionToolBar;
    ActionToolBarMethod: TActionToolBar;
    MethodTransformation: TAction;
    XPColorMap:   TXPColorMap;
    MethodPrediction: TAction;
    CustomizeDlg: TCustomizeDlg;
    ActionMainMenuBar: TActionMainMenuBar;
    Action1:      TAction;
    FileDataBase: TAction;
    TabSheetPolylines: TTabSheet;
    ActionToolBarPolylines: TActionToolBar;
    ViewTableWindow: TAction;
    MethodVarModeling: TAction;
    ViewMapWindow: TAction;
    OctreeConstruction: TAction;
    MethodSimulation: TAction;
    PanelLeft: TPanel;
    PanelBottom: TPanel;
    ToolBarShowAs: TToolBar;
    ToolButton3: TToolButton;
    ToolButtonMap: TToolButton;
    ToolButtonTable: TToolButton;
    ToolButtonGraph: TToolButton;
    ToolButton1: TToolButton;
    tbCollapse: TToolButton;
    tbExpand: TToolButton;
    PanelTop: TPanel;
    LabelPath: TLabel;
    SpeedButtonBrowse: TSpeedButton;
    SpeedButtonDelete: TSpeedButton;
    PanelInputPath: TPanel;
    PanelMiddle: TPanel;
    pgDatabase: TPageControl;
    tsExploring: TTabSheet;
    TreeView: TTreeView;
    tsModeling: TTabSheet;
    TreeView1: TTreeView;
    tsReference: TTabSheet;
    TreeView2: TTreeView;
    procedure ViewTableWindowExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure ToolsStandardStyleExecute(Sender: TObject);
    procedure ToolsXPStyleExecute(Sender: TObject);
    procedure ObserveTopExecute(Sender: TObject);
    procedure ObserveBottomExecute(Sender: TObject);
    procedure ObserveBackExecute(Sender: TObject);
    procedure ObserveRightExecute(Sender: TObject);
    procedure ObserveLeftExecute(Sender: TObject);
    procedure ObserveFrontExecute(Sender: TObject);
    procedure Observe3DExecute(Sender: TObject);
    procedure ObserveRotateExecute(Sender: TObject);
    procedure ObservePerspectiveExecute(Sender: TObject);
    procedure WindowRedrawExecute(Sender: TObject);
    procedure StyleTextExecute(Sender: TObject);
    procedure StyleSymbolExecute(Sender: TObject);
    procedure StyleLineExecute(Sender: TObject);
    procedure StyleFillExecute(Sender: TObject);
    procedure CalculatorGeologyExecute(Sender: TObject);
    procedure CalculatorGeometryExecute(Sender: TObject);
    procedure CalculatorMiningExecute(Sender: TObject);
    procedure CalculatorSurveyExecute(Sender: TObject);
    procedure acAnalyseProblemBookExecute(Sender: TObject);
    procedure acAnalyseVolumeCalculationExecute(Sender: TObject);
    procedure acAnalyseReserveCalculationExecute(Sender: TObject);
    procedure acAnalyseBaseStatisticsExecute(Sender: TObject);
    procedure acAnalyseVariogramsExecute(Sender: TObject);
    procedure CompositingSampleContactsExecute(Sender: TObject);
    procedure CompositingCentersExecute(Sender: TObject);
    procedure CompositingOreSortingExecute(Sender: TObject);
    procedure CompositingInsideHorizonsExecute(Sender: TObject);
    procedure CompositingOreIntervalsExecute(Sender: TObject);
    procedure CompositingLinearReservesExecute(Sender: TObject);
    procedure FileNewExecute(Sender: TObject);
    procedure FileDataBaseExecute(Sender: TObject);
    procedure FileOpenProjectExecute(Sender: TObject);
    procedure FileOpenModelExecute(Sender: TObject);
    procedure FileOpenReportExecute(Sender: TObject);
    procedure FileOpenImageExecute(Sender: TObject);
    procedure FileOpenTextExecute(Sender: TObject);
    procedure FileSaveAsExecute(Sender: TObject);
    procedure FileSaveProjectAsExecute(Sender: TObject);
    procedure FileCloseAllExecute(Sender: TObject);
    procedure FileCloseExecute(Sender: TObject);
    procedure FileImportExecute(Sender: TObject);
    procedure FileExportExecute(Sender: TObject);
    procedure FilePrintExecute(Sender: TObject);
    procedure FilePrintPreviewExecute(Sender: TObject);
    procedure EditCopyExecute(Sender: TObject);
    procedure EditPasteExecute(Sender: TObject);
    procedure EditSelectAllExecute(Sender: TObject);
    procedure EditFindExecute(Sender: TObject);
    procedure MapSceneryExecute(Sender: TObject);
    procedure MapOptionsExecute(Sender: TObject);
    procedure MapLegendExecute(Sender: TObject);
    procedure MapMaterialExecute(Sender: TObject);
    procedure MapLightingExecute(Sender: TObject);
    procedure MapBackColorExecute(Sender: TObject);
    procedure DrawDepthExecute(Sender: TObject);
    procedure DrawAddNodeExecute(Sender: TObject);
    procedure DrawReshapeExecute(Sender: TObject);
    procedure DrawSolidExecute(Sender: TObject);
    procedure DrawEllipseExecute(Sender: TObject);
    procedure DrawPolygonExecute(Sender: TObject);
    procedure DrawRectangleExecute(Sender: TObject);
    procedure DrawPolylineExecute(Sender: TObject);
    procedure DrawSymbolExecute(Sender: TObject);
    procedure DrawTextExecute(Sender: TObject);
    procedure ViewProjectManagerExecute(Sender: TObject);
    procedure ViewScaleExecute(Sender: TObject);
    procedure ViewSelectExecute(Sender: TObject);
    procedure ViewScrollExecute(Sender: TObject);
    procedure ViewPanExecute(Sender: TObject);
    procedure ViewVolumeXYZExecute(Sender: TObject);
    procedure ViewPlaneXYExecute(Sender: TObject);
    procedure ViewPlaneXZExecute(Sender: TObject);
    procedure ViewPlaneYZExecute(Sender: TObject);
    procedure ViewStatuslineExecute(Sender: TObject);
    procedure aZoomInOutExecute(Sender: TObject);
    procedure aZoomToProjectExecute(Sender: TObject);
    procedure aZoomToCompleteExecute(Sender: TObject);
    procedure aZoomToModelExecute(Sender: TObject);
    procedure aZoomToRectangleExecute(Sender: TObject);
    procedure PolygonsSelectTypeExecute(Sender: TObject);
    procedure PolygonsLinkToSolidExecute(Sender: TObject);
    procedure MethodGridGenerationExecute(Sender: TObject);
    procedure MethodTriangulationExecute(Sender: TObject);
    procedure MethodInterpolationExecute(Sender: TObject);
    procedure MethodBlockEvaluationExecute(Sender: TObject);
    procedure MethodPitOptimizationExecute(Sender: TObject);
    procedure MethodSetOperationsExecute(Sender: TObject);
    procedure MethodConversionExecute(Sender: TObject);
    procedure MethodPredictionExecute(Sender: TObject);
    procedure MethodTransformationExecute(Sender: TObject);
    procedure MethodVarModelingExecute(Sender: TObject);
    procedure ShowSectionExecute(Sender: TObject);
    procedure ShowContoursExecute(Sender: TObject);
    procedure ShowIsosurfaceExecute(Sender: TObject);
    procedure ShowVectorsExecute(Sender: TObject);
    procedure ShowFilmExecute(Sender: TObject);
    procedure Points2DSelectPointExecute(Sender: TObject);
    procedure Points2DCreatePointExecute(Sender: TObject);
    procedure Points3DSelectPointExecute(Sender: TObject);
    procedure Grid2DSelectCellExecute(Sender: TObject);
    procedure DrillholesCreateSegmentExecute(Sender: TObject);
    procedure DrillholesSelectDrillholeExecute(Sender: TObject);
    procedure DrillholesSelectContactExecute(Sender: TObject);
    procedure DrillholesSelectSegmentExecute(Sender: TObject);
    procedure DrillholesCreateDrillholeExecute(Sender: TObject);
    procedure Grid2DSelectRowExecute(Sender: TObject);
    procedure Grid2DSelectColExecute(Sender: TObject);
    procedure ToolsConfigurationExecute(Sender: TObject);
    procedure ToolsUnitsConverterExecute(Sender: TObject);
    procedure HelpContentsExecute(Sender: TObject);
    procedure HelpGlossaryExecute(Sender: TObject);
    procedure HelpAboutExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OctreeConstructionExecute(Sender: TObject);
    procedure MethodSimulationExecute(Sender: TObject);
  public
    FPopupXY: TPoint;
    procedure ShowTable(const AFileName: TFileName; AModelType: integer);
    procedure ShowMap(const AFileName: TFileName; AModelType: integer);
    procedure ShowGraph(const AFileName: TFileName; AModelType: integer);
    procedure EnableFileItems(AEnabled: boolean);
    procedure EnableMapItems(AModelType: integer; AEnabled: boolean);
    procedure DrawEnableItems(AEnabled: boolean);
    procedure ReadIniFile; override;
    procedure WriteIniFile;
  private
    procedure ShowStatusText(Sender: TObject);
    procedure DefaultLayout;
  end;

var
  FormGeoblock: TFormGeoblock;

implementation //=============================================================

uses
  usGlobals,
  usCommon,
  Geos.ResStrings,
  Geos.Profuns,
  fAnalyseProblems,
  fAnalyseReserves,
  fAnalyseVariograms,
  fComposeContacts,
  fComposeCenters,
  fComposeOreSorts,
  fComposeOreIntervals,
  fComposeByHorizons,
  fComposeLinearReserves,
  fDrawSymbolStyle,
  fDrawLineStyle,
  fDrawFillStyle,
  fDrawObjectDepth,
  fGraphWindow,
  fFileOpenText,
  fFileOpenModel,
  fFileImageRegistration,
  fFileImport,
  fFileExport,
  fHelpAbout,
  fmMethodDialog,
  fMethodGridGeneration,
  fMethodTriangulation,
  fMethodInterpolation,
  fMethodPrediction,
  fMethodEvaluation,
  fMethodPitOptimization,
  fMethodConversion,
  fMethodTransformation,
  fMethodSetOperations,
  fMethodVarioModeller,
  fMethodSimulation,
  fMethodOctree,
  fViewProjectManager,
  fViewScale,
  fViewVariogram,
  fMapWindow,
  fPerformIsosurfaces,
  fPerformVectors,
  fPerformContours,

  fTableWindow,
  fToolsConfiguration,
  fToolsUnitsConverter,
  fToolsGeologyCalculator,
  fToolsGeometryCalculator,
  fToolsMiningCalculator,
  //fFileBrowser,
  //fFileDataBrowser,
  fToolsSurveyCalculator,
  //fViewProjectManager,
  fMapLegend,
  fMapScenery,
  fFileDataBrowser;

{$R *.DFM}

//==================== Interface =======================

procedure TFormGeoblock.DefaultLayout;
begin
//  FormGeoblock.Left := 1; fmGeoblock.Top := 1;
//  FormGeoblock.Width := Screen.Width - 100;
//  FormGeoblock.Height := Screen.Height - 30;
  frmFileDataBrowser.Left := FormGeoblock.Left + 1;
  frmFileDataBrowser.Top := FormGeoblock.Top + 120;
  frmFileDataBrowser.Height := FormGeoblock.Height - 150;
//  frmViewProjectManager.Position := poDesigned;
  frmViewProjectManager.Left := FormGeoblock.Width + 30;
  frmViewProjectManager.Top := FormGeoblock.Top + 120;

{
  frmMapWindow.Top := 25;
  fmMapScenery.Left := fmFileDataBrowser.Width + 1;
  fmMapScenery.Top := 50;
  fmMapScenery.Left := fmFileDataBrowser.Width + 10;
  fmTableWindow.Top := 75;
  fmTableWindow.Left := fmFileDataBrowser.Width + 20;
  fmGraphWindow.Top := 100;
  fmGraphWindow.Left := fmFileDataBrowser.Width + 30;
}
end;

procedure TFormGeoblock.FormCreate(Sender: TObject);
begin
  inherited; // otherwise without dxgettext translations
  ReadIniFile;
  GetDataPath;
  Application.OnHint      := ShowStatusText;
//  PanelModelPalette.Width := fmMain.Width - PanelModelPalette.Left - 10;
///  ActionManager.Actions[].Caption := LoadResString(@rsOpen);;

end;

procedure TFormGeoblock.FormShow(Sender: TObject);
begin
  DefaultLayout;
  frmFileDataBrowser.Show;
  frmViewProjectManager.Show;
end;

procedure TFormGeoblock.ShowTable(const AFileName: TFileName; AModelType: integer);
var
  FileName : TFileName;
begin
  frmTableWindow := TfrmTableWindow.Create(Self);
  frmTableWindow.ModelType := AModelType;
  frmTableWindow.OpenTable(AFileName);
  case AModelType of
    mtPolygons:
    begin
      FileName := ChangeModelTable(DirPolygonPoly, DirPolygonVertex, AFileName);
      frmTableWindow := TfrmTableWindow.Create(Self);
      frmTableWindow.OpenTable(FileName);
    end;
    mtTins:   //Open vertices
    begin
      FileName := ChangeModelTable(DirTinFaces, DirTinVertices, AFileName);
      frmTableWindow := TfrmTableWindow.Create(Self);
      frmTableWindow.OpenTable(FileName);
    end;
    mtGrids2D:
    begin
      fmFileOpenText := TfmFileOpenText.Create(Self);
      fmFileOpenText.TextFileName := AFileName + '.par';
      fmFileOpenText.Caption := ExtractFileName(fmFileOpenText.TextFileName);
      fmFileOpenText.LoadFile;
      fmFileOpenText.Show;
    end;
    mtGrids3D:
    begin
      fmFileOpenText := TfmFileOpenText.Create(Self);
      fmFileOpenText.TextFileName := AFileName + '.par';
      fmFileOpenText.Caption := ExtractFileName(fmFileOpenText.TextFileName);
      fmFileOpenText.LoadFile;
      fmFileOpenText.Show;
    end;
    mtMeshes2D:
    begin
      FileName := ChangeModelTable(DirMesh2DVertices, DirMesh2DFaces, AFileName);
      frmTableWindow := TfrmTableWindow.Create(Self);
      frmTableWindow.OpenTable(FileName);
    end;
    mtMeshes3D:
    begin
      FileName := ChangeModelTable(DirMesh3DNode, DirMesh3DElement, AFileName);
      frmTableWindow := TfrmTableWindow.Create(Self);
      frmTableWindow.OpenTable(FileName);
    end;
  end;
  WindowTileHorizontal.Execute;
end;


procedure TFormGeoblock.ShowMap(const AFileName: TFileName; AModelType: integer);
begin
  Screen.Cursor := crHourGlass;
  try
    if frmMapWindow = nil then
    begin
      frmMapWindow := TfrmMapWindow.Create(Self);
      frmMapWindow.InitMapWin(AFileName, AModelType);
      ViewVolumeXYZ.Checked    := True;
    end
    else
      frmMapWindow.OpenNewModel(AFileName, AModelType);
  finally
    Screen.Cursor := crDefault;
    EnableMapItems(AModelType, True);
    frmMapWindow.SetFocus;
  end;
end;

procedure TFormGeoblock.ShowGraph(const AFileName: TFileName; AModelType: integer);
begin
  frmGraphWindow := TfrmGraphWindow.Create(Self);
  frmGraphWindow.ModelType := AModelType;
  frmGraphWindow.OpenTable(AFileName);
end;


procedure TFormGeoblock.FormCloseQuery(Sender: TObject; var CanClose: boolean);
var
  I: integer;
begin
  // Protection from unexpected reloading Windows System
  if MDIChildCount <> 0 then
  begin
    if MessageDlg(LoadResString(@rsShutdown) + ' Geoblock' +
      '?', mtConfirmation, mbOKCancel, 0) = mrOk then
    begin
      for I := MDIChildCount - 1 downto 0 do
        MDIChildren[I].Close;
      CanClose := True;
    end
    else
      CanClose := False;
  end;
end;

//__________________________ Compositing ______________________________\\
procedure TFormGeoblock.CompositingSampleContactsExecute(Sender: TObject);
begin
  with TfmComposeContacts.Create(Self) do
    try
      if ShowModal = mrOk then
      begin
        Hide;
        case ToolBarShowAs.Tag of
          0: ShowMap(TableOutput.TableName, OutModelType);
          1: ShowTable(TableOutput.TableName, OutModelType);
          2: ShowGraph(TableOutput.TableName, OutModelType);
        end;
      end;
    finally
      Free;
    end;
end;

//-----------------------------------------------------------------\\
procedure TFormGeoblock.CompositingCentersExecute(Sender: TObject);
begin
  with TfmComposeCenters.Create(Self) do
    try
      if ShowModal = mrOk then
      begin
        Hide;
        case ToolBarShowAs.Tag of
          0: ShowMap(OutModelName, OutModelType);
          1: ShowTable(OutModelName, OutModelType);
          2: ShowGraph(OutModelName, OutModelType);
        end;
      end;
    finally
      Free;
    end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.CompositingOreSortingExecute(Sender: TObject);
begin
  with TfmComposeOreSorts.Create(Self) do
    try
      if ShowModal = mrOk then
      begin
        Hide;
        case ToolBarShowAs.Tag of
          0: ShowMap(OutModelName, OutModelType);
          1: ShowTable(OutModelName, OutModelType);
          2: ShowGraph(OutModelName, OutModelType);
        end;
      end;
    finally
      Free;
    end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.CompositingInsideHorizonsExecute(Sender: TObject);
begin
  with TfmComposeByHorizons.Create(Self) do
    try
      if ShowModal = mrOk then

      begin
        Hide;
        case ToolBarShowAs.Tag of
          0: ShowMap(OutModelName, OutModelType);
          1: ShowTable(OutModelName, OutModelType);
          2: ShowGraph(OutModelName, OutModelType);
        end;
      end;
    finally
      Free;
    end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.CompositingOreIntervalsExecute(Sender: TObject);
begin
  with TfmComposeOreIntervals.Create(Self) do
    try
      if ShowModal = mrOk then

      begin
        Hide;
        case ToolBarShowAs.Tag of
          0: ShowMap(OutModelName, OutModelType);
          1: ShowTable(OutModelName, OutModelType);
          2: ShowGraph(OutModelName, OutModelType);
        end;
      end;
    finally
      Free;
    end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.CompositingLinearReservesExecute(Sender: TObject);
begin
  with TfmComposeLinearReserves.Create(Self) do
    try
      if ShowModal = mrOk then

      begin
        Hide;
        case ToolBarShowAs.Tag of
          0: ShowMap(OutModelName, OutModelType);
          1: ShowTable(OutModelName, OutModelType);
          2: ShowGraph(OutModelName, OutModelType);
        end;
      end;
    finally
      Free;
    end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.EnableFileItems(AEnabled: boolean);
begin
  //File Menu
  FileSave.Enabled     := AEnabled;
  FileSaveAs.Enabled   := AEnabled;
  FileSaveProjectAs.Enabled := AEnabled;
  FileClose.Enabled    := AEnabled;
  FileCloseAll.Enabled := AEnabled;

  FileExport.Enabled    := AEnabled;
  FilePrint.Enabled     := AEnabled;
  FilePrintPreview.Enabled := AEnabled;
  //Edit
  EditSelectAll.Enabled := AEnabled;
  EditFind.Enabled      := AEnabled;
  //Method
  MethodConversion.Enabled := AEnabled;
  //Analyse
  acAnalyseBaseStatistics.Enabled := AEnabled;
end;


//____________________________ File ________________________________\\
procedure TFormGeoblock.FileNewExecute(Sender: TObject);
begin
  with TFormFileNew.Create(Self) do
  try
  if ShowModal = mrOk then
    with dBase.dmBase do
    case ToolBarShowAs.Tag of
      0: ShowMap(TableOutput.TableName, OutModelType);
      1: ShowTable(TableOutput.TableName, OutModelType);
      2: ShowGraph(TableOutput.TableName, OutModelType);
    end;
  finally
    Free;
  end;
end;

//----------------------------------------------------------------
procedure TFormGeoblock.FileOpenProjectExecute(Sender: TObject);
begin
  with dmDialogs do
  begin
    OpenDialogProject.FileName   := ExpandPath(DirProjects) + 'Geoblock' + PrjExt;
    OpenDialogProject.InitialDir := ExpandPath(DirProjects);
    if OpenDialogProject.Execute then
    begin
      if OpenDialogProject.FilterIndex = 2 then
      begin
        frmViewProjectManager.LoadFromFile(OpenDialogProject.FileName);
        aZoomToComplete.Execute;
      end
      else
        with TfmFileOpenText.Create(Self) do
        begin
          TextFileName := OpenDialogProject.FileName;
          LoadFile;
          ShowModal;
          EnableFileItems(True);
        end;
    end;
  end;
end;

//----------------------------------------------------------------
procedure TFormGeoblock.FileDataBaseExecute(Sender: TObject);
begin
  frmFileDataBrowser.Show;
end;

//----------------------------------------------------------------
procedure TFormGeoblock.FileOpenModelExecute(Sender: TObject);
var
  I: integer;
begin
  with TFormFileOpenModel.Create(Self) do
    try
      if ShowModal = mrOk then
      begin
        for I := 0 to Files.Count - 1 do
          case ToolBarShowAs.Tag of
            0: ShowMap(Files[I], ModelType);
            1: ShowTable(Files[I], ModelType);
            2: ShowGraph(Files[I], ModelType);
          end;
        EnableFileItems(True);
        aZoomToComplete.Execute;
      end;
    finally
      Free;
    end;
  frmViewProjectManager.EnableButtons;
end;

//----------------------------------------------------------------
procedure TFormGeoblock.FileOpenReportExecute(Sender: TObject);
begin
  with dmDialogs do
  begin
    OpenDialog.InitialDir := DataBasePath + DirReports;
    OpenDialog.Filter     := '.rpt';
    if OpenDialog.Execute then
    begin

    end;
  end;
end;

//----------------------------------------------------------------
procedure TFormGeoblock.FileOpenImageExecute(Sender: TObject);
begin
  dmDialogs.OpenPictureDialog.InitialDir := GetCurrentDir();
  if dmDialogs.OpenPictureDialog.Execute then
  begin
    with TfmFileImageRegistration.Create(Self) do
      try
        //      Image := Image.LoadFromFile(FileName);
      finally
        Free;
      end;
    {
    FileName := dmDialogs.OpenPictureDialog.FileName;
    Picture := TPicture.Create;
    Picture.LoadFromFile(FileName);
    if (Picture.Width < 256) or (Picture.Height < 256) then begin
      Picture.BitMap.Width:=256;
      Picture.Bitmap.Height:=256;
    end;
    GLImage.Picture.Assign(Picture);
    Picture.Free;
    ShowMap(FileName, PageControlDataset.ActivePage.Tag);
    }
  end;
end;

//----------------------------------------------------------------
procedure TFormGeoblock.FileOpenTextExecute(Sender: TObject);
begin
  with dmDialogs do
  begin
    OpenDialogText.InitialDir  := ExpandPath(DirFiles);
    OpenDialogText.FilterIndex := 4; //*.*
    if OpenDialogText.Execute then
    begin
      with TfmFileOpenText.Create(Self) do
        try
          TextFileName := OpenDialogText.FileName;
          LoadFile;
          if ShowModal = mrOk then
            EnableFileItems(True);
        finally
          Free;
        end;
    end;
  end;
end;

//----------------------------------------------------------------
procedure TFormGeoblock.FileSaveProjectAsExecute(Sender: TObject);
begin
  with dmDialogs do
  begin
    SaveDialogText.FileName   := GetCurrentDir + 'Geoblock' + PrjExt;
    SaveDialogText.InitialDir := ExpandPath(DirProjects);
    SaveDialogText.Title      := LoadResString(@rsSaveProjectAs);
    SaveDialogText.FilterIndex := 2; //*.prj
    if SaveDialogText.Execute then
      frmViewProjectManager.SaveToFile(SaveDialogText.FileName);
  end;
end;

//----------------------------------------------------------------
procedure TFormGeoblock.FileSaveAsExecute(Sender: TObject);
var
  FileName: TFileName;
begin
  with dmDialogs do
  begin
    if (ActiveMDIChild is TfrmTableWindow) then
    begin
      FileName := (ActiveMDIChild as TfrmTableWindow).TableMaster.TableName;
      SaveDialog.FileName := FileName;
      if SaveDialog.Execute then
      begin
        if SaveDialog.FileName <> FileName then
        begin
          (ActiveMDIChild as
            TfrmTableWindow).SaveAs(SaveDialog.FileName);
        end
        else
          (ActiveMDIChild as TfrmTableWindow).TableMaster.Close;
      end;
    end;
    if (ActiveMDIChild is TfrmMapWindow) then
    begin
      SavePictureDialog.InitialDir := GetCurrentDir();
      if SavePictureDialog.Execute then
      begin
        (ActiveMDIChild as
          TfrmMapWindow).SaveAs(SavePictureDialog.FileName);
      end;
    end;
    if (ActiveMDIChild is TfrmGraphWindow) then
    begin
      //Save as Graph...
    end;
    if (ActiveMDIChild is TfmFileOpenText) then
      (ActiveMDIChild as TfmFileOpenText).SaveTextFileAs;
  end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.FileCloseAllExecute(Sender: TObject);
var
  I: integer;
begin
  for I := 0 to 1000 do
  begin
    FileCloseExecute(nil);
  end;
  EnableFileItems(False);
  EnableMapItems(mtUnknown, False);
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.FileCloseExecute(Sender: TObject);
begin
  with dmBase do
  begin
    if (ActiveMDIChild is TfrmTableWindow) then
    begin
      (ActiveMDIChild as TfrmTableWindow).TableMaster.Close;
      (ActiveMDIChild as TfrmTableWindow).Close;
    end;
    if (ActiveMDIChild is TfrmMapWindow) then
    begin
      (ActiveMDIChild as TfrmMapWindow).TableMap.Close;
      (ActiveMDIChild as TfrmMapWindow).Close;
    end;
    if (ActiveMDIChild is TfrmGraphWindow) then
    begin
      (ActiveMDIChild as TfrmGraphWindow).TableGraph.Close;
      (ActiveMDIChild as TfrmGraphWindow).Close;
    end;
    Application.ProcessMessages;
  end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.FileImportExecute(Sender: TObject);
begin
  with TFormFileImport.Create(Self) do
    try
      if ChooseModelType then
      begin
        if ShowModal = mrOk then
          case ToolBarShowAs.Tag of
            0: ShowMap(OutModelName, OutModelType);
            1: ShowTable(OutModelName, OutModelType);
            2: ShowGraph(OutModelName, OutModelType);
          end;
      end;
    finally
      Free;
    end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.FileExportExecute(Sender: TObject);
begin
  if (ActiveMDIChild is TfrmMapWindow) then
    frmMapWindow.DoExportToMIF
  else
    with (ActiveMDIChild as TfrmTableWindow) do
    begin
      with TFormFileExport.Create(Self) do
      begin
        try
          SourceFile := TableMaster.TableName;
          ShowModal;
        finally
          Free;
        end;
      end;
    end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.FilePrintExecute(Sender: TObject);
begin
  if dmDialogs.PrintDialog.Execute then
    if (ActiveMDIChild is TfrmTableWindow) then
    with (ActiveMDIChild as TfrmTableWindow) do
    try
      // Change to FastReport
      // dmBase.RvTableConnection.Table:=TableMaster;
      // dmBase.RvProject.ProjectFile:=ExePath+'HELP\RU\Rave\TableReports.rav';
      // dmBase.RvProject.Open;
      // dmBase.GenerateReport;
    finally
      // dmBase.RvProject.Close;
    end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.FilePrintPreviewExecute(Sender: TObject);
begin
  if (ActiveMDIChild is TfrmTableWindow) then
    with (ActiveMDIChild as TfrmTableWindow) do
    begin
    // Change to FastReport
(*    with TFormQRListing.CreateSimpleReport(Self, TableMaster.TableName) do
      begin
        QuickRep.Preview;
        Free;
      end;
      with TFormQRReserve.CreateReport(Self, TableMaster.TableName) do
      begin
        QuickRep.Preview;
        Free;
      end;
*)
    end;
end;

//__________________________Edit______________________________\\

procedure TFormGeoblock.EditCopyExecute(Sender: TObject);
begin
  if (ActiveMDIChild is TfrmTableWindow) then
    TfrmTableWindow(ActiveMDIChild).CopyToClipboard(ActiveMDIChild)
  else if (ActiveMDIChild is TfmFileOpenText) then
    TfmFileOpenText(ActiveMDIChild).CopyToClipboard
  else if (ActiveMDIChild is TfrmGraphWindow) then
    TfrmGraphWindow(ActiveMDIChild).CopyToClipboard;
end;

//---------------------------------------------------------------\\
procedure TFormGeoblock.EditPasteExecute(Sender: TObject);
begin
  if (ActiveMDIChild is TfrmTableWindow) then
    TfrmTableWindow(ActiveMDIChild).PasteFromClipboard(ActiveMDIChild)
  else if (ActiveMDIChild is TfmFileOpenText) then
    TfmFileOpenText(ActiveMDIChild).PasteFromClipboard;
end;

//---------------------------------------------------------------\\
procedure TFormGeoblock.EditSelectAllExecute(Sender: TObject);
begin
  if (ActiveMDIChild is TfrmTableWindow) then
    TfrmTableWindow(ActiveMDIChild).SelectAll(ActiveMDIChild);
end;

//---------------------------------------------------------------\\
procedure TFormGeoblock.EditFindExecute(Sender: TObject);
begin
  if (ActiveMDIChild is TfrmTableWindow) then
    TfrmTableWindow(ActiveMDIChild).EditTableFindExecute(ActiveMDIChild);
  if (ActiveMDIChild is TfrmMapWindow) then
    with (ActiveMDIChild as TfrmMapWindow) do
    begin
      frmTableWindow.EditTableFindExecute(Self);
    end;
end;

//____________________________ Methods _____________________________\\

procedure TFormGeoblock.MethodGridGenerationExecute(Sender: TObject);
begin
  with TFormMethodGridGeneration.Create(Self) do
    try
      if ShowModal = mrOk then
      begin
        Hide;
        case ToolBarShowAs.Tag of
          0: ShowMap(OutModelName, OutModelType);
          1: ShowTable(OutModelName, OutModelType);
          2: ShowGraph(OutModelName, OutModelType);
        end;
      end;
    finally
      Free;
    end;
end;

//---------------------------------------------------------------\\
procedure TFormGeoblock.MethodTriangulationExecute(Sender: TObject);
begin
  with TFormMethodTriangulation.Create(Self) do
    try
      if ShowModal = mrOk then
      begin
        Hide;
        case ToolBarShowAs.Tag of
          0: ShowMap(OutModelName, OutModelType);
          1: ShowTable(OutModelName, OutModelType);
          2: ShowGraph(OutModelName, OutModelType);
        end;
      end;
    finally
      Free;
    end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.MethodVarModelingExecute(Sender: TObject);
begin
  with TFormMethodVarioModeller.Create(Self) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

//---------------------------------------------------------------\\
procedure TFormGeoblock.MethodInterpolationExecute(Sender: TObject);
begin
  with TFormMethodInterpolation.Create(Self) do
    try
      if ShowModal = mrOk then
      begin
        Hide;
        case ToolBarShowAs.Tag of
          0: ShowMap(OutModelName, OutModelType);
          1: ShowTable(OutModelName, OutModelType);
          2: ShowGraph(OutModelName, OutModelType);
        end;
      end;
    finally
      Free;
    end;
end;

//---------------------------------------------------------------\\
procedure TFormGeoblock.MethodPredictionExecute(Sender: TObject);
begin
  with TFormMethodPrediction.Create(Self) do
    try
      if ShowModal = mrOk then
      begin
        Hide;
        case ToolBarShowAs.Tag of
          0: ShowMap(OutModelName, OutModelType);
          1: ShowTable(OutModelName, OutModelType);
          2: ShowGraph(OutModelName, OutModelType);
        end;
      end;
    finally
      Free;
    end;
end;


//---------------------------------------------------------------\\
procedure TFormGeoblock.MethodBlockEvaluationExecute(Sender: TObject);
begin
  with TFormMethodEvaluation.Create(Self) do
    try
      if ShowModal = mrOk then
      begin
        Hide;
        case ToolBarShowAs.Tag of
          0: ShowMap(OutModelName, OutModelType);
          1: ShowTable(OutModelName, OutModelType);
          2: ShowGraph(OutModelName, OutModelType);
        end;
      end;
    finally
      Free;
    end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.MethodPitOptimizationExecute(Sender: TObject);
begin
  with TFormMethodPitOptimization.Create(Self) do
    try
      if ShowModal = mrOk then
      begin
        Hide;
        case ToolBarShowAs.Tag of
          0: ShowMap(OutModelName, OutModelType);
          1: ShowTable(OutModelName, OutModelType);
          2: ShowGraph(OutModelName, OutModelType);
        end;
      end;
    finally
      Free;
    end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.MethodConversionExecute(Sender: TObject);
begin
  with TFormMethodConversion.Create(Self) do
    try
      //Next must be taken from DB browser
      //InModelName := fmMapWindow.Model.ModelName;
      //InModelType := fmMapWindow.Model.ModelType;
      //Then show only one toolbar button for input model of conversion
      if ShowModal = mrOk then
      begin
        Hide;
        case ToolBarShowAs.Tag of
          0: ShowMap(OutModelName, OutModelType);
          1: ShowTable(OutModelName, OutModelType);
          2: ShowGraph(OutModelName, OutModelType);
        end;
      end;
    finally
      Free;
    end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.MethodTransformationExecute(Sender: TObject);
begin
  with TFormMethodTransformation.Create(Self) do
    try
      if frmMapWindow <> nil then
      begin
        InModelType := frmMapWindow.Model.ModelType;
        InModelName := frmMapWindow.Caption;
        ListBoxInputNames.ItemIndex := ListBoxInputNames.Items.IndexOf(InModelName);
      end;

      if ShowModal = mrOk then

      begin
        Hide;
        case ToolBarShowAs.Tag of
          0: ShowMap(OutModelName, OutModelType);
          1: ShowTable(OutModelName, OutModelType);
          2: ShowGraph(OutModelName, OutModelType);
        end;
      end;
    finally
      Free;
    end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.MethodSetOperationsExecute(Sender: TObject);
begin
  with TFormMethodSetOperations.Create(nil) do
    try
      if ShowModal = mrOk then

      begin
        Hide;
        case ToolBarShowAs.Tag of
          0: ShowMap(OutModelName, OutModelType);
          1: ShowTable(OutModelName, OutModelType);
          2: ShowGraph(OutModelName, OutModelType);
        end;
      end;
    finally
      Free;
    end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.MethodSimulationExecute(Sender: TObject);
begin
  with TFormFileNew.Create(Self) do
  try
  if ShowModal = mrOk then
    with dBase.dmBase do
    case ToolBarShowAs.Tag of
      0: ShowMap(TableOutput.TableName, OutModelType);
      1: ShowTable(TableOutput.TableName, OutModelType);
      2: ShowGraph(TableOutput.TableName, OutModelType);
    end;
  finally
    Free;
  end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.OctreeConstructionExecute(Sender: TObject);
begin
  with TFormMethodOctree.Create(nil) do
    try
      if ShowModal = mrOk then
      begin
        Hide;
        case ToolBarShowAs.Tag of
          0: ShowMap(OutModelName, OutModelType);
          1: ShowTable(OutModelName, OutModelType);
          2: ShowGraph(OutModelName, OutModelType);
        end;
      end;
    finally
      Free;
    end;
end;


//______________________________ Map _________________________________\\

procedure TFormGeoblock.EnableMapItems(AModelType: integer; AEnabled: boolean);
begin
  //File Items
  FileExport.Enabled := AEnabled;

  //Map Items
  MapOptions.Enabled   := AEnabled;
  MapLegend.Enabled    := AEnabled;
  MapMaterial.Enabled  := AEnabled;
  MapLighting.Enabled  := AEnabled;
  MapBackColor.Enabled := AEnabled;

  //View Items
  ControlBarRight.Visible := AEnabled; // and ViewVolumeXYZ.Checked;

  ViewVolumeXYZ.Enabled := AEnabled;
  ViewPlaneXY.Enabled := AEnabled;
  ViewPlaneXZ.Enabled := AEnabled;
  ViewPlaneYZ.Enabled := AEnabled;
  ViewScale.Enabled := AEnabled;
  ViewSelect.Enabled := AEnabled;
  ViewScroll.Enabled := AEnabled;
  ViewPan.Enabled := AEnabled;

  aZoomInOut.Enabled      := AEnabled;
  aZoomToRectangle.Enabled := AEnabled;
  aZoomToProject.Enabled  := AEnabled;
  aZoomToModel.Enabled    := AEnabled;
  aZoomToComplete.Enabled := AEnabled;


  //Draw Items
  //ToolBarDraw.Visible := AEnabled;

  DrawText.Enabled      := AEnabled;
  DrawSymbol.Enabled    := AEnabled;
  DrawPolygon.Enabled   := AEnabled;
  DrawPolyline.Enabled  := AEnabled;
  DrawRectangle.Enabled := AEnabled;
  DrawEllipse.Enabled   := AEnabled;
  DrawSolid.Enabled     := AEnabled;
  DrawAddNode.Enabled   := AEnabled;
  DrawReshape.Enabled   := AEnabled;
  DrawDepth.Enabled     := AEnabled;

  acAnalyseBaseStatistics.Enabled := AEnabled;

  case AModelType of
    mtDholes, mtAll:
    begin
      PageControlModels.ActivePage := TabSheetHoles;
      DrillholesOptions.Enabled    := AEnabled;
      DrillholesSelectDrillhole.Enabled := AEnabled;
      DrillholesSelectContact.Enabled := AEnabled;
      DrillholesSelectSegment.Enabled := AEnabled;
      DrillholesCreatedrillhole.Enabled := AEnabled;
      DrillholesCreateSegment.Enabled := AEnabled;
      //        ShowVectors.Enabled:=AEnabled;
    end;
    mtPoints2D:
    begin
      PageControlModels.ActivePage := TabSheetPoints2D;
      Points2DOptions.Enabled := AEnabled;
      Points2DSelectPoint.Enabled := AEnabled;
      Points2DCreatePoint.Enabled := AEnabled;
      ShowVectors.Enabled := AEnabled;
    end;
    mtPoints3D:
    begin
      PageControlModels.ActivePage := TabSheetPoints3D;
      Points3DOptions.Enabled := AEnabled;
      Points3DSelectPoint.Enabled := AEnabled;
      Points3DCreatePoint.Enabled := AEnabled;
      ShowVectors.Enabled := AEnabled;
    end;
    mtPolygons:
    begin
      PageControlModels.ActivePage := TabSheetPolygons;
      PolygonsOptions.Enabled      := AEnabled;
      PolygonsSelectPolygon.Enabled := AEnabled;
      PolygonsSelectVertex.Enabled := AEnabled;
      PolygonsCreatePolygon.Enabled := AEnabled;
      PolygonsLinkToSolid.Enabled  := AEnabled;
      try
        PolygonsSelectTypeExecute(nil);
      except
      end;
    end;
    mtTins:
    begin
      PageControlModels.ActivePage := TabSheetTins;
      //ViewGeoScene.Enabled := AEnabled;
      TinOptions.Enabled   := AEnabled;
      ShowContours.Enabled := AEnabled;
      ShowSection.Enabled  := AEnabled;
      ShowVectors.Enabled  := AEnabled;
    end;
    mtSolids:
    begin
      SolidOptions.Enabled := AEnabled;
      ShowSection.Enabled  := AEnabled;
    end;
    mtGrids2D:
    begin
      PageControlModels.ActivePage := TabSheetGrids2D;
      Grid2DOptions.Enabled    := AEnabled;
      Grid2DSelectCell.Enabled := AEnabled;
      Grid2DSelectRow.Enabled  := AEnabled;
      Grid2DSelectCol.Enabled  := AEnabled;
      ShowContours.Enabled     := AEnabled;
      ShowVectors.Enabled      := AEnabled;
    end;
    mtGrids3D:
    begin
      PageControlModels.ActivePage := TabSheetGrids3D;
      Grid3DOptions.Enabled   := AEnabled;
      Grid3DSelectRow.Enabled := AEnabled;
      Grid3DSelectCol.Enabled := AEnabled;
      Grid3DSelectLay.Enabled := AEnabled;
      ShowIsosurface.Enabled  := AEnabled;
      ShowVectors.Enabled     := AEnabled;
      ShowSection.Enabled     := AEnabled;
    end;
    mtMeshes2D:
    begin
      PageControlModels.ActivePage := TabSheetMeshes2D;
      Mesh2DOptions.Enabled := AEnabled;
      ShowContours.Enabled  := AEnabled;
      ShowVectors.Enabled   := AEnabled;
    end;
    mtMeshes3D:
    begin
      PageControlModels.ActivePage := TabSheetMeshes3D;
      Mesh3DOptions.Enabled  := AEnabled;
      ShowContours.Enabled   := AEnabled;
      ShowIsosurface.Enabled := AEnabled;
      ShowVectors.Enabled    := AEnabled;
      ShowSection.Enabled    := AEnabled;
    end;
  end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.MapSceneryExecute(Sender: TObject);
begin
  if fmMapScenery = nil then
    fmMapScenery := TfmMapScenery.Create(self);
  fmMapScenery.Show;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.MapOptionsExecute(Sender: TObject);
begin
  with frmMapWindow do
  begin
    Model.SelectOptions;
    FormPaint(frmMapWindow);
  end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.MapLegendExecute(Sender: TObject);
begin
  with frmMapWindow do
  begin
    Model.ActiveAttribute.LegendDialog;
    FormPaint(frmMapWindow);
  end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.MapMaterialExecute(Sender: TObject);
begin
  if (ActiveMDIChild is TfrmTableWindow) then
  begin
    with TFormDrawFillStyle.Create(nil) do
      try
        ShowModal;
      finally
        Free;
      end;
  end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.MapLightingExecute(Sender: TObject);
begin
  frmMapWindow.LightDlg;
end;

procedure TFormGeoblock.MapBackColorExecute(Sender: TObject);
begin
  frmMapWindow.BackColorDlg;
  //frmMapScenery.ActionBackgroundExecute(Self);
end;

//_____________________________ Draw ___________________________\\

procedure TFormGeoblock.DrawEnableItems(AEnabled: boolean);
begin
  DrawText.Enabled      := AEnabled;
  DrawSymbol.Enabled    := AEnabled;
  DrawPolyline.Enabled  := AEnabled;
  DrawPolygon.Enabled   := AEnabled;
  DrawEllipse.Enabled   := AEnabled;
  DrawReshape.Enabled   := AEnabled;
  DrawRectangle.Enabled := AEnabled;
  DrawAddNode.Enabled   := AEnabled;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.DrawDepthExecute(Sender: TObject);
begin
  with TFormDrawObjectDepth.Create(nil) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.DrawAddNodeExecute(Sender: TObject);
begin
  DrawAddNode.Checked := True;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.DrawReshapeExecute(Sender: TObject);
begin
  DrawReshape.Checked := True;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.DrawSolidExecute(Sender: TObject);
begin
  DrawSolid.Checked := True;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.DrawEllipseExecute(Sender: TObject);
begin
  DrawEllipse.Checked := True;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.DrawPolygonExecute(Sender: TObject);
begin
  DrawPolygon.Checked := True;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.DrawRectangleExecute(Sender: TObject);
begin
  DrawRectangle.Checked := True;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.DrawPolylineExecute(Sender: TObject);
begin
  DrawPolyline.Checked := True;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.DrawSymbolExecute(Sender: TObject);
begin
  DrawSymbol.Checked := True;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.DrawTextExecute(Sender: TObject);
begin
  DrawText.Checked := True;
end;

//_________________________ View ______________________________\\

procedure TFormGeoblock.ViewProjectManagerExecute(Sender: TObject);
begin
  with frmViewProjectManager do
    try //save previous parameters
      if (frmMapWindow <> nil) and (frmMapWindow.ModelList <> nil) then
        with frmMapWindow do
          ModelList[ModelIndex].Assign(Model);
    except
    end;
  frmViewProjectManager.Show;
end;

{
procedure TfmMain.ViewGeosceneExecute(Sender: TObject);
begin
 with TFormGeoScene.Create(nil) do
    try
      ShowModal;
    finally
      Free;
    end;
end;
}

//----------------------------------------------------------------\\
procedure TFormGeoblock.ViewScaleExecute(Sender: TObject);
begin
  frmMapWindow.ViewScale;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.ViewSelectExecute(Sender: TObject);
begin
  frmMapWindow.GBCanvas.Cursor := crSelectCursor;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.ViewScrollExecute(Sender: TObject);
begin
  frmMapWindow.GBCanvas.Cursor := crScrollCursor;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.ViewPanExecute(Sender: TObject);
begin
  frmMapWindow.GBCanvas.Cursor := crPanCursor;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.ViewVolumeXYZExecute(Sender: TObject);
begin
  ControlBarRight.Visible := True;
  Observe3D.Checked := True;
  ViewPan.Enabled   := True;
  frmMapWindow.ViewXYZ;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.ViewPlaneXYExecute(Sender: TObject);
begin
  ControlBarRight.Visible := False;
  if ViewPan.Checked then
    ViewSelect.Checked := True;
  ViewPan.Enabled := False;
  frmMapWindow.ViewXY;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.ViewPlaneXZExecute(Sender: TObject);
begin
  ControlBarRight.Visible := False;
  if ViewPan.Checked then
    ViewSelect.Checked := True;
  ViewPan.Enabled := False;
  frmMapWindow.ViewXZ;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.ViewPlaneYZExecute(Sender: TObject);
begin
  ControlBarRight.Visible := False;
  if ViewPan.Checked then
    ViewSelect.Checked := True;
  ViewPan.Enabled := False;
  frmMapWindow.ViewYZ;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.ViewStatuslineExecute(Sender: TObject);
begin
  ViewStatusLine.Checked := not ViewStatusLine.Checked;
  StatusBar.Visible      := ViewStatusLine.Checked;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.ViewTableWindowExecute(Sender: TObject);
begin

end;

//___________________________ Zoom ____________________________\\

procedure TFormGeoblock.aZoomInOutExecute(Sender: TObject);
begin
  frmMapWindow.GBCanvas.Cursor := crZoomCursor;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.aZoomToProjectExecute(Sender: TObject);
begin
  aZoomToProject.Checked := True;
  frmMapWindow.ViewDefault;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.aZoomToCompleteExecute(Sender: TObject);
begin
  aZoomToComplete.Checked := True;
  frmMapWindow.ViewZoomToAll;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.aZoomToModelExecute(Sender: TObject);
begin
  frmMapWindow.ViewZoomToModel;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.aZoomToRectangleExecute(Sender: TObject);
begin

end;

//___________________________ Display ______________________________\\

{ Drillholes }
procedure TFormGeoblock.DrillholesCreateSegmentExecute(Sender: TObject);
begin
  //TODO: fmMapWindow.CreateSegment;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.DrillholesSelectDrillholeExecute(Sender: TObject);
begin
  //TODO: fmMapWindow.SelectDhole;
end;

procedure TFormGeoblock.DrillholesSelectContactExecute(Sender: TObject);
begin
  //TODO: fmMapWindow.SelectContact
end;

procedure TFormGeoblock.DrillholesSelectSegmentExecute(Sender: TObject);
begin
  //TODO: fmMapWindow.SelectSegment
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.DrillholesCreateDrillholeExecute(Sender: TObject);
begin
  //TODO: fmMapWindow.CreateHole
end;


{ Points 2D }
procedure TFormGeoblock.Points2DSelectPointExecute(Sender: TObject);
begin
  //TODO: fmMapWindow.SelectPoint2D;
end;

procedure TFormGeoblock.Points2DCreatePointExecute(Sender: TObject);
begin
  //TODO: fmMapWindow.CreatePoint2D
end;

{ Points 3D }
procedure TFormGeoblock.Points3DSelectPointExecute(Sender: TObject);
begin
  //TODO: fmMapWindow.SelectPoint3D
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.PolygonsSelectTypeExecute(Sender: TObject);
begin
  //  ComboBoxPolygonType.Items.Clear;
  (*
    GetFieldValues(ExpandPath(DirMaterial)+tblPolyMat+TableExt, fldNAME,
      ComboBoxPolygonType.Items.Append);
    with ComboBoxPolygonType, Items do
    begin
      ItemIndex := ReductionToRange(0,0,Items.Count-1);
    end;
   *)
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.PolygonsLinkToSolidExecute(Sender: TObject);
begin
  //
end;

{ Grid2D }
procedure TFormGeoblock.Grid2DSelectCellExecute(Sender: TObject);
begin
  frmMapWindow.Grid2DSelectCell;
end;

procedure TFormGeoblock.Grid2DSelectRowExecute(Sender: TObject);
begin
  frmMapWindow.Grid2DSelectRow;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.Grid2DSelectColExecute(Sender: TObject);
begin
  frmMapWindow.Grid2DSelectCol;
end;


//_____________________________ Show ___________________________\\
procedure TFormGeoblock.ShowSectionExecute(Sender: TObject);
begin
  Screen.Cursor := crSelectCursor;
  try
    frmMapWindow.PerformCrossSection;
  finally
    Screen.Cursor := crDefault;
    frmMapWindow.SetFocus;
  end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.ShowContoursExecute(Sender: TObject);
begin
  with TFormPerformContours.Create(Self) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.ShowIsosurfaceExecute(Sender: TObject);
begin
  with TFormPerformIsosurfaces.Create(Self) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.ShowVectorsExecute(Sender: TObject);
begin
  with TFormPerformVectors.Create(Self) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.ShowFilmExecute(Sender: TObject);
begin
  //frmMapWindow.PerformFilmsDlg;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.ShowStatusText(Sender: TObject);
begin
  StatusBar.SimpleText     := Application.Hint;
  StatusBar.Panels[0].Text := Application.Hint;
end;


//________________________ Observe _______________________________\\
procedure TFormGeoblock.ObserveTopExecute(Sender: TObject);
begin
  ObserveTop.Checked := True;
  frmMapWindow.ViewTop;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.ObserveBottomExecute(Sender: TObject);
begin
  ObserveBottom.Checked := True;
  frmMapWindow.ViewBottom;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.ObserveRightExecute(Sender: TObject);
begin
  ObserveRight.Checked := True;
  frmMapWindow.ViewRight;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.ObserveLeftExecute(Sender: TObject);
begin
  ObserveLeft.Checked := True;
  frmMapWindow.ViewLeft;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.ObserveBackExecute(Sender: TObject);
begin
  ObserveBack.Checked := True;
  frmMapWindow.ViewBack;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.ObserveFrontExecute(Sender: TObject);
begin
  ObserveFront.Checked := True;
  frmMapWindow.ViewFront;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.Observe3DExecute(Sender: TObject);
begin
  Observe3D.Checked := True;
  frmMapWindow.View3D;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.ObserveRotateExecute(Sender: TObject);
begin
  frmMapWindow.ViewRotate;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.ObservePerspectiveExecute(Sender: TObject);
begin
  ObservePerspective.Checked := not ObservePerspective.Checked;
  // Change perspective in MapWindow using OpenGL..
end;

//_______________________Style___________________________\\
procedure TFormGeoblock.StyleTextExecute(Sender: TObject);
begin
  if dmDialogs.FontDialog.Execute then
  begin
    //
  end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.StyleSymbolExecute(Sender: TObject);
begin
  with TFormDrawSymbolStyle.Create(Self) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.StyleLineExecute(Sender: TObject);
begin
  with TFormDrawLineStyle.Create(Self) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.StyleFillExecute(Sender: TObject);
begin
  with TFormDrawFillStyle.Create(Self) do
    try
      ShowModal;
    finally
      Free;
    end;
end;


//_____________________ Analyse _______________________\\
procedure TFormGeoblock.acAnalyseProblemBookExecute(Sender: TObject);
begin
  with TFormAnalyseProblems.Create(nil) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

procedure TFormGeoblock.acAnalyseVolumeCalculationExecute(Sender: TObject);
begin
  // Now only interactive calculation of a picked map object at MapWindow
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.acAnalyseReserveCalculationExecute(Sender: TObject);
begin
  with TFormAnalyseReserves.Create(Self) do
    try
      if ShowModal = mrOk then
      begin
        ShowTable(OutModelName, mtUnknown);
      end;
    finally
      Free;
    end;
end;

//---------------------------------------------------------------\\
procedure TFormGeoblock.acAnalyseBaseStatisticsExecute(Sender: TObject);
var
  FileName: TFileName;
begin
  if (ActiveMDIChild is TfrmTableWindow) then
    FileName := (ActiveMDIChild as TfrmTableWindow).TableMaster.TableName
  else if (ActiveMDIChild is TfrmMapWindow) then
    FileName := (ActiveMDIChild as TfrmMapWindow).Model.ModelName;

  with TfrmGraphWindow.Create(Self) do
    try
      OpenTable(FileName);
      Show;
    except
      Free;
    end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.acAnalyseVariogramsExecute(Sender: TObject);
var
  dm: integer;
begin
  with TFormAnalyseVariograms.Create(Self) do
    try
      if ShowModal = mrOk then
      begin
        Hide;
        dm := ToolBarShowAs.Tag;
        with TFormViewVariogram.Create(self) do
          try
            VariogramFileName := OutModelName;
            DisplayMode := dm;  // 1 = table view, 2 = graph view
            ShowModal;
          finally
            Free;
          end;
      end;
    finally
      Free;
    end;
end;

//____________________________ Tools ______________________________\\

procedure TFormGeoblock.ToolsConfigurationExecute(Sender: TObject);
begin
  with TFormToolsConfiguration.Create(Self) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.ToolsStandardStyleExecute(Sender: TObject);
begin
  ActionManager.Style := StandardStyle;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.ToolsXPStyleExecute(Sender: TObject);
begin
  ActionManager.Style := XPStyle;
  ActionMainMenuBar.Shadows := True;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.ToolsUnitsConverterExecute(Sender: TObject);
begin
  with TFormToolsUnitsConverter.Create(Self) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

//_______________________ Calculator ________________________\\
procedure TFormGeoblock.CalculatorGeologyExecute(Sender: TObject);
begin
  with TFormToolsGeologyCalculator.Create(Self) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.CalculatorGeometryExecute(Sender: TObject);
begin
  with TFormToolsGeometryCalculator.Create(Self) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.CalculatorMiningExecute(Sender: TObject);
begin
  with TFormToolsMiningCalculator.Create(Self) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.CalculatorSurveyExecute(Sender: TObject);
begin
  with TFormToolsSurveyCalculator.Create(Self) do
    try
      ShowModal;
    finally
      Free;
    end;
end;


//________________________Window_________________________\\
procedure TFormGeoblock.WindowRedrawExecute(Sender: TObject);
begin
  if frmMapWindow <> nil then
    frmMapWindow.Repaint;
  if frmTableWindow <> nil then
    frmTableWindow.Repaint;
  if frmGraphWindow <> nil then
    frmGraphWindow.Repaint;
end;

//_____________________________ Help ____________________________\\

procedure TFormGeoblock.HelpContentsExecute(Sender: TObject);
begin
  Application.HelpShowTableOfContents;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.HelpGlossaryExecute(Sender: TObject);
begin
  Application.HelpContext(HelpGlossary.HelpContext);
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.HelpAboutExecute(Sender: TObject);
begin
  with TFormHelpAbout.Create(Self) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.ReadIniFile;
var
  StyleID: integer;
begin
  IniFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  with IniFile do
    try
      Top  := ReadInteger(Name, 'Top', 100);
      Left := ReadInteger(Name, 'Left', 200);
      if ReadBool(Name, 'InitMax', False) then
        WindowState := wsMaximized
      else
        WindowState := wsNormal;
      StyleID := ReadInteger(Name, 'StyleID', 0);
      if StyleID = 0 then
      begin
        ActionManager.Style := StandardStyle;
        ToolsStandardStyle.Checked := True;
      end
      else
      begin
        ActionManager.Style  := XPStyle;
        ToolsXPStyle.Checked := True;
      end
    finally
      IniFile.Free;
    end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.WriteIniFile;
begin
  IniFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  with IniFile do
    try
      WriteInteger(Name, 'Top', Top);
      WriteInteger(Name, 'Left', Left);
      WriteBool(Name, 'InitMax', WindowState = wsMaximized);

      if ActionManager.Style = StandardStyle then
        WriteInteger(Name, 'StyleID', 0)
      else
        WriteInteger(Name, 'StyleID', 1);
    finally
      IniFile.Free;
    end;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.FormClose(Sender: TObject; var Action: TCloseAction);
var
  FileName: TFileName;
begin
  try
    FileName := ExpandPath(DirProjects);
    frmViewProjectManager.SaveToFile(FileName + 'Geoblock.prj');
  except
  end;
  WriteIniFile;
  inherited;
end;

//----------------------------------------------------------------\\
procedure TFormGeoblock.FormDestroy(Sender: TObject);
begin
  Screen.OnActiveFormChange := nil;
end;

end.
