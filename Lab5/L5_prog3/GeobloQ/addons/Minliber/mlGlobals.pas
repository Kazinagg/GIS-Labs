unit mlGlobals;

interface

uses
  System.Types,
  System.Math;

const
  // MaxSClass = 52;
  MaxSClass = 16;
  MaxGClass = 12;
  MaxZClass = 5;
  MaxMineral = 14;
  MaxGrain = 2 * 1024;
  MaxChord = 8000; // 8000 - available maxgrain
  NXClass = 12;
  NYClass = 12;
  ScanLine = 32 * 1024;
  SLevel: Integer = 1;
  GLevel: Integer = MaxGClass;
  FineLevel: Integer = 1;
  CoarLevel: Integer = MaxSClass;
  MaxXCor = 2048;
  MinYcor = 0;

type
  Real = Single;
  TArrayOfPoints = array [1 .. 10000] of TPoint; //
  PArrayOfPoints = ^TArrayOfPoints;

  TSize = array [1 .. MaxSClass] of Single;
  TGrade = array [1 .. MaxGClass] of Single;

  PFrac = ^TFrac;
  TFrac = array [1 .. MaxSClass, 1 .. MaxGClass] of Single;

  PGrain = ^Grain;
  Grain = array [1 .. MaxGrain] of Word;

  TGrain = record
    Chord: Real;
    MineralPhase: Word;
  end;

  POre = ^TOre;
  TOre = array [1 .. MaxChord] of TGrain;

  TLm = array [1 .. MaxMineral] of Real;
  TMineral = array [1 .. MaxMineral] of String;
  TColor = array [1 .. MaxMineral + 2] of Word;
  TFree = array [1 .. MaxMineral] of Real; // Free Material

type
  MineralSet = set of 1 .. MaxMineral;

var
  Ch: char;
  Ore: POre;
  Lmat, // Matrix of Liberation
  Lfin, Fbcon: PFrac;

  csin, Lsin: TSize;
  cgin, Lgin: TGrade;

  OreSet, TargetSet, GangueSet: MineralSet;
  FeedTotal, FeedTarget, Aalfa, // доля фазы A на отрезке
  Balfa: Real; // доля фазы B на отрезке
  Afree, Bfree, ContOre, // content of Target in Ore
  Yield, Grade, Recovery, Throughput, Quality, Loss: Real;
  SumGangue, SumTarget: Real;
  SumABcon, SumBBcon, SumFin, Sumfbcon: Real; // сумма фракций
  NumChords: Word;  // число хорд

var
  // Dp:Real;
  DStddev: TLm;
  Rythm: Real; // Texture Rythm - ритм текстуры на секущей
  StrTitleMat, StrTitleGraph: String[128];

const
  MineralCount: Word = 14;
  NTarget: Word = 1;
  IsMilled: Boolean = False;
  IsSeparated: Boolean = False;

  Mineral: TMineral = ('Magnetite', 'Quartz', 'Hematite', 'Cummingtonite',
    'Goethite', 'Feldspar', 'Apatite', 'Biotite', 'Spinel', 'Amphibole',
    'Kaolinite', 'Chlorite', 'Talc', 'Pyrite');

const
  fMinerals: String[128] = 'DATA\MINERALS.ORE';
  fSizedist: String[128] = 'DATA\SIZEDIST.MIL';
  fExtracts: String[128] = 'DATA\EXTRACTS.CON';

  fTexture: String[128] = 'REPORTS\TEXTURE.VOR';
  fFracture: String[128] = 'REPORTS\FRACTURE.VOR';

var
  SizeScale: TSize = (1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768);
  GradeScale: TGrade = (0, 5, 15, 25, 35, 45, 55, 65, 75, 85, 95, 100);
  MColor: TColor = (4, 1, 12, 13, 5, 2, 10, 8, 9, 7, 6, 3, 11, 14, 0, 15);
  SizeDist: TSize = (1, 4, 7, 8, 12, 18, 20, 15, 7, 4, 3, 1, 0, 0, 0, 0);
  RecovDist: TGrade = (0, 50, 70, 85, 95, 98, 98, 99, 99, 99, 99, 99);
  MChord: TLm = (66, 125, 28, 23, 5, 12, 7, 5, 2, 3, 9, 11, 8, 10);


implementation

procedure InitDistributions;
var
  I: Integer;
begin
  for I := 1 to MaxSClass do
    SizeScale[I] := Round(power(2, I - 1));
  for I := 1 to MaxGClass do
  begin
    case I of
      1:
        GradeScale[I] := 0;
      2 .. MaxGClass - 1:
        GradeScale[I] := 100 * (I * 0.1 - 0.15);
      MaxGClass:
        GradeScale[I] := 100;
    end;
  end;
end;

end.
