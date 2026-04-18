//----------------------------------------------------------------------------
// Geoblock is a program for modeling and visualization of geoscience datasets.
//
// The contents of this file are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except in compliance
// with the License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
//
// Software distributed under the License is distributed on an "AS IS" basis,
// WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
// the specific language governing rights and limitations under the License.
//
// The initial developer of the original code and contributors are documented
// in the accompanying help file Geoblock.chm. Portions created by these
// individuals are Copyright (C) of these individuals.
// All Rights Reserved.
//
// Last modified: June, 2002
//----------------------------------------------------------------------------

unit FactorRG;

interface

// The Initial Developer of the Original Code:
//=============================================\\
//     R- and Q-mode  Factor Analysis          \\
//  Written by H.Van Hattum and H.De Mooy      \\
//           29 December 1986                  \\
//=============================================\\
// Department of Geochemistry,
// Institute for Earth Sciences,
// Postbus 80021, 3508 TA Utrecht, The Netherlands
//==============================================
// Published in:
//=============================================\\
// H. De Mooy, J.T.A. van Hattum, and S.P.Vriend.
// A RQ-Mode Factor Analysis Program For Microcomputers.
// A Pascal Program.
// Computers & Geosciences
// Vol.14, No 4, pp 449-465, 1988
//=============================================\\

// Modified for Borland Delphi by Pavel Vassiliev, 1998

{--------------------------------------------------------------------------}

uses SysUtils;


implementation

//(in1,inp,out1,qvars,con,trm,qloading,rscores);
label 10;

const c1 = 20;  (* Максимальное число параметров при анализе данных    *)
      c2 =210;  (* c2 = ( c1*c1 + c1)/2                                *)
      c3 = 10;  (* No.of Char/Line - 9 Mod 7  (Printer,Corr.Matrix)    *)
      c4 =  7;  (* No.of Char/Line - 9 Mod 10 (Printer,No.Factors)     *)
      c5 = 60;  (* Max number of variables on data file                *)
      epsi=0.00001;
type  str10        = string[10];
      str6         = string[6];
      str22        = string[22];
      factorinter  = record
        nvars,nsamples,nsamcon:  integer;
        mean,sd,ev: array[1..c1] of real; { ev=eigenvalue    }
        misvar: array[1..c1] of  integer;
        fl: array[1..c1,1..c1] of real;   { fl=factorloading }
        missing: real;
        UHM: array[1..c2] of real;   {UHM=Upper half matrixа}
        Name: array[1..c1] of str6;
      end;
var   disk:string;
      namedat,nameinf,f_inter1,f_inter2,
      f_numbers,f_qloading,f_rscores,f_qvars: str22;
      again,name: boolean;
      ch: char;
      i,novars: integer;
      rqdata: factorinter;
      inter1,inter2,numbers: file of real;
      inp,in1,out1,qvars,qloading,rscores: text;

procedure SelectVr(var sl: factorinter);

label 20;

var
  dummy, oobject: real;
  Data: array[1..c1] of real;
  Count,k,i,j:integer;
  n: array[1..c1] of integer;
  Elem: array[1..c5] of string[6];
  ch: char;

begin
//     Clrscr;
     read(inp,sl.nsamcon);
     read(inp,novars);          { for Klovan.dat novars = 11 }
     read(inp,sl.missing);
     readln(inp);
     novars:=novars-1;
     if novars > c5 then
         writeln('Too many Variables on Data File,Stop Program');
     read(inp,elem[1]);
     writeln('This should be the Objectnumber : ',Elem[1]);

     writeln('The Variables on this information File are:');

     for i:=1 to 6 do write(' No. пар-ра ');
     writeln;
     for i:=1 to 6 do write('------------');
     writeln;
     for i:=1 to novars do
         begin
           read(inp,Elem[i]);
           if eoln(inp) then readln(inp);
           write(i:3,' - ');
           write(Elem[i]);
           if i mod 6 = 0 then writeln;
         end;
  20:
     write('How Many Variables do You Want to Use ? ');
     read(sl.nvars);
     if sl.nvars > novars then
        begin
           writeln('Your File contains less Variables, Try Again');
           goto 20;
        end;
     if sl.nvars > c1
        then begin
          writeln('Selection of More then ',c1:2,'Variables is NOT Possible');
          goto 20;
        end;
     write('Give the Numbers of Variables ');
     for i:=1 to sl.nvars do
     read(N[i]);
     for j:= sl.nvars downto 1 do
            for i:=1 to j-1 do
                begin
                if N[i] = N[i+1] then begin
                    writeln('A Variable was Selected Twice.');
                    Goto 20
                    end;
                if N[i] > N[i+1] then begin
                    K:=N[i];
                    N[i]:=N[i+1];
                    N[i+1]:=K;
                    end;
                end;
       if (N[1] < 1) or (N[sl.nvars] > novars)
           then begin
                  writeln('A variable number is out of range.');
                  Goto 20
                end;
