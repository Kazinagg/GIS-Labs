unit mlVoronoi;
(* ------------------------------------------------------------------ *)
(* Performs Delaunay  triangulation and Voronoi tesselation of a set
  of points. Coincident points are rejected.

  PntTable     -  input file of points
  TriTable     -  output file of triangles or polygons
  ContTable    - Outlines file

  MAXOPT = Maximum number of recursive calls of the routine that
  performs delaunay  optimization (Optim).
  This number is always less than MAXTRI/3.
  you can set  any value.  Greater numbers assure that
  delaunay triangulation is well performed but the program
  may require too much RAM memory. Usually the number of
  recursive calls is less than ten. *)
(* ------------------------------------------------------------------- *)

interface

uses
  System.Types,
  System.SysUtils,
  System.Math,

  GLS.GeomObjects,
  mlGlobals;

const
  MAXPTS = 1024; // ìàêñèìàëüíîå ÷èñëî òî÷åê, ç¸ðåí
  MAXTRI = 2048; // ìàêñèìàëüíîå ÷èñëî òðåóãîëüíèêîâ TRIANGLES = 2*MAXPTS
  MAXOPT = 512; // MAXIMUM OPTIMIZ. LEVEL < MAXTRI/3
  DBERR = 1.0E-15; { DOUBLE  PRECISION  ACCURACY }
  Jnd: array [0 .. 2] of longint = (1, 2, 0); { Auxiliary  vector }
  Jrd: array [0 .. 2] of longint = (2, 0, 1); { Auxiliary   vector }

type
  PTriPars = ^TTriPars;

  TTriPars = record
    ModeBtn: longint;
    CompBox: longint; { CheckBox for Components }
    TriName: String[8];
  end;

type
  PLongint = ^longint;

type
  PNumbers = ^TNumbers;
  TNumbers = array [0 .. MAXPTS - 1] of Integer;

type
  PCoords = ^TCoords;
  TCoords = array [0 .. MAXPTS - 1] of Real;

type
  Pvt = ^Tvt;
  Tvt = array [0 .. MAXTRI - 1] of longint;

type
  PVorPol = ^TVorPol;
  TVorPol = array [0 .. 50] of TPoint;

type
  PTriArr = ^TTriArr; // array of triangle with a point
  TTriArr = array [1 .. 50] of longint; // òîëüêî 50 òðåóãîëüíèêîâ ?

// Object TTess
type
  PTess = ^TTess;

  TTess = object
    ModeBtn: longint;
    InTable, TriTable, VerTable, PolTable: String;
    Data: Byte;
    TriPars: PTriPars;
    vt1, vt2, vt3: Pvt;
    nt1, nt2, nt3: Pvt;
    Dcd: PNumbers;
    Npts: longint; // ÷èñëî âåðøèí
    px, py, pz: PCoords; // êîîðäèíàòû âåðøèí
    Ntri: longint; // Number of triangles  -1
    Nvor: longint; // Number of Voronoi polygons
    Xmin, Xmax, Ymin, Ymax: Real; // Min and max coordinates
    VorPol: PVorPol;
    TriArr: PTriArr;
    IsFracture: Boolean;
    constructor Init;
    destructor Done; virtual;
    function CkTurn(var pv0: Pvt; i2, i3: longint): Integer;
    function TriFind(x, y: Real; tr: longint; var option: longint): longint;
    function GetNumFirstTriCW(Nv, Nt: longint): longint;
    function GetNumNextTriCW(Nv, Nt: longint): longint;
    function GetNumPrevTriCW(Nv, Nt: longint): longint;
    function CkLop(i1, i2, i3, i4: longint): Integer;
    procedure SwapTr(t1, t2, k1, k2: longint);
    procedure Optim(it, k1: longint);
    procedure SortNtCW;
    procedure Delaunay; virtual;
    procedure Voronoi; virtual;
  end;

// ---------------------------------------------------------------
implementation
// ---------------------------------------------------------------

function Sign(Num: Extended): ShortInt;
begin
  Result := 0;
  if Num < 0 then
    Result := -1
  else if Num > 0 then
    Result := 1;
  Sign := Result;
end;

var
  vtm, ntm, ntr: array [0 .. 2] of longint; { Auxiliary pointers }
  loptim: Integer = 0; { Optimization level }

  { ========================================================= }
constructor TTess.Init;
var
  Dir: TFileName;
  Name: TFileName;
  Ext: TFileName;
  I, J: Integer;

begin
  New(VorPol);
  New(px);
  New(py);
  New(pz);
  New(Dcd);
  New(vt1);
  Fillchar(vt1^, Sizeof(vt1^), 0);
  New(vt2);
  Fillchar(vt2^, Sizeof(vt2^), 0);
  New(vt3);
  Fillchar(vt3^, Sizeof(vt3^), 0);
  New(nt1);
  New(nt2);
  New(nt3);
  Fillchar(nt1^, Sizeof(nt1^), 0);
  Fillchar(nt2^, Sizeof(nt2^), 0);
  Fillchar(nt3^, Sizeof(nt3^), 0);

  for I := 0 to Ntri do
  begin
    nt1^[I] := -1;
    nt2^[I] := -1;
    nt3^[I] := -1;
  end;
  New(TriArr);
  IsFracture := False;
end; { Init }

destructor TTess.Done;
begin
  Dispose(px);
  Dispose(py);
  Dispose(pz);
  Dispose(vt1);
  Dispose(nt1);
  Dispose(vt2);
  Dispose(nt2);
  Dispose(vt3);
  Dispose(nt3);
  Dispose(Dcd);
  Dispose(VorPol);
  Dispose(TriArr);
end;

{ =============================================================== }
{ CKTURN - Checks if three vertices are: }
{ alligned                (0) }
{ counterclockwise tern   (-1) }
{ clockwise tern          (1) }
{ coincident points       (2) }
{ =============================================================== }
function TTess.CkTurn(var pv0: Pvt; i2, i3: longint): Integer;

var
  aux: double;
  i1: longint;

