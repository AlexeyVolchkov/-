unit UTrieGUI;

interface

uses
  UTrieNode, UTrieTree, Classes, SysUtils, Windows, Messages, Variants,
  Graphics, Controls, Forms, ComCtrls,  StdCtrls, Menus, Dialogs;

type
  TTrieGUI = class(TTrieTree)
  private
    // ����������� �� ��������� ��������� ����
    FModified:boolean;
    // ��� ����� ��� ����������/������
    FFileName:string;
    // �������� ����
    FMemo:TMemo;
    // ���� � ����������� �� ���������� ���������
    // Memo ��� ������ ���������� Task
    FResMemo: TMemo;
  protected
    // ������ ���� modified
    procedure SetModified(value: boolean);
  public
    // ����������� GUI ������
    constructor Create(AMemo, AResM: TMemo);

    // �������� ���� �� ����� � ����
    function LoadFromFile(aFileName:string):boolean;
    // ���������� ���� � ���� �� ����
    procedure SaveToFile(aFileName:string);
    // �������� ���� �� ������ � ��������� ����
    procedure Clear; override;
    // ���������� ����� � ������ � �������� ����
    function Add(const wrd:string):boolean; override;
    // �������� ����������� �����
    function Delete(wrd:string):boolean; override;
    procedure PrintSomeWords(DelChar:char);

    property Modified:boolean read FModified write SetModified;
    property FileName:string read FFileName;

  end;

implementation

// ����������� GUI ������
constructor TTrieGUI.Create(AMemo, AResM: TMemo);
begin
  inherited Create;
  FFileName:='';
  FModified:=false;
  FMemo:=AMemo;
  FMemo.Clear;
  FResMemo:= AResM;
  FResMemo.Clear;
 // FPred:= TStringList.Create;
end;

// ������ ���� modified
procedure TTrieGUI.SetModified(value: boolean);
begin
  FModified:= value;
  if value then
    begin
     // FPred.Assign(FMemo.Lines);
      PrintAll(FMemo.Lines);
      FResMemo.clear
    end;
end;

// �������� ���� �� ����� � ����
function TTrieGUI.LoadFromFile(aFileName:string):boolean;
begin
  Result:= inherited LoadFromFile(aFileName);
  FFileName:=aFilename;
  FModified:= false;
  PrintAll(FMemo.Lines);
  FResMemo.Clear;
end;

// ���������� ���� � ���� �� ����
procedure TTrieGUI.SaveToFile(aFileName:string);
begin
  inherited SaveToFile(aFileName);
  FFileName:=aFileName;
  FModified:=false;
end;

// �������� ���� �� ������ � ��������� ����
procedure TTrieGUI.Clear;
begin
  if not IsEmpty then
    begin
      inherited ClearHelp;
      Modified:=true;
    end;
end;

// ���������� ����� � ������ � �������� ����
function TTrieGUI.Add(const wrd:string):boolean;
begin
  Result:= inherited AddHelp(wrd);
  if Result then
    Modified:= true;
end;

// �������� ����������� �����
function TTrieGUI.Delete(wrd:string):boolean;
begin
  Result:= inherited DeleteHelp(wrd);
  if Result then
    Modified:= true;
end;

procedure TTrieGUI.PrintSomeWords;
begin
  inherited PrintSomeWords(FResMemo.Lines, DelChar);
end;

end.
