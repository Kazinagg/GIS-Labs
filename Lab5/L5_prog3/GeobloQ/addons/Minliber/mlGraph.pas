{$N+}
unit mlGraph;

interface

uses
  System.SysUtils,
  System.Types,
  mlGlobals,
  System.Math;

var
  GraphDriver: integer;
  GraphMode: integer;
  MaxX, MaxY: word;
  ErrorCode: integer;
  MaxColor: word;
  OldExitProc: Pointer; { Saves exit procedure address }

const
  Fonts: array [0 .. 4] of string[13] = ('DefaultFont', 'TriplexFont',
    'SmallFont', 'SansSerifFont', 'GothicFont');

  LineStyles: array [0 .. 4] of string[9] = ('SolidLn', 'DottedLn', 'CenterLn',
    'DashedLn', 'UserBitLn');

  FillStyles: array [0 .. 11] of string[14] = ('EmptyFill', 'SolidFill',
    'LineFill', 'LtSlashFill', 'SlashFill', 'BkSlashFill', 'LtBkSlashFill',
    'HatchFill', 'XHatchFill', 'InterleaveFill', 'WideDotFill', 'CloseDotFill');

  TextDirect: array [0 .. 1] of string[8] = ('HorizDir', 'VertDir');
  HorizJust: array [0 .. 2] of string[10] = ('LeftText', 'CenterText',
    'RightText');
  VertJust: array [0 .. 2] of string[10] = ('BottomText', 'CenterText',
    'TopText');

function Int2Str(L: LongInt): string;
function RealStr(R: Real): string;
procedure SetDefaultColors;
procedure MainWindow;
procedure StatLine(Msg: string);
procedure MlTitle(Name: string; Line1, Line2, Line3: string);
procedure Menu(Item: string);
procedure MoveText(x, y: integer; Text: String);
procedure WriteOut(S: string);
function ReadOreFile: Boolean;
procedure WriteOreFile;
function ReadMillFile: Boolean;
procedure WriteMillFile;
function ReadExtractFile: Boolean;
procedure WriteExtractFile;

procedure MakeTriangle(x, y, R: integer);
procedure World2Screen(x1, y1, x2, y2: integer;
  var MinXdata, MinYData, MaxXdata, MaxYData: Real; var aPoints: PArrayOfPoints;
  var NRecs: LongInt);
procedure AxisAndGrid(x1, y1, x2, y2: integer; MinXdata, MinYData, MaxXdata,
  MaxYData: Real; Mx, My: Real);
procedure Hist3D(var AFrac: TFrac; Title: string);

// =================================================================
implementation
// =================================================================

{$F+}

procedure MyExitProc;
begin
  ExitProc := OldExitProc; { Restore exit procedure address }
  // CloseGraph;
end; { MyExitProc }
{$F-}
(*
  procedure Abort(Msg : string);
  begin
  Writeln(Msg, ': ', GraphErrorMsg(GraphResult));
  Halt(1);
  end;
*)


function Int2Str(L: LongInt): string;
var
  S: string;
begin
  Str(L, S);
  Int2Str := S;
end; { Int2Str }

function RealStr(R: Real): string;
var
  S: string;
begin
  Str(R: 8: 2, S);
  RealStr := S;
end; { RealStr }

function RandColor: word;
begin
  RandColor := Random(MaxColor) + 1;
end; { RandColor }


procedure WriteOreFile;

var
  Dir: TFileName;
  Name: TFileName;
  Ext: TFileName;
  AFile: String;
  F: Text;
  Doub: Double;
  i: integer;

begin
//  AFile := FExpand(fMinerals);
  Assign(F, AFile);
{$I-}
  Rewrite(F);
  for i := 1 to MineralCount do
  begin
    Writeln(F, Mineral[i], ',', MChord[i]:1:0, ',', MColor[i]);
  end;
{$I+}
  Close(F);
end;

function ReadOreFile: Boolean;
var
  OreFile, S, sLm, sColor: String;
  F: System.Text;
  Exist: Boolean;
  Dir: TFileName;
  Name: TFileName;
  Ext: TFileName;
//  DirInfo: SearchRec;
  i, Code: integer;

begin
  ReadOreFile := False;
//  OreFile := FExpand(fMinerals);
//  FindFirst(OreFile, AnyFile, DirInfo);
  Exist := True;
  if Exist then
  begin
    Assign(F, OreFile);
{$I-}
    Reset(F);
    i := 0;
    while not Eof(F) do
    begin
      Readln(F, S);
      Inc(i);
      if (i > MaxMineral) then
      begin
        WriteOut('Error: N of minerals > ' + Int2Str(MaxMineral));
        repeat
        until KeyPressed;
        Break;
      end;
      Mineral[i] := Copy(S, 1, pos(',', S) - 1);
      Delete(S, 1, pos(',', S));
      sLm := Copy(S, 1, pos(',', S) - 1);
      Val(sLm, MChord[i], Code);
      if (Code <> 0) or (MChord[i] > 1000) or (MChord[i] < 1) then
      begin
        WriteOut('Error: mean chord of ' + Mineral[i] + ' = ' + sLm +
          ' not valid');
        Repeat
        until KeyPressed;
        Break;
      end;
      Delete(S, 1, pos(',', S));
      sColor := S; { Copy(S,1,Pos(',',S)-1); }
      Val(sColor, MColor[i], Code);
      if (Code <> 0) or (MColor[i] > 14) or (MColor[i] = 0) then
      begin
        WriteOut('Error: color of ' + Mineral[i] + ' (' + sColor +
          ') not valid');
        Repeat
        until KeyPressed;
        Break;
      end;
    end;
    System.Close(F);
    MineralCount := i;
    if MineralCount < 2 then
      Exit;
    Rythm := 0;
    for i := 1 to MineralCount do
      Rythm := Rythm + MChord[i];
    ReadOreFile := True;
  end;