//     Clrscr;
     writeln;writeln('The Selected Variables Are:');
     for i:=1 to 6 do write(' No. пар-ра ');
     for i:=1 to 6 do write('------------');
     writeln;
     for i:=1 to sl.nvars do  begin
              sl.name[i]:=Elem[N[i]];
              write(i:3,' - ');
              write(sl.name[i]);
              if i mod 6 = 0 then writeln;
            end;
     writeln;
     close(inp);
     sl.nsamples:=0;
     for i:=1 to sl.nvars do
            begin
              sl.sd[i]:=0.0;
              sl.mean[i]:=0.0;
              sl.misvar[i]:=0;
            end;
     rewrite(numbers);
     rewrite(inter1);
     repeat
            read(in1,oobject);
            write(numbers,oobject);
            sl.nsamples:=sl.nsamples + 1;
            Count:=1;
            for i:=1 to sl.nvars do
                begin
                  while N[i] <> Count do
                      begin
                       read(in1,dummy);
                       Count:=Count + 1;
                      end;
                  read(in1,Data[i]);
                  Count:= Count + 1;
                end;
            for i:=Count to novars do read(in1,dummy);
            for i:=1 to sl.nvars do
                if Data[i] <> sl.missing
                then sl.mean[i]:= sl.mean[i] + Data[i]
                else sl.misvar[i]:= sl.misvar[i] + 1;
            for i:=1 to sl.nvars do write(inter1,data[i]);
            while (eoln(in1)) and (not eof(in1)) do readln(in1);
     until (eof(in1)) or (sl.nsamples = sl.nsamcon);
     for i:=1 to sl.nvars do
            sl.mean[i]:= sl.mean[i]/(sl.nsamples-sl.misvar[i]);
     close(in1);
end;  { SelectVr }

procedure Coralot(var cr:factorinter);
var
  ind,i,j,k,l: integer;
  x: array[1..c1] of real;

procedure PrintOut;
var
   i,j,k,l,m,cycle,block,ind: integer;
begin
     rewrite(Out1);
     for i:=1 to 5 do writeln(Out1);

     Writeln(out1,' Analysis using data from File: ',Namedat);
     Write(out1,' This File Contains ',cr.nsamples:4,' Cases,');
     Writeln(out1,' and ',Novars:3,' Variables ');

     writeln(out1);
     writeln(out1,'       Mean       St.Dev.    Number of Samples   Variable');
     writeln(out1,' -----------------------------------------------------');
     for j:=1 to cr.nvars do
         begin
          k:=cr.nsamples - cr.misvar[j];
          write(out1,cr.mean[j]:11:4, cr.sd[j]:12:4, k:14);
          writeln(out1,'          ',cr.name[j]);
         end;
     writeln(out1);
     writeln(out1,'          Correlation Coefficient Matrix           ');
     L:=0;
     Cycle:=0;
     Repeat
         Block:=cycle * c3 + 1;
         if L+C3 > cr.nvars then L:= cr.nvars
                            else L:= L + C3;
         writeln(out1,' ');
         for i:= Block to L do write(out1,' ',cr.Name[i]);
         writeln(out1);
         write(Out1,' ');
         for i:= Block to L do write(out1,'--------');
         writeln(out1);
         K:= -(cr.nvars + 1);
         i:=0;
         repeat
            i:=i + 1;
            k:=k + cr.nvars - i + 2;
            if i < Block
               then begin
                    Ind:= k + Block - i;
                    if L= cr.nvars then m:= cr.nvars - block + 1
                                   else m:= c3;
                    end
               else begin
                    Ind:=k;
                    if L= cr.nvars then m:= cr.nvars - i + 1
                                   else m:= c3 + Block - i;
                    end;
               for j:=1 to i - Block do write(out1,'       ');
               for j:=1 to m do
                   begin
                     Ind:= Ind + 1;
                     write(Out1, cr.UHM[Ind]:7:3);
                   end;
               writeln(Out1,'  ',cr.Name[i]);
         until i = L;
         writeln(Out1);
         Cycle:= Cycle + 1;
     Until L= cr.nvars;
