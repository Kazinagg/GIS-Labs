unit mlTwo;

interface

uses
  System.Math,
  Vcl.ExtCtrls,
  mlRanDist,
  mlGlobals,
  mlGraph,
  mlVoronoi;

const
  NSeed:Longint = 232{MAXPTS div 2};
  Crack:Longint = MAXPTS div 4;
  MaxXimg =  400;
  MaxYimg =  400;
  MaxPixel=  MaxXimg*MaxYimg;

  LoadImages = True;    { if True then loading from disk }
  SaveImages = True;    { if TRUE then recording on disk }
  {MaxSlices  = 12;}       (* number of slices in image *)
var
  Tess : PTess;
  NeedClear : Boolean;
  NCrack, NPoisson: Integer;
type
   TCrystal = record
     Xg,Yg: Integer;     { positive and negative coordinates }
     Layer: Byte;
     Cg: Word;          { to define colorID of a crystal }
     IsReady: boolean;   { to finish growth }
   end;

   PCrystals = ^TCrystals;
   TCrystals = array[1..MAXPTS] of TCrystal;

   PArea = ^TArea;
   TArea = array[1..MaxMineral+2+100] of Longint;  {+black and  white }


procedure TwoDim(Dm:TLm; Mineral:TMineral; NTarget: word);

//---------------------------------------------------------
implementation
//---------------------------------------------------------

var
  Image     : TImage;
  Area:PArea;
  Crystals: PCrystals;
  CumLm:TLm;
  IsDelaunay, IsVoronoi, IsAggregate:Boolean;

{=========================================}

procedure SetImageWin;
var
  ViewPort: ViewPortType;
begin
  GetViewSettings(ViewPort);
  with ViewPort do
  begin
    x1:= MaxX div 2 - MaxXimg div 2-90;
    x2:= MaxX div 2 + MaxXimg div 2-90+1;
    y1:= MaxY div 2 - MaxYimg div 2+10;
    y2:= MaxY div 2 + MaxYimg div 2+10+1;
    SetViewPort(x1, y1, x2, y2, ClipOn);
  end;
end;

procedure CumContent(Dm:TLm);
var
  i,j,C: word;
  Rg,R: Real;
begin
  FillChar(CumLm,SizeOf(CumLm),0);
  Rythm:=0;
  for I:=1 to MineralCount do Rythm:=Rythm+10*Dm[i];      { sum }
  Rg:=0;
  for I:=1 to MineralCount do
  begin
    Rg:=Rg+10*Dm[I];
    CumLm[I]:=Rg;
  end;
end;

procedure CalcAreas(var Area:PArea;var Dm:TLm);
var
  I,J,K: Integer;
  PixelColor, PrevColor: word;
  Lm:TLm;
begin
  FillChar(Area^, Sizeof(Area^),0);
  FillChar(Lm, Sizeof(Lm),0);
  FillChar(Dm, Sizeof(Dm),0);
  PrevColor:=GetPixel(1,1);
  for J:=1 to MaxYimg do
  for I:=1 to MaxXimg do
  begin
    PixelColor:=GetPixel(I,J);
    case PixelColor of
      Black: Inc(Area^[MineralCount+1]);
      White: Inc(Area^[MineralCount+2]);
      else
      begin
        for K:=1 to MineralCount do
        begin
          if (PixelColor=MColor[K]) then Break; { to find index in array}
        end;
        Inc(Area^[K]);{}
      end;
    end;
    if (I=1) or (PixelColor<>PrevColor)
       {and (PixelColor<>White)}
    then
      Lm[K]:=Lm[K]+1;
    {if (PixelColor<>White) then}
      PrevColor:=PixelColor;
  end;
  for I:=1 to MineralCount do
    if Lm[I]<>0 then
      Dm[I]:=round(Area^[I]/Lm[I]);
end;

{--------------------------------------------------}
procedure Legend(Mineral:TMineral; Dm:TLm; Area: PArea);
var
  ViewPort:ViewPortType;
  I,StepY:word;
  S:String[12];
  AreaTotal:Longint;
  PerCent:Real;

