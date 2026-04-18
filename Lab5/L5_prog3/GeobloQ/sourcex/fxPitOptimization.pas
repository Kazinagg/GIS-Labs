unit fxPitOptimization;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.ImageList,
  FMX.ImgList,
  FMX.Edit,
  FMX.Layouts,
  FMX.ListBox,
  FMX.Controls.Presentation,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,

  fxInitDialog,
  uxGlobals;

type
  TFormPitOptimization = class(TfmInitialDialog)
    Panel1: TPanel;
    LabelMethod: TLabel;
    rbFloatingCone: TRadioButton;
    rbLerchsGrossmann: TRadioButton;
    rbPseudoFlow: TRadioButton;
    rbParticleSwarm: TRadioButton;
    rbNeuralNetwork: TRadioButton;
    rbGeneticAlgorithm: TRadioButton;
    cbOpenCL: TCheckBox;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPitOptimization: TFormPitOptimization;

implementation

{$R *.fmx}

procedure TFormPitOptimization.FormShow(Sender: TObject);
begin
  inherited;
  //
end;

end.