end; { of PrintOut }

begin { main body of Coralot }
      Reset(Inter1);
      for i:=1 to (cr.nvars*cr.nvars + cr.nvars) div 2 do cr.UHM[i]:=0.0;
      for k:=1 to cr.nsamples do
          begin
            for i:=1 to cr.nvars do
              begin
                read(Inter1,X[i]);
                if X[i] = cr.missing then X[i]:= cr.mean[i];
              end;
            Ind:=0;
            for i:=1 to cr.nvars do
              begin
                for j:=i to cr.nvars do
                  begin
                    Ind:= Ind + 1;
                    cr.UHM[Ind]:= (X[i] - cr.mean[i]) * (X[j] - cr.mean[j])
                                +cr.UHM[Ind];
                  end;
              end;
          end;
      Ind:= -cr.nvars;
      for j:=1 to cr.nvars do
          begin
          Ind:= Ind + cr.nvars + 2 - j;
          cr.sd[j]:= cr.UHM[Ind];
          end;
      Ind:=0;
      for j:=1 to cr.nvars do
          begin
            Ind:= Ind + 1;
            cr.UHM[Ind]:= 1.000;
            for k:= j+1 to cr.nvars do
               begin
                 Ind:= Ind + 1;
                 cr.UHM[Ind]:= cr.UHM[Ind]/(Sqrt(cr.sd[j]*cr.sd[k]));
              end;
          end;
      for i:=1 to cr.nvars do
          cr.sd[i]:= sqrt(cr.sd[i]/(cr.nsamples - cr.misvar[i] - 1));
      Printout;
//      Repeat until keypressed;
end; { of Coralot }

procedure Jacob(var jc:Factorinter);
var
  nr,p,q,pq,nn,pp,rowlast,count,stop: integer;
  Threshold: real;

procedure Passon;
var
   i, j, k: integer;
   pct, cumpct, Last, biggestseen: real;
   Sequence, Arrow: array[1..c1] of integer;
   Parking:         array[1..c1] of real;
