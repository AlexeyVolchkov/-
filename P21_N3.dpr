program P21_N3;

uses
  Forms,
  UTrieMain in 'UTrieMain.pas' {frmMain},
  UTrieNode in 'UTrieNode.pas',
  UTrieTree in 'UTrieTree.pas',
  UTrieGUI in 'UTrieGUI.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
