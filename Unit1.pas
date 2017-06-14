unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, Spin;

type
TFindWindowRec = record
  ModuleToFind: string;
  FoundHWnd: HWND;
end;

  PWindows = ^TWindows;
  TWindows = record
    WindowHandle: HWND;
    WindowText: string;
  end;



  TWindowList = array of HWND;
  PWindowList = ^TWindowList;

  TFilter = record
    ModuleFileName: PChar;
    WindowClassName: PCHar;
  end;

  TEnumParam = record
    WindowList: PWindowList;
    Filter: TFilter;
  end;
  PEnumParam = ^TEnumParam;


  TForm1 = class(TForm)
    Button2: TButton;
    Timer1: TTimer;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    GroupBox2: TGroupBox;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    GroupBox3: TGroupBox;
    ListBox1: TListBox;
    procedure Button2Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
  private
    Handle: hwnd;
   WindowRect: TRect;


    FWindowList: TWindowList;
    procedure FindWindows(const AModuleFileNameFilter, AWindowClassNameFilter: string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

function GetWindowLongPtr(hWnd: HWND; nIndex: Integer): integer; stdcall;

implementation

{$R *.DFM}

function GetWindowLongPtr; external user32 name 'GetWindowLongW';


{function EnumWindowsCallBack(Handle: hWnd; var FindWindowRec: TFindWindowRec): BOOL; stdcall;
const
  C_FileNameLength = 256;
var
  WinFileName: string;
  PID, hProcess: DWORD;
  Len: Byte;
begin
  Result := True;
  SetLength(WinFileName, C_FileNameLength);
  GetWindowThreadProcessId(Handle, PID);
  hProcess := OpenProcess(PROCESS_ALL_ACCESS, False, PID);
  Len := GetModuleFileNameEx(hProcess, 0, PChar(WinFileName), C_FileNameLength);
  if Len > 0 then
  begin
    SetLength(WinFileName, Len);
    if SameText(WinFileName, FindWindowRec.ModuleToFind) then
    begin
      Result := False;
      FindWindowRec.FoundHWnd := Handle;
    end;
  end;
end;     }

{function GetClassName(Handle: THandle): String;
var
Buffer: array[0..MAX_PATH] of Char;
begin
Windows.GetClassName(Handle, @Buffer, MAX_PATH);
Result := String(Buffer);
end;   }

function IsVivaldiOpen: Boolean;
begin
 // FindWindowRec.ModuleToFind := 'c:\windows\system32\notepad.exe';
 // FindWindowRec.FoundHWnd := 0;
//  EnumWindows(@EnumWindowsCallback, integer(@FindWindowRec));
  //Result := FindWindowRec.FoundHWnd <> 0;
end;

function WindowColor(const hwnd: HWND; const X, Y: Integer): TColor;
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

procedure TForm1.Button2Click(Sender: TObject);
var
  LC: Integer;
begin
  ListBox1.Clear;
  FindWindows('Vivaldi.exe', Edit1.Text);

  for LC := 0 to High(FWindowList) do
    ListBox1.Items.Add(IntToStr(FWindowList[LC]));

end;

function EnumWindowsCallback(hwnd: HWND; lParam: LPARAM): BOOL; stdcall;
const
  MaxName = 256;
var
  ClassName, ModuleFileName: string;
  IsVisible, IsOwned, IsAppWindow: Boolean;
  text: string;
begin
  Result := True;

  ClassName := '';
  ModuleFileName := '';

  SetLength(ClassName, MaxName);
  SetLength(ClassName, GetClassName(hwnd, PChar(ClassName), MaxName));
  SetLength(ModuleFileName, MaxName);
  SetLength(ModuleFileName, GetWindowModuleFileName(hwnd, PChar(ModuleFileName), MaxName));
 // ModuleFileName := ExtractFileName(ModuleFileName);

  SetLength(text, GetWindowTextLength(hwnd));
  GetWindowText(hwnd, PChar(text), Length(text)+1);

  IsVisible := IsWindowVisible(hwnd);
  if not IsVisible then
    exit;

  IsOwned := GetWindow(hwnd, GW_OWNER)<>0;
  if IsOwned then
    exit;

  IsAppWindow := GetWindowLongPtr(hwnd, GWL_STYLE) and WS_EX_APPWINDOW<>0;
  if not IsAppWindow then
    exit;

  with PEnumParam(lParam)^ do
  begin
    if (StrLen(Filter.WindowClassName) = 0) or (StrComp(PChar(ClassName), Filter.WindowClassName) = 0) then
 //     if (StrLen(Filter.ModuleFileName) = 0) or (StrComp(PChar(ModuleFileName), Filter.ModuleFileName) = 0) then
      begin
        SetLength(WindowList^, Length(WindowList^) + 1);
        WindowList^[High(WindowList^)] := hwnd;
      end;
  end;
end;

procedure TForm1.FindWindows(const AModuleFileNameFilter, AWindowClassNameFilter: string);
var
  EnumParam: TEnumParam;
begin
  SetLength(FWindowList, 0);
  with EnumParam do
  begin
    WindowList := @FWindowList;
    Filter.ModuleFileName := PChar(AModuleFileNameFilter);
    Filter.WindowClassName := PChar(AWindowClassNameFilter);
  end;
  EnumWindows(@EnumWindowsCallback, lParam(@EnumParam));
end;

procedure TForm1.ListBox1Click(Sender: TObject);
begin
  if ListBox1.ItemIndex < 0 then
    Exit;

  Form1.Color := WindowColor(FWindowList[ListBox1.ItemIndex], SpinEdit1.Value, SpinEdit2.Value);
end;

end.


{**********************************************}
{  Other Code by NicoDE
{**********************************************}

{type
  PMyEnumParam = ^TMyEnumParam;
  TMyEnumParam = record
    Nodes: TTreeNodes;
    Current: TTreeNode;
  end;

function EnumWindowsProc(Wnd: HWND; Param: PMyEnumParam): BOOL; stdcall;
const
  MyMaxName = 64;
  MyMaxText = 64;
var
  ParamChild: TMyEnumParam;
  ClassName: string;
  WindowText: string;
begin
  Result := True;
  SetLength(ClassName, MyMaxName);
  SetLength(ClassName, GetClassName(Wnd, PChar(ClassName), MyMaxName));
  SetLength(WindowText, MyMaxText);
  SetLength(WindowText, SendMessage(Wnd, WM_GETTEXT, MyMaxText, lParam(PChar(WindowText))));
  ParamChild.Nodes   := Param.Nodes;
  ParamChild.Current := Param.Nodes.AddChildObject(Param.Current,
    '[' + ClassName + '] "' + WindowText + '"' + ' Handle: ' + IntToStr(Wnd), Pointer(Wnd));
  EnumChildWindows(Wnd, @EnumWindowsProc, lParam(@ParamChild));
end;


procedure TForm1.Button1Click(Sender: TObject);
var
  Param: TMyEnumParam;
begin
  Param.Nodes := TreeView1.Items;
  Param.Current := TreeView1.TopItem;
  TreeView1.Items.BeginUpdate;
  EnumWindows(@EnumWindowsProc, lParam(@Param));
  TreeView1.Items.EndUpdate;
end;

{procedure TForm1.Button1Click(Sender: TObject);
begin
  NotepadHandle := FindWindow(nil, 'Untitled - Notepad');
end;  }
     {
end.       }