begin
  i1 := i2 - 1;
  if i1 = -1 then
    aux := 0
  else
    aux := (py^[pv0^[i2]] - py^[pv0^[i1]]) * (px^[pv0^[i3]] - px^[pv0^[i1]]) -
      (py^[pv0^[i3]] - py^[pv0^[i1]]) * (px^[pv0^[i2]] - px^[pv0^[i1]]);
  if (aux > DBERR) then
  begin
    CkTurn := 1;
    exit
  end;
  if (aux < -DBERR) then
  begin
    CkTurn := -1;
    exit
  end;
  if i1 = -1 then
    aux := 0
  else
    aux := (px^[pv0^[i3]] - px^[pv0^[i2]]) * (px^[pv0^[i2]] - px^[pv0^[i1]]) +
      (py^[pv0^[i3]] - py^[pv0^[i2]]) * (py^[pv0^[i2]] - py^[pv0^[i1]]);

  if (aux <= -DBERR) then
  begin
    CkTurn := 1;
    exit
  end;
  if (aux >= DBERR) then
  begin
    CkTurn := 0;
    exit;
  end;
  CkTurn := 2;
end;

{ ========================================================================= }
{ TRIFIND - find triangle with point ind }
{ tr := initial triangle }
{ Return triangle number or: }
{ -1 if triangle not found }
{ -2 if the vertix coincide with exist vertex }
{ ========================================================================= }
function TTess.TriFind(x, y: Real; tr: longint; var option: longint): longint;
var
  ii: Byte;
  aux, Newtr, PrevTr: longint;
  area, x21, x31, y21, y31: Real;
  i1, ind1, ind2: longint;
label
  the_end;

begin
  option := 0;
  Newtr := tr;
  repeat
    aux := 0;
    i1 := Jnd[0];
    ind1 := vt1^[Newtr];
    ind2 := vt2^[Newtr];
    x31 := x - px^[ind1];
    y31 := y - py^[ind1];
    x21 := px^[ind2] - px^[ind1];
    y21 := py^[ind2] - py^[ind1];
    area := y31 * x21 - y21 * x31;
    if (area < 0) then
    begin
      Newtr := nt2^[Newtr];
      if (Newtr = -1) then
      begin
        TriFind := Newtr;
        exit;
      end;
      aux := 1;
      goto the_end;
    end;
    if (area = 0) then
      if ((x31 = 0) and (y31 = 0)) then
      begin
        option := -2;
        TriFind := Newtr;
        exit;
      end;
    { --------------------------- }
    i1 := Jnd[1];
    ind1 := vt2^[Newtr];
    ind2 := vt3^[Newtr];
    x31 := x - px^[ind1];
    y31 := y - py^[ind1];
    x21 := px^[ind2] - px^[ind1];
    y21 := py^[ind2] - py^[ind1];
    area := y31 * x21 - y21 * x31;
    if (area < 0) then
    begin
      Newtr := nt3^[Newtr];
      if (Newtr = -1) then
      begin
        TriFind := Newtr;
        exit;
      end;
      aux := 1;
      goto the_end;
    end;
    if (area = 0) then
      if ((x31 = 0) and (y31 = 0)) then
      begin
        option := -2;
        TriFind := Newtr;
        exit;
      end;
    { -------------------------- }
    i1 := Jnd[2];
    ind1 := vt3^[Newtr];
    ind2 := vt1^[Newtr];
    x31 := x - px^[ind1];
    y31 := y - py^[ind1];
    x21 := px^[ind2] - px^[ind1];
    y21 := py^[ind2] - py^[ind1];
    area := y31 * x21 - y21 * x31;
    if (area < 0) then
    begin
      Newtr := nt1^[Newtr];
      if (Newtr = -1) then
      begin
        TriFind := Newtr;
        exit;
      end;
      aux := 1;
      goto the_end;
    end;
    if (area = 0) then
      if ((x31 = 0) and (y31 = 0)) then
      begin
        option := -2;
        TriFind := Newtr;
        exit;
      end;
  the_end:
    ;
  until aux <> 1;
  TriFind := Newtr;
end;

{ ======================================================================== }
{ CKLOP - Check if four points satisfy to local optimization, }
{ comparing diagonal sizes of quadrilaterals - current and }
{ á¬¥¦­®£® á ­¨¬ âà¥ã£®«ì­¨ª®¢ }
{ CkLop:=1 if satisfied        ( not swap diagonal  ) }
{ CkLop:=0 if not satisftied      ( swap diagonal  ) }
{ ======================================================================== }

function TTess.CkLop(i1, i2, i3, i4: longint): Integer;
var
  ac, bd, x2sq, y2sq, a, b, c, d, e, f, xc, yc, rsq: double;
begin
  a := 2 * (px^[i2] - px^[i1]);
  b := 2 * (py^[i2] - py^[i1]);
  c := sqr(py^[i2]) - sqr(py^[i1]) + sqr(px^[i2]) - sqr(px^[i1]);
  d := 2 * (px^[i3] - px^[i2]);
  e := 2 * (py^[i3] - py^[i2]);
  f := sqr(py^[i3]) - sqr(py^[i2]) + sqr(px^[i3]) - sqr(px^[i2]);
  x2sq := d * b - e * a;
  rsq := sqr(x2sq);
  if (rsq > 0) then
  begin
    xc := (f * b - c * e) / x2sq;
    yc := (d * c - f * a) / x2sq;
    rsq := (sqr(xc - px^[i1]) + sqr(yc - py^[i1]));
    if ((sqr(py^[i4] - yc) + sqr(px^[i4] - xc)) > rsq) then
    begin
      CkLop := 1;
      exit;
    end;
  end;
  CkLop := 0;
end;

{ ========================================================= }
{ SwapTr - Swaps the diagonals  of a quadrilater }
{ ========================================================= }
procedure TTess.SwapTr(t1, t2, k1, k2: longint);
var
  ii: Byte;
  save, ind1, ind2: longint;