end;

procedure WriteMillFile;

var
  Dir: TFileName;
  Name: TFileName;
  Ext: TFileName;
  AFile: String;
  F: Text;
  Doub: Double;
  i: integer;

begin
//  AFile := FExpand(fSizedist);
  Assign(F, AFile);
  Rewrite(F);
  for i := 1 to MaxSClass do
  begin
    Writeln(F, SizeScale[i]:8:0, ',', SizeDist[i]:5:2);
  end;
  Close(F);
end;

function ReadMillFile: Boolean;
var
  MillFile, S, sAmount, sSize: String;
  F: System.Text;
  Exist: Boolean;
  Dir: TFileName;
  Name: TFileName;
  Ext: TFileName;
///  DirInfo: SearchRec;
  i, Code: integer;

begin
  ReadMillFile := False;
///  MillFile := FExpand(fSizedist);
///  FindFirst(MillFile, AnyFile, DirInfo);
  Exist := True;
  if Exist then
  begin
    Assign(F, MillFile);
{$I-}
    Reset(F);
    i := 0;
    while not Eof(F) do
    begin
      Readln(F, S);
      Inc(i);
      if (i > MaxSClass) then
      begin
        WriteOut('Error: N of size classes > ' + Int2Str(MaxSClass));
        Repeat
        until KeyPressed;
        Break;
      end;
      sSize := Copy(S, 1, pos(',', S) - 1);
      Val(sSize, SizeScale[i], Code);
      if (Code <> 0) or (SizeScale[i] < 1) or (SizeScale[i] > 65536) then
      begin
        WriteOut('Error: size scale ' + sSize + ' not valid!');
        Repeat
        until KeyPressed;
        Break;
      end;
      Delete(S, 1, pos(',', S));
      sAmount := S;
      Val(sAmount, SizeDist[i], Code);
      if (Code <> 0) or (SizeDist[i] > 100) or (SizeDist[i] < 0) then
      begin
        WriteOut('Error: in sizedist ' + sAmount + ' % not valid!');
        Repeat
        until KeyPressed;
        Break;
      end;
    end;
{$I+}
    System.Close(F);
    ReadMillFile := True;
  end;
end;

procedure WriteExtractFile;

var
  Dir: TFileName;
  Name: TFileName;
  Ext: TFileName;
  AFile: String;
  F: Text;
  Doub: Double;
  i: integer;

begin
///  AFile := FExpand(fExtracts);
  Assign(F, AFile);
  Rewrite(F);
  for i := 1 to MaxGClass do
  begin
    Writeln(F, GradeScale[i]:4:0, ',', RecovDist[i]:3:2);
  end;
  Close(F);
end;

function ReadExtractFile: Boolean;
var
  ExtractFile, S, sRecov, sGrade: String;
  F: System.Text;
  Exist: Boolean;
  Dir: TFileName;
  Name: TFileName;
  Ext: TFileName;
  DirInfo: SearchRec;
  i, Code: integer;

begin
  ReadExtractFile := False;
///  ExtractFile := FExpand(fExtracts);
///  FindFirst(ExtractFile, AnyFile, DirInfo);
  Exist := True;
  if Exist then
  begin
    Assign(F, ExtractFile);
{$I-}
    Reset(F);
    i := 0;
    while not Eof(F) do
    begin
      Readln(F, S);
      Inc(i);
      if (i > MaxGClass) then
      begin
        WriteOut('Error: N of grade classes > ' + Int2Str(MaxGClass));
        Repeat
        until KeyPressed;
        Break;
      end;
      sGrade := Copy(S, 1, pos(',', S) - 1);
      Val(sGrade, GradeScale[i], Code);
      if (Code <> 0) or (GradeScale[i] < 0) or (GradeScale[i] > 100) then
      begin
        WriteOut('Error: grade scale ' + sGrade + ' not valid!');
        Repeat
        until KeyPressed;
        Break;
      end;
      Delete(S, 1, pos(',', S));
      sRecov := S;
      Val(sRecov, RecovDist[i], Code);
      if (Code <> 0) or (RecovDist[i] > 100) or (RecovDist[i] < 0) then
      begin
        WriteOut('Error: recovery ' + sRecov + ' not valid!');
        Repeat
        until KeyPressed;
        Break;
      end;
    end;
    System.Close(F);
    ReadExtractFile := True;
  end;
end;

procedure MakeTriangle(x, y, R: integer);
var
  Triangle: array [1 .. 3] of TPoint;
begin
  Triangle[1].x := x - round(cos(rad(30)) * R / sin(rad(30)));
  Triangle[1].y := y + R;
  Triangle[2].x := x;
  Triangle[2].y := y - round(2 * R);
  Triangle[3].x := x + round(cos(rad(30)) * R / sin(rad(30)));
  Triangle[3].y := y + R;
  FillPoly(SizeOf(Triangle) div SizeOf(PointType), Triangle);
end;

procedure ShowPie;
{ ---------------------------------- PIE -------------------------------- }
var
  CenterX: integer;
  CenterY: integer;
  Xasp, Yasp: word;
  Radius: word;
  x, y, H, w: integer;
  S: String;
  Visible: Boolean;

  function AdjAsp(Value: integer): integer;
  { Adjust a value for the aspect ratio of the device }
  begin
    AdjAsp := (LongInt(Value) * Xasp) div Yasp;
  end; { AdjAsp }

  procedure GetTextCoords(AngleInDegrees, Radius: word; var x, y: integer);
  var
    Radians: Real;
  begin
    Radians := AngleInDegrees * Pi / 180;
    x := round(cos(Radians) * Radius);
    y := round(sin(Radians) * Radius);
  end; { GetTextCoords }

