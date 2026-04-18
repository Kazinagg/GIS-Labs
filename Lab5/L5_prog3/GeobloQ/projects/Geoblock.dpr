//----------------------------------------------------------------------------
// The unit of Geoblock Project, http://sourceforge.net/projects/geoblock
//
// The contents of this file are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except in compliance
// with the License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
//
// Software distributed under the License is distributed on an "AS IS" basis,
// WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
// the specific language governing rights and limitations under the License.
//
// The initial developer of the original code is Getos Ltd., Copyright (c) 1997.
// Portions created by contributors are documented in an accompanying history log
// and Copyright (c) of these contributors, 1997-2023. All Rights Reserved.
//---------------------------------------------------------------------------

program Geoblock;

{.$R 'sources\Gb.res'}

uses
  Forms,
  dBase in '..\sources\dBase.pas' {dmBase: TDataModule},
  dDialogs in '..\sources\dDialogs.pas' {dmDialogs: TDataModule},
  fOptionDialog in '..\sources\fOptionDialog.pas' {fmOptionDialog},
  fFileOpenDialog in '..\sources\fFileOpenDialog.pas' {fmFileOpenDialog},
  fmPageDialog in '..\sources\fmPageDialog.pas' {FormPageDialog},
  fPageTreeDialog in '..\sources\fPageTreeDialog.pas' {fmPageTreeDialog},
  fFileEditGridPars in '..\sources\fFileEditGridPars.pas' {fmFileEditGridPars},
  fmGeoblock in '..\sources\fmGeoblock.pas' {FormGeoblock},
  fMethodEvaluation in '..\sources\fMethodEvaluation.pas' {FormMethodEvaluation},
  fDrawFillStyle in '..\sources\fDrawFillStyle.pas' {FormDrawFillStyle},
  fDisplayGrid3DOptions in '..\sources\fDisplayGrid3DOptions.pas' {fmDisplayGrid3DOptions},
  fComposeLinearReserves in '..\sources\fComposeLinearReserves.pas' {fmComposeLinearReserves},
  fDisplayTinOptions in '..\sources\fDisplayTinOptions.pas' {fmDisplayTinOptions},
  fDisplayPoints2DOptions in '..\sources\fDisplayPoints2DOptions.pas' {fmDisplayPoints2DOptions},
  fDisplayPoints3DOptions in '..\sources\fDisplayPoints3DOptions.pas' {fmDisplayPoints3DOptions},
  fDisplayGrid2DOptions in '..\sources\fDisplayGrid2DOptions.pas' {FormDisplayGrid2DOptions},
  fDisplayMesh3DOptions in '..\sources\fDisplayMesh3DOptions.pas' {fmDisplayMesh3DOptions},
  fDisplayMesh2DOptions in '..\sources\fDisplayMesh2DOptions.pas' {fmDisplayMesh2DOptions},
  fComposeByHorizons in '..\sources\fComposeByHorizons.pas' {fmComposeByHorizons},
  fDisplayHolesOptions in '..\sources\fDisplayHolesOptions.pas' {fmDisplayHolesOptions},
  fDisplayPolygonsOptions in '..\sources\fDisplayPolygonsOptions.pas' {fmDisplayPolygonsOptions},
  fPerformVectors in '..\sources\fPerformVectors.pas' {FormPerformVectors},
  fPerformContours in '..\sources\fPerformContours.pas' {FormPerformContours},
  fPerformIsosurfaces in '..\sources\fPerformIsosurfaces.pas' {FormPerformIsosurfaces},
  fComposeOreIntervals in '..\sources\fComposeOreIntervals.pas' {fmComposeOreIntervals},
  fDrawLineStyle in '..\sources\fDrawLineStyle.pas' {FormDrawLineStyle},
  fMethodGridGeneration in '..\sources\fMethodGridGeneration.pas' {FormMethodGridGeneration},
  fToolsUnitsConverter in '..\sources\fToolsUnitsConverter.pas' {FormToolsUnitsConverter},
  fMethodTriangulation in '..\sources\fMethodTriangulation.pas' {FormMethodTriangulation},
  fReserveCutOptions in '..\sources\fReserveCutOptions.pas' {fmReserveCutOptions},
  fDrawObjectDepth in '..\sources\fDrawObjectDepth.pas' {FormDrawObjectDepth},
  fEditCalcField in '..\sources\fEditCalcField.pas' {fmEditCalcField},
  fEditDeleteField in '..\sources\fEditDeleteField.pas' {fmEditDeleteField},
  fEditMemoField in '..\sources\fEditMemoField.pas' {fmEditMemoField},
  fEditLookupField in '..\sources\fEditLookupField.pas' {fmEditLookupField},
  fMethodInterpolation in '..\sources\fMethodInterpolation.pas' {FormMethodInterpolation},
  fInterKriging in '..\sources\fInterKriging.pas' {fmInterKriging},
  fInterPolynomRegression in '..\sources\fInterPolynomRegression.pas' {fmInterPolynomialRegression},
  fDisplaySolidOptions in '..\sources\fDisplaySolidOptions.pas' {fmDisplaySolidsOptions},
  fMapLight in '..\sources\fMapLight.pas' {fmMapLighting},
  fAnalyseReserves in '..\sources\fAnalyseReserves.pas' {FormAnalyseReserves},
  fFileImageRegistration in '..\sources\fFileImageRegistration.pas' {fmFileImageRegistration},
  fRecordEditor in '..\sources\fRecordEditor.pas' {fmRecordEditor},
  fMethodSetOperations in '..\sources\fMethodSetOperations.pas' {FormMethodSetOperations},
  fComposeCenters in '..\sources\fComposeCenters.pas' {fmComposeCenters},
  fViewRotate in '..\sources\fViewRotate.pas' {fmViewRotate},
  fEditRenField in '..\sources\fEditRenField.pas' {fmEditRenField},
  fViewScale in '..\sources\fViewScale.pas' {fmViewScale},
  fEditAddField in '..\sources\fEditAddField.pas' {fmEditAddField},
  fFileExport in '..\sources\fFileExport.pas' {FormFileExport},
  fFileEditWhittlePars in '..\sources\fFileEditWhittlePars.pas' {fmFileEditWhittlePars},
  fmInfoDialog in '..\sources\fmInfoDialog.pas' {frmInfoDialog},
  fFileImport in '..\sources\fFileImport.pas' {FormFileImport},
  fEditQuery in '..\sources\fEditQuery.pas' {fmEditQuery},
  fEditGetStatist in '..\sources\fEditGetStatist.pas' {fmEditGetStatist},
  fToolsSurveyCalculator in '..\sources\fToolsSurveyCalculator.pas' {FormToolsSurveyCalculator},
  fAnalyseVariograms in '..\sources\fAnalyseVariograms.pas' {FormAnalyseVariograms},
  fMapLegend in '..\sources\fMapLegend.pas' {fmMapLegend},
  fEditFileXML in '..\sources\fEditFileXML.pas' {fmEditFileXML},
  fToolsGeometryCalculator in '..\sources\fToolsGeometryCalculator.pas' {FormToolsGeometryCalculator},
  fToolsGeologyCalculator in '..\sources\fToolsGeologyCalculator.pas' {FormToolsGeologyCalculator},
  fComposeContacts in '..\sources\fComposeContacts.pas' {fmComposeContacts},
  fToolsConfiguration in '..\sources\fToolsConfiguration.pas' {FormToolsConfiguration},
  fToolsMiningCalculator in '..\sources\fToolsMiningCalculator.pas' {FormToolsMiningCalculator},
  fViewProjectManager in '..\sources\fViewProjectManager.pas' {frmViewProjectManager},
  fStartup in '..\sources\fStartup.pas' {fmStartup},
  fMethodConversion in '..\sources\fMethodConversion.pas' {FormMethodConversion},
  fMethodTransformation in '..\sources\fMethodTransformation.pas' {FormMethodTransformation},
  fMapWindow in '..\sources\fMapWindow.pas' {frmMapWindow},
  fTableWindow in '..\sources\fTableWindow.pas' {frmTableWindow},
  fGraphWindow in '..\sources\fGraphWindow.pas' {frmGraphWindow},
  fDrawImageEditor in '..\sources\fDrawImageEditor.pas' {fmDrawImageEditor},
  fDrawSymbolStyle in '..\sources\fDrawSymbolStyle.pas' {FormDrawSymbolStyle},
  fFileOpenText in '..\sources\fFileOpenText.pas' {fmFileOpenText},
  fComposeOreSorts in '..\sources\fComposeOreSorts.pas' {fmComposeOreSorts},
  fMethodVarioModeller in '..\sources\fMethodVarioModeller.pas' {FormMethodVarioModeller},
  fViewVariogram in '..\sources\fViewVariogram.pas' {FormViewVariogram},
  fMapScenery in '..\sources\fMapScenery.pas' {fmMapScenery},
  fFileDataBrowser in '..\sources\fFileDataBrowser.pas' {frmFileDataBrowser},
  fTerraContours in '..\sources\fTerraContours.pas' {fmGSContours},
  fTerraScene in '..\sources\fTerraScene.pas' {fmGeoScene},
  fTerraSplash in '..\sources\fTerraSplash.pas' {fmGS_Splash},
  fFileOpenModel in '..\sources\fFileOpenModel.pas' {FormFileOpenModel},
  fMethodPitOptimization in '..\sources\fMethodPitOptimization.pas' {FormMethodPitOptimization},
  fMethodPrediction in '..\sources\fMethodPrediction.pas' {FormMethodPrediction},
  fEditRecord in '..\sources\fEditRecord.pas' {fmInitialDialog1},
  fEditVariogram in '..\sources\fEditVariogram.pas' {fmEditVariogram},
  fInterLinear in '..\sources\fInterLinear.pas' {fmInterLinear},
  fViewHorizon in '..\sources\fViewHorizon.pas' {fmViewHorizon},
  fViewDataVisualizer in '..\sources\fViewDataVisualizer.pas' {fmInitialForm1},
  Geos.Sorting in '..\src\Geos.Sorting.pas',
  usVariograms in '..\sources\usVariograms.pas',
  usDelaunay2D in '..\sources\usDelaunay2D.pas',
  usIOPoly in '..\sources\usIOPoly.pas',
  usDrawVor in '..\sources\usDrawVor.pas',
  usInverseDistance in '..\sources\usInverseDistance.pas',
  usLinearByTin in '..\sources\usLinearByTin.pas',
  usNaturalNeighbors in '..\sources\usNaturalNeighbors.pas',
  usKriging in '..\sources\usKriging.pas',
  usClosestPointInt in '..\sources\usClosestPointInt.pas',
  usPolynomialRegression in '..\sources\usPolynomialRegression.pas',
  Geos.Delaunay3D in '..\src\Geos.Delaunay3D.pas',
  usTerraLayers in '..\sources\usTerraLayers.pas',
  usTerraModel in '..\sources\usTerraModel.pas',
  usTerraObjects in '..\sources\usTerraObjects.pas',
  usTerraSound in '..\sources\usTerraSound.pas',
  usModels in '..\sources\usModels.pas',
  usFileCreator in '..\sources\usFileCreator.pas',
  usTerraLoader in '..\sources\usTerraLoader.pas',
  usWhittle in '..\sources\usWhittle.pas',
  Geos.DiscoMetric in '..\src\Geos.DiscoMetric.pas',
  Geos.DiscoCore in '..\src\Geos.DiscoCore.pas',
  Geos.DiscoPoly in '..\src\Geos.DiscoPoly.pas',
  usTerraBalloon in '..\sources\usTerraBalloon.pas',
  fTerraSceneVR in '..\sources\fTerraSceneVR.pas' {fmSceneVR},
  usOptimizePF in '..\sources\usOptimizePF.pas',
  fMethodOctree in '..\sources\fMethodOctree.pas' {FormMethodOctree},
  fMethodSimulation in '..\sources\fMethodSimulation.pas' {FormFileNew},
  usGlobals in '..\sources\usGlobals.pas',
  Geos.Profuns in '..\src\Geos.Profuns.pas',
  dImages in '..\sources\dImages.pas' {dmImages: TDataModule},
  Geos.ResStrings in '..\src\Geos.ResStrings.pas',
  usCommon in '..\sources\usCommon.pas',
  fInterInverseDistance in '..\sources\fInterInverseDistance.pas' {fmInterInverseDistance},
  fInterNaturalNeighbours in '..\sources\fInterNaturalNeighbours.pas' {fmInterNaturalNeighbours},
  fmBlankDialog in '..\sources\fmBlankDialog.pas' {frmInitDialog},
  fmFirstForm in '..\sources\fmFirstForm.pas' {FormFirst},
  Geos.Interpol in '..\src\Geos.Interpol.pas',
  fmMethodDialog in '..\sources\fmMethodDialog.pas' {FormMethodDialog},
  fHelpAbout in '..\sources\fHelpAbout.pas',
  usTetraMesh in '..\sources\usTetraMesh.pas',
  GBS.Objects3D in '..\src\GBS.Objects3D.pas',
  fMethodDualDialog in '..\sources\fMethodDualDialog.pas',
  Geos.Superblock in '..\src\Geos.Superblock.pas',
  usOptimizeFC in '..\sources\usOptimizeFC.pas',
  usOptimizeLG in '..\sources\usOptimizeLG.pas',
  Geos.Normal in '..\src\Geos.Normal.pas',
  fAnalyseProblems in '..\sources\fAnalyseProblems.pas';

{$R *.RES}
{$SetPEFlags $20}  // Allows up to 4GB address space with FastMM

begin
//  TStyleManager.TrySetStyle('Aqua Light Slate');
//  LogoShow;
  InitGeneralRegistry;
  InitCursors;

  Application.Title := 'Geoblock';
  Application.CreateForm(TFormGeoblock, FormGeoblock);
  Application.CreateForm(TfrmViewProjectManager, frmViewProjectManager);
  Application.CreateForm(TdmDialogs, dmDialogs);
  Application.CreateForm(TdmBase, dmBase);
  Application.CreateForm(TdmImages, dmImages);
  Application.CreateForm(TFormFirst, FormFirst);
  Application.CreateForm(TFormBlankDialog, FormBlankDialog);
  Application.CreateForm(TFormMethodDialog, FormMethodDialog);

  Application.CreateForm(TfrmFileDataBrowser, frmFileDataBrowser);
  Application.CreateForm(TfrmMapWindow, frmMapWindow);
  Application.CreateForm(TfrmGraphWindow, frmGraphWindow);
  Application.CreateForm(TFormPageDialog, FormPageDialog);
  //   LogoClose;
  Application.Run;
end.
