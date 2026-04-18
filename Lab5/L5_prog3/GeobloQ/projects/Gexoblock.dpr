program Gexoblock;



uses
  FMX.Forms,
  System.SysUtils,
  System.IOUtils,
  fxFirstForm in '..\sourcex\fxFirstForm.pas' {fmInitialForm},
  fxInitDialog in '..\sourcex\fxInitDialog.pas' {fmInitialDialog},
  fxHelpAbout in '..\sourcex\fxHelpAbout.pas' {FormHelpAbout},
  fxToolsOptions in '..\sourcex\fxToolsOptions.pas' {FormToolsOptions},
  dmxBase in '..\sourcex\dmxBase.pas' {dmBase: TDataModule},
  dmxDialogs in '..\sourcex\dmxDialogs.pas' {dmDialogs: TDataModule},
  Geos.Objects3D in '..\src\Geos.Objects3D.pas',
  Geos.ResStrings in '..\src\Geos.ResStrings.pas',
  Geos.Delaunay3D in '..\src\Geos.Delaunay3D.pas',
  Geos.DiscoCore in '..\src\Geos.DiscoCore.pas',
  Geos.Utils in '..\src\Geos.Utils.pas',
  Geos.Profuns in '..\src\Geos.Profuns.pas',
  Geos.DiscoPoly in '..\src\Geos.DiscoPoly.pas',
  Geos.Sorting in '..\src\Geos.Sorting.pas',
  uxGlobals in '..\sourcex\uxGlobals.pas',
  uxInverseDistance in '..\sourcex\uxInverseDistance.pas',
  fxDataBrowser in '..\sourcex\fxDataBrowser.pas' {fmFileDataBrowser},
  fxMethodDialog in '..\sourcex\fxMethodDialog.pas' {fmMethodDialog},
  fxMethodDualDialog in '..\sourcex\fxMethodDualDialog.pas' {fmMethodDualDialog},
  fxInterpolation in '..\sourcex\fxInterpolation.pas' {FormMethodInterpolation},
  fxGridGeneration in '..\sourcex\fxGridGeneration.pas' {FormMethodGridGeneration},
  uxCommon in '..\sourcex\uxCommon.pas',
  dmxImages in '..\sourcex\dmxImages.pas' {dmImages: TDataModule},
  fxAssayGeneration in '..\sourcex\fxAssayGeneration.pas' {fmMethodAssayGeneration},
  fxPitOptimization in '..\sourcex\fxPitOptimization.pas' {FormMethodPitOptimization},
  frxShowScene in '..\sourcex\frxShowScene.pas' {FrameShowScene: TFrame},
  GBX.TerraModels in '..\sourcex\GBX.TerraModels.pas',
  frxDataBrowser in '..\sourcex\frxDataBrowser.pas' {FrameDataBrowser: TFrame},
  frxShowTable in '..\sourcex\frxShowTable.pas' {FrameShowTable: TFrame},
  uxClosestPointInt in '..\sourcex\uxClosestPointInt.pas',
  uxKriging in '..\sourcex\uxKriging.pas',
  uxTetraMesh in '..\sourcex\uxTetraMesh.pas',
  uxVariograms in '..\sourcex\uxVariograms.pas',
  GBS.Objects3D in '..\src\GBS.Objects3D.pas',
  Geos.Interpol in '..\src\Geos.Interpol.pas',
  Geos.Superblock in '..\src\Geos.Superblock.pas',
  fxGexoblock in '..\sourcex\fxGexoblock.pas' {frmGexoblock};

{$R *.res}

type
  TAppExcept = class(TObject)
  private
    procedure ExceptionsControl(Sender: TObject; E: Exception);
  end;

procedure TAppExcept.ExceptionsControl(Sender: TObject; E: Exception);
var
  S: String;
begin
  S:= Format('%S'+#9+'%S',[DateTimeToStr(Now),E.Message]);
  TFile.AppendAllText('Errors.log', S+#10#13);
  Application.ShowException(E);
end;

var
  AppExcept: TAppExcept;

begin
  Application.Initialize;
  AppExcept := TAppExcept.Create;
  Application.OnException:= AppExcept.ExceptionsControl;
  Application.CreateForm(TdmBase, dmBase);
  Application.CreateForm(TdmDialogs, dmDialogs);
  Application.CreateForm(TdmImages, dmImages);
  Application.CreateForm(TfrmGexoblock, frmGexoblock);
  Application.CreateForm(TfmInitialForm, fmInitialForm);
  Application.CreateForm(TfmInitialDialog, fmInitialDialog);
  Application.Run;
end.