begin
  GetAspectRatio(Xasp, Yasp);
  SetColor(LightCyan);
  SetBkColor(Black);
  SetTextJustify(CenterText, TopText);
  SetTextStyle(TriplexFont, HorizDir, 2);
  OutTextXY(GetMaxX div 2, 5, 'PIE DIAGRAM');
  SetColor(Black);
  SetTextStyle(DefaultFont, HorizDir, 1);

  GetViewSettings(ViewPort);
  with ViewPort do
  begin
    CenterX := (x2 - x1) div 2;
    CenterY := (y2 - y1) div 2;
    Radius := (y2 - y1) div 3;
    while AdjAsp(Radius) < round((y2 - y1) / 4) do
      Inc(Radius);

    S := 'Magnetite  35.0 %';
    SetFillStyle(SolidFill, LightRed);
    SetColor(LightRed);
    SetTextJustify(CenterText, CenterText);
    PieSlice(CenterX, CenterY, 0, round(0.35 * 360), Radius);
    GetTextCoords(round(0.35 * 180), Radius, x, y);

    if 0.35 <= 0.5 then
    begin
      SetTextJustify(LeftText, CenterText);
      OutTextXY(CenterX + x + 10, CenterY - AdjAsp(10 + y), S)
    end
    else
    begin
      SetTextJustify(Righttext, CenterText);
      OutTextXY(CenterX + x - 10, CenterY - AdjAsp(10 + y), S)
    end;

    S := 'Locked 45 %';

    SetFillStyle(9, LightMagenta);
    SetColor(LightMagenta);
    PieSlice(CenterX, CenterY, round(0.35 * 360),
      round((1 - 0.1) * 360), Radius);
    GetTextCoords(round(0.35 * 360) + round(0.45 * 180), Radius, x, y);
    if x > 0 then
    begin
      SetTextJustify(LeftText, BottomText);
      if y > 0 then
        OutTextXY(CenterX + x + 10, CenterY - AdjAsp(10 + y), S)
      else
        OutTextXY(CenterX + x + 10, CenterY - AdjAsp(y - 10), S)
    end;
    if x <= 0 then
    begin
      SetTextJustify(Righttext, BottomText);
      if y > 0 then
        OutTextXY(CenterX + x - 10, CenterY - AdjAsp(10 + y), S)
      else
        OutTextXY(CenterX + x - 10, CenterY + AdjAsp(y - 10), S)
    end;

    S := 'Rock 10 %';
    SetFillStyle(SolidFill, LightGreen);
    SetColor(LightGreen);
    PieSlice(CenterX { +10 } , CenterY { -AdjAsp(10) } , round((1 - 0.1) * 359),
      360, Radius);
    GetTextCoords(round(0.1 * 180), Radius, x, y);
    if 0.1 <= 0.5 then
    begin
      SetTextJustify(LeftText, TopText);
      OutTextXY(CenterX + x + 10, CenterY + AdjAsp(10 + y), S);
    end
    else
    begin
      SetTextJustify(Righttext, TopText);
      OutTextXY(CenterX + x - 10, CenterY + AdjAsp(10 + y), S);
    end;
    SetColor(LightCyan);
    SetTextJustify(CenterText, CenterText);
    OutTextXY(GetMaxX div 2, GetMaxY - 10, '< Press Any Key...>');
  end;
  SetColor(White);
end; { ShowPie }

procedure World2Screen(x1, y1, x2, y2: integer;
  var MinXdata, MinYData, MaxXdata, MaxYData: Real; var aPoints: PArrayOfPoints;
  var NRecs: LongInt);
var
  i, T: integer;
  Dx, Dy: Real;

begin
  MinXdata := aPoints^[1].x;
  MaxXdata := aPoints^[1].x;
  MinYData := aPoints^[1].y;
  MaxYData := aPoints^[1].y;
  for i := 2 to NRecs do
    with aPoints^[i] do
    begin
      if (x < MinXdata) then
        MinXdata := x;
      if (x > MaxXdata) then
        MaxXdata := x;
      if (y < MinYData) then
        MinYData := y;
      if (y > MaxYData) then
        MaxYData := y;
    end;
  if MaxXdata = MinXdata then
    Dx := 10
  else
    Dx := (y2 - y1) / (MaxXdata - MinXdata);
  if MaxYData = MinYData then
    Dy := 10
  else
    Dy := (x2 - x1) / (MaxYData - MinYData);
  for i := 1 to NRecs do
    with aPoints^[i] do
    begin
      T := x;
      x := round(((MaxYData - MinYData) - (y - MinYData)) * Dy);
      y := round(((MaxXdata - MinXdata) - (T - MinXdata)) * Dx);
    end;
end;

procedure AxisAndGrid(x1, y1, x2, y2: integer; MinXdata, MinYData, MaxXdata,
  MaxYData: Real; Mx, My: Real);
const
  size: word = 4;

var
  i, j, k, H: word;
  S: String;
  XcorStep, YcorStep: Real;
  XscrStep, YscrStep: Real;
  Xasp, Yasp: word;
  ViewPort: ViewPortType;

