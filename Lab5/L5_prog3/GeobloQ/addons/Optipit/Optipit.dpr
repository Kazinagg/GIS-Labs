program Optipit;

uses
  Forms,
  Geos.Profuns in '..\..\src\Geos.Profuns.pas',
  fpAbout in 'fpAbout.pas' {FormAbout},
  fpOptipit in 'fpOptipit.pas' {FormOptipit};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormAbout, FormAbout);
  Application.CreateForm(TFormOptipit, FormOptipit);
  Application.Run;
end.
