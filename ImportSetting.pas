unit ImportSetting;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, IniFiles,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  System.ImageList, Vcl.ImgList,
  Vcl.Themes, Vcl.Styles, Vcl.ComCtrls, Vcl.ToolWin, Vcl.ExtCtrls;

type
  TForm2 = class(TForm)
    LabelFolderPath: TLabel;
    EditFolderPath: TEdit;
    CheckBoxLogFile: TCheckBox;
    CheckBoxErrorFile: TCheckBox;
    EditMovePath: TEdit;
    EditErrorPath: TEdit;
    RadioButtonDelete: TRadioButton;
    RadioButtonMove: TRadioButton;
    ImageList1: TImageList;
    SpeedButtonFolderBrowse: TSpeedButton;
    SpeedButtonMoveFolderBrowse: TSpeedButton;
    SpeedButtonErrorFolderBrowse: TSpeedButton;
    SpeedButtonSave: TSpeedButton;
    SpeedButtonCancel: TSpeedButton;
    OpenDialog1: TOpenDialog;
    CheckBoxError: TCheckBox;
    EditPathError: TEdit;
    SpeedButtonPathError: TSpeedButton;
    CheckBoxResult: TCheckBox;
    EditResultPath: TEdit;
    SpeedButtonResult: TSpeedButton;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    ImageList2: TImageList;
    Panel1: TPanel;
    Label1: TLabel;
    procedure CheckBoxLogFileClick(Sender: TObject);
    procedure RadioButtonDeleteClick(Sender: TObject);
    procedure RadioButtonMoveClick(Sender: TObject);
    procedure CheckBoxErrorFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButtonFolderBrowseClick(Sender: TObject);
    procedure SpeedButtonMoveFolderBrowseClick(Sender: TObject);
    procedure SpeedButtonErrorFolderBrowseClick(Sender: TObject);
    procedure SpeedButtonSaveClick(Sender: TObject);
    procedure SpeedButtonCancelClick(Sender: TObject);
    procedure CheckBoxErrorClick(Sender: TObject);
    procedure SpeedButtonPathErrorClick(Sender: TObject);
    procedure CheckBoxResultClick(Sender: TObject);
    procedure SpeedButtonResultClick(Sender: TObject);
  private
    { Private declarations }
    procedure SaveSettings;
    procedure LoadSettings;
    function ErrorCheck: Boolean;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
    Operation, HasErrorFileChoice, HasLogFile, ErrorPath, FolderPath, Error,
    PathErrorCSV, ResultPathCSV, HasResult , FileNameStr: String;

implementation

{$R *.dfm}

uses Unit1;

procedure TForm2.CheckBoxErrorClick(Sender: TObject);
begin
  EditPathError.Enabled := CheckBoxError.Checked;
  SpeedButtonPathError.Enabled := CheckBoxError.Checked;
end;

procedure TForm2.CheckBoxErrorFileClick(Sender: TObject);
begin
  EditErrorPath.Enabled := CheckBoxErrorFile.Checked;
  SpeedButtonErrorFolderBrowse.Enabled := CheckBoxErrorFile.Checked;
end;

procedure TForm2.CheckBoxLogFileClick(Sender: TObject);
begin
  RadioButtonDelete.Enabled := CheckBoxLogFile.Checked;
  RadioButtonMove.Enabled := CheckBoxLogFile.Checked;
  EditMovePath.Enabled := CheckBoxLogFile.Checked;
  SpeedButtonMoveFolderBrowse.Enabled := CheckBoxLogFile.Checked;
end;

procedure TForm2.CheckBoxResultClick(Sender: TObject);
begin
  EditResultPath.Enabled := CheckBoxResult.Checked;
  SpeedButtonResult.Enabled := CheckBoxResult.Checked;
end;

procedure TForm2.FormCreate(Sender: TObject);
var
  CustomBlue: TColor;
begin
  LoadSettings;
  CustomBlue := rgb(194,209,254); // Standard blue color
  Self.Color := CustomBlue;
end;

procedure TForm2.SaveSettings;
var
  IniFile: TIniFile;
  Operation: string;
  IniFileName: string;
