unit PC.WinAPI.Windows;

interface

uses
  Winapi.Windows;

type
  IWindow = interface
    ['{5483F3F1-CDAA-4048-BAEB-C6077FDAD2F6}']
    function GetClassName: string;
    function GetText: string;
    function IsVisible: Boolean;
    function IsOwned: Boolean;
    function IsAppWindow: Boolean;
  end;

  TWindowHandles = TArray<HWND>;
  PWindowHandles = ^TWindowHandles;

  TEnumCallbackParams = record
    WindowHandles: PWindowHandles;
    ClassNameFilter: PChar;
    ClassNameFilterEnabled: Boolean;
  end;
 // PEnumCallbackParam = ^TEnumCallbackParam;

  TWindowEnumerator = class
  private
  //  class function Enum(const AClassNameFilter: string): TArray<HWND>; static;
  public
    class function Enumerate(const AClassNameFilter: string): TWindowHandles;
  end;

function NewWindow(const AHandle: HWND): IWindow;

implementation

uses
  System.SysUtils;   // TStringHelper

type
  TWindow = class
  private
    const
      MaxClassName = 256;
  protected
    class function GetClassName(const AHandle: HWND): string; inline;
    class function GetText(const AHandle: HWND): string; inline;
    class function IsVisible(const AHandle: HWND): Boolean; inline;
    class function IsOwned(const AHandle: HWND): Boolean; inline;
    class function IsAppWindow(const AHandle: HWND): Boolean;

 //   class function
  end;

function NewWindow(const AHandle: HWND): IWindow;
var
  Window: TWindow;
begin
//  Window := TWindow.Create;
//  Result := Window;
//  Window.Handle := AHandle;
end;

class function TWindow.GetClassName(const AHandle: HWND): string;
begin
  SetLength(Result, MaxClassName);
  Winapi.Windows.GetClassName(AHandle, PChar(Result), MaxClassName);
  Result := PChar(Result);   // SetLength(Result, StrLen(PChar(Result))); equivalent
end;

class function TWindow.GetText(const AHandle: HWND): string;
begin
  SetLength(Result, GetWindowTextLength(AHandle));
  GetWindowText(AHandle, PChar(Result), Length(Result) + 1);
  Result := PChar(Result);   // SetLength(Result, StrLen(PChar(Result))); equivalent
end;

class function TWindow.IsAppWindow(const AHandle: HWND): Boolean;
begin
  Result := GetWindowLongPtr(AHandle, GWL_STYLE) and WS_EX_APPWINDOW <> 0;
end;

class function TWindow.IsOwned(const AHandle: HWND): Boolean;
begin
  Result := GetWindow(AHandle, GW_OWNER) <> 0;
end;

class function TWindow.IsVisible(const AHandle: HWND): Boolean;
begin
  Result := IsWindowVisible(AHandle);
end;

{ TWindowEnumerator }

class function TWindowEnumerator.Enumerate(const AClassNameFilter: string): TWindowHandles;

  function Callback(hwnd: HWND; lParam: LPARAM): BOOL; stdcall;
  var
    ClassName: string;
  begin
    Result := True;   //carry on enumerating
    with TEnumCallbackParams(Pointer(lParam)^) do
    begin
      if ClassNameFilterEnabled then
        ClassName := TWindow.GetClassName(hwnd);
      if (not ClassNameFilterEnabled) or (ClassName = ClassNameFilter) then
        WindowHandles^ := WindowHandles^ + [hwnd];
    end;
  end;

var
  Params: TEnumCallbackParams;
begin
  with Params do
  begin
    WindowHandles := @Result;
    ClassNameFilter := PChar(AClassNameFilter);
    ClassNameFilterEnabled := not string.IsNullOrWhiteSpace(AClassNameFilter);
  end;
  EnumWindows(@Callback, lParam(@Params));
end;

end.
