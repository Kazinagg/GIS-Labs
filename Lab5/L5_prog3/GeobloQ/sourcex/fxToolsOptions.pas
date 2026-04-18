
unit fxToolsOptions;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Rtti,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.TreeView,
  FMX.Layouts,
  FMX.Grid,
  FMX.ListBox,
  FMX.StdCtrls,
  FMX.Controls.Presentation,
  FMX.Menus,

  fxInitDialog,
  uxGlobals;

type
  TfrmToolsOptions = class(TfmInitialDialog)
    TreeView: TTreeView;
    TreeViewItem1: TTreeViewItem;
    TreeViewItem2: TTreeViewItem;
    TreeViewItem3: TTreeViewItem;
    ListBox: TListBox;
    ButtonEn: TButton;
    ButtonRu: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ListBoxChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
  public
  end;

var
  frmToolsOptions: TfrmToolsOptions;

//==============================================================================
implementation
//==============================================================================

{$R *.fmx}

procedure TfrmToolsOptions.FormCreate(Sender: TObject);
var
  i: integer;
  Item: TListBoxItem;
begin
  inherited;
  Item := TListBoxItem.Create(Self);
  Item.Parent := ListBox;
  Item.Text := 'en';
  Item.AutoTranslate := True;
end;

procedure TfrmToolsOptions.FormShow(Sender: TObject);
begin
  inherited;
  //
end;

procedure TfrmToolsOptions.ListBoxChange(Sender: TObject);
begin
{
  if ListBox.Selected <> nil then
    Langs.Lang := ListBox.Selected.Text;
}
end;

end.
