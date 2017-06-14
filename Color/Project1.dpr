program Project1;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  PC.WinAPI.Windows in 'PC.WinAPI.Windows.pas',
  PC.VivaldiBrowser in 'PC.VivaldiBrowser.pas',
  Window_ in 'Window_.pas',
  Test in 'Test.pas',
  Unit2 in 'Unit2.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
