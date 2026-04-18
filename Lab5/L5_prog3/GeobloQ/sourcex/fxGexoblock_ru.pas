//---------------------------------------------------------------------------
// This unit is part of the Gexoblock Project, http://sourceforge.net/projects/geoblock
//---------------------------------------------------------------------------

unit fxGexoblock_ru;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.SysConst,
  System.Bindings.Outputs,
  System.Rtti,
  System.Math.Vectors,
  System.Actions,
  System.ImageList,
  FMX.Types,
  FMX.StdCtrls,
  FMX.Controls,
  FMX.Controls3D,
  FMX.Forms,
  FMX.Dialogs,
  FMX.Ani,
  FMX.Menus,
  FMX.Bind.DBEngExt,
  FMX.Bind.Editors,
  FMX.Types3D,
  FMX.Layers3D,
  FMX.Controls.Presentation,
  FMX.StdActns,
  FMX.ActnList,
  FMX.ImgList,
  FMX.Layouts,
  FMX.TreeView,
  FMX.Grid.Style,
  FMX.ScrollBox,
  FMX.Grid,
  Fmx.Bind.Navigator,
  FMX.TabControl,
  FMX.Styles.Objects,
  Data.Bind.EngExt,
  Data.Bind.Components,
  Data.Bind.Controls,
  Data.Bind.DBScope,
  Data.Bind.Grid,

  dmxBase,
  dmxDialogs,
  dmxImages,
  uxGlobals,
  fxGridGeneration,
  fxInterpolation,
  fxPitOptimization,
  fxFirstForm,
  frxShowScene,
  frxShowTable,
  frxDataBrowser;

type
  TfmGexoblock = class(TfmInitialForm)
    Layer3D1: TLayer3D;
    Layout3D1: TLayout3D;
    Light1: TLight;
    StyleBook: TStyleBook;
    acWindowTiles: TAction;
    ActionList: TActionList;
    acFileOpenProject: TAction;
    acFileSave: TAction;
    acFileClose: TAction;
    acWindowClose: TWindowClose;
    acFileExit: TFileExit;
    acSaveAs: TAction;
    acEditUndo: TAction;
    acDrawPoints: TAction;
    acViewMap: TAction;
    acViewScene: TAction;
    acViewGraph: TAction;
    acToolsOptions: TAction;
    acMethodInterpolation: TAction;
    acMethodGridGeneration: TAction;
    acMethodTriangulation: TAction;
    acMethodSetOperations: TAction;
    acMethodPitOptimization: TAction;
    acHelpAbout: TAction;
    acContent: TAction;
    acHelpSep: TAction;

    MainMenu: TMainMenu;
    MenuMethodGridGeneration: TMenuItem;
    MenuItem16: TMenuItem;
    miMethod: TMenuItem;
    miHelp: TMenuItem;
    miHelpGlossary: TMenuItem;
    miFile: TMenuItem;
    miFileSave: TMenuItem;
    miFileOpenProject: TMenuItem;
    miEdit: TMenuItem;
    MenuItem2: TMenuItem;
    miFileSeparator: TMenuItem;
    miFileExit: TMenuItem;
    miHelpContent: TMenuItem;
    MenuItemHelpSep: TMenuItem;
    miHelpAbout: TMenuItem;
    MenuMethodInterpolation: TMenuItem;
    miMethodTriangulation: TMenuItem;
    miView: TMenuItem;
    miDraw: TMenuItem;
    miViewMap: TMenuItem;
    miViewScene: TMenuItem;
    miViewGraph: TMenuItem;
    miAnalyse: TMenuItem;
    miTools: TMenuItem;
    miWindow: TMenuItem;
    miToolsOptions: TMenuItem;
    Langs: TLang;
    MenuItem1: TMenuItem;
    MenuItem3: TMenuItem;
    acFileImport: TAction;
    miFileImport: TMenuItem;
    MenuItem4: TMenuItem;
    acViewTable: TAction;
    PanelLeft: TPanel;
    SplitterLeft: TSplitter;
    PanelCenter: TPanel;
    SplitterRight: TSplitter;
    PanelRight: TPanel;
    ImageListOutput: TImageList;
    ImageListInput: TImageList;
    ToolBarVertical: TToolBar;
    sbMethodGridgeneration: TSpeedButton;
    sbMethodTriangulation: TSpeedButton;
    sbPitOptimization: TSpeedButton;
    ToolBarData: TToolBar;
    LabelData: TLabel;
    PanelBottom: TPanel;
    StatusBar: TStatusBar;
    PanelTop: TPanel;
    ToolBarMain: TToolBar;
    sbDatabaseBrowser: TSpeedButton;
    SpeedButton1: TSpeedButton;
    ToolBarProject: TToolBar;
    LabelProject: TLabel;
    TreeViewProject: TTreeView;
    TabControlContent: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    SpeedButton9: TSpeedButton;
    FrameDataBrowser: TFrameDataBrowser;
    sbMultiView: TSpeedButton;
    cbMultiView: TCheckBox;
    SplitterCentral: TSplitter;
    FrameShowTable: TFrameShowTable;
    FrameShowScene: TFrameShowScene;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure acFileExitCanActionExec(Sender: TCustomAction;
      var CanExec: Boolean);
    procedure acSaveAsExecute(Sender: TObject);
    procedure acMethodInterpolationExecute(Sender: TObject);
    procedure acHelpAboutExecute(Sender: TObject);
    procedure acToolsOptionsExecute(Sender: TObject);
    procedure acMethodGridGenerationExecute(Sender: TObject);
    procedure acMethodPitOptimizationExecute(Sender: TObject);
    procedure sbCenterClick(Sender: TObject);
    procedure sbMultiViewClick(Sender: TObject);
    procedure cbMultiViewChange(Sender: TObject);
  public
    procedure ReadIniFile; override;
    procedure WriteIniFile;
  private
    procedure DefaultLayout;
  end;