begin
  if Jrd[k1] = 0 then
  begin
    if Jnd[k2] = 0 then
      vt1^[t1] := vt1^[t2];
    if Jnd[k2] = 1 then
      vt1^[t1] := vt2^[t2];
    if Jnd[k2] = 2 then
      vt1^[t1] := vt3^[t2];
  end;
  if Jrd[k1] = 1 then
  begin
    if Jnd[k2] = 0 then
      vt2^[t1] := vt1^[t2];
    if Jnd[k2] = 1 then
      vt2^[t1] := vt2^[t2];
    if Jnd[k2] = 2 then
      vt2^[t1] := vt3^[t2];
  end;
  if Jrd[k1] = 2 then
  begin
    if Jnd[k2] = 0 then
      vt3^[t1] := vt1^[t2];
    if Jnd[k2] = 1 then
      vt3^[t1] := vt2^[t2];
    if Jnd[k2] = 2 then
      vt3^[t1] := vt3^[t2];
  end;
  { vt^[jrd[k1]][t1]:=vt^[jnd[k2]][t2]; }
  if k2 = 0 then
  begin
    if k1 = 0 then
      vt1^[t2] := vt1^[t1];
    if k1 = 1 then
      vt1^[t2] := vt2^[t1];
    if k1 = 2 then
      vt1^[t2] := vt3^[t1];
  end;
  if k2 = 1 then
  begin
    if k1 = 0 then
      vt2^[t2] := vt1^[t1];
    if k1 = 1 then
      vt2^[t2] := vt2^[t1];
    if k1 = 2 then
      vt2^[t2] := vt3^[t1];
  end;
  if k2 = 2 then
  begin
    if k1 = 0 then
      vt3^[t2] := vt1^[t1];
    if k1 = 1 then
      vt3^[t2] := vt2^[t1];
    if k1 = 2 then
      vt3^[t2] := vt3^[t1];
  end;
  { vt^[k2][t2]:=vt^[k1][t1]; }
  if k1 = 0 then
  begin
    save := nt1^[t1];
    nt1^[t1] := t2;
  end;
  if k1 = 1 then
  begin
    save := nt2^[t1];
    nt2^[t1] := t2;
  end;
  if k1 = 2 then
  begin
    save := nt3^[t1];
    nt3^[t1] := t2;
  end;
  { save:=nt^[k1][t1]; }
  { nt^[k1][t1]:=t2; }
  if Jrd[k1] = 0 then
  begin
    if Jnd[k2] = 0 then
      nt1^[t1] := nt1^[t2];
    if Jnd[k2] = 1 then
      nt1^[t1] := nt2^[t2];
    if Jnd[k2] = 2 then
      nt1^[t1] := nt3^[t2];
  end;
  if Jrd[k1] = 1 then
  begin
    if Jnd[k2] = 0 then
      nt2^[t1] := nt1^[t2];
    if Jnd[k2] = 1 then
      nt2^[t1] := nt2^[t2];
    if Jnd[k2] = 2 then
      nt2^[t1] := nt3^[t2];
  end;
  if Jrd[k1] = 2 then
  begin
    if Jnd[k2] = 0 then
      nt3^[t1] := nt1^[t2];
    if Jnd[k2] = 1 then
      nt3^[t1] := nt2^[t2];
    if Jnd[k2] = 2 then
      nt3^[t1] := nt3^[t2];
  end;
  { nt^[jrd[k1]][t1]:=nt^[jnd[k2]][t2]; }
  if Jnd[k2] = 0 then
    nt1^[t2] := t1;
  if Jnd[k2] = 1 then
    nt2^[t2] := t1;
  if Jnd[k2] = 2 then
    nt3^[t2] := t1;
  { nt^[jnd[k2]][t2]:=t1; }
  if k2 = 0 then
    nt1^[t2] := save;
  if k2 = 1 then
    nt2^[t2] := save;
  if k2 = 2 then
    nt3^[t2] := save;
  { nt^[k2][t2]:=save; }
  if Jrd[k1] = 0 then
    ind1 := nt1^[t1];
  if Jrd[k1] = 1 then
    ind1 := nt2^[t1];
  if Jrd[k1] = 2 then
    ind1 := nt3^[t1];
  { ind1:=nt^[jrd[k1]][t1]; }
  if k2 = 0 then
    ind2 := nt1^[t2];
  if k2 = 1 then
    ind2 := nt2^[t2];
  if k2 = 2 then
    ind2 := nt3^[t2];
  { ind2:=nt^[k2][t2]; }

  if ((ind1 <> -1) and (nt1^[ind1] = t2)) then
    nt1^[ind1] := t1;
  if ((ind2 <> -1) and (nt1^[ind2] = t1)) then
    nt1^[ind2] := t2;
  if ((ind1 <> -1) and (nt2^[ind1] = t2)) then
    nt2^[ind1] := t1;
  if ((ind2 <> -1) and (nt2^[ind2] = t1)) then
    nt2^[ind2] := t2;
  if ((ind1 <> -1) and (nt3^[ind1] = t2)) then
    nt3^[ind1] := t1;
  if ((ind2 <> -1) and (nt3^[ind2] = t1)) then
    nt3^[ind2] := t2;

end;

{ ============================================== }
{ OPTIM - Local optimization of two triangles }
{ it -pointer to triangle }
{ k1 = 2 ¯à¨ ­ ç «ì­®¬ à §¡¨¥­¨¨ }
{ = 0 ¯à¨ âà¨ ­£ã«ïæ¨¨ }
{ ============================================== }
procedure TTess.Optim(it, k1: longint);
var
  near_, I, i1, k2, k3: longint;
  a, b, c, d: longint;
label
  further;
begin
  if (loptim = MAXOPT) then
    exit;
  k2 := Jnd[k1];
  k3 := Jrd[k1];
  if k3 = 0 then
    near_ := nt1^[it];
  if k3 = 1 then
    near_ := nt2^[it];
  if k3 = 2 then
    near_ := nt3^[it];
  if (near_ = -1) then
    exit;
  inc(loptim);
  if nt1^[near_] = it then
  begin
    I := 0;
    goto further;
  end;
  if nt2^[near_] = it then
  begin
    I := 1;
    goto further;
  end;
  if nt3^[near_] = it then
  begin
    I := 2;
    goto further;
  end;
  exit; { !!!ERROR in optim!!! }

