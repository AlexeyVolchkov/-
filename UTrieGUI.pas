unit UTrieGUI;

interface

uses
  UTrieNode, UTrieTree, Classes, SysUtils, Windows, Messages, Variants,
  Graphics, Controls, Forms, ComCtrls,  StdCtrls, Menus, Dialogs;

type
  TTrieGUI = class(TTrieTree)
  private
    // Происходило ли изменение основного мемо
    FModified:boolean;
    // Имя файла для сохранения/чтения
    FFileName:string;
    // Основной мемо
    FMemo:TMemo;
    // Поле с информацией до последнего изменения
    // Memo для показа результата Task
    FResMemo: TMemo;
  protected
    // сеттер поля modified
    procedure SetModified(value: boolean);
  public
    // Конструктор GUI класса
    constructor Create(AMemo, AResM: TMemo);

    // Загрузка слов из файла в мемо
    function LoadFromFile(aFileName:string):boolean;
    // Сохранение слов в файл из мемо
    procedure SaveToFile(aFileName:string);
    // Удаление слов из дерева и основного мемо
    procedure Clear; override;
    // Добавление слова в дерево и основной мемо
    function Add(const wrd:string):boolean; override;
    // Удаление конкретного слова
    function Delete(wrd:string):boolean; override;
    procedure PrintSomeWords(DelChar:char);

    property Modified:boolean read FModified write SetModified;
    property FileName:string read FFileName;

  end;

implementation

// Конструктор GUI класса
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

// сеттер поля modified
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

// Загрузка слов из файла в мемо
function TTrieGUI.LoadFromFile(aFileName:string):boolean;
begin
  Result:= inherited LoadFromFile(aFileName);
  FFileName:=aFilename;
  FModified:= false;
  PrintAll(FMemo.Lines);
  FResMemo.Clear;
end;

// Сохранение слов в файл из мемо
procedure TTrieGUI.SaveToFile(aFileName:string);
begin
  inherited SaveToFile(aFileName);
  FFileName:=aFileName;
  FModified:=false;
end;

// Удаление слов из дерева и основного мемо
procedure TTrieGUI.Clear;
begin
  if not IsEmpty then
    begin
      inherited ClearHelp;
      Modified:=true;
    end;
end;

// Добавление слова в дерево и основной мемо
function TTrieGUI.Add(const wrd:string):boolean;
begin
  Result:= inherited AddHelp(wrd);
  if Result then
    Modified:= true;
end;

// Удаление конкретного слова
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
