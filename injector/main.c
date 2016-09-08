//work in progress, this doesn't work yet
//based on http://securityxploded.com/ntcreatethreadex.php
//also based on http://blog.opensecurityresearch.com/2013/01/windows-dll-injection-basics.html

#include <windows.h>

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
	PROCESS_INFORMATION procinfo = {0};
	STARTUPINFO startupinfo = {0};
	CreateProcess("fixres2.exe", NULL, NULL, NULL, FALSE, 0, NULL, NULL, &startupinfo, &procinfo); //hardcoded fixres2.exe for testing, will be different (macro?) in release
	Sleep(500); //wait to make sure we have a window
	return 0;
}