begin
  SetDefaultColors;
  MainViewPort;
  GetViewSettings(ViewPort);
  with ViewPort do
  begin
    SetViewPort(x2-x1-180, y1+1, x2-x1-2, y2-1, ClipOff);
    Bar(0, 0, x1+180, y2-17);
    Rectangle(0, 0, x1+180, y2-17);
    SetTextJustify(LeftText, BottomText);
    SetTextStyle(DefaultFont, HorizDir, 1);
    StepY:=8;
    OutTextXY(5*TextWidth('B'), TextHeight('B')+StepY,'Mineral');
    SetTextJustify(LeftText, BottomText);
    StepY:=StepY+2*TextHeight('B');
    for I:=1 to MineralCount do
    begin
      SetFillStyle(1,MColor[I]);
      if MColor[I]=7 then
        Rectangle(10, StepY, 25, StepY+TextHeight('H')-2)
      else
        Bar(10, StepY, 25, StepY+TextHeight('H')-2);
      OutTextXY(5*TextWidth('B'), StepY+TextHeight('H'), Mineral[i]);
      StepY:=StepY+TextHeight('H')+2;
    end;
    StepY:=StepY+5;
    Line(0, StepY, MaxX, StepY);

    SetDefaultColors;
    AreaTotal:=0; Percent:=0;
    StepY:=StepY+TextHeight('H');
    SetTextJustify(LeftText, BottomText);

    for I:=1 to MineralCount+2 do AreaTotal:=AreaTotal+Area^[i];
    OutTextXY(5*TextWidth('W'),
              StepY+2*TextHeight('H'),'Area    %     Lm');
    StepY:=StepY+2*TextHeight('H')+5;
    SetTextJustify(RightText, BottomText);
    for I:=1 to MineralCount do
    begin
      SetFillStyle(1,MColor[I]);
      if MColor[I]=7 then
        Rectangle(10, StepY, 25, StepY+TextHeight('H')-2)
      else
        Bar(10, StepY, 25, StepY+TextHeight('H')-2);
      Str(Area^[I],S);
      OutTextXY(10*TextWidth('W'), StepY+TextHeight('H'), S);
      if (AreaTotal<>0) then
        PerCent:=100*Area^[I]/AreaTotal
      else
        PerCent:=0;
      Str(PerCent:4:1,S);
      OutTextXY(16*TextWidth('M'), StepY+TextHeight('H'), S);
      Str(Dm[I]:4:0,S);
      OutTextXY(21*TextWidth('M'), StepY+TextHeight('H'), S);
      StepY:=StepY+TextHeight('H')+2;
    end;
    StepY:=StepY+2;
    Line(0, StepY, MaxX, StepY);
    StepY:=StepY+5;
    Str(Area^[MineralCount+1],S);
    OutTextXY(10*TextWidth('W'), StepY+TextHeight('H'), S);
    SetFillStyle(1,Black);
    Bar(10, StepY, 25, StepY+TextHeight('H')-2);
    if (AreaTotal<>0) then
      PerCent:=100*Area^[MineralCount+1]/AreaTotal
    else
      PerCent:=0;
    Str(PerCent:4:1,S);
    OutTextXY(16*TextWidth('M'), StepY+TextHeight('H'), S);
    {
    S:='0';  if IsVoronoi then  S:='2';
    OutTextXY(21*TextWidth('M'), StepY+TextHeight('H'), S);
    }
    StepY:=StepY+TextHeight('H')+2;
    SetFillStyle(1,White);
    Bar(10, StepY,25, StepY+TextHeight('H')-2);
    Str(Area^[MineralCount+2],S);
    OutTextXY(10*TextWidth('W'), StepY+TextHeight('H'), S);
    if (AreaTotal<>0) then
      PerCent:=100*Area^[MineralCount+2]/AreaTotal
    else
      PerCent:=0;
    Str(PerCent:4:1,S);
    OutTextXY(16*TextWidth('M'), StepY+TextHeight('H'), S);
   {
    S:='0';
    if IsParticle then  S:='0';
    OutTextXY(21*TextWidth('M'), StepY+TextHeight('H'), S);
   }
    StepY:=StepY+TextHeight('H')+2;
    Line(0, StepY, MaxX, StepY);
    Str(AreaTotal,S);
    OutTextXY(10*TextWidth('M'), StepY+TextHeight('H')+5, S);
    Percent:=0;
    for I:=1 to MineralCount+2 do Percent:=Percent+100*Area^[I]/AreaTotal;
    Str(PerCent:4:1,S);
    OutTextXY(16*TextWidth('M'), StepY+TextHeight('H')+5, S);
    Rythm:=0;
    for I:=1 to MineralCount do Rythm:=Rythm+Dm[I];
    Str(Rythm:10:0,S);
    OutTextXY(21*TextWidth('M'), StepY+TextHeight('H')+5, S);

    StepY:=StepY+2*TextHeight('H')+2;
    Line(0, StepY, MaxX, StepY);
  end; { with }
