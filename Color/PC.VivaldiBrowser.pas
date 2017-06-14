unit PC.VivaldiBrowser;

interface

uses
  Winapi.Windows,
  Vcl.Graphics;

type
  TVivaldiBrowser = class abstract
  private
    class function GetWindowHandles: TArray<HWND>; static;
  private
    const
      WindowClassName = 'Chrome_WidgetWin_1';
  public
    class function IsRunning: Boolean;
    class function IsVisible: Boolean;

    class function WindowColor(const hwnd: HWND; const X, Y: Integer): TColor;
    class function WindowColorS(const hwnd: HWND; const X, Y: Integer): TColor;

    class property WindowHandles: TArray<HWND> read GetWindowHandles;
  end;

function WindowSnap(windowHandle: HWND; bmp: TBitmap): boolean;

implementation

//[DllImport("user32.dll")]
//public static extern bool PrintWindow(IntPtr hwnd, IntPtr hdcBlt, uint nFlags);



uses
  Window_,
  Winapi.GDIPAPI, Winapi.GDIPOBJ,
  PC.WinAPI.Windows;

const
  PW_CLIENTONLY = $00000001;

//#if(_WIN32_WINNT >= 0x0603)
//#define PW_RENDERFULLCONTENT    0x00000002
//#endif /* _WIN32_WINNT >= 0x0603 */

  PW_RENDERFULLCONTENT = $00000002;   // win 8.1.+

class function TVivaldiBrowser.GetWindowHandles: TArray<HWND>;
begin
  Result := TWindowEnumerator.Enumerate(WindowClassName);
end;

class function TVivaldiBrowser.IsRunning: Boolean;
begin
  Result := Length(WindowHandles) > 0;
end;

class function TVivaldiBrowser.WindowColor(const hwnd: HWND; const X, Y: Integer): TColor;
var
  c: TCanvas;
begin
  c := TCanvas.Create;
  try
    c.Handle := GetWindowDC(hwnd);
    Result := GetPixel(c.Handle, X, Y);
  finally
    c.Free;
  end;
end;

function WindowSnap(windowHandle: HWND; bmp: TBitmap): boolean;
var
  r: TRect;
  user32DLLHandle: THandle;
  printWindowAPI: function(sourceHandle: HWND; destinationHandle: HDC;
    nFlags: UINT): BOOL; stdcall;
begin
  result := False;
  user32DLLHandle := GetModuleHandle(user32) ;
  if user32DLLHandle <> 0 then
  begin
    @printWindowAPI := GetProcAddress(user32DLLHandle, 'PrintWindow') ;
    if @printWindowAPI <> nil then
    begin
      GetWindowRect(windowHandle, r) ;
      bmp.Width := r.Right - r.Left;
      bmp.Height := r.Bottom - r.Top;
      bmp.Canvas.Lock;
      try
  result := printWindowAPI(windowHandle, bmp.Canvas.Handle, 0);
  result := printWindowAPI(windowHandle, bmp.Canvas.Handle, PW_CLIENTONLY + PW_RENDERFULLCONTENT);

//        result := printWindowAPI(windowHandle, bmp.Canvas.Handle, 0) ;
      finally
        bmp.Canvas.Unlock;
      end;
    end;
  end;
end;

class function TVivaldiBrowser.WindowColorS(const hwnd: HWND; const X, Y: Integer): TColor;
var
  B: TBitmap;
begin
//  PrintWindow(hWnd, hdcScreen, 0);
//  PrintWindow(hWnd, hdcScreen, PW_CLIENTONLY);

  B := TBitmap.Create;
  try
    WindowSnap(hwnd, B);
    result := b.Canvas.Pixels[X, Y];
  finally
    B.Free;
  end;
end;


//class function TVivaldiBrowser.WindowColor(const hwnd: HWND; const X, Y: Integer): TColor;
//var
//  hDDC, hCDC, hBMP: THandle;
//
//  c: TCanvas;
//const
//  iWidth: Integer = 20;
//  iHeight: Integer = 20;
//begin
//  hDDC := GetDC(hwnd);
//  hDDC := CreateCompatibleDC(hDDC);
//
//  hBMP := CreateCompatibleBitmap(hDDC, iWidth, iHeight);
//
//  SelectObject(hCDC, hBMP);
////    DllCall("User32.dll", "int", "PrintWindow", "hwnd", $WinHandle, "hwnd", $hCDC, "int", 0)
////    _WinAPI_BitBlt($hCDC, 0, 0, $iWidth, $iHeight, $hDDC, 0, 0, $__SCREENCAPTURECONSTANT_SRCCOPY)
//
////  c := TCanvas.Create;
////  try
////    c.Handle := GetWindowDC(hwnd);
////    Result := GetPixel(c.Handle, X, Y);
////  finally
////    c.Free;
////  end;
//
//  ReleaseDC(hwnd, hDDC);
//  DeleteDC(hCDC);
//  DeleteObject(hBMP);
// // ImageDispose(BMP);
//end;

//Func GetColor($iX, $iY, $WinHandle)
//
//    Local $aPos = WinGetPos($WinHandle)
//    $iWidth = $aPos[2]
//    $iHeight = $aPos[3]
//
//    _GDIPlus_Startup()
//
//    Local $hDDC = _WinAPI_GetDC($WinHandle)
//    Local $hCDC = _WinAPI_CreateCompatibleDC($hDDC)
//
//    $hBMP = _WinAPI_CreateCompatibleBitmap($hDDC, $iWidth, $iHeight)
//
//    _WinAPI_SelectObject($hCDC, $hBMP)
//    DllCall("User32.dll", "int", "PrintWindow", "hwnd", $WinHandle, "hwnd", $hCDC, "int", 0)
//    _WinAPI_BitBlt($hCDC, 0, 0, $iWidth, $iHeight, $hDDC, 0, 0, $__SCREENCAPTURECONSTANT_SRCCOPY)
//
//    $BMP = _GDIPlus_BitmapCreateFromHBITMAP($hBMP)
//    Local $aPixelColor = _GDIPlus_BitmapGetPixel($BMP, $iX, $iY)
//
//    _WinAPI_ReleaseDC($WinHandle, $hDDC)
//    _WinAPI_DeleteDC($hCDC)
//    _WinAPI_DeleteObject($hBMP)
//    _GDIPlus_ImageDispose($BMP)
//
//    Return Hex($aPixelColor, 6)
//EndFunc   ;==>GetColor

class function TVivaldiBrowser.IsVisible: Boolean;
var
  WindowHandle: HWND;
begin
  Result := False;
  for WindowHandle in WindowHandles do
    if not TWindowHandleHelper.IsIconic(WindowHandle) then
      Exit(True);
end;

end.
