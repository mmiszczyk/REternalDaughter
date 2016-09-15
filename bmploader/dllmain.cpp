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


#include "dll.h"
#include <stdio.h>
#include <windows.h>

HDC window_dc;
HDC bmp_dc;
HGDIOBJ ret;
HBITMAP bmp;

DWORD WINAPI blit_thread(void* data);
int usleep(long usec);

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
			/*FILE* logfile = fopen("log.txt", "a");
			fprintf(logfile, "%s", "Attaching...\n");
			fclose(logfile);*/

			//for usleep
			WORD wVersionRequested = MAKEWORD(1,0);
			WSADATA wsaData;
			WSAStartup(wVersionRequested, &wsaData);

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

//snippet from https://blogs.msdn.microsoft.com/cellfish/2008/09/17/sleep-less-than-one-millisecond/
int usleep(long usec)
{
	struct timeval tv;
	fd_set dummy;
	SOCKET s = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
	FD_ZERO(&dummy);
	FD_SET(s, &dummy);
	tv.tv_sec = usec/1000000L;
	tv.tv_usec = usec%1000000L;
	return select(0, 0, 0, &dummy, &tv);
}

DWORD WINAPI blit_thread(void* data)
{
	//TODO: fix the blinking
	while(1){
		TransparentBlt(window_dc, 0, 0, 640, 480, bmp_dc, 0, 0, 640, 480, RGB(255,255,255));
		usleep(1L);
	} 
}