end;  { Legend }

{sub}procedure SeedGerms(ASeed:Longint;Dm:TLm);
var
  I,J,C: word;
  Rg: Word;      {random number for crystals}
  RandNum,XStart, YStart:Word;

begin
  FillChar(Crystals^,Sizeof(Crystals^),0);
  CumContent(Dm);
  I:= 0; Rg:=0; XStart:=0; YStart:=0;
  Tess^.Npts:=ASeed;
  for I:=1 to ASeed do
  begin
    with Crystals^[I] do
    begin
      RandNum := round(RandUniform(-100,MaxXimg+100));{}
{     RandNum := round(RandUniform(0,XLay));{}
      Xg := RandNum; Tess^.Px^[I-1]:=Xg;
      RandNum := round(RandUniform(-100,MaxYimg+100));{}
{      RandNum := round(RandUniform(0,YLay));{}
      Yg := RandNum; Tess^.Py^[I-1]:=Yg;
      Rg := Random(round(Rythm));
      if (Rg<=CumLm[1]) then
      begin
        Cg:=1;     { fist class }
        Tess^.Pz^[I-1]:=Cg;
      end;
      for J:=2 to MineralCount do
      begin
        if (Rg<=CumLm[J]) and (Rg>CumLm[J-1]) then
        begin
          Cg:=J;
          Tess^.Pz^[I-1]:=Cg;
          Break;
        end;
      end;
      Layer := 1;
      IsReady := False;
    end;
  end;
end; { SeedCrystals }

{===============================================================}
{-                  DRAW Square POLYGONS                       -}
{---------------------------------------------------------------}
procedure CrystalGrowth(Dm:TLm; Mineral:TMineral);

var
  I,J,K,L : Longint;
  ViewPort    : ViewPortType;
  Color: Word;
  Step,PixelColor: Word;
  S: string;
  Border: boolean;

begin
  MainViewPort;
  GetViewSettings(ViewPort);
  SetDefaultColors;
  SetTextJustify(CenterText, BottomText);
  Bar((MaxX-150) div 2-120, 3*TextHeight('H'),
      (MaxX-150) div 2+120, 4*TextHeight('H'));
  SetTextJustify(CenterText, BottomText);
  S:='Calculating.., please, wait !';
  OutTextXY((MaxX-150) div 2, 4*TextHeight('H'), s);
  SetImageWin;
  GetViewSettings(ViewPort);
  with ViewPort do
  begin
     SetFillStyle(1,Black);
     Bar(0,0,MaxXImg+1,MaxYImg+1);     { Need for calculation. Don't delete It !!!}
     { germs - centers of crystals !}
      K:=0;
      for I:=1 to NSeed do
      begin
        with Crystals^[I] do
        begin
          Color:=MColor[Cg];
          PutPixel(Xg, Yg, Color);
        end;
        Inc(K);
      end;
      {other points of crystals}
      while True {(K<=MaxPixel)} do                { to count pixels }
      begin
        I := 1; Inc(K);
        while (I<=NSeed) do                  { to count grains }
        begin
          with Crystals^[I] do
          if (IsReady=False) then
          begin
            IsReady:=true;
            Xg:=Xg+1;    Yg:=Yg;
            if ((Xg>0) and (Xg<=MaxXimg)) and
               ((Yg>0) and (Yg<=MaxYimg)) then
            begin
              PixelColor:=GetPixel(Xg, Yg);
              if (PixelColor=Black) then            { Empty space }
              begin
                Color:=MColor[Cg];
                PutPixel(Xg, Yg, Color);
                Inc(K);
                IsReady:=False;
              end
            end;
            L:=1;
            while (L<(Layer*2)-1) do
            begin
              Inc(L);
              Xg:=Xg;  Yg:= Yg+1;
              if ((Xg>0) and (Xg<=MaxXimg)) and
                 ((Yg>0) and (Yg<=MaxYimg)) then
              begin
                PixelColor:=GetPixel(Xg, Yg);
                if (PixelColor=Black) then
                begin
                  Color:=MColor[Cg];
                  PutPixel(Xg, Yg, Color);
                  Inc(K);
                  IsReady:= False;
                end
              end
            end;
            L:=1;
            while (L<(Layer*2)) do
            begin
              Inc(L);
              Xg:=Xg-1;  Yg:= Yg;
              if ((Xg>0) and (Xg<=MaxXimg)) and
                 ((Yg>0) and (Yg<=MaxYimg)) then
              begin
                PixelColor:=GetPixel(Xg, Yg);
                if (PixelColor=Black) then
                begin
                  Color:=MColor[Cg];
                  PutPixel(Xg, Yg, Color);
                  Inc(K);
                  IsReady:= False;
                end
              end
            end; { side 2 }
            L:=1;
            while (L<(Layer*2)) do
            begin
              Inc(L);
              Xg:=Xg;  Yg:= Yg-1;
              if ((Xg>0) and (Xg<=MaxXimg)) and
                 ((Yg>0) and (Yg<=MaxYimg)) then
              begin
                PixelColor:=GetPixel(Xg, Yg);
                if (PixelColor=Black) then
                begin
                  Color:=MColor[Cg];
                  PutPixel(Xg, Yg, Color);
                  Inc(K);
                  IsReady:= False;
                end
              end
            end; { side 3 }
            L:=1;
            while (L<(Layer*2)) do
            begin
              Inc(L);
              Xg:=Xg+1;  Yg:= Yg;
              if ((Xg>0) and (Xg<=MaxXimg)) and
                 ((Yg>0) and (Yg<=MaxYimg)) then
              begin
                PixelColor:=GetPixel(Xg, Yg);
                if (PixelColor=Black) then
                begin
                  Color:=MColor[Cg];
                  PutPixel(Xg, Yg, Color);
                  Inc(K);
                  IsReady:= False;
                end
              end
            end; { side 4 }
            Layer:=Layer+1;                             { Next Layer }
            Inc(I);
            if Keypressed then Exit;
          end
          else Inc(I);
        end;  { with Grn[I] }
       If K>MaxPixel+1000 then Break;             { why 1000 ??? }
     end; {while k}
   if LoadImages then
   begin
    {
    LoadImg('Ml' + Int2Str(MineralCount) + '.img', Image);
    PutImage(0, 0, Image.Img^, XorPut);
    FreeImg(Image);
    {}
   end
   {
   if SaveImages then
   begin
      CatchImg(0, 0, MaxXimg, MaxYimg, Image);
      SaveImg('Ml' + Int2Str(MColor[NTarget]) + '.img', Image);
      FreeImg(Image);
   end;
   }
  end; { ViewPort }
  FillChar(Area^, SizeOf(Area^),0);
  CalcAreas(Area,Dm);
  SetDefaultColors;
  Legend(Mineral, Dm, Area);
  MainViewPort;
  GetViewSettings(ViewPort);
  SetDefaultColors;
  S:='Growth of Square Grains';
  Bar((MaxX-150) div 2-120,3*TextHeight('B'),
      (MaxX-150) div 2+120,4*TextHeight('B'));
  SetTextJustify(CenterText, BottomText);
  OutTextXY((MaxX-150) div 2, 4*TextHeight('B'),s);
end; { SquareGrains }

{===============================================================}
{-                  DRAW Square POLIGONS                       -}
{---------------------------------------------------------------}
procedure DelVor(Dm:TLm; Mineral:TMineral);
type
  PPolygon=^TPolygon;
  TPolygon=array[1..MaxYimg] of PointType;

var
  I,J,K,L : Longint;
  ViewPort    : ViewPortType;
  Color: Word;
  Polygon:PPolygon;
  Rg, ColorCurr, ColorPrev, ColorNext:Word;
  VorFile: Text;
  S,Sx,Sy,Line: String;
  C, Xpnt, Ypnt, Cpnt, IL:Integer;

begin    { body of DelVor }
  New(Polygon);
  MainViewPort;
  GetViewSettings(ViewPort);

  SetDefaultColors;
  SetTextJustify(CenterText, BottomText);
  Bar((MaxX-150) div 2-120, 3*TextHeight('H'),
      (MaxX-150) div 2+120, 4*TextHeight('H'));
  s:='Calculating.., please, wait !';
  OutTextXY((MaxX-150) div 2, 4*TextHeight('H'), s);
  with Tess^ do           { additional points }
  begin
    Npts:=NSeed;
    SetImageWin;
    GetViewSettings(ViewPort);
    with ViewPort do
    begin
      if NeedClear then
      begin
        SetFillStyle(1,Black);
        Bar(0,0,MaxXImg+1,MaxYImg+1);
        NPoisson:=0;
        NCrack:=0;
      end;
      Delaunay;
      if IsDelaunay then
      for I:=0 to Ntri do
      begin
        Polygon^[1].X:=round(Px^[vt1^[I]]);
        Polygon^[1].Y:=round(Py^[vt1^[I]]);
        Polygon^[2].X:=round(Px^[vt2^[I]]);
        Polygon^[2].Y:=round(Py^[vt2^[I]]);
        Polygon^[3].X:=round(Px^[vt3^[I]]);
        Polygon^[3].Y:=round(Py^[vt3^[I]]);
        Polygon^[4].X:=round(Px^[vt1^[I]]);
        Polygon^[4].Y:=round(Py^[vt1^[I]]);
        SetColor(White);
        DrawPoly(4,Polygon^);
      end;
      if (IsVoronoi)or(IsAggregate) then
      begin
        if (IsVoronoi)or(IsAggregate) then Voronoi;
        FillChar(Polygon^, SizeOf(Polygon^),#0);
        SetColor(Black);{}
        S:=FExpand(fTEXTURE);
        Assign(VorFile,S);
        Reset(VorFile);
        K:=0;
        while not Eof(VorFile) do
        begin
          ReadLn(VorFile, S);
          if S='' then Continue;
          if (S[1]='*') then
          begin
            if K=0 then Continue;
            SetFillStyle(1,MColor[Cpnt]);
            FillPoly(K,Polygon^);{}
            SetLineStyle(SolidLn,0,ThickWidth);{}
            if not IsAggregate then
            DrawPoly(K,Polygon^);{}
 {          SetColor(Black);{}
 {          SetFillStyle(1,MColor[Cpnt]);
            FillEllipse(Xpnt, Ypnt, 2, 2);  {}
            Continue;
          end;
          if (S[1]='{') then
            begin
              if Pos('}',s)>0 then Continue;
              while ((not Eof(VorFile)) and (S[1]<>'}'))do Read(VorFile,S[1]);
              if not Eof(VorFile) then Readln(VorFile);
              Continue;
            end;
          if (S[1]='P') then
          begin
            FillChar(Polygon^, SizeOf(Polygon^),#0);
            K:=0;
            Line:=Copy(S,1,Pos(',',S)-1);
            System.Delete(S,1,Length(Line)+1);
            Line:=Copy(S,1,Pos(',',S)-1);
            System.Delete(S,1,Length(Line)+1);
            Val(Line,Xpnt,C);
            Line:=Copy(S,1,Pos(',',S)-1);
            System.Delete(S,1,Length(Line)+1);
            Val(Line,Ypnt,C);
            Line:=S;
            Val(Line,Cpnt,C);
            Continue;
          end;
          Inc(K);
          Sx:=Copy(S,1,Pos(',',S)-1);
          System.Delete(S,1,Length(Sx)+1);
          Val(Sx,Polygon^[K].X,C);
          Sy:=S;
          Val(Sy,Polygon^[K].Y,C);
        end;
        Close(VorFile);
      end;
      SetLineStyle(SolidLn,0,NormWidth);{}
      Rectangle(0,0, MaxXimg+1, MaxYimg+1);
    end; { ViewPort }
  end;
  CalcAreas(Area,Dm);
  Legend(Mineral, Dm, Area);
  MainViewPort;
  GetViewSettings(ViewPort);
  SetDefaultColors;
  if IsVoronoi then S:='Voronoi Grains';
  if IsAggregate then S:='Aggregates of Voronoi Grains';
  if (not IsVoronoi)and(not IsAggregate) then
    S:='Delaunay Triangulation';

  Bar((MaxX-150) div 2-120,3*TextHeight('B'),
      (MaxX-150) div 2+120,4*TextHeight('B'));
  SetTextJustify(CenterText, BottomText);
  OutTextXY((MaxX-150) div 2, 4*TextHeight('B'),s);
  Dispose(Polygon);
end; { Delaunay  }

{--------------------------------------------------}
procedure RandomParticles(Dm:TLm; Mineral:TMineral);
type
  PPolygon=^TPolygon;
  TPolygon=array[1..MaxYimg] of PointType;

var
  I,J,K,L : Longint;
  ViewPort    : ViewPortType;
  Color: Word;
  Polygon:PPolygon;
  Rg, ColorCurr, ColorPrev, ColorNext:Word;
  VorFile: Text;
  S,Sx,Sy,Line: String;
  C, Xpnt, Ypnt, Cpnt, IL:Integer;

begin
  New(Polygon);
  MainViewPort;
  GetViewSettings(ViewPort);

  SetDefaultColors;
  SetTextJustify(CenterText, BottomText);
  Bar((MaxX-150) div 2-120, 3*TextHeight('H'),
      (MaxX-150) div 2+120, 4*TextHeight('H'));
  SetTextJustify(CenterText, BottomText);
  s:='Calculating.., please, wait !';
  OutTextXY((MaxX-150) div 2, 4*TextHeight('H'), s);
  with Tess^ do           { additional points }
  begin
    Npts:=Crack;
    SetImageWin;
    GetViewSettings(ViewPort);
    with ViewPort do
    begin
      Delaunay;
      Voronoi;
      SetColor(White);{}
      Rectangle(0,0, MaxXimg+1, MaxYimg+1);
      SetLineStyle(SolidLn,0,ThickWidth);{}
      FillChar(Polygon^, SizeOf(Polygon^),#0);
      S:=FExpand(fFracture);
      Assign(VorFile,S);
      Reset(VorFile);
      K:=0;
      while not Eof(VorFile) do
      begin
        ReadLn(VorFile, S);
        if S='' then Continue;
        if (S[1]='*') then
        begin
          if K=0 then Continue;
          DrawPoly(K,Polygon^);{}
          Continue;
        end;
        if (S[1]='{') then
          begin
            if Pos('}',s)>0 then Continue;
            while ((not Eof(VorFile)) and (S[1]<>'}'))do
              Read(VorFile,S[1]);
            if not Eof(VorFile) then Readln(VorFile);
            Continue;
          end;
        if (S[1]='P') then
        begin
          FillChar(Polygon^, SizeOf(Polygon^),#0);
          K:=0;
          Line:=Copy(S,1,Pos(',',S)-1);
          System.Delete(S,1,Length(Line)+1);
          Line:=Copy(S,1,Pos(',',S)-1);
          System.Delete(S,1,Length(Line)+1);
          Val(Line,Xpnt,C);
          Line:=Copy(S,1,Pos(',',S)-1);
          System.Delete(S,1,Length(Line)+1);
          Val(Line,Ypnt,C);
          Line:=S;
          Val(Line,Cpnt,C);
          Continue;
        end;
        Inc(K);
        Sx:=Copy(S,1,Pos(',',S)-1);
        System.Delete(S,1,Length(Sx)+1);
        Val(Sx,Polygon^[K].X,C);
        Sy:=S;
        Val(Sy,Polygon^[K].Y,C);
      end;
      Close(VorFile);
    end;
  end;
  CalcAreas(Area,Dm);
  Legend(Mineral, Dm, Area);
  MainViewPort;
  GetViewSettings(ViewPort);
  SetDefaultColors;
  S:='Voronoi Fracture';
  Bar((MaxX-150) div 2-120,3*TextHeight('B'),
      (MaxX-150) div 2+120,4*TextHeight('B'));
  SetTextJustify(CenterText, BottomText);
  OutTextXY((MaxX-150) div 2, 4*TextHeight('B'),s);
  Dispose(Polygon);
end; { RandomFracture }

{--------------------------------------------------}
procedure PoissonFracture(Dm:TLm; Mineral:TMineral);
var
  I,J,K,L : Longint;
  Xc,yc,r,alpha,betta: real;
  Xa,Ya,Xb,Yb : Real;
  ViewPort    : ViewPortType;
  Color: Word;
  Side1,Side2,PixelColor: Word;
  s: string;

begin   { PoissonFracture }
  MainViewPort;
  GetViewSettings(ViewPort);
  SetDefaultColors;

  SetImageWin;
  GetViewSettings(ViewPort);
  with ViewPort do
  begin
     SetColor(White);
     SetLineStyle(0,0,NormWidth);
     I:=0; Side1:=0; Side2:=0;
     {
     while (I<=Crack) do
     with Crystals^[I] do
     begin
       Inc(I);
       Side1:=round(RandUniform(1,4));
       case Side1 of
       1:begin
           Xa:=RandUniform(1,MaxXimg); Ya:=1;
         end;
       2:begin
           Xa:=MaxXimg; Ya:= RandUniform(1,MaxYimg);
         end;
       3:begin
           Xa:=RandUniform(1,MaxXimg); Ya:=MaxYimg;
         end;
       4:begin
           Xa:=1; Ya:= RandUniform(1,MaxYimg);
         end;
       end;
       repeat Side2:=round(RandUniform(1,4)); until Side2<>Side1;
       case Side2 of
       1:begin
           Xb:=RandUniform(1,MaxXimg); Yb:=1;
         end;
       2:begin
           Xb:=MaxXimg; Yb:= RandUniform(1,MaxYimg);
         end;
       3:begin
           Xb:=RandUniform(1,MaxXimg); Yb:=MaxYimg;
         end;
       4:begin
           Xb:=1; Yb:= RandUniform(1,MaxYimg);
         end;
       end;
       Line(round(Xa),round(Ya),round(Xb),round(Yb));
     end;
     {}

     Xc:= MaxXimg div 2;
     Yc:= MaxYimg div 2;
     R:=sqrt(xc*xc+yc*yc);
     for I:=1 to Crack do
     with Crystals^[I] do
     begin
       alpha:=Rad(Random(360));
       betta:=Rad(Random(360));
       Xa:=Xc+R*sin(alpha);
       Ya:=Yc+R*cos(alpha);
       Xb:=Xc+R*sin(betta);
       Yb:=Yc+R*cos(betta);
       Line(round(Xa),round(Ya),round(Xb),round(Yb));
     end;
     {}
  end;
  CalcAreas(Area,Dm);
  Legend(Mineral, Dm, Area);
  MainViewPort;
  GetViewSettings(ViewPort);
  SetDefaultColors;

  S:='Poisson Fracture';
  Bar((MaxX-150) div 2-120,3*TextHeight('B'),
      (MaxX-150) div 2+120,4*TextHeight('B'));
  SetTextJustify(CenterText, BottomText);
  OutTextXY((MaxX-150) div 2, 4*TextHeight('B'),s);
  SetDefaultColors;
end; { PoissonParticles }



procedure  MainScreen;
begin
  MainWindow;
  Menu('Growth Voronoi Aggregates Delaunay Fracture Poisson Reset');
  StatLine(' Help '+#179+' Esc - Return to Main Menu '+#179+
           ' Key 1..5 - Change Number of Germs');
  SetDefaultColors;
  Bar(0, 0, MaxX, MaxY);
  SetTextStyle(DefaultFont, HorizDir, 2);
  SetTextJustify(CenterText, BottomText);
  OutTextXY(MaxX div 2 - 80, TextHeight('B')+5,  '2D Ore Texture');
  SetTextStyle(DefaultFont, HorizDir, 1);
  SetTextJustify(LeftText, BottomText);
  OutTextXY(160, MaxYimg+6*TextHeight('H'),'Target:     '+Mineral[NTarget]);
  SetFillStyle(1,MColor[NTarget]);
  if MColor[NTarget]=7 then
    Rectangle(160+TextWidth('Target: '),     MaxYimg+5*TextHeight('H'),
              160+TextWidth('Target: ')+15,  MaxYimg+6*TextHeight('H')-2)
  else
    Bar(160+TextWidth('Target: '),    MaxYimg+5*TextHeight('H'),
        160+TextWidth('Target: ')+15, MaxYimg+6*TextHeight('H')-2);
  SetDefaultColors;
end; { MainScreen }

{========================================================================}
{-   Two Dimentional Mineral Liberation Respresentation  Model          -}
{------------------------------------------------------------------------}
procedure TwoDim(Dm:TLm; Mineral:TMineral; NTarget: Word);
var
  S:String[10];

label one;

begin
  MainScreen;
  Tess:=New(PTess, Init);
  New(Area);
  New(Crystals);
  NPoisson:=0;
  NCrack:=0;
  FillChar(Area^, SizeOf(Area^),0);
  SeedGerms(NSeed,Dm);
  CrystalGrowth(Dm,Mineral);
  repeat
    one:
    repeat
      Ch:= readkey;
    until not KeyPressed;
    if Ch = #0 then Ch := ReadKey;      { trap function keys }
    case Upcase(Ch) of
       'G','R': begin
              NeedClear:=True;
              SeedGerms(NSeed,Dm);
              CrystalGrowth(Dm,Mineral);
              NPoisson:=0;
              NCrack:=0;
            end;
       'D','S':
            begin
              IsDelaunay:=True;
              IsVoronoi:=False;
              IsAggregate:=False;
              Tess^.IsFracture:=False;
              DelVor(Dm,Mineral);
              NeedClear:=True;
              NPoisson:=0;
              NCrack:=0;
            end;
       'V': begin
              IsVoronoi:=True;
              IsDelaunay:=False;
              IsAggregate:=False;
              Tess^.IsFracture:=False;
              DelVor(Dm,Mineral);
              NeedClear:=False;
              NPoisson:=0;
              NCrack:=0;
            end;
       'A': begin
              IsAggregate:=True;
              IsDelaunay:=False;
              IsVoronoi:=False;
              Tess^.IsFracture:=False;
              DelVor(Dm,Mineral);
              NeedClear:=False;
              NPoisson:=0;
              NCrack:=0;
            end;
       'F': begin
              Inc(NCrack);
              if (NCrack>1) then
              begin NCrack:=1; Continue; end;
              SeedGerms(Crack,Dm);
              Tess^.IsFracture:=True;
              RandomParticles(Dm, Mineral);
              NeedClear:=True;
            end;
       'P': begin
              Inc(NPoisson);
              if (NPoisson>1) then
              begin NPoisson:=1; Continue; end;
              IsDelaunay:=False;
              IsVoronoi:=False;
              IsAggregate:=False;
              SeedGerms(Crack,Dm);
              PoissonFracture(Dm, Mineral);
            end;
       #49:begin
             NeedClear:=True;
             NSeed := MAXPTS div 1;
             SeedGerms(NSeed,Dm);
             CrystalGrowth(Dm,Mineral);
             NPoisson:=0;
             NCrack:=0;
           end;
       #50:begin
             NeedClear:=True;
             NSeed := MAXPTS div 2;
             SeedGerms(NSeed,Dm);
             CrystalGrowth(Dm,Mineral);
             NPoisson:=0;
             NCrack:=0;
           end;
       #51:begin
             NeedClear:=True;
             NSeed := MAXPTS div 4;
             SeedGerms(NSeed,Dm);
             CrystalGrowth(Dm,Mineral);
             NPoisson:=0;
             NCrack:=0;
           end;
       #52: begin
              NeedClear:=True;
              NSeed := MAXPTS div 8;
              SeedGerms(NSeed,Dm);
              CrystalGrowth(Dm,Mineral);
              NPoisson:=0;
              NCrack:=0;
            end;
       #53: begin
              NeedClear:=True;
              NSeed := MAXPTS div 16;
              SeedGerms(NSeed,Dm);
              CrystalGrowth(Dm,Mineral);
              NPoisson:=0;
              NCrack:=0;
            end;
       { Fracture keys }
       {
       #54: begin
              SeedCrystals(Crack,Dm);
              RandomParticles(Dm, Mineral);
              AfterFracture:=True;
            end;
       }
       #27: Break;
      else Goto one;               { to prevent redraw...}
    end;
  until Upcase(Ch)= #27;      { Esc }
  Dispose(Area);
  Dispose(Crystals);
  Tess^.Done;
end;

end.