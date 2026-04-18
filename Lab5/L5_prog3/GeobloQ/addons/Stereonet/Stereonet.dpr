program Stereonet;

uses
  Vcl.Forms,
  fStereonet in 'fStereonet.pas' {fmMain},
  uStereonet in 'uStereonet.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