begin
  // Set Folder Path and Enable Read CSV button for Form1
  Form1.EditFolderPath.Text := EditFolderPath.Text;
  Form1.SpeedButton1.Enabled := True;
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'GRD\' + ChangeFileExt(ExtractFileName(Application.ExeName),'') + '.ini');
  try
    // Import Folder Path
    IniFile.WriteString('Settings', 'FolderPath', EditFolderPath.Text);
    //Errorfile
    IniFile.WriteBool('Settings', 'Error',CheckBoxError.Checked);
    IniFile.WriteString('Settings', 'PathErrorCSV', EditPathError.Text);
    // Log File
    IniFile.WriteBool('Settings', 'HasbkFile',CheckBoxLogFile.Checked);
    // Determine which radio button is checked and write it as a string
    if RadioButtonDelete.Checked then
      Operation := 'Delete'
    else if RadioButtonMove.Checked then
      Operation := 'Move'
    else
      Operation := 'None'; // Or whatever default/no operation value you wish
    IniFile.WriteString('Settings', 'Operation', Operation);
    IniFile.WriteString('Settings', 'MovePath', EditMovePath.Text);

    // Error File
    IniFile.WriteBool('Settings', 'HasErrorFile',CheckBoxErrorFile.Checked);
    IniFile.WriteString('Settings', 'ErrorPath', EditErrorPath.Text);
    //Result
    IniFile.WriteBool('Settings', 'HasResult',CheckBoxResult.Checked);
    IniFile.WriteString('Settings', 'ResultPath', EditResultPath.Text);

  finally
    IniFile.Free;
  end;
end;

procedure TForm2.SpeedButtonSaveClick(Sender: TObject);
begin
  if ErrorCheck then
  begin
    SaveSettings;
    Close;
  end;
end;

procedure TForm2.SpeedButtonCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TForm2.SpeedButtonErrorFolderBrowseClick(Sender: TObject);
var
  FolderDialog: TFileOpenDialog;
begin
  FolderDialog := TFileOpenDialog.Create(nil);
  try
    FolderDialog.Options := FolderDialog.Options + [fdoPickFolders];
    if FolderDialog.Execute then
    begin
      EditErrorPath.Text := FolderDialog.FileName;
    end;
  finally
    FolderDialog.Free;
  end;
end;

procedure TForm2.SpeedButtonFolderBrowseClick(Sender: TObject);
var
  FolderDialog: TFileOpenDialog;
begin
  FolderDialog := TFileOpenDialog.Create(nil);
  try
    FolderDialog.Options := FolderDialog.Options + [fdoPickFolders];
    if FolderDialog.Execute then
    begin
      EditFolderPath.Text := FolderDialog.FileName;
    end;
  finally
    FolderDialog.Free;
  end;
end;

procedure TForm2.SpeedButtonMoveFolderBrowseClick(Sender: TObject);
var
  FolderDialog: TFileOpenDialog;
begin
  FolderDialog := TFileOpenDialog.Create(nil);
  try
    FolderDialog.Options := FolderDialog.Options + [fdoPickFolders];
    if FolderDialog.Execute then
    begin
      EditMovePath.Text := FolderDialog.FileName;
    end;
  finally
    FolderDialog.Free;
  end;
end;

procedure TForm2.SpeedButtonPathErrorClick(Sender: TObject);
var
  FolderDialog: TFileOpenDialog;
begin
  FolderDialog := TFileOpenDialog.Create(nil);
  try
    FolderDialog.Options := FolderDialog.Options + [fdoPickFolders];
    if FolderDialog.Execute then
    begin
      EditPathError.Text := FolderDialog.FileName;
    end;
  finally
    FolderDialog.Free;
  end;
end;

procedure TForm2.SpeedButtonResultClick(Sender: TObject);
var
  FolderDialog: TFileOpenDialog;
begin
  FolderDialog := TFileOpenDialog.Create(nil);
  try
    FolderDialog.Options := FolderDialog.Options + [fdoPickFolders];
    if FolderDialog.Execute then
    begin
      EditResultPath.Text := FolderDialog.FileName;
    end;
  finally
    FolderDialog.Free;
  end;
end;

procedure TForm2.LoadSettings;
var
  IniFile: TIniFile;
  Operation: string;