begin
   Last:= 100000.0;
   for k:=1 to jc.nvars do
       begin
       biggestseen:=-100.0;
       for i:=1 to jc.nvars do
           if (biggestseen < jc.ev[i]) and (jc.ev[i] < Last) then
              begin
              biggestseen:= jc.ev[i];
              Sequence[k]:= i;
              end;
       Last:= jc.ev[Sequence[k]];
   end;
   for i:=1 to jc.nvars do Arrow[Sequence[i]]:= i;
   for i:=1 to jc.nvars do
       if Sequence[i] <> i then
          begin   (* Sorting of EigenValues and Vectors *)
            k:= Sequence[i];
            Last:= jc.ev[i];
            for j:=1 to jc.nvars do Parking[j]:= jc.fl[i,j];
            jc.ev[i]:= jc.ev[k];
            for j:=1 to jc.nvars do jc.fl[i,j]:= jc.fl[k,j];
            jc.ev[k]:=Last;
            for j:=1 to jc.nvars do jc.fl[k,j]:= Parking[j];
            Sequence[Arrow[i]]:= Sequence[i];
            Arrow[Sequence[i]]:= Arrow[i];
            Sequence[i]:= i;
            Arrow[i]:= i;
          end;   (* Insertion-Sort by a Pointer-Array *)
       writeln(Out1);
       Writeln(Out1,'   Eigenvalue        PCT    CumPCT       ');
       writeln(Out1,'-----------------------------------------');
       CumPCT:=0.0;
       for i:=1 to jc.nvars do
           begin
             PCT:= jc.ev[i]/jc.nvars * 100;
             CumPCT:= CumPCT + PCT;
             writeln(Out1,jc.ev[i]:14:5, PCT:10:2, CumPCT:10:2);
           end;
       writeln(Out1);
       writeln(Out1,' Number of Rotations: ',Nr:4);
       Rewrite(Inter2);
       for j:=1 to jc.nvars do
           for i:=1 to jc.nvars do write(Inter2,jc.fl[j,i]);
       end;

       function Newthreshold: real;
       var
          p,q,pq: integer;
          t: real;
       begin
          pq:=0;
          t:=0;
          for p:=1 to jc.nvars-1 do
              begin
              pq:= pq + 1;
              for q:= p+1 to jc.nvars do
                  begin
                    pq:=pq+1;
                    t:=jc.UHM[pq] * jc.UHM[pq] + t;
                  end;
              end;
          Newthreshold:=sqrt(2*t/Stop);
       end; { of function Newthreshold }

       procedure Rotation;
       var
          k,q,qq,pi,qi: integer;
          a,b,l,m,c,cc,s,ss,s2,t: real;
       begin
          q:=pq-pp+p;
          qq:=(q-1)*(nn-q+2) div 2+1;
          L:=jc.UHM[pq];
          jc.UHM[pq]:=0;
          a:=jc.uhm[pp];
          b:=jc.uhm[qq];
          m:=a-b;
          t:=sqrt(4*L*L+M*M);
          c:=sqrt((abs(m)/t+1)/2);
          if m < 0.0 then begin
                            s:= -L/(C*T);
                            s2:=-2*L*L/T;
                          end
                     else begin
                            s:= L/(C*T);
                            s2:=2*L*L/T;
                          end;
          cc:=c*c;
          ss:=s*s;
          jc.uhm[pp]:=a*cc+b*ss+s2;
          jc.uhm[qq]:=a*ss+b*cc-s2;
          for k:=1 to jc.nvars do
              begin
                a:=jc.fl[p,k];
                b:=jc.fl[q,k];
                jc.fl[p,k]:=a*c+b*s;
                jc.fl[q,k]:=b*c-a*s;
              end;
          for k:=1 to jc.nvars do
          pi:=p;
          qi:=q;
          for k:=1 to jc.nvars do
              begin
              if (qi <> qq) and (pi <> pp) then
                 begin
                   a:= jc.UHM[pi];
                   b:=jc.UHM[qi];
                   jc.UHM[pi]:=a*c+b*s;
                   jc.UHM[qi]:=b*c-a*s;
                 end;
              if pi < pp then pi:= pi + jc.nvars - k
                         else pi:= pi + 1;
              if qi < qq then qi:= qi + jc.nvars - k
                         else qi:= qi + 1;
              end;
       end; { of Rotation }

begin  { main body of Jacobi }
      Nr:=0;
      NN:=2*jc.nvars;
      Stop:= jc.nvars * (jc.nvars - 1);
      for q:=1 to jc.nvars do
          begin
            for p:=1 to jc.nvars do jc.fl[p,q]:= 0.0;
            jc.fl[q,q]:=1.0;
          end;
      Threshold:=Newthreshold;
      Repeat
        pp:= -jc.nvars;
        rowlast:=0;
        for p:=1 to jc.nvars do
            begin
              pp:=pp+jc.nvars+2-p;
              rowlast:=rowlast+jc.nvars+1-p;
              for pq:=pp+1 to rowlast do
                  if abs(jc.UHM[pq]) > Threshold
                     then begin
                            count:=0;
                            Nr:=Nr+1;
                            Rotation;
                          end
                      else count:=count+1;
            end;
        Threshold:= Threshold/6.0;
        if Threshold < Epsi then Threshold:= Newthreshold;
      Until (Threshold < Epsi) or (Count >= Stop);
      pp:= -jc.nvars;
      for q:=1 to jc.nvars do
          begin
            pp:=pp+jc.nvars+2-q;
            jc.ev[q]:=jc.UHM[pp];
          end;
      Passon;
end; { of Jacobi }

{------------------------------ END OF JACOBI -------------------------------}

