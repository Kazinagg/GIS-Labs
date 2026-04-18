(*
  Based on Safak Cinar demo
  http://members.shaw.ca/safak/
*)
program PitDigger;

{$R '..\..\assets\resource\cursors.res'}

uses
  Forms,
  fPitDigger in 'fPitDigger.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
