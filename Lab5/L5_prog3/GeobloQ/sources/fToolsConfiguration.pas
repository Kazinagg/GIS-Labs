// -----------------------------------------------------------------------------
// The modeling system Geoblock http://sourceforge.net/projects/geoblock
// -----------------------------------------------------------------------------
(* Configuration of tools *)

unit fToolsConfiguration;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.IniFiles,
  System.Win.Registry,
  System.ImageList,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Vcl.Samples.Spin,
  Vcl.AppEvnts,
  Vcl.ImgList,
  Vcl.FileCtrl,


  GBEditValue, 
  dBase,
  dDialogs, 
  fPageTreeDialog,
  usGlobals,
  usCommon,
  Geos.ResStrings;

type
  TFormToolsConfiguration = class(TfmPageTreeDialog)
    tsInterface: TTabSheet;
    tsDisplay: TTabSheet;
    CheckBoxAxes: TCheckBox;
    LabelBackground: TLabel;
    PanelBackground: TPanel;
    tsData: TTabSheet;
    LabelProgram: TLabel;
    LabelData: TLabel;
    PanelExePath: TPanel;
    cbDataPath: TComboBox;
    ButtonBrowsePathData: TButton;
    LabelPrecision: TLabel;
    SpinEditPrecision: TSpinEdit;
    CheckBoxCoordinates: TCheckBox;
    LabelMapUnits: TLabel;
    ComboBoxMapUnits: TComboBox;
    cbxTwoSideLighting: TCheckBox;
    PanelScale: TPanel;
    lblScaleX: TLabel;
    GBEditValue1: TGBEditValue;
    GBEditValue2: TGBEditValue;
    GBEditValue3: TGBEditValue;
    Label1: TLabel;
    Label2: TLabel;
    ImageList: TImageList;
    tsMaterial: TTabSheet;
    ListView: TListView;
    ButtonModifyMat: TButton;
    lblScalarBB: TLabel;
    CheckBoxLoadProject: TCheckBox;
    CheckBoxSaveProject: TCheckBox;
    procedure PanelBackgroundClick(Sender: TObject);
    procedure TreeViewClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ButtonBrowsePathDataClick(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonModifyMatClick(Sender: TObject);
  private
    RegIni: TRegistryIniFile;
    CurrLangID: integer;
    procedure SetValues;
    procedure InitDirectories;
    function CheckDirectory(S: string): boolean;
    procedure SetDirectories;
    procedure Read_Registry;
    procedure Write_Registry;
    procedure ReadIniFile;
    procedure WriteIniFile;
  public
  end;

var
  FormToolsConfiguration: TFormToolsConfiguration;

//==========================================================================
implementation
//==========================================================================

{$R *.dfm}

procedure TFormToolsConfiguration.FormCreate(Sender: TObject);
begin
  inherited; // if removed then the form is created with no localazation!
  RegIni := TRegistryIniFile.Create(GeneralSection);
  Read_Registry;
  ReadIniFile;
  CurrLangID := LangID;
  InitDirectories;
end;

procedure TFormToolsConfiguration.ButtonBrowsePathDataClick(Sender: TObject);
var
  Dir: string;
begin
  Dir := cbDataPath.Text; //Initial Dir
  if SelectDirectory(LoadResString(@rsSelectDataFolder), '', Dir) then
  begin
    if AnsiLastChar(Dir) <> PathDelim then
      Dir := Dir + PathDelim;
    if IndexOf(Dir, cbDataPath.Items) > 0 then
      cbDataPath.ItemIndex :=
        IndexOf(Dir, cbDataPath.Items)
    else
    begin
      cbDataPath.Items.Insert(0, Dir);
      cbDataPath.ItemIndex := 0;
    end;
  end;
end;

function TFormToolsConfiguration.CheckDirectory(S: string): boolean;
begin
  Result := DirectoryExists(S);
  if not Result then
  begin
    if MessageDlg(LoadResString(@rsPathNotExist) + '. ' +
      LoadResString(@rsCreate) + ' ' + S + ' ?', mtConfirmation,
      mbOKCancel, 0) = mrOk then
    begin
      try
        if not ForceDirectories(S) then
          Abort;
        Result := True;
      except
        MessageDlg(LoadResString(@rsErrorCreatingPath), mtError, [mbOK], 0);
      end;
    end;
  end;
end;

procedure TFormToolsConfiguration.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  WriteIniFile;
  inherited;
end;


procedure TFormToolsConfiguration.FormDestroy(Sender: TObject);
begin
  RegIni.Free;
end;

procedure TFormToolsConfiguration.InitDirectories;
begin
  PanelExePath.Caption := ExePath;
  PanelExePath.Hint    := PanelExePath.Caption;
  cbDataPath.Items.Add(DataBasePath);
  cbDataPath.ItemIndex := 0;
end;

procedure TFormToolsConfiguration.PanelBackgroundClick(Sender: TObject);
begin
  with dmDialogs.ColorDialog do
  begin
    Color := PanelBackground.Color;
    if Execute then
    begin
      PanelBackground.Color := Color;
    end;
  end;
end;

procedure TFormToolsConfiguration.SetDirectories;
begin
  if CheckDirectory(cbDataPath.Text) then
    DataBasePath := cbDataPath.Text;
end;

procedure TFormToolsConfiguration.SetValues;
begin
  Precision := SpinEditPrecision.Value;
end;

procedure TFormToolsConfiguration.TreeViewClick(Sender: TObject);
begin
  if (TreeView.Selected.ExpandedImageIndex = 1) then
    PageControl.ActivePage := tsInterface
  else if (TreeView.Selected.ExpandedImageIndex = 2) then
    PageControl.ActivePage := tsDisplay
  else if (TreeView.Selected.ExpandedImageIndex = 3) then
    PageControl.ActivePage := tsData
  else if (TreeView.Selected.ExpandedImageIndex = 4) then
    PageControl.ActivePage := tsMaterial;
end;

procedure TFormToolsConfiguration.ButtonModifyMatClick(Sender: TObject);
var
  PathStr, FileName: string;
  ListItem: TListItem;
begin
  with dmDialogs do
  begin
    OpenDialog.FilterIndex := 1;
    OpenDialog.InitialDir  := ExpandPath(DirDataReference);
    OpenDialog.FileName    := '';
    if OpenDialog.Execute then
    begin
      FileName := OpenDialog.FileName;
      PathStr  := ExtractFileDir(FileName);
      if PathStr[Length(PathStr)] <> PathDelim then
        PathStr := PathStr + PathDelim;
      FileName := ChangeFileExt(ExtractFileName(FileName), '');
      ListItem := ListView.FindCaption(0, FileName, True, True, False);
      ListView.Selected := ListItem;
    end;
  end;
end;

procedure TFormToolsConfiguration.Read_Registry;
begin
  with RegIni do
  begin
    ReadString(GeneralSection, 'DataPath', cbDataPath.Text);
  end;
end;

procedure TFormToolsConfiguration.Write_Registry;
begin
  with RegIni do
  begin
    WriteString(GeneralSection, 'DataPath', cbDataPath.Text);
  end;
end;

procedure TFormToolsConfiguration.ReadIniFile;
begin
  IniFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  with IniFile do
    try
      CheckBoxLoadProject.Checked := ReadBool(Name, CheckBoxLoadProject.Caption, True);
      CheckBoxSaveProject.Checked := ReadBool(Name, CheckBoxSaveProject.Caption, True);
      CheckBoxCoordinates.Checked := ReadBool(Name, CheckBoxCoordinates.Caption, True);
      SpinEditPrecision.Value     := ReadInteger(Name, SpinEditPrecision.Hint, -2);
      ComboBoxMapUnits.ItemIndex  := ReadInteger(Name, ComboBoxMapUnits.Hint, 3);
    finally
      IniFile.Free;
    end;
end;

procedure TFormToolsConfiguration.WriteIniFile;
begin
  IniFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  with IniFile do
    try
      WriteBool(Name, CheckBoxLoadProject.Caption, CheckBoxLoadProject.Checked);
      WriteBool(Name, CheckBoxSaveProject.Caption, CheckBoxSaveProject.Checked);
      WriteBool(Name, CheckBoxCoordinates.Caption, CheckBoxCoordinates.Checked);
      WriteInteger(Name, SpinEditPrecision.Hint, SpinEditPrecision.Value);
      WriteInteger(Name, ComboBoxMapUnits.Hint, ComboBoxMapUnits.ItemIndex);
    finally
      IniFile.Free;
    end;
end;

procedure TFormToolsConfiguration.ButtonOKClick(Sender: TObject);
var
  FileName: TFileName;
begin
  SetValues;
  SetDirectories;
  Write_Registry;
  if LangID <> CurrLangID then
  begin
    MessageDlg(LoadResString(@rsReloadGeoblockToChangeLanguage),
      mtInformation, [mbOK], 0);
    FileName := ChangeFileExt(ParamStr(0), '.ini');
    if FileExists(UpperCase(FileName)) then
      DeleteFile(UpperCase(FileName));
    //Else sections will be dublicated for every language.
  end;
end;

end.