procedure Varimax(vx:factorinter);
var
   Commun: array[1..c1] of real;
   Sign, Order: array[1..c1] of integer;
   Nfacs, Noqld, i,j,k: integer;

procedure QModel;
var
   i,j,k: integer;
   SampleLength, QFld, Oobject: real;
   W: array[1..c1] of real;
begin                                       (* Establishing of Number *)
   if Noqld > vx.nvars then Noqld:=vx.nvars;(* of Qloadings of Output *)
   if Noqld > c4 then Noqld:= c4;
   SampleLength:= sqrt(vx.nsamples - 1.0);
   reset(Numbers);
   reset(Inter1);
   rewrite(Qloading);
   writeln(Out1); writeln(Out1);
   writeln(Out1,'    Q-Mode Factor Loadings ');
   writeln(Out1);
   write(Out1,' Проба ');for i:=1 to Noqld do write(Out1,' Фактор ',i:2);
   writeln(Out1);
   write(Out1,'------');for i:=1 to Noqld do write(Out1,'--------');
   Writeln(Out1);
   for i:=1 to vx.nsamples do
       begin
         read(Numbers, Oobject);
         write(Out1,' ',Oobject:6:1); write(Qloading, Oobject:6:1);
         for k:=1 to vx.nvars do
             begin
               read(Inter1, W[k]);
               if W[k] <> vx.missing
               then W[k]:=(W[k]-vx.mean[k])/vx.sd[k]
               else W[k]:=0.0;
             end;
             for j:=1 to Noqld do
                 begin
                   QFld:=0.0;
                   for k:=1 to vx.nvars do
                       QFld:=QFld + W[k] * vx.fl[j,k];
                   QFld:= QFld / SampleLength;
                   write(Out1,QFld:9:4); Write(Qloading, QFld:9:4);
                 end;
             writeln(Out1); writeln(Qloading);
       end;
    end; { of QModel }

   procedure FacScore;
   var
      i,j,k: integer;
      RfScore, Oobject: real;
      W: array[1..c1] of real;
      Utrans, Uinv: array[1..c1,1..c1] of real;

   procedure InvertMatrix;
   var
      i,j,k: integer;
      Factor: real;
   begin
        for i:=1 to Nfacs do
            begin
              for j:=1 to Nfacs do Uinv[i,j]:=0.0;
              Uinv[i,i]:=1.0;
            end;
        for i:=1 to Nfacs do
            begin
              Factor:= UTrans[i,i];
              for j:=1 to Nfacs do
                  begin
                    Utrans[i,j]:= Utrans[i,j] / Factor;
                    Uinv[i,j]:= Uinv[i,j] / Factor;
                  end;
              for j:=1 to Nfacs do
                  if i <> j then
                     begin
                       Factor:= Utrans[j,i];
                       for k:=1 to Nfacs do
                           begin
                           if Factor <> 0.0 then
                              begin
                               Utrans[j,k]:=Utrans[j,k]-Utrans[i,k]*Factor;
                               Uinv[j,k]:=Uinv[j,k]-Uinv[i,k]*Factor;
                              end;
                           end;
                     end;
            end;
   end; { of InvertMatrix }

   begin { body of FacScore }
   for i:=1 to Nfacs do
      begin
      for j:=1 to Nfacs do
          begin
          Utrans[i,j]:=0.0;
          for k:=1 to vx.nvars do
              Utrans[i,j]:=vx.fl[order[i],k]*vx.fl[order[j],k]+Utrans[i,j];
          end;
      end;
  InvertMatrix;
  writeln(Out1); writeln(Out1);
  writeln(Out1,'   Score  Коэффициенты факторного R-Mетода   ');
  writeln(Out1);
  write(Out1,' ');
  for i:=1 to Nfacs do Write(Out1,'   Фактор ',i:2);
  writeln(Out1,' Параметр ');
  write(Out1,' ');
  for i:=1 to Nfacs do Write(Out1,'----------'); writeln(Out1,'----------');
  for k:=1 to vx.Nvars do
      begin
      for j:=1 to Nfacs do
          begin
            Utrans[k,j]:=0.0;
            for i:=1 to Nfacs do
                begin
                  Utrans[k,j]:=vx.fl[order[i],k] * Uinv[i,j] + Utrans[k,j];
                end;
            write(Out1,Utrans[k,j]:10:4);
          end;
      writeln(Out1,'     ',vx.Name[k]);
      end;
  writeln(Out1);writeln(Out1);
  reset(Inter1);
  reset(Numbers);
  rewrite(Rscores);
  writeln(Out1,'       R-Mode Factor Score ');
  writeln(Out1);
  write(Out1,' Проба');
  for i:=1 to Nfacs do write(Out1,' Фактор',i:2); writeln(Out1);
      write(Out1,'------');
      for i:=1 to Nfacs do write(Out1,'---------');writeln(Out1);
      for i:=1 to vx.nsamples do
          begin
          for k:=1 to vx.nvars do
              begin
              read(Inter1,W[k]);
              if W[k] <> vx.missing
                 then W[k]:=(W[k]-vx.mean[k])/vx.sd[k]
                 else W[k]:=0.0;
              end;
          read(Numbers,Oobject);
          Write(Out1,' ',Oobject:6:1); write(Rscores,Oobject:6:1);
          for j:=1 to Nfacs do
              begin
                RfScore:= 0.0;
                for k:=1 to vx.nvars do
                    RfScore:=RfScore + W[k]*Utrans[k,j];
              write(Out1,RfScore:10:4); write(RScores,RfScore:10:4);
              end;
          writeln(Out1);writeln(RScores);
          end;
    end; { of FacScore }

    procedure VarOut1;
    var
      Result: real;
      i,j: integer;
    begin
     rewrite(Qvars);
     writeln(Qvars,vx.nvars:8,vx.nsamples:8,Nfacs:8);
     for i:=1 to vx.nvars do write(Qvars,vx.Name[i]:10);
     writeln(Qvars);
     Writeln(Out1);
     Writeln(Out1,'        Principal Factor Matrix ');
     Writeln(Out1);
     Write(Out1,' ');
     for i:=1 to Nfacs do Write(Out1,'  Фактор',i:2);
     writeln(Out1,'    Communality Variable ');
     write(Out1,' ');
     for i:=1 to NFacs do write(Out1,'-----------');
     writeln(Out1,'------------------------------');
     for j:=1 to vx.nvars do
         begin
           write(Out1,' ');
           for i:=1 to Nfacs do
               begin
                result:=vx.fl[i,j] * Vx.ev[i];
                Commun[j]:=commun[j] + result * result;
                write(Out1,Result:10:4);
                write(Qvars,Result:10:4);
               end;
           writeln(Out1,Commun[j]:11:4,'         ',vx.Name[j]);
           writeln(Qvars);
         end;
     Close(Qvars);
     end; { VarOut1 }

     procedure Varim;
     var
        i,j,k,conv,stop: integer;
        High,Low,xr,x,y,Cost,Sint,Num,Den,a,b,c,d,u,v: real;
        Eigen: array[1..c1] of real;
     begin
        for j:=1 to vx.nvars do
            for i:=1 to Nfacs do
                vx.fl[i,j]:= vx.fl[i,j]*vx.ev[i]/sqrt(Commun[j]);
            conv:=(Nfacs*(Nfacs-1)) div 2;
            stop:=0; i:=1; j:=1;
        while stop < conv do
              begin
              if i < Nfacs then i:=i+1
                           else begin
                                if j < Nfacs-1 then j:=j+1
                                               else j:=1;
                                i:=j+1
                                end;
              a:=0.0; b:=0.0; c:=0.0; d:=0.0;
              for k:=1 to vx.nvars do
                  begin
                  u:=(vx.fl[j,k]+vx.fl[i,k])*(vx.fl[j,k]-vx.fl[i,k]);
                  v:=2.0 * vx.fl[j,k] * vx.fl[i,k];
                  a:=a+u;
                  b:=b+v;
                  c:=c+(u+v)*(u-v);
                  d:=d+2.0*u*v;
                  end;
              num:=d-(2.0*a*b)/vx.nvars;
              den:=c-(a*a-b*b)/vx.nvars;
              xr:=sqrt(num*num+den*den);
              if xr <= Epsi
                 then stop:=stop+1
                 else begin
                      Cost:=Den/Xr;
                      Cost:=sqrt((1.0+Cost)/2.0);
                      Cost:=sqrt((1.0+Cost)/2.0);
                      Sint:=sqrt(1.0-Cost*Cost);
                      if Sint <= Epsi
                         then stop:=stop+1
                         else begin
                              stop:=0;
                              if num < 0.0 then Sint:= -Sint;
                              for k:=1 to vx.nvars do
                                  begin
                                  x:=vx.fl[j,k]; y:=vx.fl[i,k];
                                  vx.fl[j,k]:=x*Cost+y*Sint;
                                  vx.fl[i,k]:=y*Cost-x*Sint
                                  end;
                              end;
                      end;
              end; { of While loop }
     for i:=1 to Nfacs do
               begin
               Eigen[i]:=0.0;
               Sign[i]:=0;
               end;
     for j:=1 to vx.nvars do
               for i:=1 to Nfacs do
                   begin
                   vx.fl[i,j]:=vx.fl[i,j]*sqrt(Commun[j]);
                   Eigen[i]:=Eigen[i]+vx.fl[i,j]*vx.fl[i,j];
                   if vx.fl[i,j] < 0.0 then Sign[i]:= Sign[i] + 1
                   end;
           High:=21.0;
           for i:=1 to Nfacs do
               begin
               Low:=0.0;
               if Sign[i] > vx.nvars div 2 then Sign[i]:= -1
                                           else Sign[i]:=  1;
               for J:=1 to Nfacs do
                   if (Eigen[j] < High) and (Eigen[j] > Low) then
                   begin
                     Low:= Eigen[j];
                     Order[i]:= j
                   end;
               High:=Eigen[Order[i]];
               end;
       end;  { of Varim }

       procedure Varout2;
       var
        i,j,k: integer;
       begin
           writeln(Out1);
           writeln(Out1,' Varimax Rotated R-Mode Factor-Loading Matrix ');
           writeln(Out1);
           write(Out1,' ');
           for i:=1 to Nfacs do write(Out1,' Фактор',i:2);
           writeln(Out1,' Параметр');
           write(Out1,' ');
           for i:=1 to Nfacs do write(Out1,'---------- ');
           writeln(Out1,'---------- ');
           for j:=1 to vx.nvars do
               begin
               for i:=1 to Nfacs do
                   begin
                     k:=Order[i];
                     vx.fl[k,j]:=Sign[k]*vx.fl[k,j];
                     write(Out1,vx.fl[k,j]:10:4);
                   end;
               writeln(Out1,'         ',vx.Name[j]);
               end;
      end; { of VarOut2 }

