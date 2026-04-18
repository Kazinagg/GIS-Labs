program Minliber;

uses
  Vcl.Forms,
  fMinliber in 'fMinliber.pas' {Form3},
  mlRandist in 'mlRandist.pas',
  mlGlobals in 'mlGlobals.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