var
  fmGexoblock: TfmGexoblock;

implementation //=============================================================

{$R *.fmx}

uses
  fxHelpAbout,
  fxToolsOptions;

//----------------------------------------------------------------------------
procedure TfmGexoblock.DefaultLayout;
begin
  PanelCenter.Visible := True;
  PanelRight.Visible := True;
end;

//----------------------------------------------------------------------------
procedure TfmGexoblock.FormCreate(Sender: TObject);
begin
  inherited;
  ReadIniFile;
  with FrameDataBrowser do
  begin
    ReadDBFiles;
    ///BuildTree(TreeViewData, qTree);
  end;

 /// Application.OnHint      := OnApplicationHint(Sender);
end;

//----------------------------------------------------------------------------
procedure TfmGexoblock.FormShow(Sender: TObject);
begin
  inherited;
  DefaultLayout;
end;

//----------------------------------------------------------------------------
//------------------------------- Actions ----------------------------------\\
//----------------------------------------------------------------------------
procedure TfmGexoblock.acFileExitCanActionExec(Sender: TCustomAction;
  var CanExec: Boolean);
begin
  Application.Terminate;
end;

//----------------------------------------------------------------------------
procedure TfmGexoblock.acMethodGridGenerationExecute(Sender: TObject);
begin
  with TFormGridGeneration.Create(Self) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

//----------------------------------------------------------------------------
procedure TfmGexoblock.acMethodInterpolationExecute(Sender: TObject);
begin
  with TFormInterpolation.Create(Self) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

//----------------------------------------------------------------------------
procedure TfmGexoblock.acMethodPitOptimizationExecute(Sender: TObject);
begin
  with TFormPitOptimization.Create(Self) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

//----------------------------------------------------------------------------
procedure TfmGexoblock.acSaveAsExecute(Sender: TObject);
begin
  //Save As
end;

//--------------------------- Options ----------------------------------------
procedure TfmGexoblock.acToolsOptionsExecute(Sender: TObject);
begin
  frmToolsOptions.Show;
end;

//----------------------------------------------------------------------------
//_______________________ Help ________________________\\
//----------------------------------------------------------------------------
procedure TfmGexoblock.acHelpAboutExecute(Sender: TObject);
begin
  with TFormHelpAbout.Create(Self) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

{
procedure TfmGexoblock.HelpContentsExecute(Sender: TObject);
begin
  Application.HelpShowTableOfContents;
end;

procedure TfmGexoblock.HelpGlossaryExecute(Sender: TObject);
begin
  Application.HelpContext(HelpGlossary.HelpContext);
end;
}


//----------------------------------------------------------------------------
procedure TfmGexoblock.ReadIniFile;
begin
  inherited;
  with IniFile do
    try
      Top := ReadInteger(Name, 'Top', 100);
      Left := ReadInteger(Name, 'Left', 200);
      if ReadBool(Name, 'InitMax', False) then
        // WindowState = wsMaximized
      else
        // WindowState = wsNormal;
        StyleID := ReadInteger(Name, 'StyleID', 0);
      if StyleID = 0 then
      begin
        // ActionManager.Style := StandardStyle;
        // ToolsStandardStyle.Checked := True;
      end
      else
      begin
        // ActionManager.Style  := XPStyle;
        // ToolsXPStyle.Checked := True;
      end
    finally
      IniFile.Free;
    end;
end;

//----------------------------------------------------------------------------
procedure TfmGexoblock.sbCenterClick(Sender: TObject);
begin
  FrameShowTable.Visible := not FrameShowTable.Visible;
end;

//----------------------------------------------------------------------------
procedure TfmGexoblock.cbMultiViewChange(Sender: TObject);
begin
  FrameDataBrowser.TreeViewData.ShowCheckboxes := cbMultiView.IsChecked;
end;

//----------------------------------------------------------------------------
procedure TfmGexoblock.sbMultiViewClick(Sender: TObject);
begin
///
end;

//----------------------------------------------------------------------------
procedure TfmGexoblock.WriteIniFile;
begin
  with IniFile do
    try
      WriteInteger(Name, 'Top', Top);
      WriteInteger(Name, 'Left', Left);
      /// in VCL      WriteBool(Name, 'InitMax', WindowState = wsMaximized);
      {
        if ActionManager.Style = StandardStyle then
        WriteInteger(Name, 'StyleID', 0)
        else
        WriteInteger(Name, 'StyleID', 1);
      }
    finally
      IniFile.Free;
    end;
  inherited;
end;

//----------------------------------------------------------------------------
procedure TfmGexoblock.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
    //fmViewProjectManager.SaveToFile(ExpandPath(DirProject) + 'Gexoblock.prj');
  except
  end;
  WriteIniFile;
  inherited;
end;

end.