further:
  i1 := Jnd[I];
  if k3 = 0 then
    a := vt1^[it];
  if k3 = 1 then
    a := vt2^[it];
  if k3 = 2 then
    a := vt3^[it];
  if k1 = 0 then
    b := vt1^[it];
  if k1 = 1 then
    b := vt2^[it];
  if k1 = 2 then
    b := vt3^[it];
  if k2 = 0 then
    c := vt1^[it];
  if k2 = 1 then
    c := vt2^[it];
  if k2 = 2 then
    c := vt3^[it];
  if i1 = 0 then
    d := vt1^[near_];
  if i1 = 1 then
    d := vt2^[near_];
  if i1 = 2 then
    d := vt3^[near_];

  if (CkLop(a, b, c, d) = 0) then
  begin
    SwapTr(it, near_, k1, I);
    Optim(it, k1);
    Optim(near_, I);
  end;
  dec(loptim);
  { Exit;{ }
end;

{ ======================================================================= }
procedure TTess.Delaunay;

var
  nptf, nptfs, nptfi: longint; { Hull vertices (tot, up, low) }
  I, k, l, n1, J: longint; { Auxiliary variables }
  it: longint; { Pointer to triangle }
  nrej1: longint; { Number of rejected points }
  nrej2: longint; { —¨á«® á®¢¯ ¤ îé¨å â®ç¥ª }

  strip: Real; { External frame fraction }
  DxStrip, DyStrip: Real; { Dimensions of external frame }
  px1, px2, py1, py2, aux: Real; { Auxiliary variables }
  m, q, x0: Real; { Params straight line }

  nx, ny, k1, k2: longint;
  it1, ntrk, knd, krd: longint;
  ind: longint;

  pt, option: longint;
  s: string[20];

  { sub } procedure DrawTriangles;
  var
    I: longint;
    Triangle: array [1 .. 4] of TPoint;
  begin

///    SetFillStyle(1, Black);
///    Bar(0, 0, GetMaxX, GetMaxY);

    for I := 0 to Ntri do
    begin
      Triangle[1].x := round(px^[vt1^[I]]);
      Triangle[1].y := round(py^[vt1^[I]]);
      Triangle[2].x := round(px^[vt2^[I]]);
      Triangle[2].y := round(py^[vt2^[I]]);
      Triangle[3].x := round(px^[vt3^[I]]);
      Triangle[3].y := round(py^[vt3^[I]]);
      Triangle[4].x := round(px^[vt1^[I]]);
      Triangle[4].y := round(py^[vt1^[I]]);
      {
        SetFillStyle(1,round(Pz^[v1^[I]]));
        FillPoly(3,Triangle);
      }

///      SetFillStyle(1, White);
///      SetColor(White);
///      DrawPoly(4, Triangle);
    end;
///    ReadKey;
  end;

{ sub } procedure DrawTriangle(Nt: longint);
  var
    Triangle: array [1 .. 4] of TPoint;
  begin
    Triangle[1].x := round(px^[vt1^[Nt]]);
    Triangle[1].y := round(py^[vt1^[Nt]]);
    Triangle[2].x := round(px^[vt2^[Nt]]);
    Triangle[2].y := round(py^[vt2^[Nt]]);
    Triangle[3].x := round(px^[vt3^[Nt]]);
    Triangle[3].y := round(py^[vt3^[Nt]]);
    Triangle[4].x := round(px^[vt1^[Nt]]);
    Triangle[4].y := round(py^[vt1^[Nt]]);
    {
      SetFillStyle(1,round(Pz^[v1^[nt]]));
      FillPoly(3,Triangle);
    }

///    SetFillStyle(1, White);
///    SetColor(White);
///    DrawPoly(4, Triangle);
///    ReadKey;
  end;

begin

  { px^[0]:=110;  px^[1]:=105;  px^[2]:=100;  px^[3]:=055;  px^[4]:=205;
    px^[5]:=165;  px^[6]:=140;  px^[7]:=065;  px^[8]:=200;  px^[9]:=115;
    px^[10]:=0;   px^[11]:=0;   px^[12]:=0;   px^[13]:=0;   px^[14]:=0;
    px^[15]:=0;   px^[16]:=0;   px^[17]:=0;   px^[18]:=0;   px^[19]:=0;


    py^[0]:=170;  py^[1]:=130;  py^[2]:=095;  py^[3]:=090;  py^[4]:=085;
    py^[5]:=110;  py^[6]:=090;  py^[7]:=135;  py^[8]:=130;  py^[9]:=050;
    py^[10]:=0;   py^[11]:=0;   py^[12]:=0;   py^[13]:=0;   py^[14]:=0;
    py^[15]:=0;   py^[16]:=0;   py^[17]:=0;   py^[18]:=0;   py^[19]:=0;

    npts:=10;(*{

    k:=5;
    l:=3;
    npts:=(k)*(l);

    for i:=0 to 2*k*l do
    begin
    Px^[i]:=0;
    Py^[i]:=0;
    end;
    for j:=0 to k-1 do
    for i:=0 to l-1 do
    begin
    Px^[j*l+i]:=35 - (J mod 2)*0*25 + I * 50;
    Py^[j*l+i]:=30 + J * 40;
    end;
    { }(* * )

    Px^[5]:=Px^[2];
    npts:=30;{}
    k:=3;
    J:=100;
    for i:=0 to npts-1 do
    begin
    if ((i div (k)) mod 2) =1 then Px^[i]:=J+25 + (i mod (k))* 50+random(round(10))
    else Px^[i]:=J    + (i mod (k))* 50+random(round(10));
    Py^[i]:=10 + (i div (k)) * 40+random(round(10));
    end;

    {}(* *)
  Xmin := px^[0];
  Xmax := px^[0];
  Ymin := py^[0];
  Ymax := py^[0];
  for I := 2 to Npts do
  begin
    if Xmin > px^[I - 1] then
      Xmin := px^[I - 1];
    if Xmax < px^[I - 1] then
      Xmax := px^[I - 1];
    if Ymin > py^[I - 1] then
      Ymin := py^[I - 1];
    if Ymax < py^[I - 1] then
      Ymax := py^[I - 1];
  end;

  { ====== Computes external frame ====== }
  strip := 0.05;
  DxStrip := strip * (Xmax - Xmin);
  DyStrip := strip * (Ymax - Ymin);
  px1 := Xmin - DxStrip;
  py1 := Ymin - DyStrip;
  n1 := 1 + round(Sqrt(Sqrt(Npts))); { john }
  px2 := (Xmax - Xmin + 2 * DxStrip) / n1;
  py2 := (Ymax - Ymin + 2 * DyStrip) / n1;
  for I := 0 to Npts - 1 do
  begin
    nx := 1 + round((px^[I] - px1) / px2);
    ny := 1 + round((py^[I] - py1) / py2);
    k1 := (ny mod 2);
    if k1 = 0 then
      k1 := 1
    else
      k1 := -1;
    k2 := (1 - k1) div 2;
    vt1^[I] := n1 * ny - k1 * nx - k2 * (n1 + 1) + 1;
    vt2^[I] := I;
    vt3^[I] := I;
  end;
  (* Sort by bin number and increasing abscissa *)
  for I := 0 to Npts - 1 do
  begin
    for J := I + 1 to Npts - 1 do
    begin
      if (px^[vt3^[J]] < px^[vt3^[I]]) then
      (* *** Swaps two memory locations by abscissa ** *)
      begin
        pt := vt3^[I];
        vt3^[I] := vt3^[J];
        vt3^[J] := pt;
      end;
      if (vt1^[vt2^[J]] < vt1^[vt2^[I]]) then
      begin
        (* **  Swaps two memory locations by bin ** *)
        pt := vt2^[I];
        vt2^[I] := vt2^[J];
        vt2^[J] := pt;
      end;
    end;
  end;

  { ====== Creates the convex hull ===== }
  x0 := px^[vt3^[0]];
  q := py^[vt3^[0]];
  m := (py^[vt3^[Npts - 1]] - q) / (px^[vt3^[Npts - 1]] - x0);
  nptfi := 1;
  nptfs := Npts;
  nt1^[0] := vt3^[0];
  for I := 1 to Npts - 1 do
  begin
    ind := vt3^[I];
    if ((py^[ind] - q) >= m * (px^[ind] - x0)) then
    begin
      dec(nptfs);
      nt1^[nptfs] := ind;
    end
    else
    begin
      nt1^[nptfi] := ind;
      inc(nptfi);
    end;
  end;
  nptf := 1;
  for I := 2 to Npts - 1 do
  begin
    while ((CkTurn(nt1, nptf, I) > 0) and (nptf >= 1)) do
      dec(nptf);
    inc(nptf);
    nt1^[nptf] := nt1^[I];
  end;

  while ((CkTurn(nt1, nptf, 0) > 0) and (nptf >= 1)) do
    dec(nptf);

  (* Builds the ordered list of vertices *)
  for I := 0 to nptf do
  begin
    ind := nt1^[I];
    Dcd^[I] := ind;
    vt1^[ind] := 0;
  end;
  k := nptf;
  for I := 0 to Npts - 1 do
  begin
    ind := vt2^[I];
    if (vt1^[ind] <> 0) then
    begin
      inc(k);
      Dcd^[k] := ind;
    end;
  end;

  (* Builds first triangles *)
  Ntri := nptf - 2;
  for I := 0 to Ntri do
  begin
    vt1^[I] := Dcd^[0];
    vt2^[I] := Dcd^[I + 1];
    vt3^[I] := Dcd^[I + 2];
    nt1^[I] := I + 1;
    nt2^[I] := I - 1;
    nt3^[I] := -1;
    Optim(I, 2);
  end;
  { DrawTriangles;ReadKey;{ }
  { Beginning of triangulation }
  nt1^[Ntri] := -1;
  it := 0;
  nrej1 := 0;
  nrej2 := 0;
  for I := nptf + 1 to Npts - 1 do
  begin
    n1 := Dcd^[I];
    it1 := TriFind(px^[n1], py^[n1], it, option);
    if (it1 >= 0) and (option = 0) then
    begin
      it := it1;
      { New triangles }
      ntr[0] := it;
      ntr[1] := Ntri + 1;
      ntr[2] := Ntri + 2;
      vtm[0] := vt1^[it]; { Vertices }
      ntm[0] := nt1^[it]; { Near triangles }
      vtm[1] := vt2^[it];
      ntm[1] := nt2^[it];
      vtm[2] := vt3^[it];
      ntm[2] := nt3^[it];
      for k := 0 to 2 do
      begin
        ntrk := ntr[k];
        knd := Jnd[k];
        krd := Jrd[k];
        vt1^[ntrk] := n1;
        vt2^[ntrk] := vtm[k];
        vt3^[ntrk] := vtm[knd];
        nt1^[ntrk] := ntr[knd];
        nt2^[ntrk] := ntr[krd];
        nt3^[ntrk] := ntm[knd];
      end;
      for k := 0 to 2 do
      begin
        ind := nt3^[ntr[k]];
        if (ind >= 0) then
        begin
          if (nt1^[ind] = ntr[0]) then
            nt1^[ind] := ntr[k];
          if (nt2^[ind] = ntr[0]) then
            nt2^[ind] := ntr[k];
          if (nt3^[ind] = ntr[0]) then
            nt3^[ind] := ntr[k];
        end;
      end;
      inc(Ntri, 2);
      { DrawTriangles;ReadKey;{ }
      Optim(ntr[0], 0);
      { DrawTriangles;ReadKey;{ }
      Optim(ntr[1], 0);
      { DrawTriangles;ReadKey;{ }
      Optim(ntr[2], 0);
      { DrawTriangles;ReadKey;{ }
    end
    else
    begin
      inc(nrej1);
      if (it1 = -2) then
        inc(nrej2);
    end;
  end;

  {
    Str(nrej2,s);
    OutTextXY(0,0,'‘®¢¯ ¢è¨å â®ç¥ª: '+s);

    Str(nrej1,s);
    OutTextXY(0,20,'Žâ¡à®è¥­­­ëå â®ç¥ª: '+s);
    Str(Ntri,s);
    OutTextXY(0,40,'’à¥ã£®«ì­¨ª®¢: '+s);
  }
end;

{ ============================================================== }
{ VORONOI TESSELATION }
{ ================================================================ }
function CkTurnNew(Tri: TGLPolygon): Integer; // Tri: xyPolygon

var
  aux: double;

begin
  aux := (Tri[2].y - Tri[1].y) * (Tri[3].x - Tri[1].x) - (Tri[3].y - Tri[1].y) *
    (Tri[2].x - Tri[1].x);
  if (aux > DBERR) then
  begin
    CkTurnNew := 1;
    exit
  end;
  if (aux < -DBERR) then
  begin
    CkTurnNew := -1;
    exit
  end;
  if 1 = -1 then
    aux := 0
  else
    aux := (Tri[3].x - Tri[2].x) * (Tri[2].x - Tri[1].x) + (Tri[3].y - Tri[2].y)
      * (Tri[2].y - Tri[1].y);

  if (aux <= -DBERR) then
  begin
    CkTurnNew := 1;
    exit
  end;
  if (aux >= DBERR) then
  begin
    CkTurnNew := 0;
    exit;
  end;
  CkTurnNew := 2;
end;

function TTess.GetNumNextTriCW(Nv, Nt: longint): longint;
var
  Result: longint;
begin
  if Nv = vt1^[Nt] then
    Result := nt3^[Nt]
  else if Nv = vt2^[Nt] then
    Result := nt1^[Nt]
  else if Nv = vt3^[Nt] then
    Result := nt2^[Nt]
  else
  begin
    Result := -1;
    { Writeln('Error GetNumPrevTriCW');{ }
  end; { }
  GetNumNextTriCW := Result;
end;

function TTess.GetNumPrevTriCW(Nv, Nt: longint): longint;
var
  Result: longint;
begin
  if Nv = vt1^[Nt] then
    Result := nt1^[Nt]
  else if Nv = vt2^[Nt] then
    Result := nt2^[Nt]
  else if Nv = vt3^[Nt] then
    Result := nt3^[Nt]
  else
  begin
    Result := -1;
    { Writeln('Error GetNumPrevTriCW');{ }
  end; { }
  GetNumPrevTriCW := Result;
end;

function TTess.GetNumFirstTriCW(Nv, Nt: longint): longint;
var
  Result, FromNt: longint;
begin
  FromNt := Nt;
  repeat
    Result := Nt;
    Nt := GetNumPrevTriCW(Nv, Nt);
  until ((Nt < 0) or (Nt = FromNt)); { Found first or made turn }
  GetNumFirstTriCW := Result;
end;

// ------------------------------------------------------------
procedure TTess.Voronoi;

  function FindTri(x, y: Real; tr: longint; var option: longint): longint;
  var
    ii: Byte;
    aux, Newtr, PrevTr: longint;
    area, x21, x31, y21, y31: Real;
    i1, ind1, ind2: longint;
  label
    the_end;

  begin
    option := 0;
    Newtr := tr;
    repeat
      aux := 0;
      i1 := Jnd[0];
      ind1 := vt1^[Newtr];
      ind2 := vt2^[Newtr];
      x31 := x - px^[ind1];
      y31 := y - py^[ind1];
      x21 := px^[ind2] - px^[ind1];
      y21 := py^[ind2] - py^[ind1];
      area := y31 * x21 - y21 * x31;
      if (area < 0) then
      begin
        Newtr := nt1^[Newtr];
        if (Newtr = -1) then
        begin
          FindTri := Newtr;
          exit;
        end;
        aux := 1;
        goto the_end;
      end;
      if (area = 0) then
        if ((x31 = 0) and (y31 = 0)) then
        begin
          option := -2;
          FindTri := Newtr;
          exit;
        end;
      { --------------------------- }
      i1 := Jnd[1];
      ind1 := vt2^[Newtr];
      ind2 := vt3^[Newtr];
      x31 := x - px^[ind1];
      y31 := y - py^[ind1];
      x21 := px^[ind2] - px^[ind1];
      y21 := py^[ind2] - py^[ind1];
      area := y31 * x21 - y21 * x31;
      if (area < 0) then
      begin
        Newtr := nt2^[Newtr];
        if (Newtr = -1) then
        begin
          FindTri := Newtr;
          exit;
        end;
        aux := 1;
        goto the_end;
      end;
      if (area = 0) then
        if ((x31 = 0) and (y31 = 0)) then
        begin
          option := -2;
          FindTri := Newtr;
          exit;
        end;
      { -------------------------- }
      i1 := Jnd[2];
      ind1 := vt3^[Newtr];
      ind2 := vt1^[Newtr];
      x31 := x - px^[ind1];
      y31 := y - py^[ind1];
      x21 := px^[ind2] - px^[ind1];
      y21 := py^[ind2] - py^[ind1];
      area := y31 * x21 - y21 * x31;
      if (area < 0) then
      begin
        Newtr := nt3^[Newtr];
        if (Newtr = -1) then
        begin
          FindTri := Newtr;
          exit;
        end;
        aux := 1;
        goto the_end;
      end;
      if (area = 0) then
        if ((x31 = 0) and (y31 = 0)) then
        begin
          option := -2;
          FindTri := Newtr;
          exit;
        end;
    the_end:
      ;
    until aux <> 1;
    FindTri := Newtr;
  end;

var
  I, J, k: longint;
  vtNum: Byte;
  KOut, PrevX, PrevY: Real;

  Center: PointType;
  NPoly, Nt, option: longint;
  Poly: xyPolygon;
  p1, p2, p3, mp1, mp2, Intp, intp1, pc: rxycoord;
  l1, l2, ile1, ile2: implineeq;
  ple, ple1, ple2: paralineeq; { not in use }
  ls1, ls2: rlineseg; { not in use }
  IntExists: Boolean;
  VorFile: Text;
  s: String;
  OutOff: Boolean;

const
  ViewMinY = 0;
  ViewMaxY = 400;
  ViewMinX = 0;
  ViewMaxX = 400;

begin
  Fillchar(VorPol^, Sizeof(VorPol^), #0);
  if IsFracture then
    s := FExpand(fFracture)
  else
    s := FExpand(fTexture);
  Assign(VorFile, s);
  Rewrite(VorFile);

  SortNtCW;

  Nt := 1;
  PrevX := -1000;
  PrevY := -1000;
  for I := 0 to Npts - 1 do
  begin
    Fillchar(TriArr^, Sizeof(TriArr^), #0);
    k := 0;
    for J := 0 to Ntri do { find all triangles with I point }
    begin
      if (vt1^[J] = I) or (vt2^[J] = I) or (vt3^[J] = I) then
      begin
        inc(k);
        TriArr^[k] := J;
      end;
    end;
    Writeln(VorFile, 'P', I + 1, ',', round(px^[I]), ',', round(py^[I]), ',',
      round(pz^[I]));

    Nt := GetNumFirstTriCW(I, TriArr^[1]);
    for J := 0 to k do
    begin
      if Nt < 0 then
        Continue;
      p1.x := px^[vt1^[Nt]];
      p1.y := py^[vt1^[Nt]];
      p2.x := px^[vt2^[Nt]];
      p2.y := py^[vt2^[Nt]];
      p3.x := px^[vt3^[Nt]];
      p3.y := py^[vt3^[Nt]];

      pc.x := ((p1.x + p2.x + p3.x) / 3);
      pc.y := ((p1.y + p2.y + p3.y) / 3); { }

      vtNum := 0;
      if (vt1^[Nt] = I) then
        vtNum := 1;
      if (vt2^[Nt] = I) then
        vtNum := 2;
      if (vt3^[Nt] = I) then
        vtNum := 3;
      case vtNum of
        0:
          begin
            { writeln ('Error in voronoi I=',I,',Nt=',nt,' Vertix I not found in nt');{ }
          end;
        1:
          begin
            MidPoint(p1, p2, mp1);
            LineEquation(0, p1, p2, l1, ple);
            MidPoint(p1, p3, mp2);
            LineEquation(0, p1, p3, l2, ple);
          end;
        2:
          begin
            MidPoint(p2, p1, mp1);
            LineEquation(0, p2, p1, l1, ple);
            MidPoint(p2, p3, mp2);
            LineEquation(0, p2, p3, l2, ple);
          end;
        3:
          begin
            MidPoint(p3, p1, mp1);
            LineEquation(0, p3, p1, l1, ple);
            MidPoint(p3, p2, mp2);
            LineEquation(0, p3, p2, l2, ple);
          end;
      end;
      LinePntPerpend(l1, mp1, ile1);
      LinePntPerpend(l2, mp2, ile2);
      Intersect(0, ile1, ile2, ple1, ple2, ls1, ls2, Intp, IntExists); { }
      if IntExists then
      begin
        if Abs(Intp.x) > 10000 then
          Intp.x := Sign(Intp.x) * 10000;
        if Abs(Intp.y) > 10000 then
          Intp.y := Sign(Intp.y) * 10000;
        (*
          if (FindTri(Intp.x,Intp.y,nt,Option)<-1) or (Option<>-2) then
          begin
          Poly[1].x:=Intp.x; {to midle side if out off triangle}
          Poly[1].y:=Intp.y;

          OutOff:=False;

          Poly[2].x:=Px^[vt1^[nt]];
          Poly[2].y:=Py^[vt1^[nt]];
          Poly[3].x:=Px^[vt2^[nt]];
          Poly[3].y:=Py^[vt2^[nt]];
          if ckTurnNew(Poly)=1 then
          begin
          Intp.x:=(Poly[2].x+Poly[3].x)/2;
          Intp.y:=(Poly[2].y+Poly[3].y)/2;
          Writeln(VorFile,'{ '#9'Out off }');
          end;

          Poly[2].x:=Px^[vt2^[nt]];
          Poly[2].y:=Py^[vt2^[nt]];
          Poly[3].x:=Px^[vt3^[nt]];
          Poly[3].y:=Py^[vt3^[nt]];
          if ckTurnNew(Poly)=1 then
          begin
          OutOff:=True;
          Intp.x:=(Poly[2].x+Poly[3].x)/2;
          Intp.y:=(Poly[2].y+Poly[3].y)/2;
          Writeln(VorFile,'{ '#9'Out off }');
          end;

          Poly[2].x:=Px^[vt3^[nt]];
          Poly[2].y:=Py^[vt3^[nt]];
          Poly[3].x:=Px^[vt1^[nt]];
          Poly[3].y:=Py^[vt1^[nt]];
          if ckTurnNew(Poly)=1 then
          begin
          OutOff:=True;
          Intp.x:=(Poly[2].x+Poly[3].x)/2;
          Intp.y:=(Poly[2].y+Poly[3].y)/2;
          Writeln(VorFile,'{ '#9'Out off }');
          end;
          end
          else
          begin
          {          if GetNumPrevTriCW(I,nt)<0 then
          Writeln(VorFile, round(Px^[I]),',',round(Py^[I]));{}
          end;
          (* *)
        if (FindTri(Intp.x, Intp.y, Nt, option) = -1) or (option < -2) then
          KOut := -500
        else
          KOut := 500;

        if GetNumPrevTriCW(I, Nt) < 0 then { First triangle }
        begin
          case vtNum of
            1:
              MidPoint(p1, p2, mp1);
            2:
              MidPoint(p2, p3, mp1);
            3:
              MidPoint(p3, p1, mp1);
          end;
          KOut := KOut / Sqrt((mp1.x - Intp.x) * (mp1.x - Intp.x) +
            (mp1.y - Intp.y) * (mp1.y - Intp.y));
          mp2.x := Intp.x + KOut * (mp1.x - Intp.x);
          mp2.y := Intp.y + KOut * (mp1.y - Intp.y);
          Writeln(VorFile, mp2.x:1:0, ',', mp2.y:1:0); { }
        end; { First triangle }
        {
          if (Intp.X<-100)or(Intp.X>500) then Intp.X:=PrevX;
          if (Intp.Y<-100)or(Intp.Y>500) then Intp.Y:=PrevY;

          if (Intp.X=PrevX)and(Intp.Y=PrevY) then Continue; }

        Writeln(VorFile, Intp.x:1:0, ',', Intp.y:1:0);
        PrevX := Intp.x;
        PrevY := Intp.y;

        if GetNumNextTriCW(I, Nt) < 0 then { Last triangle }
        begin
          case vtNum of
            1:
              MidPoint(p3, p1, mp1);
            2:
              MidPoint(p1, p2, mp1);
            3:
              MidPoint(p2, p3, mp1);
          end;
          KOut := KOut / Sqrt((mp1.x - Intp.x) * (mp1.x - Intp.x) +
            (mp1.y - Intp.y) * (mp1.y - Intp.y));
          mp2.x := Intp.x + KOut * (mp1.x - Intp.x);
          mp2.y := Intp.y + KOut * (mp1.y - Intp.y);
          {
            if (Intp.X<-100)or(Intp.X>500) then Intp.X:=PrevX;
            if (Intp.Y<-100)or(Intp.Y>500) then Intp.Y:=PrevY;

            if (Intp.X=PrevX)and(Intp.Y=PrevY) then Continue; }

          Writeln(VorFile, mp2.x:1:0, ',', mp2.y:1:0); { }
          PrevX := Intp.x;
          PrevY := Intp.y;
        end; { Last triangle }
      end
      else
      begin
        Writeln(VorFile, '{'#9'Bad triangle}');
        Writeln(VorFile, '{'#9'I=', I, ',nt=', Nt, '}');

        Writeln(VorFile, '{', #13, #13,

          '            (', vt2^[Nt]:3, ') (', px^[vt2^[Nt]]:5:1, ',',
          py^[vt2^[Nt]]:5:1, ')', #13, '             / \                ', #13,
          '            /   \               ', #13, '        ', nt1^[Nt]:3,
          '/     \', nt2^[Nt]:3, #13, '          / <', Nt:3, '> \             ',
          #13, '         /         \            ', #13, '      (', vt1^[Nt]:3,
          ')------(', vt3^[Nt]:3, ') (', px^[vt3^[Nt]]:5:1, ',', py^[vt3^[Nt]]:5
          :1, ') ', #13, '             ', nt3^[Nt]:3, #13, '      (',
          px^[vt1^[Nt]]:5:1, ',', py^[vt1^[Nt]]:5:1,
          ')                   ', #13,

          #13, '}');
        (* & *)
      end;
      Nt := GetNumNextTriCW(I, Nt);
    end; { for J }
    Writeln(VorFile, '*');
  end;
  Close(VorFile);
end;

procedure TTess.SortNtCW;

{ sub } procedure SwapLL(var a, b: longint);
  var
    T: longint;
  begin { SwapLL }
    T := a;
    a := b;
    b := T;
  end; { SwapLL }

var
  I, Nt, vt1I, vt2I, vt3I: longint;

  { snt1, snt2, snt3: array [0..200] of longint;{~~~for trace~~~ }

begin { SortNtCW }
  (*
    for i:=0 to Ntri do             {---for trace---}
    begin                           {---for trace~~~}
    snt1[I]:=nt1^[I]+1;           {---for trace~~~}
    snt2[I]:=nt2^[I]+1;           {---for trace~~~}
    snt3[I]:=nt3^[I]+1;           {---for trace~~~}
    end;                            {~~~for trace~~~}(* *)
  for I := 0 to Ntri do
  begin
    vt1I := vt1^[I];
    vt2I := vt2^[I];
    vt3I := vt3^[I];

    Nt := 4 + 2 + 1; { 111b }                       { find number of Nt1 }

    if (nt1^[I] <> -1) then
      if (vt3I <> vt1^[nt1^[I]]) and (vt3I <> vt2^[nt1^[I]]) and
        (vt3I <> vt3^[nt1^[I]]) then
        Nt := 1 { nt:=001b }
      else
        Nt := Nt xor 1; { nt:=110b }
    if (Nt <> 1) then
    begin
      if (nt2^[I] <> -1) then
        if (vt3I <> vt1^[nt2^[I]]) and (vt3I <> vt2^[nt2^[I]]) and
          (vt3I <> vt3^[nt2^[I]]) then
          Nt := 2 { nt:=010b }
        else
          Nt := Nt xor 2; { nt:=10?b }
      if (Nt <> 2) then
        if (nt3^[I] <> -1) then
          if (vt3I <> vt1^[nt3^[I]]) and (vt3I <> vt2^[nt3^[I]]) and
            (vt3I <> vt3^[nt3^[I]]) then
            Nt := 4 { nt:=100b }
          else
            Nt := Nt xor 4; { nt:=0??b }
      if ((Nt and 1) <> 1) then
        if Nt = 0 then
        begin
          { !!! ERROR All near triangles have vt3^[J] !!! }
        end
        else if Nt = 4 { 100b } then
          SwapLL(nt1^[I], nt3^[I])
        else
          SwapLL(nt1^[I], nt2^[I]);
    end;
    Nt := 2;
    if (nt2^[I] <> -1) and { is nt2 real nt3? }
      (vt2I <> vt1^[nt2^[I]]) and (vt2I <> vt2^[nt2^[I]]) and
      (vt2I <> vt3^[nt2^[I]]) then
      Nt := 3;
    if (nt3^[I] <> -1) and { is nt3 real nt2? }
      (vt1I <> vt1^[nt3^[I]]) and (vt1I <> vt2^[nt3^[I]]) and
      (vt1I <> vt3^[nt3^[I]]) then
      Nt := 3;
    { if nt3 is real nt2 then swap(nt2,nt3) }
    if (Nt = 3) then
      SwapLL(nt2^[I], nt3^[I]);
  end;

end; // SortNtCW

end.
