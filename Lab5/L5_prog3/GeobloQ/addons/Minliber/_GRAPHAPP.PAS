{************************************************}
{                                                }
{   Turbo Pascal 6.0                             }
{   Turbo Vision BGI Support Demo                }
{   Copyright (c) 1990 by Borland International  }
{                                                }
{************************************************}

unit GraphApp;

{ Модуль поддеpжки BGI для пpогpамм Turbo Vision. Смотpите
  TVBGI.PAS для пpимеpа как использовать этот модуль.
}

interface

uses 
  Objects;

function GraphAppInit(ADriver, AMode: Integer; ABGIPath: PString;
  LoadAtInit: Boolean): Boolean;
procedure GraphAppDone;
function GraphicsStart: Boolean;
procedure GraphicsStop;
function GraphicsActive: Boolean;

implementation

uses 
  Graph, 
  Drivers, 
  Memory, 
  App;

const
  GraphActive: Boolean = False;
  DriverPtr:   Pointer = nil;
  DriverSize:  Word = 0;
  EmptyString: string[1] = '';
  BGIPath:     PString = @EmptyString;
  Driver:      Integer = Detect;
  Mode:        Integer = 0;

  LastDriver = 10;
  DriverName: array[1..LastDriver] of string[8] =
    ('CGA',                {  1. CGA      }
     'CGA',                {  2. MCGA     }
     'EGAVGA',             {  3. EGA      }
     'EGAVGA',             {  4. EGA64    }
     'EGAVGA',             {  5. EGAMONO  }
     'IBM8514',            {  6. IBM8514  }
     'HERC',               {  7. HercMono }
     'ATT',                {  8. ATT400   }
     'EGAVGA',             {  9. VGA      }
     'PC3270');            { 10. PC3270   }


{ Utility methods }
procedure FreeDriverMem(var P: Pointer; var S: Word);
begin
  if P <> nil then FreeMem(P, S);
  P := nil;
  S := 0;
end;

function GraphAppLoadDriver(DriverNum: Integer): Boolean;
var F: File;
begin
  GraphAppLoadDriver := False;
  if DriverNum <= LastDriver then
  begin
    Assign(F, BGIPath^ + DriverName[Driver] + '.BGI');
    {$I-}
    Reset(F, 1);
    {$I+}
    if IOResult = 0 then
    begin
      DriverSize := FileSize(F);
      if (DriverSize < 64 * 1024 - $F) and (DriverSize <= MaxAvail) then
      begin
        GetMem(DriverPtr, DriverSize);
        BlockRead(F, DriverPtr^, DriverSize);
        if (IOResult = 0) and (RegisterBGIdriver(DriverPtr) >= 0) then
          GraphAppLoadDriver := True
        else
          FreeDriverMem(DriverPtr, DriverSize);
      end;
      Close(F);
    end;
  end;
end;

function GraphAppInit(ADriver, AMode: Integer;
  ABGIPath: PString; LoadAtInit: Boolean): Boolean;
begin
  GraphAppInit := True;
  if ABGIPath <> nil then BGIPath := ABGIPath;
  Driver := ADriver;
  Mode := AMode;
  FreeDriverMem(DriverPtr, DriverSize);
  if LoadAtInit then
  begin
    if Driver = 0 then DetectGraph(Driver, Mode);
    if (Driver > 0) then GraphAppInit := GraphAppLoadDriver(Driver)
    else GraphAppInit := False;
  end;
end;

procedure GraphAppDone;
begin
  if GraphActive then CloseGraph;
  FreeDriverMem(DriverPtr, DriverSize);
  GraphActive := False;
  BGIPath := @EmptyString;
  Driver := Detect;
  Mode := 0;
end;


function GraphicsStart: Boolean;
begin

  GraphicsStart := True;
  if GraphActive then Exit;
  DoneSysError;
  DoneEvents;
  DoneVideo;
  DoneMemory;
  InitGraph(Driver, Mode, BGIPath^);
  InitEvents;

  if Driver < 0 then
  begin
    GraphicsStart := False;
    GraphicsStop;
  end
  else
    GraphActive := True;
end;

function GraphicsActive: Boolean;
begin
  GraphicsActive := GraphActive;
end;

procedure GraphicsStop;
begin
  DoneEvents;
  if GraphActive then CloseGraph;
  GraphActive := False;
  InitMemory;
  InitVideo;
  InitEvents;
  InitSysError;
  Application^.Redraw;
end;

end.
