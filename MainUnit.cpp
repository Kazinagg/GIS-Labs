//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "MainUnit.h"
#include <Vcl.Imaging.jpeg.hpp>

#include "GLS.Material.hpp" // <<< ДОБАВИТЬ ЭТУ СТРОКУ
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
//    // Загружаем сетку
//    GLSphere2->Material->Texture->Image->LoadFromFile(L"maps\\unigrid.bmp");
//    GLSphere2->Material->Texture->Enabled = true;
//
//    // --- ПРАВИЛЬНЫЙ СПОСОБ ДЛЯ СТАРЫХ ВЕРСИЙ GLSCENE (ПРОЗРАЧНОСТЬ) ---
//    // Мы говорим текстуре: "Построй свой канал прозрачности, считая все белые пиксели невидимыми"
//	GLSphere2->Material->Texture->ImageAlpha = tiaWhiteTransparent; // Если фон у unigrid.bmp черный, замени на tiaBlackTransparent
//
//    // Включаем режим смешивания, чтобы прозрачность заработала
//    GLSphere2->Material->BlendingMode = bmTransparency;
//
//
//    // --- ПРАВИЛЬНЫЙ СПОСОБ ДЛЯ СТАРЫХ ВЕРСИЙ GLSCENE (ЦВЕТ) ---
//    // Мы напрямую устанавливаем компоненты цвета: Красный, Зеленый, Синий. 1.0 = максимум.
//    GLSphere2->Material->FrontProperties->Emission.Color.x = 1.0; // Красный
//    GLSphere2->Material->FrontProperties->Emission.Color.y = 1.0; // Зеленый
//    GLSphere2->Material->FrontProperties->Emission.Color.z = 1.0; // Синий
//	// Emission - это собственное свечение объекта, он не будет зависеть от источника света.

	// Загружаем сетку
//	GLSphere2->Material->Texture->Image->LoadFromFile(L"maps\\unigrid.bmp");
//	GLSphere2->Material->Texture->Enabled = true;
//
//	// --- МАГИЯ ПРОЗРАЧНОСТИ ДЛЯ BMP ---
//    // Указываем, что цвет левого нижнего пикселя картинки будет прозрачным
//    GLSphere2->Material->BlendingMode = bmTransparency;
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
    // Если зажата левая кнопка мыши (ssLeft)
    if (Shift.Contains(ssLeft)) {
        // Вращаем наш куб-пустышку (а вместе с ним и обе сферы внутри)
        GLDummyCube1->Turn(X - mx);   // Вращение по горизонтали
        GLDummyCube1->Pitch(Y - my);  // Вращение по вертикали

        // Обновляем координаты мыши
        mx = X;
        my = Y;
	}
}
//---------------------------------------------------------------------------

