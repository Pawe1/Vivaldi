unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  PC.VivaldiBrowser, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Timer1: TTimer;
    Image1: TImage;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  unit2;

procedure TForm1.Button1Click(Sender: TObject);
begin
  case TVivaldiBrowser.IsRunning of
    False: Caption := 'Not running';
    True:
      begin
        Caption := 'RUNNING !';

        if TVivaldiBrowser.IsVisible then
          Color := TVivaldiBrowser.WindowColor(TVivaldiBrowser.WindowHandles[0], 10, 80)
        else
          Color := clBtnFace;
      end;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
const
  FullWindow = True; // Set to false if you only want the client area.
var
  Win: HWND;
  DC: HDC;
  Bmp: TBitmap;
  FileName: string;
  WinRect: TRect;
  Width: Integer;
  Height: Integer;
begin
  Form1.Hide;
  try
    Application.ProcessMessages; // Was Sleep(500);
    Win := TVivaldiBrowser.WindowHandles[0];//GetForegroundWindow;

    if FullWindow then
    begin
      GetWindowRect(Win, WinRect);
      DC := GetWindowDC(Win);
    end else
    begin
      Winapi.Windows.GetClientRect(Win, WinRect);
      DC := GetDC(Win);
    end;
    try
      Width := WinRect.Right - WinRect.Left;
      Height := WinRect.Bottom - WinRect.Top;

      Bmp := TBitmap.Create;
      try
        Bmp.Height := Height;
        Bmp.Width := Width;
        BitBlt(Bmp.Canvas.Handle, 0, 0, Width, Height, DC, 0, 0, SRCCOPY);
        FileName := 'Screenshot_' +
          FormatDateTime('mm-dd-yyyy-hhnnss', Now());
        Bmp.SaveToFile(Format('C:\Users\ONC53287\Desktop\Vivaldi\Color\Win32\%s.bmp', [FileName]));
      finally
        Bmp.Free;
      end;
    finally
      ReleaseDC(Win, DC);
    end;
  finally
    Form1.Show;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
//  WindowSnap(TVivaldiBrowser.WindowHandles[0], Image1.Picture.Bitmap) ;
//  WindowSnap(Self.Handle, Image1.Picture.Bitmap) ;
  Screenshot(TVivaldiBrowser.WindowHandles[0], Image1.Picture.Bitmap) ;
  Image1.Refresh;

  Button1Click(Self);
end;

end.
