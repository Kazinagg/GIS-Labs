unit mlLiber;

uses
  MLGraph,
  System.Math,
  mlRanDist,
  mlGlobals,
  MlOne,
  MlTwo;

// ============================
procedure InitOre;
var
  I: Longint;
begin
  New(Ore);
  New(Lmat);
  New(Lfin);
  FillChar(Ore^, Sizeof(Ore^), 0);
  FillChar(Lmat^, Sizeof(Lmat^), 0);
  FillChar(Lfin^, Sizeof(Lfin^), 0);
  Rythm := 0;
  for I := 1 to MineralCount do
  begin
    { Dm[i]:= random(100); }    { if we don't have empirical distribution }
    DStdDev[I] := round(MChord[I] / 3);
    Rythm := Rythm + MChord[I];
  end;
  TargetSet := [NTarget];
  OreSet := [1 .. MineralCount];
  GangueSet := OreSet - TargetSet;
end; { InitParams }

procedure DoneOre;
begin
  Dispose(Ore);
  Dispose(Lmat);
  Dispose(Lfin);
end;


// ------------------------------------------------------
// Генератор зёрен руды
// ------------------------------------------------------
procedure GenerOre;
var
  N: Longint;
  Boundary: Real;
  PrevMineralPhase: Real;
begin
  Randomize; { initialize number of current grain }
  N := 0;
  Boundary := 0;
  PrevMineralPhase := 0; { initialize index of mineral phase }
  while (Boundary <= ScanLine) and (N < MaxChord) do
  begin
    Inc(N);
    with Ore^[N] do
    begin
      repeat
        MineralPhase := 1 + Random(MineralCount);
      until MineralPhase <> PrevMineralPhase;
      PrevMineralPhase := MineralPhase;
      { Random }
      { Chord:=random(MChord[Phase]); }
      { Exponential }
      { Chord:=RandExponent(MChord[Phase]); }
      { Normal }
      { Chord:=RandNorm(MChord[Phase],dstddev[phase]); }
      { Gauss }
      Chord := (RandGauss(MChord[MineralPhase], DStdDev[MineralPhase]));
      { LogNormal }
      { Chord:=RandLogNorm(MChord[Phase],DStdDev[Phase]);{ }
      Boundary := Boundary + Chord;
    end;
  end; { while }
  Ore^[N].Chord := Ore^[N].Chord - (Boundary - ScanLine) + 1;
  NumChords := N;
end; { GenerOre }

// =============== Расчёт матрицы раскрытия =================
procedure CalcLmat;
var
  I, j, k, m, N: Longint;
  Inlock: array [1 .. MaxMineral] of Single; // phases inside fragment
  Locked: Real;
  Crack, { current point of crack and }
  { right end of an active particle }
  Phaser: Real; { the current boundary of active grain }
  { for active mineral phase }

label
  composite;

begin
  FillChar(Lmat^, Sizeof(Lmat^), 0);
  FillChar(Inlock, Sizeof(Inlock), 0);
  for I := 1 to MaxSClass do
  begin
    Crack := SizeScale[I];
    N := 1;
    Phaser := Ore^[N].Chord;
    while (Crack <= ScanLine) do { walk along line }
    begin
      if (Ore^[N].MineralPhase = NTarget) then { free particle }
        Lmat^[I, MaxGClass] := Lmat^[I, MaxGClass] + Int(Phaser / Crack)
        { free target }
      else
        Lmat^[I, 1] := Lmat^[I, 1] + Int(Phaser / Crack); { free gangue }
      Crack := Crack + SizeScale[I] * Int(Phaser / Crack);
      Inlock[Ore^[N].MineralPhase] := SizeScale[I] - (Crack - Phaser);
      while (Crack > Phaser) do { composite }
      begin
        Inc(N); { next grain }
        if (N > NumChords) then; {
          goto Composite;        {ERROR! }
        with Ore^[N] do
        begin
          { writeln(n, ' ');{ }
          Phaser := Phaser + Chord;
          Inlock[MineralPhase] := Inlock[MineralPhase] + Chord;
        end;
      end;
      Locked := 0;
      with Ore^[N] do
      begin
        Inlock[MineralPhase] := Inlock[MineralPhase] - (Phaser - Crack + 1);
        for m := 1 to MineralCount do
          Locked := Locked + Inlock[m];
        if Locked > 0 then
        begin
          if Inlock[NTarget] > 0 then
          begin
            Grade := Inlock[NTarget] / SizeScale[I];
            j := trunc(Grade * 10) + 2;
            Lmat^[I, j] := Lmat^[I, j] + 1;
          end
          else
            Lmat^[I, 1] := Lmat^[I, 1] + 1;
        end
        else if (I = 1) then
        begin
          if (MineralPhase = NTarget) then
            Lmat^[1, MaxGClass] := Lmat^[1, MaxGClass] + 1
          else
            Lmat^[1, 1] := Lmat^[1, 1] + 1
        end;
      end;
      FillChar(Inlock, Sizeof(Inlock), #0);
      Crack := Crack + SizeScale[I];
    composite:
    end; { Measure Line }
  end; { for MaxSClass }

  if (Ore^[N].MineralPhase = NTarget) then
    Lmat^[1, MaxGClass] := Lmat^[1, MaxGClass] - 1
  else
    Lmat^[1, 1] := Lmat^[1, 1] - 1;

  { Loop to average out the real values !!! }
  { for I:=1 to Nloop do OneLMat;
    for I:=1 to MaxSClass do
    for J:=1 to MaxGClass do
    if LMat^[I,J]<>0 then LMat^[I,J]/Nloop;
  }
end; // CalcLmat

{ =========================================================== }
{ - Draw the table of fractions in the graphic mode         - }
{ ----------------------------------------------------------- }
procedure CommonTable;
var
  I, j, k, m, Row, Col: Longint;
  D: Real;
  S: string;
  ViewPort: ViewPortType;
  H, Hc, dx, dy, ytab: word;

begin
  MainViewPort;
  GetViewSettings(ViewPort);
  with ViewPort do
  begin
    SetDefaultColors;
    Bar(0, 0, MaxX, MaxY);
    dx := (x2 - x1) div (MaxGClass + 2); { borders of table }
    dy := TextHeight('M') + 2;
    SetTextStyle(DefaultFont, HorizDir, 2);
    H := TextHeight('M');
    ytab := 5 * H;
    SetTextJustify(LeftText, TopText);
    SetTextStyle(DefaultFont, HorizDir, 1);

    SetDefaultColors;
    Bar(6, TextHeight('H') + 2, dx + 49, 6 * TextHeight('M'));
    Rectangle(5, TextHeight('H') + 1, dx + 50, 6 * TextHeight('M') + 1);
    SetColor(White);
    OutTextXY(dx + 55, H + 10, 'GANGUE');
    SetDefaultColors;
    m := 0;
    Col := 0;
    while (m <= MineralCount) do
    begin
      Row := 0;
      Hc := TextHeight('H');
      while Row < 5 do
      begin
        Inc(m);
        Inc(Row);
        if m <= MineralCount then
        begin
          SetFillStyle(1, MColor[m]);
          if (m in TargetSet) then
          begin
            SetFillStyle(1, LightGray);
            SetColor(LightGray);
          end
          else if MColor[m] = 7 then
            SetColor(Black);
          if MColor[m] = 7 then
            Rectangle(10 + Col * 30, Hc + Row * 5, 30 + Col * 30,
              Hc + (Row + 1) * 5)
          else
            Bar(10 + Col * 30, Hc + Row * 5, 30 + Col * 30, Hc + (Row + 1) * 5);
          Hc := Hc + 2;
        end;
      end;
      Inc(Col);
    end;
    SetDefaultColors;
    Bar(x2 - x1 - 94, 5, x2 - x1 - 6, ytab - 3 * dy);
    Rectangle(x2 - x1 - 95, TextHeight('H') + 1, x2 - x1 - 5,
      6 * TextHeight('M') + 1);
    m := 0;
    Col := 0;
    while (m <= MineralCount) do
    begin
      Row := 0;
      Hc := TextHeight('H');
      while Row < 5 do
      begin
        Inc(m);
        Inc(Row);
        if (m in TargetSet) then
        begin
          SetFillStyle(1, MColor[m]);
          if MColor[m] = 7 then
            Rectangle(x2 - x1 - 90 + Col * 30, Hc + Row * 5,
              x2 - x1 - 70 + Col * 30, Hc + (Row + 1) * 5)
          else
            Bar(x2 - x1 - 90 + Col * 30, Hc + Row * 5, x2 - x1 - 70 + Col * 30,
              Hc + (Row + 1) * 5);
        end;
        Hc := Hc + 2;
      end;
      Inc(Col);
    end;
    SetTextJustify(RightText, TopText);
    SetColor(MColor[NTarget]);
    if MColor[NTarget] = 7 then
      SetColor(DarkGray);
    OutTextXY(x2 - x1 - 100, H + 10, 'TARGET');
    SetDefaultColors;
    SetLineStyle(0, 1, NormWidth);
    SetTextJustify(LeftText, CenterText);
    { ----- draw scale of size classes -------- }
    I := MaxSClass;
    k := dy;
    while (I > 0) do
    begin
      D := SizeScale[I];
      str(D: 5: 0, S);
      OutTextXY(0, ytab + k, S);
      dec(I);
      k := k + dy;
    end;
    SetTextJustify(LeftText, BottomText);
    OutTextXY(5, ytab - dy, 'SIZE');
    OutTextXY(5, ytab, '  mu');
    OutTextXY(0, (MaxSClass + 3) * dy + ytab, '  SUM');
    { -------- draw scale of grade classes ------- }
    SetTextJustify(CenterText, BottomText);
    if (not IsMilled) and (not IsSeparated) then
      OutTextXY((x2 - x1) div 2, ytab - 4 * dy - 5, '1D Ore Texture');
    if IsMilled then
      OutTextXY((x2 - x1) div 2, ytab - 4 * dy - 5, 'Mill Product');
    if IsSeparated then
      OutTextXY((x2 - x1) div 2, ytab - 4 * dy - 5, 'Concentrate');
    OutTextXY((x2 - x1) div 2, ytab - 3 * dy, 'G R A D E, %');

    SetTextJustify(LeftText, BottomText);
    SetColor(MColor[NTarget]);
    if MColor[NTarget] = 7 then
      SetColor(DarkGray);

    OutTextXY(dx, ytab - 2 * dy, '     0');
    OutTextXY(MaxGClass * dx, ytab - 2 * dy, '   100');
    for j := 2 to MaxGClass - 1 do
    begin
      str(GradeScale[j]: 6: 0, S);
      OutTextXY(j * dx, ytab - 2 * dy, S);
    end;
    SetColor(White);
    OutTextXY(dx, ytab - dy, '   100');
    OutTextXY(MaxGClass * dx, ytab - dy, '     0');
    for j := 2 to MaxGClass - 1 do
    begin
      str((100 - GradeScale[j]): 6: 0, S);
      OutTextXY(j * dx, ytab - dy, S);
    end;
    SetColor(Black);
    OutTextXY((MaxGClass + 1) * dx, ytab - dy, '   SUM');
    { ------ sums of mineral phases ------------- }
    SumFin := 0;
    SumGangue := 0;
    SumTarget := 0;
    for I := 1 to MaxSClass do
      for j := 1 to MaxGClass do
      begin
        Lfin^[I, j] := Lmat^[I, j] * SizeScale[I];
        SumFin := SumFin + Lfin^[I, j];
        SumGangue := SumGangue + Lfin^[I, j] * (1 - GradeScale[j] / 100);
        SumTarget := SumTarget + Lfin^[I, j] * GradeScale[j] / 100;
      end;
    Aalfa := 100 * SumGangue / SumFin;
    Balfa := 100 * SumTarget / SumFin;
    ContOre := Balfa;
  end; { ViewPort }
end; { CommonTable }

// =========================================
procedure ShowMatrix(AStrTitle: String);
var
  I, j, k, m: Longint;
//  ViewPort, CurrPort: ViewPortType;
  S: string;
  H, dx, dy, ytab: word;
  StepY, StepX, Period: Longint;

begin
  MainViewPort;
  GetViewSettings(ViewPort);
  with ViewPort do
  begin
    dx := (x2 - x1) div (MaxGClass + 2) + 1;
    dy := TextHeight('V') + 2;
    SetTextStyle(DefaultFont, HorizDir, 2);
    H := TextHeight('M');
    ytab := 5 * H;

    { empty title window }
    SetTextJustify(CenterText, CenterText);
    SetDefaultColors;
    Bar(dx + TextWidth(' GANGUE'), 2, x2 - x1 - dx - TextWidth('TARGET') - 10,
      TextHeight('M') + 10);

    OutTextXY((x2 - x1) div 2, TextHeight('M'), AStrTitle);
    Menu('New Graph Texture Mill Extract Delete Reset Save Quit');
    StatLine('Help ' + #179 +
      ' Press a highlighted character to execute menu item');

    SetViewPort(dx - 2, ytab + dy, (x2 - x1), MaxY - H, ClipOn);
    GetViewSettings(CurrPort);
    with CurrPort do
    begin
      { Bar(0,0,MaxX,MaxY); }
      dx := (x2 - x1) div (MaxGClass + 1);
      SetTextJustify(RightText, TopText);
      Rectangle(0, 0, MaxGClass * dx, (MaxSClass + 2) * dy);
      { ------- draw table of Lmat -------- }
      k := 0;
      for I := MaxSClass downto 1 do
      begin
        for j := 1 to MaxGClass do
        begin
          str(Lfin^[I, j]: 7: 0, S);
          if Lfin^[I, j] > 0 then
          begin
            if (j = 1) then
              SetColor(White)
            else
            begin
              SetColor(MColor[NTarget]);
              if MColor[NTarget] = 7 then
                SetColor(DarkGray);
            end
          end
          else
            SetColor(Black);
          OutTextXY(j * dx, dy + k, S);
        end;
        k := k + dy;
      end;
      SetColor(Black);
      SetTextJustify(RightText, BottomText);
      { ------- sum of particles in size classes-------- }
      afree := 0;
      bfree := 0;
      k := 0;
      for I := MaxSClass downto 1 do
      begin
        Lsin[I] := 0;
        afree := afree + Lfin^[I, 1];
        bfree := bfree + Lfin^[I, MaxGClass];
        for j := 1 to MaxGClass do
          Lsin[I] := Lsin[I] + Lfin^[I, j];
        str(Lsin[I]: 7: 0, S);
        k := k + dy;
        OutTextXY(x2 - x1 - TextHeight('M') div 2, dy + k, S);
      end;
      { -------  free particles of a and b ------- }
      afree := 100 * afree / SumFin;
      bfree := 100 * bfree / SumFin;
      { Sums of fragments in Grade Classes }
      for j := 1 to MaxGClass do
      begin
        Lgin[j] := 0;
        for I := 1 to MaxSClass do
          Lgin[j] := Lgin[j] + Lfin^[I, j];
        str(Lgin[j]: 6: 0, S);
        if Lgin[j] > 0 then
        begin
          if (j = 1) then
            SetColor(White)
          else
          begin
            SetColor(MColor[NTarget]);
            if MColor[NTarget] = 7 then
              SetColor(DarkGray);
          end;
        end
        else
          SetColor(Black);
        if (j = 1) or (j = 2) then
          OutTextXY(j * dx + 3, (MaxSClass + 3) * dy + TextHeight('M') div 2, S)
        else
          OutTextXY(j * dx, (MaxSClass + 3) * dy + TextHeight('M') div 2, S);
      end;
      { total sum }
      SetDefaultColors;
      str(SumFin: 8: 0, S);
      OutTextXY(x2 - x1 - TextWidth('M') div 2, (MaxSClass + 3) * dy +
        TextHeight('M') div 2, S);

      { ------------- line indicators of lockedness and sizes -------------- }
      Line(0, (MaxSClass + 2) * dy, MaxGClass * dx, (MaxSClass + 2) * dy);

      SetTextJustify(LeftText, BottomText);
      StepX := 200;
      StepY := (MaxSClass) * dy + 50;
      OutTextXY(StepX + 3 * TextWidth('M'), StepY, 'Mineral');
      OutTextXY(StepX + 19 * TextWidth('M'), StepY, 'Lm');
      Line(StepX, StepY + 2, StepX + 21 * TextWidth('M'), StepY + 2);
      I := 0;
      StepY := StepY + TextHeight('B');
      while (I < MineralCount) do
      begin
        Inc(I);
        SetTextJustify(LeftText, BottomText);
        SetFillStyle(1, MColor[I]);
        if (I in TargetSet) then
        begin
          OutTextXY(StepX - 20, StepY + TextHeight('H'), '->');
          OutTextXY(StepX + 22 * TextWidth('M'), StepY + TextHeight('H'), '<-');
        end;
        if MColor[I] = 7 then
          Rectangle(StepX, StepY, StepX + 15, StepY + TextHeight('H') - 2)
        else
          Bar(StepX, StepY, StepX + 15, StepY + TextHeight('H') - 2);
        OutTextXY(StepX + 25, StepY + TextHeight('H'), Mineral[I]);
        str(MChord[I]: 4: 0, S);
        SetTextJustify(RightText, BottomText);
        OutTextXY(StepX + 21 * TextWidth('H'), StepY + TextHeight('H'), S);
        StepY := StepY + TextHeight('H') + 2;
      end;
      Line(StepX, StepY + 2, StepX + 21 * TextWidth('M'), StepY + 2);
      SetTextJustify(LeftText, BottomText);
      OutTextXY(StepX + 25, StepY + 12, 'Rythm');
      Rythm := 0;
      for I := 1 to MineralCount do
        Rythm := Rythm + MChord[I];
      str(Rythm: 10: 0, S);
      SetTextJustify(RightText, BottomText);
      OutTextXY(StepX + 21 * TextWidth('H'), StepY + 12, S);

      if not IsSeparated then
      begin
        SetColor(Black);
        SetTextJustify(LeftText, BottomText);
        StepX := 0;
        StepY := (MaxSClass) * dy + 120;
        SetColor(Black);
        OutTextXY(StepX, StepY, 'GANGUE');
        OutTextXY(StepX, StepY + 2 * TextHeight('A'), 'Content    = ');
        str((100 - ContOre): 5: 2, S);
        OutTextXY(StepX + 14 * TextWidth('B'), StepY, 'vol.%');
        SetColor(White);
        OutTextXY(StepX + 14 * TextWidth('B'), StepY + 2 * TextHeight('B'), S);

        if IsMilled then
        begin
          SetColor(Black);
          OutTextXY(StepX, StepY + 4 * TextHeight('A'), 'LibFactor  = ');
          str(100 * ContOre / (100 - afree): 5: 2, S);
          SetColor(MColor[NTarget]);
          if MColor[NTarget] = 7 then
            SetColor(DarkGray);
          OutTextXY(StepX + 14 * TextWidth('A'),
            StepY + 4 * TextHeight('A'), S);
        end;
        SetTextJustify(LeftText, BottomText);
        StepX := MaxX - 220;
        StepY := (MaxSClass) * dy + 120;
        SetColor(Black);
        OutTextXY(StepX, StepY, 'TARGET');
        OutTextXY(StepX, StepY + 2 * TextHeight('B'), 'Content    = ');
        str(ContOre: 5: 2, S);
        OutTextXY(StepX + 14 * TextWidth('A'), StepY, 'vol.%');
        SetColor(MColor[NTarget]);
        if MColor[NTarget] = 7 then
          SetColor(DarkGray);
        OutTextXY(StepX + 14 * TextWidth('A'), StepY + 2 * TextHeight('B'), S);
        if IsMilled then
        begin
          SetColor(Black);
          OutTextXY(StepX, StepY + 4 * TextHeight('B'), 'LibDegree  = ');
          str(100 * bfree / ContOre: 5: 2, S);
          SetColor(MColor[NTarget]);
          if MColor[NTarget] = 7 then
            SetColor(DarkGray);
          OutTextXY(StepX + 14 * TextWidth('A'),
            StepY + 4 * TextHeight('B'), S);
        end;
      end
      else
      begin
        if FeedTotal <> 0 then
          Yield := 100 * SumFin / FeedTotal
        else
          Yield := 0;
        Grade := Balfa;
        if FeedTotal <> 0 then
          Recovery := Yield * Grade / (100 * FeedTarget / FeedTotal)
        else
          Recovery := 0;
        Throughput := 100 - Yield;
        if Throughput <> 0 then
          Quality := 100 * (FeedTarget - SumTarget) / (FeedTotal - SumFin)
        else
          Quality := 0;
        if FeedTotal <> 0 then
          Loss := Throughput * Quality / (100 * FeedTarget / FeedTotal)
        else
          Loss := 0;
        SetTextJustify(LeftText, BottomText);
        StepX := 0;
        StepY := (MaxSClass) * dy + 120;
        SetColor(Black);
        OutTextXY(StepX, StepY, 'TAILINGS');
        OutTextXY(StepX, StepY + 2 * TextHeight('T'), 'Throughput  = ');
        str(Throughput: 5: 2, S);
        OutTextXY(StepX + 14 * TextWidth('T'), StepY, 'vol.%');
        SetColor(White);
        OutTextXY(StepX + 14 * TextWidth('T'), StepY + 2 * TextHeight('B'), S);
        SetColor(Black);
        OutTextXY(StepX, StepY + 4 * TextHeight('T'), 'Quality     = ');
        OutTextXY(StepX, StepY + 6 * TextHeight('T'), 'Loss        = ');
        str(Quality: 5: 2, S);
        SetColor(MColor[NTarget]);
        if MColor[NTarget] = 7 then
          SetColor(DarkGray);
        OutTextXY(StepX + 14 * TextWidth('T'), StepY + 4 * TextHeight('B'), S);
        str(Loss: 5: 2, S);
        OutTextXY(StepX + 14 * TextWidth('T'), StepY + 6 * TextHeight('B'), S);

        SetTextJustify(LeftText, BottomText);
        StepX := MaxX - 220;
        StepY := (MaxSClass) * dy + 120;
        SetColor(Black);
        OutTextXY(StepX, StepY, 'CONCENTRATE');
        OutTextXY(StepX, StepY + 2 * TextHeight('C'), 'Yield       = ');
        OutTextXY(StepX, StepY + 4 * TextHeight('C'), 'Grade       = ');
        OutTextXY(StepX, StepY + 6 * TextHeight('C'), 'Recovery    = ');
        str(Yield: 5: 2, S);
        OutTextXY(StepX + 14 * TextWidth('C'), StepY, 'vol.%');
        SetColor(MColor[NTarget]);
        if MColor[NTarget] = 7 then
          SetColor(DarkGray);
        OutTextXY(StepX + 14 * TextWidth('C'), StepY + 2 * TextHeight('B'), S);
        str(Grade: 5: 2, S);
        OutTextXY(StepX + 14 * TextWidth('C'), StepY + 4 * TextHeight('B'), S);
        str(Recovery: 5: 2, S);
        OutTextXY(StepX + 14 * TextWidth('C'), StepY + 6 * TextHeight('B'), S);
        SetColor(Black);
      end;
    end;
  end;
end; { MinLibMat }

procedure ResetInData;
begin
  TargetSet := [NTarget];
  OreSet := [1 .. MineralCount];
  GangueSet := OreSet - TargetSet;
  CalcLmat;
  IsMilled := False;
  IsSeparated := False;
  StrTitleMat := 'Liberation Matrix';
  StrTitleGraph := 'Liberation Spectrum';
end;

procedure TargetNew;
begin
  if NTarget > MineralCount then
    NTarget := 1;
  if NTarget < 1 then
    NTarget := MineralCount;
  TargetSet := [NTarget];
  CalcLmat;
  IsMilled := False;
  IsSeparated := False;
  StrTitleMat := 'Liberation Matrix';
  StrTitleGraph := 'Liberation Spectrum';
end;

procedure DeleteTarget;
var
  I, k: Longint;
begin
  k := 0;
  for I := 1 to MineralCount do
  begin
    if (I = NTarget) then
      Continue;
    Inc(k);
    Mineral[k] := Mineral[I];
    MChord[k] := MChord[I];
    MColor[k] := MColor[I];
  end;
  MineralCount := k;
  if NTarget > k then
    dec(NTarget);
  WriteOrefile;
  ResetInData;
  StrTitleMat := 'Матрица раскрытия';
  StrTitleGraph := 'Спектр раскрытия';
end;

procedure WriteInFile;
var
  I, j: Longint;
  OutFile: Text;
  S: string;
  Name: String[8];
const
  Lenin: Longint = 125;
begin
  Name := Mineral[NTarget];
  S := FExpand('REPORTS\' + Name + '.LIB');
  Assign(OutFile, S);
  Rewrite(OutFile);
  writeln(OutFile, 'LIBERATION RESULTS');
  writeln(OutFile, Mineral[NTarget] + ' + Gangue');
  writeln(OutFile, 'Mean Grain Size of ' + Mineral[NTarget] + ':',
    MChord[NTarget]);
  writeln(OutFile, 'Mean Grain Size of Gangue:', Rythm - MChord[NTarget]);
  writeln(OutFile, 'Volumetric Grade of ' + Mineral[NTarget] + ':',
    100 * MChord[NTarget] / Rythm:5:3);
  writeln(OutFile, 'LIBERATION MATRIX:');
  S := '=';
  for I := 1 to Lenin do
    S := S + '=';
  writeln(OutFile, S);
  writeln(OutFile, '':15, 'GRADE CLASS');
  write(OutFile, '':5);
  for I := 1 to MaxGClass do
    Write(OutFile, '':5, GradeScale[I]:5:1);
  writeln(OutFile);
  writeln(OutFile, 'SIZE');
  writeln(OutFile, 'CLASS');
  S := '-';
  for I := 1 to Lenin do
    S := S + '-';
  writeln(OutFile, S);
  for I := MaxSClass downto 1 do
  begin
    write(OutFile, SizeScale[I]:5:0);
    for j := 1 to MaxGClass do
    begin
      str(Lfin^[I, j]: 6: 0, S);
      write(OutFile, S:10);
    end;
    writeln(OutFile);
  end;
  S := '=';
  for I := 1 to Lenin do
    S := S + '=';
  writeln(OutFile, S);
  writeln(OutFile);
  writeln(OutFile, 'MILL MATRIX:');
  S := '=';
  for I := 1 to Lenin do
    S := S + '=';
  writeln(OutFile, S);
  writeln(OutFile, '':15, 'GRADE CLASS');
  write(OutFile, '':5);
  for I := 1 to MaxGClass do
    Write(OutFile, '':5, GradeScale[I]:5:1);
  writeln(OutFile);
  writeln(OutFile, 'SIZE');
  writeln(OutFile, 'CLASS');
  S := '-';
  for I := 1 to Lenin do
    S := S + '-';
  writeln(OutFile, S);
  for I := MaxSClass downto 1 do
  begin
    write(OutFile, SizeScale[I]:5:0);
    for j := 1 to MaxGClass do
    begin
      str((SizeDist[I] / 100) * Lfin^[I, j]: 6: 0, S);
      write(OutFile, S:10);
    end;
    writeln(OutFile);
  end;
  S := '=';
  for I := 1 to Lenin do
    S := S + '=';
  writeln(OutFile, S);
  if IsMilled then
    writeln(OutFile, 'Степень раскрытия: ', 100 * bfree / ContOre:5:2);
  writeln(OutFile);
  writeln(OutFile, 'EXTRACT MATRIX:');
  S := '=';
  for I := 1 to Lenin do
    S := S + '=';
  writeln(OutFile, S);
  writeln(OutFile, '':15, 'GRADE CLASS');
  write(OutFile, '':5);
  for I := 1 to MaxGClass do
    Write(OutFile, '':5, GradeScale[I]:5:1);
  writeln(OutFile);
  writeln(OutFile, 'SIZE');
  writeln(OutFile, 'CLASS');
  S := '-';
  for I := 1 to Lenin do
    S := S + '-';
  writeln(OutFile, S);
  for I := MaxSClass downto 1 do
  begin
    write(OutFile, SizeScale[I]:5:0);
    for j := 1 to MaxGClass do
    begin
      str((SizeDist[I] / 100) * (RecovDist[j] / 100) * Lfin^[I, j]: 6: 0, S);
      write(OutFile, S:10);
    end;
    writeln(OutFile);
  end;
  S := '=';
  for I := 1 to Lenin do
    S := S + '=';
  writeln(OutFile, S);
  if IsSeparated then
  begin
    writeln(OutFile, 'CONCENTRATE, vol.% ');
    writeln(OutFile, 'Yield    = ', Yield:5:2);
    writeln(OutFile, 'Grade    = ', Grade:5:2);
    writeln(OutFile, 'Recovery = ', Recovery:5:2);
  end;
  Close(OutFile);
end; { WriteLibMat }

procedure Mill;
var
  I, j: Integer;
begin
  if not IsMilled then
  begin
    for I := MaxSClass downto 1 do
      for j := 1 to MaxGClass do
        Lmat^[I, j] := Lmat^[I, j] * SizeDist[I] / 100;
    IsMilled := True;
    StrTitleMat := 'Mill Matrix';
    StrTitleGraph := 'Mill Product';
  end;
  IsSeparated := False;
end;

procedure Extractor;
var
  I, j: Integer;
begin
  if not IsSeparated then
  begin
    FeedTotal := SumFin;
    FeedTarget := SumTarget;
    if not IsMilled then
    begin
      SumFin := 0;
      SumGangue := 0;
      SumTarget := 0;
      for I := 1 to MaxSClass do
        for j := 1 to MaxGClass do
        begin
          Lfin^[I, j] := Lmat^[I, j] * SizeScale[I];
          SumFin := SumFin + Lfin^[I, j];
          SumGangue := SumGangue + Lfin^[I, j] * (1 - GradeScale[j] / 100);
          SumTarget := SumTarget + Lfin^[I, j] * GradeScale[j] / 100;
        end;
      Aalfa := 100 * SumGangue / SumFin;
      Balfa := 100 * SumTarget / SumFin;
      FeedTotal := 0;
      FeedTarget := 0;
      for I := MaxSClass downto 1 do
        for j := 1 to MaxGClass do
        begin
          Lfin^[I, j] := Lfin^[I, j] * (SizeDist[I] / 100);
          FeedTotal := FeedTotal + Lfin^[I, j];
          FeedTarget := FeedTarget + Lfin^[I, j] * GradeScale[j] / 100;
        end;
    end;
    for I := MaxSClass downto 1 do { Mill+Separator }
      for j := 1 to MaxGClass do
        Lmat^[I, j] := Lmat^[I, j] * (SizeDist[I] / 100) * (RecovDist[j] / 100);
    IsSeparated := True;
    StrTitleMat := 'Extract Matrix';
    StrTitleGraph := 'Concentrate';
  end;
  IsMilled := False;
end;

{ ======================== MAIN BODY ============================== }
label one;

var
  Code: Integer;

begin // main body
  Initialize;
  { InitDistributions; }

  MlTitle('MINLIBER', 'Version 1.6', { Build 123 }
    'M I N E R A L   L I B E R A T O R', 'for  Multiphase  Ores');
  { }
  if not ReadOreFile then
  begin
    MineralCount := MaxMineral;
    WriteOrefile;
  end;
  if not ReadMillFile then
    WriteMillFile;
  if not ReadExtractFile then
    WriteExtractFile;
  NTarget := 1; { initial position of target mineral in array }
  InitOre;
  GenerOre;
  CalcLmat;
  StrTitleMat := 'Liberation Matrix';
  StrTitleGraph := 'Liberation Spectrum';
  { TwoDim(MChord,Mineral,NTarget);{ }
  repeat
    CommonTable;
    ShowMatrix(StrTitleMat);
  one:
    if Ch = #0 then
      Ch := readkey; { trap function keys }
    Code := ord(Ch);
    case Upcase(Ch) of
      #72, 'B':
        begin
          dec(NTarget);
          TargetNew;
        end;
      { #77, } #80, 'N':
        begin
          Inc(NTarget);
          TargetNew;
        end;
      'G':
        Hist3d(Lfin^, StrTitleGraph);
      'M':
        begin
          if not IsMilled then
            CalcLmat;
          Mill;
        end;
      #75, 'E':
        begin
          if not IsSeparated then
            CalcLmat;
          Extractor;
        end;
      'T':
        begin
          TwoDim(MChord, Mineral, NTarget);
          ResetInData;
        end;
      'R':
        ResetInData;
      'S', #60:
        begin
          WriteOut('Save ' + Mineral[NTarget] + '.LIB ? [Y,N]');
          Ch := readkey;
          if Upcase(Ch) = 'Y' then
            WriteInFile;
        end;
      'D':
        begin
          if (MineralCount < 3) then
          begin
            WriteOut('Must be from 2 to 14 phases!');
            Repeat
            until KeyPressed;
          end
          else
          begin
            WriteOut('Delete ' + Mineral[NTarget] + ' ? [Y,N]');
            Ch := readkey;
            if Upcase(Ch) = 'Y' then
            begin
              DeleteTarget;
              ResetInData;
            end;
          end;
        end;
      'Q' { ,#27{ } :
        begin
          WriteOut('Close the Program ? [Y,N]');
          Ch := readkey;
          if Upcase(Ch) = 'Y' then
          begin
            Break;
            DoneOre;
            { Halt;{ }
          end;
        end;
      #27:
        Break;
    else
      Goto one; { to prevent redraw... }
    end;
  until Upcase(Ch) = 'Q';
  DoneOre;
end;
end.