begin
  begin
    SetColor(Black);
    SetTextStyle(SmallFont, HorizDir, size);
    SetTextJustify(Righttext, CenterText);
    H := TextHeight('V');

    XcorStep := (MaxXdata - MinXdata) / NXClass;
    YcorStep := (MaxYData - MinYData) / NYClass;
    XscrStep := (x2 - x1) / NXClass;
    YscrStep := (y2 - y1) / NYClass;
    i := 0;
    repeat
      k := 1;
      Line(-H, i * round(YscrStep), x2 - x1, i * round(YscrStep));
      OutTextXY(-H - 5, i * round(YscrStep),
        Int2Str(round(MaxXcor - My * i * XcorStep)));
      if i < NXClass then
        repeat
          Line(-H div 2, i * round(YscrStep) + k * (round(YscrStep) div 5), 0,
            i * round(YscrStep) + k * (round(YscrStep) div 5));
          Inc(k);
        until k > 4;
      Inc(i);
    until i > NXClass;

    SetTextStyle(SmallFont, VertDir, size);
    SetTextJustify(CenterText, TopText);
    i := 0;
    repeat
      k := 1;
      Line(round(i * XscrStep), 0, round(i * XscrStep), y2 - y1 + H + 5);
      OutTextXY(round(i * XscrStep) - 2, y2 - y1 + H + 5,
        Int2Str(round(Mx * i * YcorStep + MinYcor)));
      if i < NYClass then
        repeat
          Line(round(i * XscrStep) + k * (round(XscrStep) div 5),
            y2 - y1 + H div 2, round(i * XscrStep) + k *
            (round(XscrStep) div 5), y2 - y1 + H);
          Inc(k);
        until k > 4;
      Inc(i);
    until i > NYClass;

    Line(0, 0, 0, -2 * H);
    Line(-5, -H, 0, -2 * H);
    Line(+5, -H, 0, -2 * H);
    SetTextStyle(SmallFont, HorizDir, size);
    SetTextJustify(CenterText, BottomText);
    OutTextXY(-H, -H, 'X');

    Line(x2 - x1, y2 - y1, x2 - x1 + 3 * H, y2 - y1);
    Line(x2 - x1 + 2 * H, y2 - y1 + 5, x2 - x1 + 3 * H, y2 - y1);
    Line(x2 - x1 + 2 * H, y2 - y1 - 5, x2 - x1 + 3 * H, y2 - y1);
    SetTextJustify(LeftText, CenterText);
    OutTextXY(x2 - x1 + 2 * H, y2 - y1 + H, 'Y');

    SetTextStyle(DefaultFont, HorizDir, 1);
    SetTextJustify(CenterText, CenterText);
  end; { ViewPort }
end; { AxisAndGrid }

{ ---------------------------- Histos ---------------------------------- }
{ -  OutPut of Histograms and Graphics                                 - }
{ ---------------------------------------------------------------------- }
procedure DrawAxes(NumXClass: word; NumYClass: word; Title: string;
  Xlabel: string; Ylabel: string);
var
  XStep: Real;
  YStep: Real;
  i, j: integer;
  ViewPort: ViewPortType;
  H: word;

begin
  GetViewSettings(ViewPort);
  with ViewPort do
  begin
    SetTextJustify(CenterText, TopText);
    SetTextStyle(DefaultFont, HorizDir, 2);
    SetColor(Black); { цвет букв }
    OutTextXY((x2 - x1) div 2, 5, Title);
    SetTextStyle(DefaultFont, HorizDir, 1);

    H := TextHeight('M');
    SetViewPort(6 * H, 6 * H, MaxX - 128, MaxY - (6 * H), ClipOff);
    GetViewSettings(ViewPort);
    with ViewPort do
    begin
      Line(0, 0, 0, y2 - y1); { Y axis }
      SetTextJustify(CenterText, CenterText);
      SetTextStyle(DefaultFont, VertDir, 1);
      OutTextXY(-4 * H, (y2 - y1) div 2, Ylabel);
      SetTextStyle(DefaultFont, HorizDir, 1);
      SetTextJustify(CenterText, BottomText);
      j := y2 - y1;
      for i := 0 to NumYClass do
      begin
        Line(-H div 2, j, 0, j);
        OutTextXY(-H, j, Int2Str(i * 20));
        j := round(j - (y2 - y1) / NumYClass);
      end;

      Line(0, y2 - y1, x2 - x1, y2 - y1); { X axis }
      SetTextJustify(LeftText, BottomText);
      OutTextXY((x2 - x1) + H, y2 - y1 + 2 * H, Xlabel);
      XStep := (x2 - x1) / NumXClass;
      SetTextJustify(CenterText, BottomText);
      j := 0;
      for i := 1 to NumXClass do
      begin
        Line(j, y2 - y1, j, (y2 - y1) + (H div 2));
        OutTextXY(round(j + XStep / 2), y2 - y1 + 2 * H, Int2Str(i));
        j := round(j + XStep);
      end;
      Line(j, y2 - y1, j, (y2 - y1) + (H div 2));
    end; { with }
  end; { with }
end; { DrawAxis }

procedure ShowSHisto(MaxSClass: word; var OneVec: TSize; Color: word);
const
  YTicks: word = 5;
var
  H, L: word;
  XStep: Real;
  YStep: Real;
  i, j: integer;
  sum: Real;
  cumvec: TSize;
begin
  SetDefaultColors;
  Bar(0, 0, MaxX, MaxY);
  DrawAxes(MaxSClass, YTicks, 'Size Histogram', 'Size Classes',
    'Parameters, %');
  with ViewPort do
  begin
    FillChar(cumvec, SizeOf(cumvec), 0);
    sum := 0;
    for i := 1 to MaxSClass do
      sum := sum + OneVec[i];
    for i := 1 to MaxSClass do
      OneVec[i] := round(OneVec[i] * (y2 - y1) / sum);
    L := 0;
    for i := 1 to MaxSClass do
    begin
      cumvec[i] := OneVec[i] + L;
      L := round(cumvec[i]);
    end;

    H := TextHeight('H');
    SetTextJustify(LeftText, BottomText);
    OutTextXY((x2 - x1) + H, y2 - y1 + 4 * H, 'Diameters, mu');
    XStep := (x2 - x1) / MaxSClass;
    i := 0;
    j := 0;
    L := 0;
    while i < MaxSClass do
    begin
      Inc(i);
      SetFillStyle(1, Color);
      Bar3D(j + 6, (y2 - y1) - round(OneVec[i]), round(j + XStep - 6),
        (y2 - y1) - 1, 5, TopOn);
      { PutPixel(J, round((y2-y1)-(OneVec[I])),White); }
      Line(j, (y2 - y1) - L, round(j + XStep), (y2 - y1) - round(cumvec[i]));
      L := round(cumvec[i]);
      j := round(j + XStep);
    end;
  end;
