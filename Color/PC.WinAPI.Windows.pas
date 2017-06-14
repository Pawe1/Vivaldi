unit PC.WinAPI.Windows;

interface

uses
  Winapi.Windows;

type
  TWindowEnumerator = class
  private
    type
      TWindowHandles = TArray<HWND>;
      PWindowHandles = ^TWindowHandles;

      TEnumCallbackParams = record
        WindowHandles: PWindowHandles;
        ClassNameFilter: PChar;
        ClassNameFilterEnabled: Boolean;
      end;
     // PEnumCallbackParam = ^TEnumCallbackParam;

  private
  //  class function Enum(const AClassNameFilter: string): TArray<HWND>; static;
  public
    class function Enumerate(const AClassNameFilter: string): TArray<HWND>;
  end;

implementation

uses
  Window_,
  System.SysUtils;   // TStringHelper

{ TWindowEnumerator }

class function TWindowEnumerator.Enumerate(const AClassNameFilter: string): TArray<HWND>;

  function Callback(hwnd: HWND; lParam: LPARAM): BOOL; stdcall;
  var
    ClassName: string;
  begin
    Result := True;   //carry on enumerating
    with TEnumCallbackParams(Pointer(lParam)^) do
    begin
      if ClassNameFilterEnabled then
        ClassName := TWindowHandleHelper.GetClassName(hwnd);
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
