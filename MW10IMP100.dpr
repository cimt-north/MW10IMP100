program MW10IMP100;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  ImportSetting in 'ImportSetting.pas' {Form2},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