begin     { body of procedure VariMax }
  Nfacs:= 0;
  while vx.ev[Nfacs+1] > 1.0 do Nfacs:= Nfacs + 1;
  Noqld:= Nfacs;
  while (vx.ev[Noqld+1] > 0.75) and (Noqld < vx.Nvars-1) do NoQld:=NoQld+1;
  for i:=1 to vx.Nvars do
      begin
        vx.ev[i]:=sqrt(abs(vx.ev[i]));
        Commun[i]:=0.0;
      end;
  VarOut1;
  QModel;
  Writeln;
  if Nfacs > 1
     then begin
           if Nfacs > c4
              then begin
                    Nfacs:=c4;
                    write('Number of Factor Exceeds ');
                    writeln('Printer Width, Set to ',c4:3);
                   end;
           Varim;
           VarOut2;
           FacScore;
          end
     else begin
            writeln(' Default 1 Factor Generated, Rotation of');
            writeln(' Less Then Two Factors is Not Possible');
          end;
    write('Изменить число Факторов ? (Y/N)  ');
//    ch:=readkey;
    writeln;writeln;
    if upcase(Ch) in ['Y','y'] then Again:= true
                             else Again:= false;
    while Again do
          begin
          writeln;
          write(' Give the Number of Factors Wanted ! ');
          read(Nfacs);
          writeln; writeln;
          if Nfacs < 2
             then begin
                  write(' Program Read on Input: ',Nfacs:2,' BUT');
                  writeln(' Less than Two Factors is not Useful ');
                  end
             else if Nfacs > vx.Nvars
                     then begin
                          write(' Программа считала ввод: ');
                          Write(Nfacs:3,', Больше факторов чем');
                          writeln('переменных вводить нельзя');
                          end
                     else if Nfacs > c4
                          then begin
                               write(' Считан ввод: ');
                               Write(Nfacs:3,', Больше чем ',c4:3);
                               writeln('Факторов вводить нельзя');
                               end
                          else begin
                               reset(Inter2);
                               for i:=1 to Nfacs do
                                   begin
                                     Commun[i]:=0.0;
                                     for j:=1 to vx.Nvars do
                                         read(Inter2,vx.fl[i,j]);
                                   end;
                               VarOut1;
                               Varim;
                               VarOut2;
                               FacsCore;
                               end;
                 Write(' Do You Want Another Number of Factors ? (Y/N) ');
