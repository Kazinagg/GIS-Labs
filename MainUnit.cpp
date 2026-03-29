//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "MainUnit.h"
#include <Vcl.Imaging.jpeg.hpp>

#include "GLS.Material.hpp"
#include "GLS.Color.hpp"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "GLS.BaseClasses"
#pragma link "GLS.Coordinates"
#pragma link "GLS.Objects"
#pragma link "GLS.Scene"
#pragma link "GLS.SceneViewer"
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::TreeView1Change(TObject *Sender, TTreeNode *Node)
{
	// Проверяем, что кликнули по существующему пункту
	if (Node == nullptr) return;

    if (Node->Text == L"Топография") {
        GLSphere1->Material->Texture->Image->LoadFromFile(L"maps\\topography.jpg");
        GLSphere1->Material->Texture->Enabled = true;
    }
    else if (Node->Text == L"Температура") {
        GLSphere1->Material->Texture->Image->LoadFromFile(L"maps\\temperature.jpg");
        GLSphere1->Material->Texture->Enabled = true;
    }
}
//---------------------------------------------------------------------------

void __fastcall TForm1::FormCreate(TObject *Sender)
{

    GLSphere2->Material->Texture->Image->LoadFromFile(L"maps\\unigrid.bmp");
	GLSphere2->Material->Texture->Enabled = true;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::GLSceneViewer1MouseDown(TObject *Sender, TMouseButton Button,
          TShiftState Shift, int X, int Y)
{
	mx = X;
	my = Y;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::GLSceneViewer1MouseMove(TObject *Sender, TShiftState Shift,
          int X, int Y)
{
	if (Shift.Contains(ssLeft)) {
		GLDummyCube1->Turn(X - mx);
		GLDummyCube1->Pitch(Y - my);

        mx = X;
        my = Y;
	}
}
//---------------------------------------------------------------------------

