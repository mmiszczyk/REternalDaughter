#include <windows.h>
#include <wingdi.h>
#include <winuser.h>

#ifndef _DLL_H_
#define _DLL_H_

#if BUILDING_DLL
#define DLLIMPORT __declspec(dllexport)
#else
#define DLLIMPORT __declspec(dllimport)
#endif

class DLLIMPORT DllClass
{
	public:
		DllClass();
		virtual ~DllClass();
		__declspec (dllexport) void LoadBMPToWindow(HWND window);
};

#endif