//                  ch:=readkey;
                  writeln; writeln;
                  if upcase(Ch) in ['Y','y'] then Again:= true
                                            else Again:= false;
                  end;
end; { of VariMax procedure }

{--------------------------- MAIN BODY -------------------------------}

Begin
//   Clrscr;
//   TextColor(Yellow);
//   TextBackGround(Blue);
10:
   repeat
        namedat:='klovan.dat';
        i:= pos('.',namedat);
        if i>0 then nameinf:=copy(namedat,1,i);
        nameinf:=concat(nameinf,'INF');
        assign(in1,namedat);
        assign(inp,nameinf);

        {$I-}
        reset(in1);
        if not(IOResult = 0) then
        begin
          writeln;
          writeln(Chr(7),'  Файла Данных нет на диске ');
          writeln;writeln('Для продолжения нажмите <RETURN>');
//          ch:=readkey;
          {$I+}
          Goto 10;
        end;
        reset(inp);
        if not (IOResult = 0) then
        begin
          writeln;
          writeln(Chr(7),' Файла ',nameinf,' нет на диске');
          writeln;writeln(' Нажмите <Enter> для продолжения ');
//          ch:=readkey;
          {$I+}
          Goto 10;
        end;
        {$I+}
        writeln;

        disk:='';           { запись данных в текущий директорий }

        write('РЕЗУЛЬТАТЫ БУДУТ ЗАПИСАНЫ в каталог ',disk);
        writeln;
        f_inter1     := concat(disk,'xselect.$$$');
        f_inter2     := concat(disk,'facload.$$$');
        f_numbers    := concat(disk,'sampleno.$$$');
        f_qloading   := concat(disk,'qloading.rqm');
        f_rscores    := concat(disk,'rscores.rqm');
        f_qvars      := concat(disk,'qvars.rqm');
        assign(inter1,f_inter1);
        assign(inter2,f_inter2);
        assign(numbers,f_numbers);
        assign(qloading,f_qloading);
        assign(rscores,f_rscores);
        assign(qvars,f_qvars);

        repeat
           write('Вывести на Экран (S) или на Принтер (P) ? ');