end; { ShowSHisto }

procedure ShowGHisto(MaxGClass: word; var OneVec: TGrade; Color: word);
const
  YTicks: word = 5;
var
  i, j, H, L: word;
  midgrade, XStep, YStep: Real;
  sum: Real;
  cumvec: TGrade;
  S: string;

begin
  SetDefaultColors;
  Bar(0, 0, MaxX, MaxY);
  DrawAxes(MaxGClass, YTicks, 'Grade Histogram', 'Grade Classes', 'Values, %');
  with ViewPort do
  begin
    H := TextHeight('H');
    XStep := (x2 - x1) / MaxGClass;
    SetTextJustify(LeftText, BottomText);
    OutTextXY((x2 - x1) + H, y2 - y1 + 4 * H, 'Target Contents, %');
    SetTextJustify(CenterText, BottomText);
    OutTextXY(round(XStep / 2), y2 - y1 + 4 * H, '0');
    for i := 2 to MaxGClass - 1 do
    begin
      midgrade := 100 * (i * 0.1 - 0.15);
      Str(midgrade: 6: 0, S);
      OutTextXY(round((i - 1) * XStep), y2 - y1 + 4 * H, S);
    end;
    OutTextXY(round(MaxGClass * XStep - XStep / 2), y2 - y1 + 4 * H, '100');
    {
      OutTextXY((x2-x1)+H, y2-y1+4*H, 'Density');
      OutTextXY((x2-x1)+H, y2-y1+4*H, 'Magnetic');
    }
    sum := 0;
    FillChar(cumvec, SizeOf(cumvec), 0);
    for i := 1 to MaxGClass do
      sum := sum + OneVec[i];
    for i := 1 to MaxGClass do
      OneVec[i] := round(OneVec[i] * (y2 - y1) / sum);
    L := 0;
    for i := 1 to MaxGClass do
    begin
      cumvec[i] := OneVec[i] + L;
      L := round(cumvec[i]);
    end;
    j := 0;
    i := 0;
    L := 0;
    while i < MaxGClass do
    begin
      Inc(i);
      SetFillStyle(1, Color);
      Bar3D(j + 6, (y2 - y1) - round(OneVec[i]), round(j + XStep) - 6,
        (y2 - y1) - 1, 5, TopOn);
      { Bar(J+6,(y2-y1)-OneVec[I], round(J+Xstep)-6, (y2-y1)-1); }
      { PutPixel(J, (y2-y1)-OneVec[I],White); }
      Line(j, (y2 - y1) - L, round(j + XStep), (y2 - y1) - round(cumvec[i]));
      j := round(j + XStep);
      L := round(cumvec[i]);
    end;
  end;
end; { ShowGHisto }

{ ================ 3D Graph box =============== }
procedure Hist3D(var AFrac: TFrac; Title: string);
const
  MaxPts = 4;
  Ch: Char = #75;
type
  PolygonType = array [1 .. MaxPts] of PointType;

var
  ViewPort: ViewPortType;
  Poly: PolygonType;
  Frac: TFrac;
  Width, Height, Depth: word;
  Color: word;
  BoxWidth: integer;
  BoxHeight: integer;
  BoxDepth: integer;
  SumGfrac: TGrade;
  SumSfrac: TSize;
  SumXClass: LongInt;
  XStep: integer;
  Zstep: integer;
  YStep: integer;
  XYstep: integer;
  Xrest, Yrest: integer;
  S: string;
  x1, x2, y1, y2: integer;

  { ************************************************ }
  procedure ScrVals;
  var
    i, j: integer;
    Count: LongInt;
  begin
    with ViewPort do
    begin
      { fractions }
      for i := 1 to MaxSClass do
      begin
        for j := 1 to MaxGClass do
        begin
          Frac[i, j] := AFrac[i, j] * ((y2 - y1) div 2) / ScanLine;
        end;
      end;
      { sum sizes }
      for i := 1 to MaxSClass do
      begin
        Count := 0;
        for j := 1 to MaxGClass do
        begin
          Count := Count + round(Frac[i, j]);
        end;
        SumSfrac[i] := Count;
      end;

      { sum grades }
      for j := 1 to MaxGClass do
      begin
        Count := 0;
        for i := 1 to MaxSClass do
          Count := Count + round(Frac[i, j]);
        SumGfrac[j] := Count div MaxGClass;
      end;
    end;
  end; { ScrVals }

