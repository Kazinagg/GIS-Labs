{$N+}
program Crystals;

uses
  Graph, 
  Math, 
  uGlobals, 
  MlGraph;

const
  Seed = 1024;

  MaxXimg = 512{ div 2};
  MaxYimg = 256{ div 2};
  MaxPixel= MaxXimg*MaxYimg-(MaxXimg+MaxYimg);   {<131072 }

type
   PGrain = ^Grain;
   Grain = record
     Xg,Yg: integer;
     Layer: word;
     Phase: word;
     Ready: boolean;
   end;

var
  Grn:PGrain;
  i: word;
  k: longint;
  ch:char;

{=========================================}
procedure CircleCryst;

var
  I,J,K,L : Longint;
  xc,yc: word;
  r: real;
  xa,ya,xb,yb  : integer;
  ViewPort    : ViewPortType;
  Step,PixelColor: Word;
  s: string;

begin   {circle}
  GetViewSettings(ViewPort);
  with ViewPort do
  begin
    ClearViewPort;
    SetFillStyle(1,Black);
    s:='Circle';
    SetTextJustify(CenterText, BottomText);
    OutTextXY((x2-x1) div 2, TextHeight('B')+5,s);
    OutTextXY((x2-x1) div 2, (y2-y1)-5,'Please Wait...');

    xc:= (x2-x1) div 2;
    yc:= (y2-y1) div 2;
    r:=sqrt(xc*xc+yc*yc);

    SetColor(Cyan);
    SetLineStyle(0,0,NormWidth);
    with ViewPort do
    begin
       { growth of circle }
       for i:=1 to round(yc) do
       begin
         {setcolor(i);}
         circle(xc,yc,i);
       end;
       Bar((x2-x1) div 2 - 100, (y2-y1)-2*TextHeight('B'),
           (x2-x1) div 2 + 100, (y2-y1));
       SetTextJustify(CenterText, BottomText);
       SetColor(LightGray);
       OutTextXY((x2-x1) div 2, (y2-y1)-5,'Image '+
            Int2Str(MaxXimg)+' * '+Int2Str(MaxYimg)+ ' mu');
       SetColor(Lightgray);
       Rectangle(0, 0, x2-x1, y2-y1);
     end; { ViewPort }
  end;
end; // Circle 

{===============================================================}
{-                  DRAW Square Crystal                        -}
{---------------------------------------------------------------}
procedure SquareCryst;

var
  I,J,K,L : Longint;
  ViewPort    : ViewPortType;
  NumPixels: Word;
  Step,PixelColor: Word;
  ch: char;
  s: string;
  border: boolean;

begin
  New(Grn);
  GetViewSettings(ViewPort);
  with ViewPort do
  begin
    ClearViewPort;
    s:='Cubic System';
    SetTextJustify(CenterText, BottomText);
    OutTextXY((x2-x1) div 2, TextHeight('B')+5,s);
    OutTextXY((x2-x1) div 2, (y2-y1)-5,'Please Wait...');

    with Grn^ do
    begin
        Xg:=(x2-x1) div 2;
        Yg:=(y2-y1) div 2;
        Ready:=false;
        Phase:=Blue;
        Layer:=1;
        PutPixel(Xg, Yg, Phase);
    end;
    NumPixels:= ((x2-x1) div 2) * ((y2-y1) div 2);

    k:=1;
    while (k<NumPixels) do                            { to count pixels }
    begin
      i := 1;
        with Grn^ do
        if (ready=false) then
        begin
          ready:=true;
          Xg:=Xg+1;    Yg:=Yg;
          if (Xg>0) and (Xg<MaxXimg) and (Yg>0) and (Yg<MaxYimg) then
          begin
            PixelColor:=GetPixel(Xg, Yg);
            if (PixelColor=Black) then            { Empty }
            begin
              PutPixel(Xg, Yg, Phase);
              Inc(k);
              ready:=false;
            end
          end;

          L:=1;
          while (L<(Layer*2)-1) do
          begin
            Inc(L);
            Xg:=Xg;  Yg:= Yg+1;
            if (Xg>0) and (Xg<MaxXimg) and (Yg>0) and (Yg<MaxYimg)  then
            begin
              PixelColor:=GetPixel(Xg, Yg);
              if (PixelColor=Black) then
              begin
                PutPixel(Xg, Yg, Phase);
                Inc(K);
                ready:= false;
              end
            end
          end; { side 1}

          L:=1;
          while (L<(Layer*2)) do
          begin
            Inc(L);
            Xg:=Xg-1;  Yg:= Yg;
            if (Xg>0) and (Xg<MaxXimg) and (Yg>0) and (Yg<MaxYimg)  then
            begin
              PixelColor:=GetPixel(Xg, Yg);
              if (PixelColor=Black) then
              begin
                PutPixel(Xg, Yg, Phase);
                Inc(K);
                ready:= false;
              end
            end
          end; { side 2 }

          L:=1;
          while (L<(Layer*2)) do
          begin
            Inc(L);
            Xg:=Xg;  Yg:= Yg-1;
            if (Xg>0) and (Xg<MaxXimg) and (Yg>0) and (Yg<MaxYimg)  then
            begin
              PixelColor:=GetPixel(Xg, Yg);
              if (PixelColor=Black) then
              begin
                PutPixel(Xg, Yg, Phase);
                Inc(K);
                ready:= false;
              end
            end
          end; { side 3 }

          L:=1;
          while (L<(Layer*2)) do
          begin
            Inc(L);
            Xg:=Xg+1;  Yg:= Yg;
            if (Xg>0) and (Xg<MaxXimg) and (Yg>0) and (Yg<MaxYimg)  then
            begin
              PixelColor:=GetPixel(Xg, Yg);
              if (PixelColor=Black) then
              begin
                PutPixel(Xg, Yg, Phase);
                Inc(K);
                ready:= false;
              end
            end
          end; { side 4 }
          Layer:=Layer+1;                             { Next Layer }
          Inc(i);
        end
        else inc(i);
   end;   { with Grn^ }
   Bar((x2-x1) div 2 - 100, (y2-y1)-2*TextHeight('B'),
           (x2-x1) div 2 + 100, (y2-y1));
   SetTextJustify(CenterText, BottomText);
   OutTextXY((x2-x1) div 2, (y2-y1)-5,'Image '+
            Int2Str(MaxXimg)+' * '+Int2Str(MaxYimg)+ ' mu');

   SetColor(lightgray);
   Rectangle(0, 0, x2-x1, y2-y1);
  end; { ViewPort }
  Dispose(Grn);
