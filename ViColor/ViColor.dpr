program ViColor;

uses
  Vcl.Forms,
  Main in 'Main.pas' {Form1},
  PC.WinAPI.Windows in 'PC.WinAPI.Windows.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
