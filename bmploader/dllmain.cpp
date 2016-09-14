/*************************
*       bmploader:       *
*        part of         *
*    REternal Daughter   *
*                        *
*     copyright 2016     *
*   by Maciej Miszczyk   *
*                        *
*  this program is free  *
*           and          *
*  open source software  *
* released under GNU GPL *
*    (see COPYING for    *
*    further details)    *
*************************/

//this is a very basic library
//it exports a function that takes HWND as an argument
//and writes a bitmap from "img.bmp" in the same folder
//into the window to which the handle points

//if I get the game to load this DLL, I could hijack execution,
//push HWND onto stack and paint whatever I want in the game window

//if I could do that before anything game-related is displayed
//on an executable which changes resolution and doesn't upscale,
//I'd solve the problem of wasted screen real estate because
//portions of image greater than 320x240 would never be overwritten

//unfortunately, I wasn't able to get it to work
//I tried adding this as import to the game .exe but it always
//results in a corrupted executable. I'm not sure how to solve it

#include "dll.h"
#include <stdio.h>
#include <windows.h>

HDC window_dc;
HDC bmp_dc;
HGDIOBJ ret;
HBITMAP bmp;

DWORD WINAPI blit_thread(void* data)
{
	while(1){
		TransparentBlt(window_dc, 0, 0, 640, 480, bmp_dc, 0, 0, 640, 480, RGB(255,255,255));
		Sleep(1); //try not killing performance
	} 
}

DllClass::DllClass()
{

}

DllClass::~DllClass()
{

}

__declspec (dllexport) BOOL WINAPI DllMain(HINSTANCE hinstDLL,DWORD fdwReason,LPVOID lpvReserved)
{
	switch(fdwReason)
	{
		case DLL_PROCESS_ATTACH:
		{
			//logfile for debugging
			FILE* logfile = fopen("log.txt", "a");
			fprintf(logfile, "%s", "Attaching...\n");
			fclose(logfile);

			//create a HDC with bitmap
			HWND* window = (HWND*)0x43fef8; //HWND changes but it's always stored at the same address so I can hardcode it
			TCHAR path[4096];
			GetFullPathName("img.bmp",4096,path,NULL);
			bmp = (HBITMAP)LoadImage(NULL,path,IMAGE_BITMAP,0,0,LR_LOADFROMFILE);
			bmp_dc = CreateCompatibleDC(NULL);
			ret = SelectObject(bmp_dc,bmp);
	
			//get HDC from window
			window_dc = GetDC(*window);

			//blit
			//BitBlt(window_dc, 0, 0, 640, 480, bmp_dc, 0, 0, SRCCOPY);
			//TransparentBlt(window_dc, 0, 0, 640, 480, bmp_dc, 0, 0, 640, 480, 0xffffff);
			CreateThread(NULL, 0, blit_thread, NULL, 0, NULL);
		}
		case DLL_PROCESS_DETACH:
		{
			//cleanup
			/*FILE* logfile = fopen("log.txt", "a");
			fprintf(logfile, "%s", "Detaching...\n");
			fclose(logfile);
			SelectObject(bmp_dc,ret);
			DeleteDC(bmp_dc);
			DeleteObject(bmp);*/
			//cleanup breaks the functionality, therefore no cleanup
			//fuck yeah, memory leaks!
			break;
		}
		case DLL_THREAD_ATTACH:
		{
			break;
		}
		case DLL_THREAD_DETACH:
		{
			break;
		}
	}
	
	return TRUE;
}
