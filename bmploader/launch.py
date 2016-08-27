# DLL injector by Andoryuuta
# original post: https://gist.github.com/Andoryuuta/e498f029f518e3235d44b6a763232fe2

from ctypes import *
import win32event
import win32process
import win32api
import win32ui
import sys
import os.path

def panic(proc, reason):
        win32ui.MessageBox(reason, 'Launcher Error!', 0)
        win32api.TerminateProcess(proc, 1)
        sys.exit(1)

def inject_dll(proc, dll_path):
        # Check if the file exists
        if not os.path.isfile(dll_path):
                panic(proc, 'DLL path specified does not exist')

        # Pull in kernel32 from ctypes becaue pywin32 doesn't implement VirutallAllocEx or WriteProcessMemory.
        k32 = windll.kernel32

        # Allocate space for dll path in the processes memory
        PAGE_READWRITE = 0x04
        VIRTUAL_MEM = (0x1000|0x2000)
        dll_path_address = k32.VirtualAllocEx(proc.__int__(), 0, len(dll_path), VIRTUAL_MEM, PAGE_READWRITE)

        # Write dll_path into the allocated memory
        bytesWritten = c_int(0)
        k32.WriteProcessMemory(proc.__int__(), dll_path_address, dll_path, len(dll_path), byref(bytesWritten))

        # Get LoadLibraryA's address in memory
        hKernel32 = win32api.GetModuleHandle('kernel32.dll')
        hLoadLibraryA = win32api.GetProcAddress(hKernel32, "LoadLibraryA")

        # Create at thread at the address of LoadLibraryA in the external process,
        # Passing the adress of the allocated memory as an argument.
        # The result is a tuple of the thread handle and thread ID.
        remoteData = win32process.CreateRemoteThread(proc, None, 0, hLoadLibraryA, dll_path_address, 0)

        # Wait for thread to end.
        # Timeout of 60 seconds.
        eventState = win32event.WaitForSingleObjectEx(remoteData[0], 60 * 1000, False)
        if eventState == win32event.WAIT_TIMEOUT:
                panic(proc, 'Injected DllMain thread timed out.')

def main():
        # Create the process in a suspended state
        # The result is a tuple of (hProcess, hThread, dwProcessId, dwThreadId)
        si = win32process.STARTUPINFO()
        procData = win32process.CreateProcess('Eternal Daughter.exe', None, None, None, False, win32process.CREATE_SUSPENDED, None, None, si)
        
        # Inject the dll into the suspended process
        inject_dll(procData[0], 'test.dll')

        # Resume the thread after the DLL has been injected.
        win32process.ResumeThread(procData[1])


if __name__ == '__main__':
main()
