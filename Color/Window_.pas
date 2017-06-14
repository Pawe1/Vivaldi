unit Window_;

interface

uses
  Winapi.Windows;

type
  TWindowHandleHelper = class
  private
    const
      MaxClassName = 256;
  public
    class function GetClassName(const AHandle: HWND): string; inline;
    class function GetText(const AHandle: HWND): string; inline;
    class function IsVisible(const AHandle: HWND): Boolean; inline;
    class function IsOwned(const AHandle: HWND): Boolean; inline;
    class function IsAppWindow(const AHandle: HWND): Boolean;
    class function IsIconic(const AHandle: HWND): Boolean;
  end;

implementation

class function TWindowHandleHelper.GetClassName(const AHandle: HWND): string;
begin
  SetLength(Result, MaxClassName);
  Winapi.Windows.GetClassName(AHandle, PChar(Result), MaxClassName);
  Result := PChar(Result);   // SetLength(Result, StrLen(PChar(Result))); equivalent
end;

class function TWindowHandleHelper.GetText(const AHandle: HWND): string;
begin
  SetLength(Result, GetWindowTextLength(AHandle));
  GetWindowText(AHandle, PChar(Result), Length(Result) + 1);
  Result := PChar(Result);   // SetLength(Result, StrLen(PChar(Result))); equivalent
end;

class function TWindowHandleHelper.IsAppWindow(const AHandle: HWND): Boolean;
begin
  Result := GetWindowLongPtr(AHandle, GWL_STYLE) and WS_EX_APPWINDOW <> 0;
end;

class function TWindowHandleHelper.IsOwned(const AHandle: HWND): Boolean;
begin
  Result := GetWindow(AHandle, GW_OWNER) <> 0;
end;

class function TWindowHandleHelper.IsVisible(const AHandle: HWND): Boolean;
begin
  Result := IsWindowVisible(AHandle);
end;

class function TWindowHandleHelper.IsIconic(const AHandle: HWND): Boolean;
begin
  Result := Winapi.Windows.IsIconic(AHandle);
end;


end.