//           ch:= Readkey;
        until (upcase(ch)='S') or  (upcase(ch)='P') ;
        if upcase(ch) in ['S','s'] then  assign(out1,'Con')
                                   else  assign(out1,'Lpt1');
        SelectVR(RQData);
        if RQData.nsamples=RQData.nsamcon
           then begin
                     Coralot(RQData);
                     Jacob(RQdata);
//                     Repeat until keypressed;
                     Varimax(RQData);
                     Close(Qloading);
{                    Close(Rscores);}                 { ??? }
                     Close(Inter1);
                     Close(Inter2);
                     Close(Numbers);
                     Close(Out1);
                end
           else begin
                  Writeln;
                  Write(' Error  expected',RQData.nsamcon:4);
                  Writeln(' Samples ,Found', RQData.nsamples:4,' Samples');
                  Writeln(' Check Your Data and Info File.         ');
           end;
     writeln;
     write('Do you want to use the program again ? Y/N  ');
//    ch:=readkey;
     writeln;
     if upcase(ch) in ['Y','y']
           then begin
                Again:=true;
                write('Do you want to use the same File ? Y/N ');
//                ch:=readkey;
                writeln;
                if upcase(ch) in ['Y','y'] then name:=true
                                                    else name:=false;
                end
            else again:=false;
        until not again;
End.   { of FactorRQ }