end; { SquareCryst }

procedure OrthorhombicCryst;
var
  I,J,K,L : Longint;
  ViewPort    : ViewPortType;
  NumPixels: Word;
  Step,PixelColor: Word;
  ch: char;
  s: string;
  border: boolean;


begin
  New(Grn);
  GetViewSettings(ViewPort);
  with ViewPort do
  begin
    ClearViewPort;
    s:='Orthorhombic System';
    SetTextJustify(CenterText, BottomText);
    OutTextXY((x2-x1) div 2, TextHeight('B')+5,s);
    OutTextXY((x2-x1) div 2, (y2-y1)-5,'Please Wait...');

    with Grn^ do
    begin
        Xg:=(x2-x1) div 2;
        Yg:=(y2-y1) div 2;
        Ready:=false;
        Phase:=Red;
        Layer:=1;
        PutPixel(Xg, Yg, Phase);
    end;
    NumPixels:= ((x2-x1) div 2) * ((y2-y1) div 2);

    k:=1;
    while (k<NumPixels div 4) do                      { to count pixels }
    begin
      with Grn^ do
      begin

          Xg:=Xg;    Yg:=Yg-1;
          PutPixel(Xg, Yg, Phase);
          Inc(k);

          L:=1;
          while (L<(Layer*2)-1) do
          begin
            Inc(L);
            Xg:=Xg+1;  Yg:= Yg+1;
            PutPixel(Xg, Yg, Phase);
            Inc(K);
          end; { side 1}

          L:=1;
          while (L<(Layer*2)) do
          begin
            Inc(L);
            Xg:=Xg-1;  Yg:= Yg+1;
            PutPixel(Xg, Yg, Phase);
            Inc(K);
          end; { side 2 }

          L:=1;
          while (L<(Layer*2)) do
          begin
            Inc(L);
            Xg:=Xg-1;  Yg:= Yg-1;
            PutPixel(Xg, Yg, Phase);
            Inc(K);
          end; { side 3 }

          L:=1;
          while (L<(Layer*2)) do
          begin
            Inc(L);
            Xg:=Xg+1;  Yg:= Yg-1;
            PutPixel(Xg, Yg, Phase);
            Inc(K);
          end; { side 4 }

          {Xg:=Xg+1; Yg:=Yg-1;}
          Layer:=Layer+1;                             { Next Layer }
      end;
   end;

   Bar((x2-x1) div 2 - 100, (y2-y1)-2*TextHeight('B'),
           (x2-x1) div 2 + 100, (y2-y1));
   SetTextJustify(CenterText, BottomText);
   OutTextXY((x2-x1) div 2, (y2-y1)-5,'Image '+
            Int2Str(MaxXimg)+' * '+Int2Str(MaxYimg)+ ' mu');

   SetColor(lightgray);
   Rectangle(0, 0, x2-x1, y2-y1);

  end;
  Dispose(Grn);
end;


procedure HexagonalCryst;
var
  I,J,K,L : Longint;
  ViewPort    : ViewPortType;
  NumPixels: Word;
  Step,PixelColor: Word;
  ch: char;
  s: string;
  border: boolean;


