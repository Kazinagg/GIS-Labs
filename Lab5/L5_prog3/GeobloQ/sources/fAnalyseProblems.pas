//-----------------------------------------------------------------------------
// The modeling system Geoblock http://sourceforge.net/projects/geoblock
//-----------------------------------------------------------------------------
{! The Form for problem book plugins}

unit fAnalyseProblems;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ImgList,
  Vcl.ActnList,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,

  fmPageDialog,
  usGlobals,
  usCommon,
  Geos.ResStrings;

type
  TFormAnalyseProblems = class(TFormPageDialog)
    procedure ListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: boolean);
    procedure ButtonOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure Execute(Sender: TObject);
    function GetListViews(APage: string): TListView;
    function GetPages(Page: string): TTabSheet;
    function GetImages(APage: string): TImageList;
  public
    property Images[Page: string]: TImageList read GetImages;
    property ListViews[Page: string]: TListView read GetListViews;
    property Pages[Page: string]: TTabSheet read GetPages;
  end;

var
  FormAnalyseProblems: TFormAnalyseProblems;

type
  TMethodProcedure = procedure of object;

  TCustomProblem = class(TComponent)
  private
    FExecute:   TMethodProcedure;
    FonExecute: TNotifyEvent;
    FHint:      string;
  public
    procedure Run;
    property Execute: TMethodProcedure read FExecute write FExecute;
    property onExecute: TNotifyEvent read FonExecute write FonExecute;
  published
    property Hint: string read FHint write FHint;
  end;

//=========================================================================
implementation
//=========================================================================

{$R *.DFM}

procedure TFormAnalyseProblems.Execute(Sender: TObject);
var
  ListView: TListView;
begin
  Hide;
  try
    ListView := nil;
    if Assigned(PageControl.ActivePage) then
      ListView := ListViews[PageControl.ActivePage.Caption];
    if ListView <> nil then
    begin
      if Assigned(ListView.Selected) then
        TCustomProblem(ListView.Selected.Data).Run;
    end;
  finally
    Show;
  end;
end;

function TFormAnalyseProblems.GetListViews(APage: string): TListView;
var
  I:    integer;
  Page: TTabSheet;
begin
  Result := nil;
  Page   := Pages[APage];
  for I := 0 to Page.ControlCount - 1 do
    if Page.Controls[I] is TListView then
    begin
      Result := TListView(Page.Controls[I]);
      Exit;
    end;
end;

function TFormAnalyseProblems.GetPages(Page: string): TTabSheet;
var
  I:      integer;
  Images: TImageList;
begin
  Result := nil;
  for I := 0 to PageControl.PageCount - 1 do
    if CompareText(PageControl.Pages[I].Caption, Page) = 0 then
    begin
      Result := PageControl.Pages[I];
      Exit;
    end;

  Result := TTabSheet.Create(PageControl);
  Result.PageControl := PageControl;
  Result.Parent := PageControl;
  Result.Caption := Page;
  Result.TabVisible := True;

  Images := TImageList.Create(Result);
  with Images do
  begin
    CreateSize(32, 32);
    Masked := False;
  end;

  with TListView.Create(Result) do
  begin
    Parent     := Result;
    Align      := alClient;
    ViewStyle  := vsIcon;
    LargeImages := Images;
    OnDblClick := Execute;
    OnSelectItem := ListViewSelectItem;
  end;
end;

procedure TFormAnalyseProblems.ListViewSelectItem(Sender: TObject;
  Item: TListItem; Selected: boolean);
begin
  TListView(Sender).Hint := TCustomProblem(Item.Data).Hint;
end;

function TFormAnalyseProblems.GetImages(APage: string): TImageList;
var
  I:    integer;
  Page: TTabSheet;
begin
  Result := nil;
  Page   := Pages[APage];
  for I := 0 to Page.ControlCount - 1 do
    if Page.Components[I] is TImageList then
    begin
      Result := TImageList(Page.Components[I]);
      Exit;
    end;
end;

procedure TCustomProblem.Run;
begin
  if Assigned(Execute) then
    Execute;
  if Assigned(onExecute) then
    onExecute(Self.Owner);
end;

procedure TFormAnalyseProblems.ButtonOKClick(Sender: TObject);
var
  ListView: TListView;
begin
  ListView := ListViews[PageControl.ActivePage.Caption];
  if ListView.Selected <> nil then
    TCustomProblem(ListView.Selected.Data).Run;
end;


procedure TFormAnalyseProblems.FormCreate(Sender: TObject);
var
  I: integer;

begin
  inherited;
  //
end;

end.
