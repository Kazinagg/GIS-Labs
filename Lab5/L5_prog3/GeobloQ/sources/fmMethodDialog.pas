//---------------------------------------------------------------------------
// The modeling system Geoblock http://sourceforge.net/projects/geoblock
//---------------------------------------------------------------------------

unit fmMethodDialog;

(* MethodDialog is the parent form for inherited method dialogs *)

interface

uses
  System.SysUtils,
  System.Classes,
  System.IniFiles,
  System.Math,
  System.ImageList,
  Vcl.ImgList,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.Buttons,
  Vcl.ToolWin,
  //BDE
  Data.DB,
  Bde.DBTables,

  fmBlankDialog,
  usCommon,
  Geos.Profuns,
  usGlobals,
  fEditGetStatist,
  dDialogs,
  Geos.ResStrings,
  dBase;

type
  TFormMethodDialog = class(TFormBlankDialog)
    GroupBoxInput:    TGroupBox;
    ProgressBar:      TProgressBar;
    PanelInputPath:   TPanel;
    PanelInputButtons: TPanel;
    ToolBarInput:     TToolBar;
    ToolButton1:      TToolButton;
    ToolButtonHoles:  TToolButton;
    ToolButtonPoints2D: TToolButton;
    ToolButtonPoints3D: TToolButton;
    ToolButtonPolygons: TToolButton;
    ToolButtonTins:   TToolButton;
    ToolButtonSolids: TToolButton;
    ToolButtonGrids2D: TToolButton;
    ToolButtonGrids3D: TToolButton;
    ToolButtonMeshes2D: TToolButton;
    ToolButtonMeshes3D: TToolButton;
    ToolButton2:      TToolButton;
    GroupBoxOutput:   TGroupBox;
    ToolBarShowAs:    TToolBar;
    ToolButton3:      TToolButton;
    ToolButtonMap:    TToolButton;
    ToolButtonTable:  TToolButton;
    ToolButtonGraph:  TToolButton;
    SpeedButtonOutputBrowse: TSpeedButton;
    GroupBoxRealAttribute: TGroupBox;
    ListBoxRealAttribute: TListBox;
    GroupBoxModel:    TGroupBox;
    ListBoxInputNames: TListBox;
    PanelOutPath:     TPanel;
    EditOutName:      TEdit;
    ToolBarRight:     TToolBar;
    SpeedButtonInputBrowse: TSpeedButton;
    SpeedButtonInputInfo: TSpeedButton;
    ImageListOutput: TImageList;
    ImageListInput: TImageList;
    procedure ListBoxInputNamesClick(Sender: TObject);
    procedure ListBoxRealAttributeClick(Sender: TObject);
    procedure ListBoxInputNamesKeyUp(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure ToolButtonInputClick(Sender: TObject);
    procedure ToolButtonShowAsClick(Sender: TObject);
    procedure SpeedButtonInputInfoClick(Sender: TObject);
    procedure SpeedButtonInputBrowseClick(Sender: TObject);
    procedure SpeedButtonOutputBrowseClick(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EditOutNameChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FInModelName:  TFileName;
    FOutModelName: TFileName;
    FInModelType:  integer;
    FOutModelType: integer;
    function GetInModelType: integer;
    function GetInModelName: TFileName;
    procedure SetInModelType(const Value: integer);
    procedure SetInModelName(const Value: TFileName);
    function GetOutModelName: TFileName;
    procedure SetOutModelName(const Value: TFileName);
    function GetOutModelType: integer;
    procedure SetOutModelType(const Value: integer);
  public
    ActiveAttribute: string;
    function GetPathFromTag(AToolBarTag: integer): string; virtual;
    procedure UpdateInputNames(APathAndMask: string);
    procedure UpdateRealAttributes(const ATableName: TFileName;
      const AModelType: integer);
    property InModelName: TFileName read GetInModelName write SetInModelName;
    property InModelType: integer read GetInModelType write SetInModelType;
    property OutModelName: TFileName read GetOutModelName write SetOutModelName;
    property OutModelType: integer read GetOutModelType write SetOutModelType;
    procedure ReadIniFile; override;
    procedure WriteIniFile;
  end;

var
  FormMethodDialog: TFormMethodDialog;

//==================================================================
implementation
//==================================================================

{$R *.DFM}


procedure TFormMethodDialog.FormCreate(Sender: TObject);
var
  I: integer;
begin
  inherited;
  //Force assignments of button's tags in the code
  ToolButtonHoles.Tag    := mtDholes;
  ToolButtonPoints2D.Tag := mtPoints2D;
  ToolButtonPoints3D.Tag := mtPoints3D;
  ToolButtonPolygons.Tag := mtPolygons;
  ToolButtonTins.Tag     := mtTins;
  ToolButtonSolids.Tag   := mtSolids;
  ToolButtonGrids2D.Tag  := mtGrids2D;
  ToolButtonGrids3D.Tag  := mtGrids3D;
  ToolButtonMeshes2D.Tag := mtMeshes2D;
  ToolButtonMeshes3D.Tag := mtMeshes3D;

  ReadIniFile;

  for I := 1 to ToolBarInput.ButtonCount - 1 do  //Except two separators 0 and 11
  begin
    if (ToolBarInput.Buttons[I].Visible and ToolBarInput.Buttons[I].Enabled) then
    begin
      if ToolBarInput.Buttons[I].Tag = ToolBarInput.Tag then
      begin
        ToolBarInput.Buttons[I].Down := True;
        ToolBarInput.Buttons[I].Click;
        ToolBarInput.Tag := ToolBarInput.Buttons[I].Tag;
        Break;
      end;
    end;
  end;
end;


procedure TFormMethodDialog.ToolButtonInputClick(Sender: TObject);
begin
  ToolBarInput.Tag := (Sender as TToolButton).Tag;
  InModelType      := ToolBarInput.Tag;
  OutModelType     := InModelType; // Default value
  PanelInputPath.Caption := GetPathFromTag(ToolBarInput.Tag);
  PanelInputPath.Hint := PanelInputPath.Caption;
  PanelOutPath.Caption := PanelInputPath.Caption;
  PanelOutPath.Hint := PanelOutPath.Caption;
  UpdateInputNames(PanelInputPath.Caption + TableMask);
  ListBoxInputNames.ItemIndex := 0;
  ListBoxInputNamesClick(Self);
end;

procedure TFormMethodDialog.UpdateInputNames(APathAndMask: string);
var
  SearchRec: TSearchRec;
begin
  ListBoxInputNames.Items.BeginUpdate;
  try
    ListBoxInputNames.Items.Clear;
    try
      if FindFirst(APathAndMask, faAnyFile and not (faDirectory or faVolumeID),
        SearchRec) = 0 then
        repeat
          ListBoxInputNames.Items.Add(ChangeFileExt(SearchRec.Name, ''));
        until FindNext(SearchRec) <> 0;
    finally
      FindClose(SearchRec);
    end;
  finally
    ListBoxInputNames.Items.EndUpdate;
  end;
end;

procedure TFormMethodDialog.UpdateRealAttributes(const ATableName: TFileName;
  const AModelType: integer);

var
  I:      integer;
  ATable: TTable;
begin
  ListBoxRealAttribute.Items.BeginUpdate;
  try
    ListBoxRealAttribute.Items.Clear;
    try
      ATable := TTable.Create(Self);
      ATable.TableName := InModelName;
      ATable.Open;
      for I := 0 to ATable.FieldCount - 1 do
      begin
        if IsRealAttribute(ATable.Fields[I]) then
          ListBoxRealAttribute.Items.Add(ATable.Fields[I].FieldName);
      end;
      case AModelType of
        mtPoints2D, mtTins, mtGrids2D, mtMeshes2D:
        begin
          ListBoxRealAttribute.Items.Add(fldZ);
        end;
      end;
    except
    end;
    ATable.Close;
  finally
    ATable.Free;
    ListBoxRealAttribute.Items.EndUpdate;
  end;
  try
    CheckItemIndex(ListBoxRealAttribute);
  except
  end;
  ButtonOK.Enabled := ListBoxRealAttribute.Items.Count - 1 <> 0;
end;

procedure TFormMethodDialog.ListBoxRealAttributeClick(Sender: TObject);
begin
  if ListBoxRealAttribute.Items.Count > 0 then
    ActiveAttribute := ListBoxRealAttribute.Items[ListBoxRealAttribute.ItemIndex]
  else
    ActiveAttribute := '';
end;

procedure TFormMethodDialog.ListBoxInputNamesClick(Sender: TObject);
begin
  if ListBoxInputNames.Items.Count > 0 then
  begin
    InModelName := PanelInputPath.Caption +
      ListBoxInputNames.Items[ListBoxInputNames.ItemIndex];
    UpdateRealAttributes(InModelName, InModelType);
    EditOutName.Text := ListBoxInputNames.Items[ListBoxInputNames.ItemIndex];
    OutModelName     := PanelOutPath.Caption + EditOutName.Text;
  end
  else
  begin
    InModelName      := '';
    EditOutName.Text := '';
    ListBoxInputNames.ItemIndex := 0;
    ListBoxRealAttribute.Items.Clear;
  end;
  dmBase.TableInput.TableName := InModelName;
  ButtonOK.Enabled := InModelName <> '';
end;

function TFormMethodDialog.GetPathFromTag(AToolBarTag: integer): string;
begin
  case AToolBarTag of
    mtDholes: Result   := ExpandPath(DirDholes);
    mtPoints2D: Result := ExpandPath(DirPoints2D);
    mtPoints3D: Result := ExpandPath(DirPoints3D);
    mtPolygons: Result := ExpandPath(DirPolygonPoly);
    mtTins: Result     := ExpandPath(DirTinFaces);
    mtSolids: Result   := ExpandPath(DirSolids);
    mtGrids2D: Result  := ExpandPath(DirGrid2D);
    mtGrids3D: Result  := ExpandPath(DirGrid3D);
    mtMeshes2D: Result := ExpandPath(DirMesh2D);
    mtMeshes3D: Result := ExpandPath(DirMesh3D);
    else
      Result := ExpandPath(DirDataBase);
  end;
end;

procedure TFormMethodDialog.ListBoxInputNamesKeyUp(Sender: TObject;
  var Key: word; Shift: TShiftState);
begin
  ListBoxRealAttributeClick(nil);
end;

procedure TFormMethodDialog.SpeedButtonInputInfoClick(Sender: TObject);
begin
  if InModelName <> '' then
  begin
    fmEditGetStatist := TfmEditGetStatist.Create(Self);
    fmEditGetStatist.TableName := InModelName;
    fmEditGetStatist.ShowModal;
    fmEditGetStatist.Free;
  end;
end;

procedure TFormMethodDialog.SpeedButtonInputBrowseClick(Sender: TObject);
begin
  with dmDialogs do
  begin
    OpenDialog.InitialDir := PanelInputPath.Caption;
    if OpenDialog.Execute then
    begin
      InModelName := OpenDialog.FileName;
      PanelInputPath.Caption := ExtractFilePath(OpenDialog.FileName);
      PanelInputPath.Hint := PanelInputPath.Caption;
      UpdateInputNames(PanelInputPath.Caption + TableMask);

      ListBoxInputNames.ItemIndex := 0;
      ListBoxInputNamesClick(Self);
    end;
  end;
end;

procedure TFormMethodDialog.SpeedButtonOutputBrowseClick(Sender: TObject);
begin
  with dmDialogs do
  begin
    SaveDialog.InitialDir := PanelOutPath.Caption;
    SaveDialog.FileName   := NameOnly(OutModelName) + TableExt;
    if SaveDialog.Execute then
    begin
      OutModelName      := SaveDialog.FileName;
      PanelOutPath.Caption := ExtractFilePath(SaveDialog.FileName);
      PanelOutPath.Hint := PanelOutPath.Caption;
      EditOutName.Text  := NameOnly(SaveDialog.FileName);
    end;
  end;
end;

procedure TFormMethodDialog.EditOutNameChange(Sender: TObject);
begin
  OutModelName := PanelOutPath.Caption + EditOutName.Text;
end;

procedure TFormMethodDialog.ToolButtonShowAsClick(Sender: TObject);
begin
  ToolBarShowAs.Tag := (Sender as TToolButton).Tag;
end;

procedure TFormMethodDialog.ReadIniFile;
begin
  IniFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  with IniFile do
    try
      ToolButtonMap.Down := ReadBool(Name, ToolButtonMap.Name, True);
      if ToolButtonMap.Down then
        ToolButtonMap.Click;
      ToolButtonTable.Down := ReadBool(Name, ToolButtonTable.Name, False);
      if ToolButtonTable.Down then
        ToolButtonTable.Click;
      ToolButtonGraph.Down := ReadBool(Name, ToolButtonGraph.Name, False);
      if ToolButtonGraph.Down then
        ToolButtonGraph.Click;
      ToolBarInput.Tag := ReadInteger(Name, ToolBarInput.Name, 0);
    finally
      IniFile.Free;
    end;
end;

procedure TFormMethodDialog.WriteIniFile;
begin
  IniFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  with IniFile do
    try
      WriteInteger(Name, ToolBarInput.Name, ToolBarInput.Tag);
      WriteBool(Name, ToolButtonMap.Name, ToolButtonMap.Down);
      WriteBool(Name, ToolButtonTable.Name, ToolButtonTable.Down);
      WriteBool(Name, ToolButtonGraph.Name, ToolButtonGraph.Down);
    finally
      IniFile.Free;
    end;
end;

function TFormMethodDialog.GetOutModelName: TFileName;
begin
  try
    Result := FOutModelName;
  except
    Result := '';
  end;
end;

procedure TFormMethodDialog.SetOutModelName(const Value: TFileName);
begin
  if CompareText(FOutModelName, Value) <> 0 then
  begin
    FOutModelName     := Value;
    PanelOutPath.Caption := ExtractFilePath(FOutModelName);
    PanelOutPath.Hint := FOutModelName;
  end;
end;

function TFormMethodDialog.GetOutModelType: integer;
begin
  try
    Result := FOutModelType;
  except
    Result := mtPoints2D;
  end;
end;

procedure TFormMethodDialog.SetOutModelType(const Value: integer);
begin
  if CompareValue(FOutModelType, Value) <> 0 then
  begin
    FOutModelType := Value;
  end;
end;

procedure TFormMethodDialog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  WriteIniFile;
  inherited;
end;


function TFormMethodDialog.GetInModelType: integer;
begin
  try
    Result := FInModelType;
  except
    Result := mtDHoles;
  end;
end;


function TFormMethodDialog.GetInModelName: TFileName;
begin
  try
    Result := FInModelName;
  except
    Result := '';
  end;
end;

procedure TFormMethodDialog.SetInModelType(const Value: integer);
begin
  if CompareValue(FInModelType, Value) <> 0 then
  begin
    FInModelType := Value;
  end;
end;

procedure TFormMethodDialog.SetInModelName(const Value: TFileName);
begin
  if CompareText(FInModelName, Value) <> 0 then
  begin
    FInModelName := Value;
    PanelInputPath.Caption := ExtractFilePath(FInModelName);
    PanelInputPath.Hint := FInModelName;
  end;
end;

procedure TFormMethodDialog.ButtonOKClick(Sender: TObject);
begin
  inherited;

  if FileExists(ChangeFileExt(OutModelName, TableExt)) then
  begin
    if MessageDlg(LoadResString(@rsUpdate) + ' ' + OutModelName +
      '?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    begin
      ModalResult := mrNone;
      Exit;
    end;
  end;
end;

end.