begin
  New(Grn);
  GetViewSettings(ViewPort);
  with ViewPort do
  begin
    ClearViewPort;
    s:='Hexagonal System';
    SetTextJustify(CenterText, BottomText);
    OutTextXY((x2-x1) div 2, TextHeight('B')+5,s);
    OutTextXY((x2-x1) div 2, (y2-y1)-5,'Please Wait...');

    NumPixels:= ((x2-x1) div 2) * ((y2-y1) div 2);
    with Grn^ do
    begin
        Xg:=(x2-x1) div 2;
        Yg:=(y2-y1) div 2;
        Ready:=false;
        Phase:=LightRed;
        Layer:=1;
        PutPixel(Xg, Yg, Phase);
        PutPixel(Xg+1, Yg, Phase);
        PutPixel(Xg+1, Yg+1, Phase);
        PutPixel(Xg, Yg+1, Phase);
    end;

    
    k:=1;
    while (k<NumPixels div 4) do                      { to count pixels }
    begin
      with Grn^ do
      begin
          Xg:=Xg;    Yg:=Yg-1;
          PutPixel(Xg, Yg, Phase);
          Inc(k);

          l:=1;
          while l<layer do
          begin
            Xg:=Xg+1;    Yg:=Yg;
            PutPixel(Xg, Yg, Phase);
            inc(l);inc(k);
          end;

          L:=1;
          while (L<(Layer*2)-2) do
          begin
            Inc(L);
            Xg:=Xg+1;  Yg:= Yg+1;
            PutPixel(Xg, Yg, Phase);
            Inc(K);
          end; { side 1}

          l:=1;
          while l<layer do
          begin
            Xg:=Xg;    Yg:=Yg+1;
            PutPixel(Xg, Yg, Phase);
            inc(l);inc(k);
          end;

          L:=1;
          while (L<(Layer*2)) do
          begin
            Inc(L);
            Xg:=Xg-1;  Yg:= Yg+1;
            PutPixel(Xg, Yg, Phase);
            Inc(K);
          end; { side 2 }

          l:=1;
          while l<layer do
          begin
            Xg:=Xg-1;    Yg:=Yg;
            PutPixel(Xg, Yg, Phase);
            inc(l);inc(k);
          end;

          L:=1;
          while (L<(Layer*2)) do
          begin
            Inc(L);
            Xg:=Xg-1;  Yg:= Yg-1;
            PutPixel(Xg, Yg, Phase);
            Inc(K);
          end; { side 3 }

          l:=1;
          while l<layer do
          begin
            Xg:=Xg;    Yg:=Yg-1;
            PutPixel(Xg, Yg, Phase);
            inc(l);inc(k);
          end;

          L:=1;
          while (L<(Layer*2)) do
          begin
            Inc(L);
            Xg:=Xg+1;  Yg:= Yg-1;
            PutPixel(Xg, Yg, Phase);
            Inc(K);
          end; { side 4 }

          {Xg:=Xg+1; Yg:=Yg-1;}
          Layer:=Layer+1;                             { Next Layer }
      end;
   end;

   Bar((x2-x1) div 2 - 100, (y2-y1)-2*TextHeight('B'),
           (x2-x1) div 2 + 100, (y2-y1));
   SetTextJustify(CenterText, BottomText);
   OutTextXY((x2-x1) div 2, (y2-y1)-5,'Image '+
            Int2Str(MaxXimg)+' * '+Int2Str(MaxYimg)+ ' mu');

   SetColor(lightgray);
   Rectangle(0, 0, x2-x1, y2-y1);

  end;
  Dispose(Grn);
end;


procedure  CommonImage;
var
  ViewPort: ViewPortType;
  i,step:word;
begin
  MainWindow;
  Menu('Circle Square Orthorhombic Hexagonal Quit');
  StatLine('Esc-Exit in Main Menu');
  ClearViewPort;
  SetColor(LightGray);
  SetFillStyle(1,Black);
  SetTextStyle(DefaultFont, HorizDir, 2);
  SetTextJustify(CenterText, BottomText);
  OutTextXY(MaxX div 2, TextHeight('B')+5,  'GROWTH OF CRYSTALS');
  if (MaxSClass>18) or (MaxGClass>12) then    { change font for large model }
         SetTextStyle(SmallFont,HorizDir,2)
  else
         SetTextStyle(DefaultFont,HorizDir,1);
  with ViewPort do
  begin
    x1:= MaxX div 2 - MaxXimg div 2-50;
    x2:= MaxX div 2 + MaxXimg div 2-50;
    y1:= MaxY div 2 - MaxYimg div 2+10;
    y2:= MaxY div 2 + MaxYimg div 2+10;
    SetViewPort(x1, y1, x2, y2, ClipOn);
  end;
end;

begin
  Initialize;
  CommonImage;
  repeat
    ch:= readkey;
    if ch = #0 then ch := readkey;      { trap function keys }
    case Upcase(ch) of
       'C': CircleCryst;
       'S': SquareCryst;
       'O': OrthorhombicCryst;
       'H': HexagonalCryst;
       'Q':Halt;
    end;
  until Upcase(Ch)= 'Q';
  CloseGraph;
end.