{ sub } procedure DrawXYZ;
  begin
    with ViewPort do
    begin
      SetColor(Black);
      if (upcase(Ch) = #77) then
      begin
        Line(x2 - x1, y2 - y1, x2 - x1, (y2 - y1) div 2);
        Line((x2 - x1) div 2, (y2 - y1) div 2, (x2 - x1) div 2, 0);
        Line(0, (y2 - y1) div 2, 0, 0);
      end
      else
      begin
        Line(0, y2 - y1, 0, (y2 - y1) div 2);
        Line((x2 - x1) div 2, (y2 - y1) div 2, (x2 - x1) div 2, 0);
        Line(x2 - x1, (y2 - y1) div 2, x2 - x1, 0);
      end;
    end;
  end; { DrawXYZ }

{ sub } procedure StepsAndText;
  var
    i, k: word;
  begin
    with ViewPort do
    begin
      BoxWidth := (x2 - x1) div 2;
      BoxHeight := (y2 - y1) div 2;
      BoxDepth := BoxHeight;
      XStep := round(BoxWidth / MaxGClass);
      YStep := round(BoxDepth / MaxSClass);
      Zstep := round(BoxHeight / MaxZClass);
      XYstep := round(BoxWidth / MaxSClass);
      Xrest := BoxWidth - XStep * MaxGClass;
      Yrest := BoxDepth - YStep * MaxSClass;
      Width := round(0.8 * XStep); { calc barwidth }

      if (MaxSClass > 18) or (MaxGClass > 12) then { change font }
        SetTextStyle(SmallFont, HorizDir, 2)
      else
        SetTextStyle(DefaultFont, HorizDir, 1);
      SetColor(Black);
      if (upcase(Ch) = #77) then { view from a }
      begin
        SetTextJustify(CenterText, BottomText);
        OutTextXY((x2 - x1), BoxHeight - 2 * TextHeight('H'), ' Volume,%');
        OutTextXY((x2 - x1) - (x2 - x1) div 4, (y2 - y1) + 30, 'Grade Class');
        SetTextJustify(LeftText, BottomText);
        OutTextXY(0, (y2 - y1) div 2 + (y2 - y1) div 4, 'Size');
        OutTextXY(0, (y2 - y1) div 2 + (y2 - y1) div 4 +
          TextHeight('S'), 'Class');
        SetTextJustify(Righttext, BottomText);
        SetColor(Black);
        SetFillStyle(1, White);
        Bar(x2 - x1 - 20, 0, x2 - x1, TextHeight('M'));
        OutTextXY(x2 - x1 - 20, TextHeight('M'), 'Free Gangue ');

        SetColor(Black);
        SetFillStyle(1, MColor[NTarget]);
        if MColor[NTarget] = 7 then
          SetFillStyle(9, MColor[NTarget]);
        Bar(x2 - x1 - 20, 2 * TextHeight('M'), x2 - x1, 3 * TextHeight('M'));
        OutTextXY(x2 - x1 - 20, 3 * TextHeight('M'),
          'Free ' + Mineral[NTarget] + ' ');

        SetColor(White);
        Rectangle(x2 - x1 - 20, 4 * TextHeight('M'), x2 - x1,
          5 * TextHeight('M'));
        SetFillStyle(1, MColor[NTarget]);
        Bar(x2 - x1 - 19, 4 * TextHeight('M') + 1, x2 - x1 - 1,
          5 * TextHeight('M') - 1);
        SetColor(Black);
        OutTextXY(x2 - x1 - 20, 5 * TextHeight('M'), 'Composition ');
      end
      else
      begin
        SetTextJustify(CenterText, BottomText);
        OutTextXY(0, BoxHeight - 2 * TextHeight('H'), 'Volume,%');
        OutTextXY((x2 - x1) div 2 - (x2 - x1) div 4, (y2 - y1) + 30,
          'Grade Class');
        SetTextJustify(Righttext, BottomText);
        OutTextXY(x2 - x1, (y2 - y1) div 2 + (y2 - y1) div 4, 'Size');
        OutTextXY(x2 - x1, (y2 - y1) div 2 + (y2 - y1) div 4 +
          TextHeight('S'), 'Class');
        SetFillStyle(1, White);
        Bar(0, 1, 20, TextHeight('M'));
        SetTextJustify(LeftText, BottomText);
        SetColor(Black);
        OutTextXY(20 + TextWidth('M'), TextHeight('M'), 'Free Gangue ');

        SetFillStyle(1, MColor[NTarget]);
        if MColor[NTarget] = 7 then
          SetFillStyle(9, MColor[NTarget]);
        Bar(0, 2 * TextHeight('M'), 20, 3 * TextHeight('M'));
        SetColor(Black);
        OutTextXY(20 + TextWidth('M'), 3 * TextHeight('M'),
          'Free ' + Mineral[NTarget]);

        SetColor(White);
        Rectangle(0, 4 * TextHeight('M'), 20, 5 * TextHeight('M'));
        SetFillStyle(1, MColor[NTarget]);
        Bar(1, 4 * TextHeight('M') + 1, 19, 5 * TextHeight('M') - 1);
        SetColor(Black);
        OutTextXY(20 + TextWidth('M'), 5 * TextHeight('M'), 'Composition ');
      end;
    end;
  end; { StepsAndText }

{ sub } procedure LeftAndBackWall;
  var
    i, k: integer;
    Add: integer;
  begin
    with ViewPort do
    begin
      Add := round(Yrest / MaxZClass);
      k := y2 - y1;
      for i := 0 to MaxZClass do
      begin
        SetColor(Black);
        if upcase(Ch) = #77 then
        begin
          Line(x2 - x1 + TextWidth('My'), k, x2 - x1, k); { Ticks on Z }
          Line((x2 - x1), k, (x2 - x1) div 2, k - (y2 - y1) div 2); { Right }
          Line(-TextWidth('My'), k - (y2 - y1) div 2, (x2 - x1) div 2,
            k - (y2 - y1) div 2); { Back }
          SetTextJustify(LeftText, BottomText);
          OutTextXY(x2 - x1, k, Int2Str(i * 20)); { Scale Z }
          SetTextJustify(Righttext, BottomText);
          OutTextXY(-1, k - (y2 - y1) div 2, Int2Str(i * 20));
          k := k - Zstep - Add;
        end
        else
        begin
          Line(-TextWidth('My'), k, 0, k); { Ticks on Z }
          Line(0, k, (x2 - x1) div 2, k - (y2 - y1) div 2); { Left }
          Line((x2 - x1) div 2, k - (y2 - y1) div 2,
            (x2 - x1) + TextWidth('My'), k - (y2 - y1) div 2); { Back }
          SetTextJustify(Righttext, BottomText);
          OutTextXY(0, k, Int2Str(i * 20)); { Scale Z }
          SetTextJustify(LeftText, BottomText);
          OutTextXY(x2 - x1 + 1, k - (y2 - y1) div 2, Int2Str(i * 20));
          k := k - Zstep - Add;
        end;
      end;
    end;
  end; { LeftAndBackWall }

{ sub } procedure LinesXY;
  var
    i, j, k, L: integer;

  begin
    with ViewPort do
    begin
      SetTextJustify(CenterText, TopText);
      SetColor(Black);
      { ----------- Ось X ------------ }
      if upcase(Ch) = #77 then
      begin
        k := (x2 - x1);
        for j := MaxGClass downto 1 do
        begin
          Line(k, (y2 - y1), k, (y2 - y1) + TextHeight('M') div 2);
          { ticks for X }
          OutTextXY(k - XStep div 2, (y2 - y1) + TextHeight('M') div 2,
            Int2Str(j)); { Grade Scale }
          k := k - XStep;
        end
      end
      else
      begin
        k := 0;
        for j := 1 to MaxGClass do
        begin
          Line(k, (y2 - y1), k, (y2 - y1) + TextHeight('M') div 2); { ticks X }
          OutTextXY(k + XStep div 2, (y2 - y1) + TextHeight('M') div 2,
            Int2Str(j)); { Grade Scale }
          k := k + XStep;
        end
      end;
      { -------- Lines parallel to X------ }
      SetTextJustify(CenterText, CenterText);
      SetColor(Black);
      if (upcase(Ch) = #77) then
        L := (x2 - x1)
      else
        L := 0;
      k := y2 - y1;
      for i := MaxSClass downto 1 do
      begin
        if upcase(Ch) = #77 then
        begin
          Line(L, k, L - BoxWidth, k);
          OutTextXY(L - BoxWidth - 2 * TextHeight('M'), k, Int2Str(i));
          L := L - XYstep - Xrest div MaxGClass;
        end
        else
        begin
          Line(L, k, L + BoxWidth, k);
          OutTextXY(L + BoxWidth + 2 * TextHeight('M'), k, Int2Str(i));
          L := L + XYstep + Xrest div MaxGClass;
        end;
        k := k - YStep - Yrest div MaxSClass;
      end;

      { Strips like Y ax }
      SetColor(Black);
      k := (x2 - x1) div 2;
      for i := 1 to MaxGClass + 1 do
      begin
        if upcase(Ch) = #77 then
        begin
          Line(k + BoxWidth, (y2 - y1), k, (y2 - y1) div 2);
          k := k - XStep - Xrest div MaxGClass;
        end
        else
        begin
          Line(k - BoxWidth, (y2 - y1), k, (y2 - y1) div 2);
          k := k + XStep;
        end;
      end;
    end;
    SetColor(MaxColor);
  end; { LinesXY }

{ ----------- Draw Fracs ---------- }
  procedure XYfrac;
  const
    MaxPts = 4;
  type
    PolygonType = array [1 .. MaxPts] of PointType;
  var
    Poly: PolygonType;
    i, j, k, L, Dx, Dy: integer;

  begin
    with ViewPort do
    begin
      Dx := XYstep;
      Dy := YStep;
      for i := MaxSClass downto 1 do { from coarse to fine }
      begin
        if (upcase(Ch) = #77) then
          k := Dx
        else
          k := (x2 - x1) div 2 - Dx;
        L := (y2 - y1) div 2 + Dy;
        for j := 1 to MaxGClass do
        begin
          if (Frac[i, j] > 0) then
          begin
            { Color and FillColor Front and Top Faces }
            case j of
              1:
                begin
                  SetFillStyle(9, White); { gangue }
                  SetColor(White);
                end;
              MaxGClass:
                begin
                  SetFillStyle(9, MColor[NTarget]); { colortarg }
                  SetColor(MColor[NTarget]);
                end;
            else
              begin { locked }
                SetFillStyle(9, MColor[NTarget]);
                SetColor(White);
              end
            end; { case }

            if (upcase(Ch) = #77) then
            begin
              Bar(k + XStep, L - round(Frac[i, j]), k - Width + XStep, L);
              Poly[1].x := k + XStep;
              Poly[1].y := L - round(Frac[i, j]);
              Poly[2].x := k - Width div 2 + XStep;
              Poly[2].y := L - round(Frac[i, j]) - (Width div 2) *
                YStep div XYstep;
              Poly[3].x := Poly[2].x - Width;
              Poly[3].y := Poly[2].y;
              Poly[4].x := k - Width + XStep;
              Poly[4].y := L - round(Frac[i, j]);
            end
            else
            begin
              Bar(k, L - round(Frac[i, j]), k + Width, L);
              Poly[1].x := k;
              Poly[1].y := L - round(Frac[i, j]);
              Poly[2].x := k + Width div 2;
              Poly[2].y := L - round(Frac[i, j]) - (Width div 2) *
                YStep div XYstep;
              Poly[3].x := Poly[2].x + Width;
              Poly[3].y := Poly[2].y;
              Poly[4].x := k + Width;
              Poly[4].y := L - round(Frac[i, j]);
            end;
            FillPoly(MaxPts, Poly);

            { Color and Pattern of front face }
            case j of
              1:
                begin
                  SetFillStyle(1, White); { gangue }
                  SetColor(White);
                end;
              MaxGClass:
                begin
                  SetFillStyle(1, MColor[NTarget]); { colortarg }
                  SetColor(MColor[NTarget]);
                end;
            else
              begin { locked }
                SetFillStyle(1, MColor[NTarget]);
                SetColor(White);
              end
            end; { case }

            Poly[1].x := Poly[4].x;
            Poly[1].y := Poly[4].y;
            Poly[2].x := Poly[3].x;
            Poly[2].y := Poly[3].y;
            Poly[3].x := Poly[2].x;
            Poly[3].y := Poly[2].y + round(Frac[i, j]);
            if (upcase(Ch) = #77) then
              Poly[4].x := k - Width + XStep
            else
              Poly[4].x := k + Width;
            Poly[4].y := L;
            FillPoly(MaxPts, Poly);
            if upcase(Ch) = #77 then
              Rectangle(k + XStep, L - round(Frac[i, j]), k - Width + XStep, L)
            else
              Rectangle(k, L - round(Frac[i, j]), k + Width, L);
            k := k + XStep;
          end
          else
            k := k + XStep;
        end;
        Dx := Dx + XYstep;
        Dy := Dy + YStep;
      end;
    end;
  end; { XYfrac }

{ ------- Marginal distribution for XGrade --------- }
  procedure XSumfrac;
  var
    L, k, j: integer;
  begin
    with ViewPort do
    begin
      k := XStep + (x2 - x1) div 2;
      L := (y2 - y1) div 2;
      for j := 1 to MaxGClass do
      begin
        if j <> Succ(MaxGClass) then
        begin
          case j of
            1:
              begin
                SetFillStyle(9, White);
                SetColor(Black);
              end;
            MaxGClass:
              begin
                SetFillStyle(9, MColor[NTarget]);
                SetColor(MColor[NTarget]);
              end;
          else
            begin
              SetFillStyle(9, MColor[NTarget]);
              SetColor(White);
            end
          end; { case }

          Bar(k, L - round(SumGfrac[j]), k - Width, L);
          SetColor(MaxColor);
          Rectangle(k, L - round(SumGfrac[j]), k - Width, L);
          k := k + XStep;
        end;
      end;
    end;
  end; { XSumfrac }

{ ---------- Marginal distribution for Size ---------- }
  procedure YSumfrac;
  var
    i, k, L: integer;
    Poly: PolygonType;

  begin
    SetFillStyle(9, Cyan);
    SetColor(LightCyan);
    with ViewPort do
    begin
      k := (x2 - x1) div 2 - XYstep;
      L := (y2 - y1) div 2 + YStep + round(Yrest / MaxSClass);
      for i := MaxSClass downto 1 do { from coarse to fine }
      { for I := 1 to MaxSClass do }                { from fine to coarse }
      begin
        if SumSfrac[i] > 0 then
        begin
          Poly[1].x := k;
          Poly[1].y := L - round(SumSfrac[i]);
          Poly[2].x := k + XYstep div 2;
          Poly[2].y := L - round(SumSfrac[i]) - YStep div 2 -
            Yrest div MaxSClass;
          Poly[3].x := Poly[2].x;
          Poly[3].y := L - YStep div 2 - Yrest div MaxSClass;
          Poly[4].x := k;
          Poly[4].y := L;
          FillPoly(MaxPts, Poly);
          k := k - XYstep;
          L := L + YStep + round(Yrest / MaxSClass);
        end
        else
        begin
          k := k - XYstep;
          L := L + YStep + round(Yrest / MaxSClass);
        end;
      end;
    end;
    SetColor(MaxColor);
  end; { YSumfrac }

  procedure EmptyBView;
  begin
    MainViewPort;
    SetDefaultColors;
    Bar(0, 0, MaxX, MaxY);
    SetTextJustify(CenterText, CenterText);
    SetTextStyle(DefaultFont, HorizDir, 2);
    OutTextXY(MaxX div 2, TextHeight('H'), Title);
    SetTextStyle(DefaultFont, HorizDir, 1);
    { OutTextXY(MaxX div 2, 5*TextHeight('B'),'of '+Mineral[NTarget]); }
    if (MaxSClass > 18) or (MaxGClass > 12) then { change font }
      SetTextStyle(SmallFont, HorizDir, 2)
    else
      SetTextStyle(DefaultFont, HorizDir, 1);
    SetViewPort(MaxX div 2 - 256, MaxY div 2 - 128, MaxX div 2 + 256,
      MaxY div 2 + 128, ClipOff);
    GetViewSettings(ViewPort);
    with ViewPort do
    begin
      Bar(0, 0, MaxX, MaxY - 128);
      DrawXYZ;
      StepsAndText;
      LeftAndBackWall;
      LinesXY;
    end;
  end;

  procedure EmptyAView;
  begin
    MainViewPort;
    SetDefaultColors;
    Bar(0, 0, MaxX, MaxY);
    SetTextJustify(CenterText, CenterText);
    SetTextStyle(DefaultFont, HorizDir, 2);
    OutTextXY(MaxX div 2, TextHeight('B'), Title);
    SetTextStyle(DefaultFont, HorizDir, 1);
    { OutTextXY(MaxX div 2, 5*TextHeight('B'),'of '+Mineral[NTarget]); }
    if (MaxSClass > 18) or (MaxGClass > 12) then { change font }
      SetTextStyle(SmallFont, HorizDir, 2)
    else
      SetTextStyle(DefaultFont, HorizDir, 1);
    SetViewPort(MaxX div 2 - 256, MaxY div 2 - 128, MaxX div 2 + 256,
      MaxY div 2 + 128, ClipOff);
    GetViewSettings(ViewPort);
    with ViewPort do
    begin
      Bar(0, 0, MaxX, MaxY - 128);
      DrawXYZ;
      StepsAndText;
      LeftAndBackWall;
      LinesXY;
    end;
  end;

{ ------------------ Main body of Hist3D ------------ }
begin
  Menu('<-Left ->Right');
  StatLine(' Help ' + #179 + ' Esc - Return to Main Menu');
  EmptyBView;
  ScrVals;
  XYfrac;
  repeat
    repeat
      Ch := Readkey;
    until not KeyPressed;
    if Ch = #0 then
      Ch := Readkey; { trap function keys }
    case upcase(Ch) of
      #75:
        begin { left arroy view from b }
          EmptyBView;
          XYfrac;
        end;
      #77:
        begin { right arroy view from a }
          EmptyAView;
          XYfrac;
        end;
    end;
  until upcase(Ch) = #27;
end; { Hist3D }

end. { MlGraph }