begin
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'GRD\' + ChangeFileExt(ExtractFileName(Application.ExeName),'') + '.ini');
  try
    // Import Folder Path
    EditFolderPath.Text := IniFile.ReadString('Settings', 'FolderPath', '');

    // Log File
    CheckBoxLogFile.Checked := IniFile.ReadBool('Settings', 'HasbkFile', False);
    //Error
    CheckBoxError.Checked := IniFile.ReadBool('Settings', 'Error', False);
    // For radio buttons, determine the operation and set the appropriate radio button
    Operation := IniFile.ReadString('Settings', 'Operation', '');
    RadioButtonDelete.Checked := (Operation = 'Delete');
    RadioButtonMove.Checked := (Operation = 'Move');
    EditMovePath.Text := IniFile.ReadString('Settings', 'MovePath', '');
    EditPathError.Text := IniFile.ReadString('Settings', 'PathErrorCSV', '');
    //Result
    CheckBoxResult.Checked := IniFile.ReadBool('Settings', 'HasResult', False);
    EditResultPath.Text := IniFile.ReadString('Settings', 'ResultPath', '');


    // Enable or not from HasLogFile
    RadioButtonDelete.Enabled := CheckBoxLogFile.Checked;
    RadioButtonMove.Enabled := CheckBoxLogFile.Checked;

    EditMovePath.Enabled := CheckBoxLogFile.Checked;
    SpeedButtonMoveFolderBrowse.Enabled := CheckBoxLogFile.Checked;

    EditPathError.Enabled := CheckBoxError.Checked;
    SpeedButtonPathError.Enabled := CheckBoxError.Checked;

    EditResultPath.Enabled := CheckBoxResult.Checked;
    SpeedButtonResult.Enabled := CheckBoxResult.Checked;

    // Visible Edit Path Field
    EditMovePath.Visible :=  RadioButtonMove.Checked;
    SpeedButtonMoveFolderBrowse.Visible :=  RadioButtonMove.Checked;

    // Error File
    CheckBoxErrorFile.Checked := IniFile.ReadBool('Settings', 'HasErrorFile', False);
    EditErrorPath.Text := IniFile.ReadString('Settings', 'ErrorPath', '');
    // Error File Check Box
    EditErrorPath.Enabled := CheckBoxErrorFile.Checked;
    SpeedButtonErrorFolderBrowse.Enabled := CheckBoxErrorFile.Checked;


  finally
    IniFile.Free;
  end;
end;


function TForm2.ErrorCheck: Boolean;
begin
  Result := True; // Assume the path is correct

  // Check if the CSV folder path is empty
  if Trim(EditFolderPath.Text) = '' then
  begin
    ShowMessage('Please specify CSV folder path.');
    Result := False; // Set the result to False to indicate an error
    EditFolderPath.SetFocus;
    Exit; // Exit the procedure
  end;

  // Check if the folder path exists
  if not DirectoryExists(Trim(EditFolderPath.Text)) then
  begin
    ShowMessage('The specified CSV folder path does not exist.');
    Result := False; // Set the result to False to indicate an error
    EditFolderPath.SetFocus;
    Exit;
  end;

  // Check If has move file
  if CheckBoxLogFile.Checked And RadioButtonMove.Checked then
  begin
    // Check if the Log folder path is empty
    if Trim(EditMovePath.Text) = '' then
    begin
      ShowMessage('Please specify Move folder path.');
      Result := False; // Set the result to False to indicate an error
      EditMovePath.SetFocus;
      Exit; // Exit the procedure
    end;

    // Check if the folder path exists
    if not DirectoryExists(Trim(EditMovePath.Text)) then
    begin
      ShowMessage('The specified Move folder path does not exist.');
      Result := False; // Set the result to False to indicate an error
      EditMovePath.SetFocus;
      Exit;
    end;
  end;

  // Check If has Error file
  if CheckBoxErrorFile.Checked then
  begin
    // Check if the Error folder path is empty
    if Trim(EditErrorPath.Text) = '' then
    begin
      ShowMessage('Please specify Error folder path.');
      Result := False; // Set the result to False to indicate an error
      EditErrorPath.SetFocus;
      Exit; // Exit the procedure
    end;

    // Check if the folder path exists
    if not DirectoryExists(Trim(EditErrorPath.Text)) then
    begin
      ShowMessage('The specified Error folder path does not exist.');
      Result := False; // Set the result to False to indicate an error
      EditErrorPath.SetFocus;
      Exit;
    end;
  end;

end;


procedure TForm2.RadioButtonDeleteClick(Sender: TObject);
begin
  EditMovePath.Visible := False;
  SpeedButtonMoveFolderBrowse.Visible := False;
end;


procedure TForm2.RadioButtonMoveClick(Sender: TObject);
begin
  EditMovePath.Visible := True;
  SpeedButtonMoveFolderBrowse.Visible := True;
end;




end.
