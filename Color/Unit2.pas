unit Unit2;

interface

uses
  vcl.graphics,
  Windows;

function Screenshot(wnd: HWND; const bmp: vcl.graphics.TBitmap): Boolean;

implementation

const
  PW_CLIENTONLY = 1;

var
  PrintWindow: function(sHandle: HWND; dHandle: HDC; nFlags: UINT): BOOL; stdcall;



//function Screenshot(wnd: HWND; const bmp: TBitmap32): Boolean;
//var
//  rec: TRect;
//begin
//
//  GetClientRect(wnd, rec);
//  bmp.SetSize((rec.Right - rec.Left), (rec.Bottom - rec.Top));
//
//  bmp.Canvas.Lock;
//  try
//    Result := PrintWindow(wnd, bmp.Canvas.Handle, PW_CLIENTONLY);
//
//  finally
//    bmp.Canvas.Unlock;
//  end;
//end;

function Screenshot(wnd: HWND; const bmp: vcl.graphics.TBitmap): Boolean;
var
  rec: TRect;
begin

  GetClientRect(wnd, rec);
  bmp.SetSize((rec.Right - rec.Left), (rec.Bottom - rec.Top));

  bmp.Canvas.Lock;
  try
    Result := PrintWindow(wnd, bmp.Canvas.Handle, PW_CLIENTONLY);

  finally
    bmp.Canvas.Unlock;
  end;
end;

initialization
  @PrintWindow := GetProcAddress(LoadLibrary('user32.dll'), 'PrintWindow');

end.
