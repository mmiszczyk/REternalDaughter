//work in progress, this doesn't work yet
//based on http://securityxploded.com/ntcreatethreadex.php
//also based on http://blog.opensecurityresearch.com/2013/01/windows-dll-injection-basics.html

#include <windows.h>
#include <string.h>

typedef NTSTATUS (WINAPI *LPFUN_NtCreateThreadEx)
(
  OUT PHANDLE hThread,
  IN ACCESS_MASK DesiredAccess,
  IN LPVOID ObjectAttributes,
  IN HANDLE ProcessHandle,
  IN LPTHREAD_START_ROUTINE lpStartAddress,
  IN LPVOID lpParameter,
  IN BOOL CreateSuspended,
  IN ULONG StackZeroBits,
  IN ULONG SizeOfStackCommit,
  IN ULONG SizeOfStackReserve,
  OUT LPVOID lpBytesBuffer
);

struct NtCreateThreadExBuffer
{
  ULONG Size;
  ULONG Unknown1;
  ULONG Unknown2;
  PULONG Unknown3;
  ULONG Unknown4;
  ULONG Unknown5;
  ULONG Unknown6;
  PULONG Unknown7;
  ULONG Unknown8;
};

int main(int argc, char *argv[]) {
	//start the game
	char* executable = "fixres2.exe"; //hardcoded fixres2.exe for testing, will be different (macro?) in release
	char* dll = "bmploader.dll";
	PROCESS_INFORMATION procinfo = {0};
	STARTUPINFO startupinfo = {0};
	CreateProcess(executable, NULL, NULL, NULL, FALSE, 0, NULL, NULL, &startupinfo, &procinfo);
	Sleep(500); //wait to make sure we have a window
	SuspendThread(procinfo.hThread);
	
	//now we're doing the injection
	LPVOID dll_in_memory = VirtualAllocEx(procinfo.hProcess, NULL, (strlen(dll) + 1), MEM_RESERVE|MEM_COMMIT, PAGE_EXECUTE_READWRITE);
	WriteProcessMemory(procinfo.hProcess, dll_in_memory, dll, (strlen(dll) +1), NULL); //put path to dll in memory
	
	LPVOID loadlib = GetProcAddress(GetModuleHandle(TEXT("kernel32.dll")), "LoadLibraryA"); //get DLL loading function
	HMODULE ntdll = GetModuleHandle("ntdll.dll");
	LPFUN_NtCreateThreadEx createthread = (LPFUN_NtCreateThreadEx)GetProcAddress(ntdll, "NtCreateThreadEx");
	NTSTATUS ret = createthread(procinfo.hThread, 0x1FFFFF, NULL, procinfo.hProcess, loadlib, dll_in_memory, FALSE, NULL, NULL, NULL, NULL);
	
	ResumeThread(procinfo.hThread);
	return 0;
}
